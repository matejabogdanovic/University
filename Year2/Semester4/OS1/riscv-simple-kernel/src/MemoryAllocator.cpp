//
// Created by os on 4/30/24.
//

#include "../inc/MemoryAllocator.hpp"
#include "../inc/riscv.hpp"

//int MemoryAllocator::mem[3] = {0,0,0};
MemoryAllocator& MemoryAllocator::instance() { /// singleton class
    static MemoryAllocator ma;
    return ma;
}

MemoryAllocator::MemoryAllocator() {
    /// HEAP space AROUND [800056e0, 88000000)
    this->start = (size_t)HEAP_START_ADDR; // 800056e0
    this->end = (size_t)HEAP_END_ADDR; // 88000000

    this->head = (FreeMemBlock*)start;
    this->head->size = this->end - this->start - sizeof(FreeMemBlock); // whole HEAP - size of struct
    this->head->next= nullptr;

}

void *MemoryAllocator::malloc(size_t size) {
    /// make blocks
    uint64 volatile mem_in_blocks;
    mem_in_blocks = (size + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
    /// call malloc
    return _malloc(mem_in_blocks);
}

void *MemoryAllocator::malloc_blocks(size_t size) { /// only from C api
    /// get blocks
    uint64 volatile mem_in_blocks;
    mem_in_blocks = Riscv::r_a1();
    /// call malloc
    return _malloc(mem_in_blocks);
}

void *MemoryAllocator::_malloc(size_t size_blcks) { // idea from 1. zad. avgust 2021.
    if(!this->head) return nullptr; /// no memory
    size_t needed_size = size_blcks * MEM_BLOCK_SIZE;
    size_t max_free_size = end - (start + sizeof(FreeMemBlock));
    if(needed_size > max_free_size) return nullptr; /// too large size
    /// first fit algorithm
    FreeMemBlock* curr = this->head, *prev = nullptr;
    for(; curr != nullptr; prev = curr, curr = curr->next)
        if(curr->size >= needed_size)break;
    if(!curr)return nullptr; // can't find block of needed_size size

    size_t remainder = curr->size - needed_size;
    if(remainder >= sizeof(FreeMemBlock) + MEM_BLOCK_SIZE) {
        /// calculate address of remaining block <=> sliced from the beginning and the rest is free memory
        FreeMemBlock *remaining_blk = (FreeMemBlock *) ((size_t) curr + sizeof(FreeMemBlock) + needed_size);
        remaining_blk->next = curr->next;
        /// size <= from remaining free space subtract struct header size
        remaining_blk->size = remainder-sizeof(FreeMemBlock);
        /// put it in the list
        if(prev) prev->next = remaining_blk;
        else this->head = remaining_blk; // it's first block

        curr->size = needed_size; // curr will be new allocated block

    }else{ /// give a whole block with a remainder because it's too small
        /// put it in the list
        if(prev) prev->next = curr->next;
        else this->head = curr->next; // it's first block
    }

    curr->next = nullptr;
    return (void *)((size_t)curr + sizeof(FreeMemBlock));
}

int MemoryAllocator::free(void * ptr) {

    if(ptr == nullptr) return -1; // invalid address
    size_t addr = (size_t)ptr;
    if(addr < this->start || addr >= this->end) return -2; // out of heap bounds

    if(alreadyDeallocated(addr))return 0;

    FreeMemBlock* blk = (FreeMemBlock*)(addr - sizeof(FreeMemBlock)); // not safe
    if(blk->next != nullptr || blk->size<=0) return -3; // basic checks

    if(!this->head){
        this->head = blk;
        return 0;
    }
    /// sorted list ascending by address
    FreeMemBlock* curr = this->head, *prev = nullptr;
    for(; curr != nullptr; prev = curr, curr = curr->next)//[0-2]{3-4}[6-7][8-22]
        if(addr + blk->size <= (size_t)curr )break;

    blk->next = curr;

    if(prev){
        prev->next = blk;
        if(tryToJoin(prev, blk)) /// if joined, change blk header
            blk = prev;
    }
    else head = blk; // first in the list
    tryToJoin(blk, blk->next); /// try to join with next
    return 0;
}

bool MemoryAllocator::tryToJoin(FreeMemBlock* first, FreeMemBlock* second) {
    if(!first || !second) return false;
    if((size_t)first + sizeof(FreeMemBlock) + first->size == (size_t) second){
        first->size += sizeof(FreeMemBlock) + second->size;
        first->next = second->next;

        second->next = nullptr;
        second->size = 0xFF; // for record where freed header was
        return true;
    }
    return false;
}


bool MemoryAllocator::deallocatedAllMemory() const {
    return ((size_t)head == start)&&  // same start address
    (head->size >= (this->end - this->start - sizeof(FreeMemBlock)))&& // same free size
    head->next == nullptr; // no more free memory
}

bool MemoryAllocator::alreadyDeallocated(size_t addr) {
    for (FreeMemBlock* h = this->head;  h ;h = h->next) {

        if(addr < (size_t)h) break; // no need to check other blocks

        if(addr > (size_t)(h) && addr <= (size_t)(h)+h->size)
            return true; // already deallocated

    }
    return false;
}






