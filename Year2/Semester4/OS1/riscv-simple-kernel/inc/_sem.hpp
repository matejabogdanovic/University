//
// Created by os on 5/12/24.
//

#ifndef PROJECT_BASE__SEM_HPP
#define PROJECT_BASE__SEM_HPP
#include "../inc/syscall_c.hpp"
#include "../inc/_thread.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/List.hpp"

class _sem {
public:
    /// operators for making objects
    void *operator new(size_t n){ return MemoryAllocator::instance().malloc(n); }
    void *operator new[](size_t n){ return MemoryAllocator::instance().malloc(n); }
    void operator delete(void *p) noexcept{ MemoryAllocator::instance().free(p); }
    void operator delete[](void *p) noexcept{ MemoryAllocator::instance().free(p); }

    static int semOpen(sem_t *handle, int init);
    int semClose();
    int semWait(time_t timeout = 0, bool timed_wait = false);
    int semSignal();
    int semTryWait();

    static bool validSemaphore(sem_t s);
protected:
     void block(_thread* t);
     void unblock();
     void unblock_timedout(_thread* t);
private:
    friend class _thread;
    friend class ConsoleBuffer;
    enum waitCode{ ALREADYLOCKED = -3, TIMEOUT = -2, SEMDEAD = -1,  SEMLOCKED = 0, SEMFREE = 1 };

    static void addToList(_sem* s);
    static int removeFromList(_sem* s);

   explicit _sem(int val) : val(val),  next(nullptr)
    {

    }
    int val;
    List<_thread> blocked;
    // for keeping track of all semaphores when using timedWait
    static _sem* head;
    static _sem* tail;
    _sem* next;

};


#endif //PROJECT_BASE__SEM_HPP
