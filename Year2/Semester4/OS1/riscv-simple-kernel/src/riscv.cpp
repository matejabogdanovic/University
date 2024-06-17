//
// Created by os on 5/7/24.
//
#include "../inc/riscv.hpp"
#include "../inc/_thread.hpp"
void Riscv::popSstatusSPPandSPIE(bool swToUsr) {
    if(swToUsr)// change previous privileges
        Riscv::swMode(Mode::USER); // it will be switched when sret is called

    __asm__ volatile("csrw sepc, ra"); // sepc <= ra (it's line after this call)
    __asm__ volatile("sret"); // pc <= sepc (ra) and previous privileges set to current
}

