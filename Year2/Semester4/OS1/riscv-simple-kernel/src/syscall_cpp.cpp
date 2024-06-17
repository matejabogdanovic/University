//
// Created by os on 5/8/24.
//
#include "../inc/syscall_cpp.hpp"



// can't have ::operator because of error: explicit qualification in declaration
void* operator new(size_t chunk){ return mem_alloc(chunk); }

void operator delete(void* ptr){ mem_free(ptr); }

Thread::Thread(void (*body)(void *), void *arg) : myHandle(nullptr), body(body), arg(arg){
}

Thread::~Thread() {
    //delete myHandle; // it will deallocate itself
}

void Thread::runWrapper(void* self){ ((Thread*)self)->run(); }

int Thread::start() {

    auto b = this->body!= nullptr?body: runWrapper;
    void* a = this->body!= nullptr?arg: this;
    myHandle = myHandle!= nullptr?myHandle: nullptr;

    return thread_create(&myHandle, b, a);
}

void Thread::dispatch() { thread_dispatch(); }

int Thread::sleep(time_t time) { return time_sleep(time); }

Thread::Thread(): myHandle(nullptr), body(nullptr), arg(nullptr) { }


Semaphore::Semaphore(unsigned int init) : myHandle(nullptr) {
    sem_open(&myHandle, init);
}

Semaphore::~Semaphore() {
    sem_close(myHandle); // removes handle from the list and frees space
}

int Semaphore::wait() {
    return sem_wait(myHandle);
}

int Semaphore::signal() {
    return sem_signal(myHandle);
}

int Semaphore::timedWait(time_t timeout) {
    return sem_timedwait(myHandle, timeout);
}

int Semaphore::tryWait() {
    return sem_trywait(myHandle);
}

PeriodicThread::PeriodicThread(time_t period) : Thread(){
    this->period = period;

}

char Console::getc() {
    return ::getc();
}

void Console::putc(char c) {
    ::putc(c);
}
