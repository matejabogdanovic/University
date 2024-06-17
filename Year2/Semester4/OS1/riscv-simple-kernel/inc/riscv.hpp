//
// Created by marko on 20.4.22..
//

#ifndef OS1_VEZBE07_RISCV_CONTEXT_SWITCH_1_SYNCHRONOUS_RISCV_HPP
#define OS1_VEZBE07_RISCV_CONTEXT_SWITCH_1_SYNCHRONOUS_RISCV_HPP

#include "../lib/hw.h"
#include "../inc/printingSupervisor.hpp"
#include "../inc/sysID.hpp"
#include "../inc/MemoryAllocator.hpp"
class Riscv
{
public:
    friend class Handlers;
//    // pop sstatus.spp and sstatus.spie bits (has to be a non inline function)
    static void popSstatusSPPandSPIE(bool swToUsr);
    enum Mode{
        USER, SUPERVISOR
    };
    static void changeMode(Mode mode);

    static void printStats();
    //
//    // push x3..x31 registers onto stack
//    static void pushRegisters();
//
//    // pop x3..x31 registers onto stack
//    static void popRegisters();

    // read register scause
    static uint64 r_scause();

    // write register scause
    static void w_scause(uint64 scause);

    // read register sepc
    static uint64 r_sepc();

    // write register sepc
    static void w_sepc(uint64 sepc);

    // read register stvec
    static uint64 r_stvec();

    // write register stvec
    static void w_stvec(uint64 stvec);

    // read register stval
    static uint64 r_stval();

    // write register stval
    static void w_stval(uint64 stval);

    enum BitMaskSip
    {
        SIP_SSIE = (1 << 1),
        SIP_STIE = (1 << 5),
        SIP_SEIE = (1 << 9),
    };

    // mask set register sip
    static void ms_sip(uint64 mask);

    // mask clear register sip
    static void mc_sip(uint64 mask);

    // read register sip
    static uint64 r_sip();

    // write register sip
    static void w_sip(uint64 sip);

    enum BitMaskSstatus
    {
        SSTATUS_SIE = (1 << 1),
        SSTATUS_SPIE = (1 << 5),
        SSTATUS_SPP = (1 << 8),
    };

    // mask set register sstatus
    static void ms_sstatus(uint64 mask);

    // mask clear register sstatus
    static void mc_sstatus(uint64 mask);

    // read register sstatus
    static uint64 r_sstatus();

    // write register sstatus
    static void w_sstatus(uint64 sstatus);

    // ====================================================================

    static void ecall();

    static uint64 r_a0();

    static void w_a0(uint64 a0);

    static uint64 r_a1();

    static void w_a1(uint64 a1);

    static uint64 r_a2();

    static void w_a2(uint64 a2);

    static uint64 r_a3();

    static void w_a3(uint64 a3);

    static uint64 r_a4();

    static void w_a4(uint64 a4);

    static void halt();
private:
    static void swMode(Mode mode); // only from trap
};

inline uint64 Riscv::r_scause()
{
    uint64 volatile scause;
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    return scause;
}

inline void Riscv::w_scause(uint64 scause)
{
    __asm__ volatile ("csrw scause, %[scause]" : : [scause] "r"(scause));
}

inline uint64 Riscv::r_sepc()
{
    uint64 volatile sepc;
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    return sepc;
}

inline void Riscv::w_sepc(uint64 sepc)
{
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
}

inline uint64 Riscv::r_stvec()
{
    uint64 volatile stvec;
    __asm__ volatile ("csrr %[stvec], stvec" : [stvec] "=r"(stvec));
    return stvec;
}

inline void Riscv::w_stvec(uint64 stvec)
{
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
}

inline uint64 Riscv::r_stval()
{
    uint64 volatile stval;
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    return stval;
}

inline void Riscv::w_stval(uint64 stval)
{
    __asm__ volatile ("csrw stval, %[stval]" : : [stval] "r"(stval));
}

inline void Riscv::ms_sip(uint64 mask)
{
    __asm__ volatile ("csrs sip, %[mask]" : : [mask] "r"(mask));
}

inline void Riscv::mc_sip(uint64 mask)
{
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
}

inline uint64 Riscv::r_sip()
{
    uint64 volatile sip;
    __asm__ volatile ("csrr %[sip], sip" : [sip] "=r"(sip));
    return sip;
}

inline void Riscv::w_sip(uint64 sip)
{
    __asm__ volatile ("csrw sip, %[sip]" : : [sip] "r"(sip));
}

inline void Riscv::ms_sstatus(uint64 mask)
{
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
}

inline void Riscv::mc_sstatus(uint64 mask)
{
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
}

inline uint64 Riscv::r_sstatus()
{
    uint64 volatile sstatus;
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    return sstatus;
}

inline void Riscv::w_sstatus(uint64 sstatus)
{
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
}

// ========================================================================


inline void Riscv::ecall() {
    __asm__ volatile ("ecall");
}

inline uint64 Riscv::r_a0() {
    uint64 volatile a0;
    __asm__ volatile ("mv %[a0], a0" : [a0] "=r"(a0));
    return a0;
}

inline void Riscv::w_a0(uint64 a0) {
    __asm__ volatile ("mv a0, %[a0]" : : [a0] "r"(a0));
}

inline uint64 Riscv::r_a1() {
    uint64 volatile a1;
    __asm__ volatile ("mv %[a1], a1" : [a1] "=r"(a1));
    return a1;
}

inline void Riscv::w_a1(uint64 a1) {
    __asm__ volatile ("mv a1, %[a1]" : : [a1] "r"(a1));
}

inline uint64 Riscv::r_a2() {
    uint64 volatile a2;
    __asm__ volatile ("mv %[a2], a2" : [a2] "=r"(a2));
    return a2;
}

inline void Riscv::w_a2(uint64 a2) {
    __asm__ volatile ("mv a2, %[a2]" : : [a2] "r"(a2));
}

inline uint64 Riscv::r_a3() {
    uint64 volatile a3;
    __asm__ volatile ("mv %[a3], a3" : [a3] "=r"(a3));
    return a3;
}

inline void Riscv::w_a3(uint64 a3) {
    __asm__ volatile ("mv a3, %[a3]" : : [a3] "r"(a3));
}

inline uint64 Riscv::r_a4() {
    uint64 volatile a4;
    __asm__ volatile ("mv %[a4], a4" : [a4] "=r"(a4));
    return a4;
}

inline void Riscv::w_a4(uint64 a4) {
    __asm__ volatile ("mv a4, %[a4]" : : [a4] "r"(a4));
}

inline void Riscv::halt() {
    __asm__ volatile("li t0, 0x5555");
    __asm__ volatile("li t1, 0x100000");
    __asm__ volatile("sw t0, 0(t1) ");
}

inline void Riscv::swMode(Riscv::Mode mode) {

    if(mode == USER) // change to user mode
        Riscv::mc_sstatus(Riscv::SSTATUS_SPP); // previous privileges
    else if(mode == SUPERVISOR)
        Riscv::ms_sstatus(Riscv::SSTATUS_SPP);

}

inline void Riscv::changeMode(Riscv::Mode mode) {
    Riscv::w_a0(sysID::CHANGE_MODE);
    Riscv::w_a1(mode); // 0 is user mode
    Riscv::ecall();
}

inline void Riscv::printStats() {
    printStringS("\t\t");
    printStringS("scause: ");printIntS(r_scause(), 16);printStringS("\t");
    printStringS("sstatus: ");printIntS(r_sstatus(), 16);printStringS("\t");
    printStringS("sepc: ");printIntS(r_sepc(), 16);printStringS("\t");
    printStringS("sip: ");printIntS(r_sip(), 16);printStringS("\t");
    printStringS("stval: ");printIntS(r_stval(), 16);printStringS("\t");
    printStringS("stvec: ");printIntS(r_stvec(), 16);printStringS("\n\t\t");
    printStringS("a0: ");printIntS(r_a0(), 16);printStringS("\t");
    printStringS("a1: ");printIntS(r_a1(), 16);printStringS("\t");
    printStringS("a2: ");printIntS(r_a2(), 16);printStringS("\t");
    printStringS("a3: ");printIntS(r_a3(), 16);printStringS("\t");
    printStringS("a4: ");printIntS(r_a4(), 16);printStringS("\n\t\t");

}


#endif //OS1_VEZBE07_RISCV_CONTEXT_SWITCH_1_SYNCHRONOUS_RISCV_HPP
