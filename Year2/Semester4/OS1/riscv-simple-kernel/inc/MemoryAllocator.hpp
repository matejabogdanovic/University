//
// Created by os on 4/30/24.
//

#ifndef PROJECT_BASE_MEMORYALLOCATOR_HPP
#define PROJECT_BASE_MEMORYALLOCATOR_HPP

#include "../lib/hw.h"


class MemoryAllocator { /// singleton
public:
    static MemoryAllocator& instance();

    int free(void*); /// real free function
    void* malloc(size_t size); /// C++ wrapper
    bool alreadyDeallocated(uint64 addr);
    friend class Handlers;

    MemoryAllocator(const MemoryAllocator&) = delete;
    MemoryAllocator& operator=(const MemoryAllocator&) = delete;
private:
    struct FreeMemBlock{
        size_t size;
        FreeMemBlock* next;
    };
    void* malloc_blocks(size_t size); /// only SyscallHandler can call
    void* _malloc(size_t size_blcks); /// real malloc function
    bool tryToJoin(FreeMemBlock* first, FreeMemBlock* second);
    MemoryAllocator();


    size_t start, end;
    FreeMemBlock* head = nullptr;
public:
    bool deallocatedAllMemory() const;

};


#endif //PROJECT_BASE_MEMORYALLOCATOR_HPP
