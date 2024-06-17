//
// Created by os on 5/4/24.
//

#ifndef PROJECT_BASE__THREAD_HPP
#define PROJECT_BASE__THREAD_HPP

#include "../lib/hw.h"
#include "Scheduler.hpp"
#include "../inc/MemoryAllocator.hpp"
#include "../inc/_sem.hpp"
#include "../inc/List_sorted.hpp"


class _thread {
public:
    /// operators for making objects
    void *operator new(size_t n){ return MemoryAllocator::instance().malloc(n); }
    void *operator new[](size_t n){ return MemoryAllocator::instance().malloc(n); }
    void operator delete(void *p) noexcept{ MemoryAllocator::instance().free(p); }
    void operator delete[](void *p) noexcept{ MemoryAllocator::instance().free(p); }

    static _thread* putcThr;
    static _thread* mainThread;
    ///fields
    using Body = void(*)(void *);
    static _thread* running;
    ///
    static bool schedulerEmpty();
    static bool schedulerOnlyMainThread();
    static bool hasSleepingThreads() { return sleeping.peekFirst() != nullptr; };

    /// getters and setters
    enum State{RUNNING, READY, EXITED, FINISHED, BLOCKED, SLEEPING};

    void *getArg() const { return arg; }
    uint64 getTimeSlice() const { return timeSlice; }
    bool isFinished() const { return finished; }

    /// destructor
    virtual ~_thread(){
        // for C api, deallocation is ok since it will be done with thread_exit() and then we just
        // deallocate stack since it's not in scheduler, not waiting or sleeping (it's running thread)
        // for CPP api, thread will be, if needed, removed from
        // Scheduler
        // sleeping list
        // and if thread is waiting on a semaphore

        if(this != running) {
            bool removed = Scheduler::remove(this); // just remove it from scheduler and delete it since it's not running
            if(!removed)removed = sleeping.remove(this); // if not in scheduler, it can be sleeping
            //if(!removed)// or in a semaphore which we cannot deal with

        }
        delete stack;
    }
private:
    friend class Handlers;
    friend class _sem;


    /// used in syscallHandler
    static int threadCreate(thread_t *handle, Body start_routine, void *arg, void* stack);
    static int threadExit();
    static int timeSleep(time_t time);

    /// some setters
    void setFinished(bool val) { _thread::finished = val; }
    void setState(State val) { _thread::state = val; }
    void setArg(void *val) { _thread::arg = val; }
    void setTimeSlice(uint64 val) { _thread::timeSlice = val; }

    /// for sleeping
    static void timeSleepHandler();
    bool shouldWakeUp() const { return time_sleeping <= 0; }

    /// for timed waiting
    static void timedWaitingHandler();

    void setTimedSem(_sem* s) { timed_sem = s; }
    _sem* getTimedSem() const { return timed_sem; }

    bool isTimedWaiting() const { return timed_sem != nullptr; }

    void setTimeout(time_t to) { timeout = to; }
    bool isTimedout() const { return timeout <=0; }


    struct Context{
        uint64 ra;
        uint64 sp;
    };
    /// constructor
    explicit _thread(Body body, void* arg, char* stack, uint64 time_slice);

    static void threadWrapper();
    static void dispatch(); // GOATED
    static void contextSwitch(Context* old_context, Context* new_context, bool old_finished = false); // contextSwitch.S

    Body body;
    void* arg;
    char *stack;
    Context context;
    uint64 timeSlice;
    bool finished;
    State state;
    int wait_ret_val; // _SEM.WAIT
    static uint64 timeSliceCounter;
    _sem* timed_sem;// _SEM.TIMEDWAIT
    time_t timeout; // _SEM.TIMEDWAIT
    time_t time_sleeping;




    static ListSorted<_thread, time_t> sleeping;
};


#endif //PROJECT_BASE__THREAD_HPP
