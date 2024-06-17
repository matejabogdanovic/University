//
// Created by marko on 20.4.22..
//

#include "../inc/Scheduler.hpp"

List<_thread> Scheduler::readyCoroutineQueue;

_thread *Scheduler::get()
{
    return readyCoroutineQueue.removeFirst();
}

void Scheduler::put(_thread *pcb)
{
    readyCoroutineQueue.addLast(pcb);
}

_thread *Scheduler::peek_first() {

    return readyCoroutineQueue.peekFirst();
}

_thread *Scheduler::peek_last() {
    return readyCoroutineQueue.peekLast();
}

bool Scheduler::remove(_thread *t) {
    return readyCoroutineQueue.remove(t);
}
