
#include "../inc/syscall_c.hpp"
#include "../inc/syscall_cpp.hpp"
#include "../inc/riscv.hpp"
#include "../inc/Handlers.hpp"
#include "../inc/_thread.hpp"
#include "../inc/_console.hpp"


extern void userMain();

static bool usrFinished = false;

void userMainWrapper(void* ){
    userMain();


    usrFinished = true;
}

int main(){
    /// sstatus <= 0b10, intr enabled
    /// stvec <= adresa syscallHandler prekidne rutine iz .S fajla, |0b00 direktan rezim 00 na poslednja 2 bita
    Riscv::w_stvec( (uint64)&Handlers::trapHandler | 0b00);

    thread_t t, usr, putcThread;
    thread_create(&t, nullptr, nullptr); /// mainThread (running)

    ConsoleBuffer* putc_buffer = new ConsoleBuffer(); ConsoleBuffer* getc_buffer = new ConsoleBuffer();
    _console::putcBuffer = putc_buffer; _console::getcBuffer = getc_buffer;

    thread_create(&putcThread, _console::putcHandle, (void*) 1);
    _thread::putcThr = putcThread;
    /// IMPORTANT! do not delete this dispatch. This is here so putcThread gets its SUPERVISOR privileges in csr regiser
    /// also, it blocks putcThread on a buffer semaphore until putc is called.
    thread_dispatch();

    Riscv::changeMode(Riscv::Mode::USER);
    /// entered user mode


    thread_create(&usr, userMainWrapper, nullptr);


    while (!_thread::schedulerEmpty() || !usrFinished //|| _thread::hasSleepingThreads()
){ // wait for userMain and all the threads to finish
        thread_dispatch();
    }

    /// exit user mode
    Riscv::changeMode(Riscv::Mode::SUPERVISOR);

    printStringS("FREEING-MAIN\n");

    delete t;
    delete usr;
    delete putc_buffer;
    delete getc_buffer;
    delete putcThread;

    printStringS(MemoryAllocator::instance().deallocatedAllMemory()?"\nDeallocated: YES.\n":"\nNot deallocated.\n");
    Riscv::halt();
    return 0;
}
