.macro PUSH_REGS
addi sp, sp, -256
  .irp index,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
  .endr
.endm

.macro POP_REGS
  .irp index,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
     ld x\index, \index * 8(sp)
  .endr
      addi sp, sp, 256
.endm

.macro PUSH_REGS_notA0
addi sp, sp, -256
  .irp index,0,1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
  .endr
.endm

.macro POP_REGS_notA0
  .irp index,0,1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
     ld x\index, \index * 8(sp)
  .endr
      addi sp, sp, 256
.endm

.extern _ZN8Handlers14handleSyscallsEv
.extern _ZN8Handlers11handleTimerEv
.extern _ZN8Handlers13handleConsoleEv
.align 4
.global _ZN8Handlers11trapHandlerEv
.type _ZN8Handlers11trapHandlerEv, @function

_ZN8Handlers11trapHandlerEv:

    PUSH_REGS

    call _ZN8Handlers11handleTimerEv # handleTimer
    andi a0, a0, 255
    bnez a0, pop_all # if a0 == 1 (a!=0), it's timer interrupt so branch and restore context

    call _ZN8Handlers13handleConsoleEv # handleConsole
    andi a0, a0, 255
    bnez a0, pop_all # if a0 == 1 (a!=0), it's console interrupt so branch and restore context


    # get arguments a0..a4
    ld x10, 10*8(sp)
    ld x11, 11*8(sp)
    ld x12, 12*8(sp)
    ld x13, 13*8(sp)
    ld x14, 14*8(sp)

    xori x10, x10, 0x13 # sysID::THREAD_DISPATCH
    beqz x10, call_dispatch # if it is sysID::THREAD_DISPATCH in a0 is 0 so jump

    ld x10, 10*8(sp) # restore a0 again
    call _ZN8Handlers14handleSyscallsEv # handleSyscalls

    POP_REGS_notA0 # in a0 is return value so don't pop a0

    sret

call_dispatch: ld x10, 10*8(sp) # restore a0 again
call _ZN8Handlers14handleSyscallsEv # handleSyscalls
pop_all:POP_REGS # restore ALL registers
    sret # pc <= sepc

