//
// Created by os on 5/12/24.
//

#include "../inc/_sem.hpp"

_sem* _sem::head = nullptr;
_sem* _sem::tail = nullptr;


int _sem::semOpen(sem_t *handle, int init) {
    _sem* s = new _sem(init);
    volatile _sem*  tmp = s;

    if(tmp) *handle = s;
    else return -1; // cannot allocate

    addToList(s);

    return 0;
}


int _sem::semWait(time_t timeout, bool timed_wait) {

    if(timed_wait){ // timedWait
        if(timeout == 0)
            return waitCode::TIMEOUT;
        _thread::running->setTimedSem(this);
        _thread::running->setTimeout(timeout);
    }
    if(--val < 0)
        block(_thread::running);
    // unblocked or passed wait

    return _thread::running->wait_ret_val; // 0 by default
}

int _sem::semSignal() {
    if(++val <= 0)
        unblock();
    return 0;
}

int _sem::semTryWait() {

   // if(val < 0) return waitCode::ALREADYLOCKED; // error
    if(--val < 0)
        return waitCode::SEMLOCKED;
    return waitCode::SEMFREE;
}
void _sem::block(_thread* t) {
    blocked.addLast(t);
    t->setState(_thread::State::BLOCKED);
    thread_dispatch();
}

void _sem::unblock() {
    _thread* t = blocked.removeFirst();

    if(t){
        if(t->isTimedWaiting()){
            t->setTimedSem(nullptr); // not timed waiting anymore
            t->setTimeout(0);
        }
        t->setState(_thread::State::READY);
        Scheduler::put(t);
    }
}


int _sem::semClose() {

    removeFromList(this);

    while (blocked.peekFirst() != nullptr){
        _thread* t = blocked.removeFirst();
        t->setState(_thread::State::READY);
        t->wait_ret_val = waitCode::SEMDEAD;
        Scheduler::put(t);
    }

    return 0;
}

void _sem::addToList(_sem* s) {
    if (tail){
        tail->next = s;
        tail = s;
    }else
        head = tail = s;
}

int _sem::removeFromList(_sem* s) {
    if(!head)
        return -1;

    _sem* h = head, *prev = nullptr;
    for (; h ; prev = h, h = h->next) {
        if(h == s)break;
    }

    if(!h) return -1;
    if(!prev){ // first
        head = head->next;
        if(!head) tail = nullptr;
        return 0;
    }
    prev->next = s->next;
    s->next = nullptr;

    if(tail == s) // if last
        tail = prev;
    return 0;
}

void _sem::unblock_timedout(_thread *t) {

    blocked.remove(t);
    t->setState(_thread::State::READY);
    t->wait_ret_val = waitCode::TIMEOUT;
    semSignal(); // val++
    Scheduler::put(t);
}

bool _sem::validSemaphore(sem_t s) { /// if in list then it's valid
    for (_sem* h = head; h ; h = h->next) {
        if(s == h)
            return true;
    }
    return false;
}




