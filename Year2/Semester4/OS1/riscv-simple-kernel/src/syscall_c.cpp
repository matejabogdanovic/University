#include "../inc/syscall_c.hpp"
#include "../inc/riscv.hpp" // included sysID, printingSupervisor


uint64 syscall_wrapper(sysID id, void* a1 = 0, void* a2 = 0, void* a3 = 0, void* a4 = 0){
    /// arguments are implicitly stored in a0-a5 registers
    Riscv::ecall();
    uint64 volatile ret;
    ret = Riscv::r_a0();
    return ret;
}

void *mem_alloc(size_t size) {
    uint64 volatile mem_in_blocks;
    mem_in_blocks = (size + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
    return (void*) syscall_wrapper(sysID::MEM_ALLOC, (void*)mem_in_blocks);
}

int mem_free(void *ptr) {
    return (int)syscall_wrapper(sysID::MEM_FREE, ptr);
}

int thread_create(thread_t *handle, void (*start_routine)(void *), void *arg) {
    void* stack_space = mem_alloc(DEFAULT_STACK_SIZE); /// allocate stack
    if(!stack_space) return -1; /// no space for stack
    return (int) syscall_wrapper(sysID::THREAD_CREATE, (void *)handle,(void *)start_routine, arg, stack_space);
}

int thread_exit() {
    return (int) syscall_wrapper(sysID::THREAD_EXIT);
}

void thread_dispatch() {
    //uint64 volatile save_a0 = Riscv::r_a0();
    syscall_wrapper(sysID::THREAD_DISPATCH);
    //Riscv::w_a0(save_a0);
}

int sem_open(sem_t *handle, unsigned int init) {
    return (int) syscall_wrapper(sysID::SEM_OPEN, (void *)handle, (void *)(uint64)init);
}

int sem_close(sem_t handle) {
    return (int) syscall_wrapper(sysID::SEM_CLOSE, handle);
}

int sem_wait(sem_t id) {
    return (int) syscall_wrapper(sysID::SEM_WAIT, (void *)id);
}

int sem_signal(sem_t id) {
    return (int) syscall_wrapper(sysID::SEM_SIGNAL, (void *)id);
}

int sem_timedwait(sem_t id, time_t timeout) {
    if(timeout <= 0)return -2; // TIMEOUT
    return (int)syscall_wrapper(sysID::SEM_TIMEDWAIT, (void *)id, (void *)timeout);
}

int sem_trywait(sem_t id) {
    return (int)syscall_wrapper(sysID::SEM_TRYWAIT, (void *)id);
}

int time_sleep(time_t time) {
    if(time <= 0) return -1;
    return (int) syscall_wrapper(sysID::TIME_SLEEP, (void *)time);
}


char getc() {
    return (char)syscall_wrapper(sysID::GET_C);
}

void putc(char c) {
    syscall_wrapper(sysID::PUT_C, (void *)(uint64)c);
}




