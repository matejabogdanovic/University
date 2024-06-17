
//
// Created by os on 5/4/24.
//

#include "../inc/_thread.hpp"
#include "../inc/riscv.hpp"


_thread *_thread::running = nullptr;
uint64 _thread::timeSliceCounter = 0;
_thread* _thread::mainThread = nullptr;
_thread* _thread::putcThr = nullptr;
ListSorted<_thread, time_t> _thread::sleeping;

void _thread::timeSleepHandler(){
    for (ListSorted<_thread, time_t>::Elem* h = sleeping.head; h; h = h->next) {
        if(h->data->time_sleeping > 0) h->data->time_sleeping--; // dec sleeping time
    }
    while (sleeping.peekFirst() && sleeping.peekFirst()->shouldWakeUp()){ // since it's sorted list, first elements should always wake up first
        _thread* t = sleeping.removeFirst();
        t->setState(State::READY);
        Scheduler::put(t);
    }
}


int _thread::timeSleep(time_t time) {
    running->time_sleeping = time;
    sleeping.add(running, &running->time_sleeping);
    running->setState(State::SLEEPING);
    thread_dispatch();
    // back from the sleep
    return 0;
}


void _thread::timedWaitingHandler(){
    for (_sem* s = _sem::head; s ;) { // all semaphores
        _sem* snext = s->next;
        for (List<_thread>::Elem* t = s->blocked.head; t ; ) { // all blocked threads
            List<_thread>::Elem* nxt = t->next;
            if(t->data->isTimedWaiting()){
                if(t->data->timeout > 0) t->data->timeout--; // dec timeout

                if(t->data->isTimedout()){
                    s->unblock_timedout(t->data);

                }

            }
            t = nxt;
        }
        s = snext;
    }
}

bool _thread::schedulerEmpty() {
    return Scheduler::peek_first() == nullptr;
}

bool _thread::schedulerOnlyMainThread() {
    return Scheduler::peek_first() == mainThread && Scheduler::peek_last() == mainThread;
}

void _thread::dispatch() {

    _thread* old = running;

    if(!old->isFinished() && old->state != BLOCKED && old->state != SLEEPING){
        Scheduler::put(old);
        old->setState(State::READY);
    }

    /// automatic thread deletion for C api
    bool old_finished = old->isFinished();
    if (old_finished){
        delete old;
    }

    running = Scheduler::get();
    running->setState(State::RUNNING);

    _thread::contextSwitch(&old->context, &running->context, old_finished);

}
/// for syscalls
int _thread::threadCreate(thread_t *handle, Body start_routine, void *arg, void* stack_space) {
    char* stack = nullptr;
    if (!stack_space){
        stack = (char *)MemoryAllocator::instance().malloc(DEFAULT_STACK_SIZE);
        if (!stack) return -1; /// cannot allocate stack
    }
    else stack = (char*) stack_space; /// stack allocated

    _thread* t = new _thread(start_routine, arg, stack, DEFAULT_TIME_SLICE);
    volatile _thread* tmp = t; /// because it wants to optimize
    if (t->isFinished()){ delete t; t = nullptr; *handle = t; return -3;}

    *handle = (tmp!= nullptr)?t: nullptr;
    return (tmp!= nullptr)?0:-1;
}
int _thread::threadExit() {
    running->setFinished(true);
    running->setState(State::EXITED);
    thread_dispatch(); // yield?
    /// if we end up here it's an error for sure
    return -1;
}
/// running a thread function
void _thread::threadWrapper() {
    // don't sw to user mode if putcThr is running (it's the only supervisor thread in scheduler, so
    // since popSstatusSPPandSPIE grants previous priveleges, user thread could get supervisor priveleges
    // when switching from putcThr
    Riscv::popSstatusSPPandSPIE(_thread::running != putcThr); /// go to previous privileges (exit supervisor)
    running->body(_thread::running->getArg()); /// running a function
    running->setFinished(true); /// it won't be put back in scheduler
    running->setState(State::FINISHED);
    thread_dispatch(); // yield?

}
/// constructor
_thread::_thread(_thread::Body body, void *arg, char *stack, uint64 time_slice):
        body(body),
        arg(arg),
        stack(stack),
        context({
                        body != nullptr ? (uint64) &threadWrapper : 0,
                        stack != nullptr ? (uint64) &stack[DEFAULT_STACK_SIZE] : 0  // top to bottom stack
                }),
        timeSlice(time_slice),
        finished(false),
        state(State::READY),
        wait_ret_val(0),
        timed_sem(0),
        timeout(0),
        time_sleeping(0)
{

    if(body != nullptr) {
            Scheduler::put(this);
    }else {
        if (!mainThread && body == nullptr) { // first thread is main thread
            mainThread = this;
            running = this;
            this->setState(State::RUNNING);
        } else { // if it doesn't have body, optimise and delete thread instantly
            this->setState(State::FINISHED);
            setFinished(true);
        }
    }
}























