//
// Created by marko on 20.4.22..
//

#ifndef OS1_VEZBE07_RISCV_CONTEXT_SWITCH_1_SYNCHRONOUS_SCHEDULER_HPP
#define OS1_VEZBE07_RISCV_CONTEXT_SWITCH_1_SYNCHRONOUS_SCHEDULER_HPP

#include "List.hpp"

class _thread;

class Scheduler
{
private:
    static List<_thread> readyCoroutineQueue;

public:
    static _thread *get();

    static void put(_thread *pcb);

    static _thread* peek_first();

    static _thread* peek_last();

    static bool remove(_thread* t);
};

#endif //OS1_VEZBE07_RISCV_CONTEXT_SWITCH_1_SYNCHRONOUS_SCHEDULER_HPP
