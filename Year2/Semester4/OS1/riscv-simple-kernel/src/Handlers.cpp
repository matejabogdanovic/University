//
// Created by os on 4/29/24.
//
#include "../inc/Handlers.hpp"
#include "../inc/syscall_c.hpp"
#include "../inc/riscv.hpp"
#include "../inc/_thread.hpp"
#include "../inc/_console.hpp"



void Handlers::handleSyscalls() {

    uint64 volatile sys_id = Riscv::r_a0();
    uint64 volatile a1, a2, a3, a4;
    a1 = Riscv::r_a1();
    a2 = Riscv::r_a2();
    a3 = Riscv::r_a3();
    a4 = Riscv::r_a4();

    uint64 volatile ret = 0;

    uint64 volatile sepc = Riscv::r_sepc();
    uint64 volatile sstatus = Riscv::r_sstatus(); // implicitly save sstatus on stack
    uint64 volatile cause = Riscv::r_scause();
    /// ecall from S mode or U mode
    if (cause != 0x0000000000000009UL && cause != 0x0000000000000008UL) {
        printStringS("SCAUSE ERROR: Not syscall.\n");
        Riscv::printStats();
        Riscv::halt();
        return;
    }


    switch (sys_id) {
        case sysID::MEM_ALLOC:
            ret = (uint64) MemoryAllocator::instance().malloc_blocks(a1);
            break;
        case sysID::MEM_FREE:
            ret = (int) MemoryAllocator::instance().free((void *) a1);
            break;
        case sysID::THREAD_CREATE:
            ret = (int) _thread::threadCreate((thread_t *) a1, (_thread::Body) a2, (void *) a3, (void *) a4);
            break;
        case sysID::THREAD_EXIT:
            ret = (int) _thread::threadExit(); /// will return if error
            break;
        case sysID::THREAD_DISPATCH:
            /// it returns void
            /// reset time
            _thread::timeSliceCounter = 0;
            /// change context
            _thread::dispatch();
            /// from new thread stack restore sstatus and sepc
            //Riscv::w_sstatus(sstatus); // context switching so save sstatus and return restore it
            break;
        case sysID::SEM_OPEN:
            ret = (int)_sem::semOpen((sem_t *)a1, (int)a2);
            break;
        case sysID::SEM_CLOSE:
            if(!_sem::validSemaphore((sem_t)a1)){
                ret = -1;
                break;
            }
            ((sem_t)a1)->semClose();
            ret = MemoryAllocator::instance().free((void *)a1); // deallocate semaphore, used in C and CPP api
            break;
        case sysID::SEM_WAIT:// can change context: yes
            if(!_sem::validSemaphore((sem_t)a1)){
                ret = -1;
                break;
            }
            ret = (int)((sem_t)a1)->semWait();
            break;
        case sysID::SEM_SIGNAL:
            if(!_sem::validSemaphore((sem_t)a1)){
                ret = -1;
                break;
            }
            ret = (int)((sem_t)a1)->semSignal();
            break;
        case sysID::SEM_TIMEDWAIT:// can change context: yes
            if(!_sem::validSemaphore((sem_t)a1)){
                ret = -1; // SEMDEAD
                break;
            }
            ret = (int)((sem_t)a1)->semWait((time_t)a2, true);
            break;
        case sysID::SEM_TRYWAIT:
            if(!_sem::validSemaphore((sem_t)a1)){
                ret = -1;
                break;
            }
            ret = (int)((sem_t)a1)->semTryWait();
            break;
        case sysID::TIME_SLEEP: // can change context: yes
            ret = (int)(_thread::timeSleep((time_t)a1));
            break;
        case sysID::GET_C:
            ret = (char)_console::getcBuffer->get();
            break;
        case sysID::PUT_C:
            _console::putcBuffer->put(a1);
            break;
        case sysID::CHANGE_MODE:
            /// in a1 is what mode to change
            if(_thread::running != _thread::mainThread) // don't allow user threads to change mode
            {
                printStringS("sysID::CHANGE_MODE ERROR: Change not granted.\n");
                Riscv::printStats();
                Riscv::halt();
                return;
            }
            ret = 0;
            Riscv::swMode((Riscv::Mode)a1);
            Riscv::w_sepc(sepc + 4);
            Riscv::w_a0(ret);
            return;
        default:
            printStringS("ERROR: handleSyscalls.switch.default: \n");
            Riscv::printStats();

            ret = 0;
            return;
        }
        // prekidna rutina obradjena
        Riscv::w_sstatus(sstatus);
        Riscv::w_sepc(sepc + 4); /// in spec is ecall and +4 is next instruction
        Riscv::w_a0(ret); /// write return value


}

int Handlers::handleTimer() {
    uint64 volatile cause = Riscv::r_scause();

    if(cause == 0x8000000000000001UL){ /// TIMER
        // interrupt: yes, cause code: supervisor software interrupt (timer)

        Riscv::mc_sip(Riscv::SIP_SSIE);
        _thread::timeSliceCounter++;

        _thread::timedWaitingHandler(); // timed waiting on semaphores
        _thread::timeSleepHandler(); // time_sleep wake up needed threads

        if (_thread::timeSliceCounter >= _thread::running->getTimeSlice()){ // if time is up

            /// on old thread stack save sepc and sstatus
            uint64 volatile sepc = Riscv::r_sepc();
            uint64 volatile sstatus = Riscv::r_sstatus();
            /// reset time
            _thread::timeSliceCounter = 0;
            /// change context
            _thread::dispatch();
            /// from new thread stack restore sstatus and sepc
            Riscv::w_sstatus(sstatus);
            Riscv::w_sepc(sepc);

        }


        return 1;
    }

    return 0;
}


int Handlers::handleConsole() {
    uint64 volatile cause = Riscv::r_scause();
    if(cause == 0x8000000000000009UL){ /// CONSOLE
        // interrupt: yes, cause code: supervisor external interrupt (console)
        _console::getcHandle();
       // console_handler(); // uncomment this to use GETC from lib
        Riscv::mc_sip(Riscv::SIP_SSIE); // interrupt done
        return 1;
    }
    return 0;
}


