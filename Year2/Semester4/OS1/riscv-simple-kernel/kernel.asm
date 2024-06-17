
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000d117          	auipc	sp,0xd
    80000004:	e1813103          	ld	sp,-488(sp) # 8000ce18 <_GLOBAL_OFFSET_TABLE_+0x38>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	411070ef          	jal	ra,80007c2c <start>

0000000080000020 <spin>:
    80000020:	0000006f          	j	80000020 <spin>
	...

0000000080001000 <copy_and_swap>:
# a1 holds expected value
# a2 holds desired value
# a0 holds return value, 0 if successful, !0 otherwise
.global copy_and_swap
copy_and_swap:
    lr.w t0, (a0)          # Load original value.
    80001000:	100522af          	lr.w	t0,(a0)
    bne t0, a1, fail       # Doesn’t match, so fail.
    80001004:	00b29a63          	bne	t0,a1,80001018 <fail>
    sc.w t0, a2, (a0)      # Try to update.
    80001008:	18c522af          	sc.w	t0,a2,(a0)
    bnez t0, copy_and_swap # Retry if store-conditional failed.
    8000100c:	fe029ae3          	bnez	t0,80001000 <copy_and_swap>
    li a0, 0               # Set return to success.
    80001010:	00000513          	li	a0,0
    jr ra                  # Return.
    80001014:	00008067          	ret

0000000080001018 <fail>:
    fail:
    li a0, 1               # Set return to failure.
    80001018:	00100513          	li	a0,1
    8000101c:	00008067          	ret

0000000080001020 <_ZN8Handlers11trapHandlerEv>:
.global _ZN8Handlers11trapHandlerEv
.type _ZN8Handlers11trapHandlerEv, @function

_ZN8Handlers11trapHandlerEv:

    PUSH_REGS
    80001020:	f0010113          	addi	sp,sp,-256
    80001024:	00013023          	sd	zero,0(sp)
    80001028:	00113423          	sd	ra,8(sp)
    8000102c:	00213823          	sd	sp,16(sp)
    80001030:	00313c23          	sd	gp,24(sp)
    80001034:	02413023          	sd	tp,32(sp)
    80001038:	02513423          	sd	t0,40(sp)
    8000103c:	02613823          	sd	t1,48(sp)
    80001040:	02713c23          	sd	t2,56(sp)
    80001044:	04813023          	sd	s0,64(sp)
    80001048:	04913423          	sd	s1,72(sp)
    8000104c:	04a13823          	sd	a0,80(sp)
    80001050:	04b13c23          	sd	a1,88(sp)
    80001054:	06c13023          	sd	a2,96(sp)
    80001058:	06d13423          	sd	a3,104(sp)
    8000105c:	06e13823          	sd	a4,112(sp)
    80001060:	06f13c23          	sd	a5,120(sp)
    80001064:	09013023          	sd	a6,128(sp)
    80001068:	09113423          	sd	a7,136(sp)
    8000106c:	09213823          	sd	s2,144(sp)
    80001070:	09313c23          	sd	s3,152(sp)
    80001074:	0b413023          	sd	s4,160(sp)
    80001078:	0b513423          	sd	s5,168(sp)
    8000107c:	0b613823          	sd	s6,176(sp)
    80001080:	0b713c23          	sd	s7,184(sp)
    80001084:	0d813023          	sd	s8,192(sp)
    80001088:	0d913423          	sd	s9,200(sp)
    8000108c:	0da13823          	sd	s10,208(sp)
    80001090:	0db13c23          	sd	s11,216(sp)
    80001094:	0fc13023          	sd	t3,224(sp)
    80001098:	0fd13423          	sd	t4,232(sp)
    8000109c:	0fe13823          	sd	t5,240(sp)
    800010a0:	0ff13c23          	sd	t6,248(sp)

    call _ZN8Handlers11handleTimerEv # handleTimer
    800010a4:	079040ef          	jal	ra,8000591c <_ZN8Handlers11handleTimerEv>
    andi a0, a0, 255
    800010a8:	0ff57513          	andi	a0,a0,255
    bnez a0, pop_all # if a0 == 1 (a!=0), it's timer interrupt so branch and restore context
    800010ac:	0c051063          	bnez	a0,8000116c <pop_all>

    call _ZN8Handlers13handleConsoleEv # handleConsole
    800010b0:	149040ef          	jal	ra,800059f8 <_ZN8Handlers13handleConsoleEv>
    andi a0, a0, 255
    800010b4:	0ff57513          	andi	a0,a0,255
    bnez a0, pop_all # if a0 == 1 (a!=0), it's console interrupt so branch and restore context
    800010b8:	0a051a63          	bnez	a0,8000116c <pop_all>


    # get arguments a0..a4
    ld x10, 10*8(sp)
    800010bc:	05013503          	ld	a0,80(sp)
    ld x11, 11*8(sp)
    800010c0:	05813583          	ld	a1,88(sp)
    ld x12, 12*8(sp)
    800010c4:	06013603          	ld	a2,96(sp)
    ld x13, 13*8(sp)
    800010c8:	06813683          	ld	a3,104(sp)
    ld x14, 14*8(sp)
    800010cc:	07013703          	ld	a4,112(sp)

    xori x10, x10, 0x13 # sysID::THREAD_DISPATCH
    800010d0:	01354513          	xori	a0,a0,19
    beqz x10, call_dispatch # if it is sysID::THREAD_DISPATCH in a0 is 0 so jump
    800010d4:	08050863          	beqz	a0,80001164 <call_dispatch>

    ld x10, 10*8(sp) # restore a0 again
    800010d8:	05013503          	ld	a0,80(sp)
    call _ZN8Handlers14handleSyscallsEv # handleSyscalls
    800010dc:	405030ef          	jal	ra,80004ce0 <_ZN8Handlers14handleSyscallsEv>

    POP_REGS_notA0 # in a0 is return value so don't pop a0
    800010e0:	00013003          	ld	zero,0(sp)
    800010e4:	00813083          	ld	ra,8(sp)
    800010e8:	01013103          	ld	sp,16(sp)
    800010ec:	01813183          	ld	gp,24(sp)
    800010f0:	02013203          	ld	tp,32(sp)
    800010f4:	02813283          	ld	t0,40(sp)
    800010f8:	03013303          	ld	t1,48(sp)
    800010fc:	03813383          	ld	t2,56(sp)
    80001100:	04013403          	ld	s0,64(sp)
    80001104:	04813483          	ld	s1,72(sp)
    80001108:	05813583          	ld	a1,88(sp)
    8000110c:	06013603          	ld	a2,96(sp)
    80001110:	06813683          	ld	a3,104(sp)
    80001114:	07013703          	ld	a4,112(sp)
    80001118:	07813783          	ld	a5,120(sp)
    8000111c:	08013803          	ld	a6,128(sp)
    80001120:	08813883          	ld	a7,136(sp)
    80001124:	09013903          	ld	s2,144(sp)
    80001128:	09813983          	ld	s3,152(sp)
    8000112c:	0a013a03          	ld	s4,160(sp)
    80001130:	0a813a83          	ld	s5,168(sp)
    80001134:	0b013b03          	ld	s6,176(sp)
    80001138:	0b813b83          	ld	s7,184(sp)
    8000113c:	0c013c03          	ld	s8,192(sp)
    80001140:	0c813c83          	ld	s9,200(sp)
    80001144:	0d013d03          	ld	s10,208(sp)
    80001148:	0d813d83          	ld	s11,216(sp)
    8000114c:	0e013e03          	ld	t3,224(sp)
    80001150:	0e813e83          	ld	t4,232(sp)
    80001154:	0f013f03          	ld	t5,240(sp)
    80001158:	0f813f83          	ld	t6,248(sp)
    8000115c:	10010113          	addi	sp,sp,256

    sret
    80001160:	10200073          	sret

0000000080001164 <call_dispatch>:

call_dispatch: ld x10, 10*8(sp) # restore a0 again
    80001164:	05013503          	ld	a0,80(sp)
call _ZN8Handlers14handleSyscallsEv # handleSyscalls
    80001168:	379030ef          	jal	ra,80004ce0 <_ZN8Handlers14handleSyscallsEv>

000000008000116c <pop_all>:
pop_all:POP_REGS # restore ALL registers
    8000116c:	00013003          	ld	zero,0(sp)
    80001170:	00813083          	ld	ra,8(sp)
    80001174:	01013103          	ld	sp,16(sp)
    80001178:	01813183          	ld	gp,24(sp)
    8000117c:	02013203          	ld	tp,32(sp)
    80001180:	02813283          	ld	t0,40(sp)
    80001184:	03013303          	ld	t1,48(sp)
    80001188:	03813383          	ld	t2,56(sp)
    8000118c:	04013403          	ld	s0,64(sp)
    80001190:	04813483          	ld	s1,72(sp)
    80001194:	05013503          	ld	a0,80(sp)
    80001198:	05813583          	ld	a1,88(sp)
    8000119c:	06013603          	ld	a2,96(sp)
    800011a0:	06813683          	ld	a3,104(sp)
    800011a4:	07013703          	ld	a4,112(sp)
    800011a8:	07813783          	ld	a5,120(sp)
    800011ac:	08013803          	ld	a6,128(sp)
    800011b0:	08813883          	ld	a7,136(sp)
    800011b4:	09013903          	ld	s2,144(sp)
    800011b8:	09813983          	ld	s3,152(sp)
    800011bc:	0a013a03          	ld	s4,160(sp)
    800011c0:	0a813a83          	ld	s5,168(sp)
    800011c4:	0b013b03          	ld	s6,176(sp)
    800011c8:	0b813b83          	ld	s7,184(sp)
    800011cc:	0c013c03          	ld	s8,192(sp)
    800011d0:	0c813c83          	ld	s9,200(sp)
    800011d4:	0d013d03          	ld	s10,208(sp)
    800011d8:	0d813d83          	ld	s11,216(sp)
    800011dc:	0e013e03          	ld	t3,224(sp)
    800011e0:	0e813e83          	ld	t4,232(sp)
    800011e4:	0f013f03          	ld	t5,240(sp)
    800011e8:	0f813f83          	ld	t6,248(sp)
    800011ec:	10010113          	addi	sp,sp,256
    sret # pc <= sepc
    800011f0:	10200073          	sret

00000000800011f4 <_ZN7_thread13contextSwitchEPNS_7ContextES1_b>:
.global _ZN7_thread13contextSwitchEPNS_7ContextES1_b
.type _ZN7_thread13contextSwitchEPNS_7ContextES1_b, @function
_ZN7_thread13contextSwitchEPNS_7ContextES1_b:
    # a0 is oldContext, a1 is newContext, a2 is bool true if should save old context

    andi a2, a2, 255 # if old thread deallocated branch and load only new context
    800011f4:	0ff67613          	andi	a2,a2,255
    bnez a2, load_new_context   #_ZN7_thread13contextSwitchEPNS_7ContextES1_b
    800011f8:	00061663          	bnez	a2,80001204 <load_new_context>

    sd ra, 0*8(a0)
    800011fc:	00153023          	sd	ra,0(a0) # 1000 <_entry-0x7ffff000>
    sd sp, 1*8(a0)
    80001200:	00253423          	sd	sp,8(a0)

0000000080001204 <load_new_context>:

load_new_context:
    ld ra, 0*8(a1)
    80001204:	0005b083          	ld	ra,0(a1)
    ld sp, 1*8(a1)
    80001208:	0085b103          	ld	sp,8(a1)

    8000120c:	00008067          	ret

0000000080001210 <_ZL16producerKeyboardPv>:
    sem_t wait;
};

static volatile int threadEnd = 0;

static void producerKeyboard(void *arg) {
    80001210:	fe010113          	addi	sp,sp,-32
    80001214:	00113c23          	sd	ra,24(sp)
    80001218:	00813823          	sd	s0,16(sp)
    8000121c:	00913423          	sd	s1,8(sp)
    80001220:	01213023          	sd	s2,0(sp)
    80001224:	02010413          	addi	s0,sp,32
    80001228:	00050493          	mv	s1,a0
    struct thread_data *data = (struct thread_data *) arg;

    int key;
    int i = 0;
    8000122c:	00000913          	li	s2,0
    80001230:	00c0006f          	j	8000123c <_ZL16producerKeyboardPv+0x2c>
    while ((key = getc()) != 0x1b) {
        data->buffer->put(key);
        i++;

        if (i % (10 * data->id) == 0) {
            thread_dispatch();
    80001234:	00004097          	auipc	ra,0x4
    80001238:	818080e7          	jalr	-2024(ra) # 80004a4c <thread_dispatch>
    while ((key = getc()) != 0x1b) {
    8000123c:	00004097          	auipc	ra,0x4
    80001240:	a28080e7          	jalr	-1496(ra) # 80004c64 <getc>
    80001244:	0005059b          	sext.w	a1,a0
    80001248:	01b00793          	li	a5,27
    8000124c:	02f58a63          	beq	a1,a5,80001280 <_ZL16producerKeyboardPv+0x70>
        data->buffer->put(key);
    80001250:	0084b503          	ld	a0,8(s1)
    80001254:	00003097          	auipc	ra,0x3
    80001258:	400080e7          	jalr	1024(ra) # 80004654 <_ZN6Buffer3putEi>
        i++;
    8000125c:	0019071b          	addiw	a4,s2,1
    80001260:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    80001264:	0004a683          	lw	a3,0(s1)
    80001268:	0026979b          	slliw	a5,a3,0x2
    8000126c:	00d787bb          	addw	a5,a5,a3
    80001270:	0017979b          	slliw	a5,a5,0x1
    80001274:	02f767bb          	remw	a5,a4,a5
    80001278:	fc0792e3          	bnez	a5,8000123c <_ZL16producerKeyboardPv+0x2c>
    8000127c:	fb9ff06f          	j	80001234 <_ZL16producerKeyboardPv+0x24>
        }
    }

    threadEnd = 1;
    80001280:	00100793          	li	a5,1
    80001284:	0000c717          	auipc	a4,0xc
    80001288:	c2f72623          	sw	a5,-980(a4) # 8000ceb0 <_ZL9threadEnd>
    data->buffer->put('!');
    8000128c:	02100593          	li	a1,33
    80001290:	0084b503          	ld	a0,8(s1)
    80001294:	00003097          	auipc	ra,0x3
    80001298:	3c0080e7          	jalr	960(ra) # 80004654 <_ZN6Buffer3putEi>

    sem_signal(data->wait);
    8000129c:	0104b503          	ld	a0,16(s1)
    800012a0:	00004097          	auipc	ra,0x4
    800012a4:	8ac080e7          	jalr	-1876(ra) # 80004b4c <sem_signal>
}
    800012a8:	01813083          	ld	ra,24(sp)
    800012ac:	01013403          	ld	s0,16(sp)
    800012b0:	00813483          	ld	s1,8(sp)
    800012b4:	00013903          	ld	s2,0(sp)
    800012b8:	02010113          	addi	sp,sp,32
    800012bc:	00008067          	ret

00000000800012c0 <_ZL8producerPv>:

static void producer(void *arg) {
    800012c0:	fe010113          	addi	sp,sp,-32
    800012c4:	00113c23          	sd	ra,24(sp)
    800012c8:	00813823          	sd	s0,16(sp)
    800012cc:	00913423          	sd	s1,8(sp)
    800012d0:	01213023          	sd	s2,0(sp)
    800012d4:	02010413          	addi	s0,sp,32
    800012d8:	00050493          	mv	s1,a0
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    800012dc:	00000913          	li	s2,0
    800012e0:	00c0006f          	j	800012ec <_ZL8producerPv+0x2c>
    while (!threadEnd) {
        data->buffer->put(data->id + '0');
        i++;

        if (i % (10 * data->id) == 0) {
            thread_dispatch();
    800012e4:	00003097          	auipc	ra,0x3
    800012e8:	768080e7          	jalr	1896(ra) # 80004a4c <thread_dispatch>
    while (!threadEnd) {
    800012ec:	0000c797          	auipc	a5,0xc
    800012f0:	bc47a783          	lw	a5,-1084(a5) # 8000ceb0 <_ZL9threadEnd>
    800012f4:	02079e63          	bnez	a5,80001330 <_ZL8producerPv+0x70>
        data->buffer->put(data->id + '0');
    800012f8:	0004a583          	lw	a1,0(s1)
    800012fc:	0305859b          	addiw	a1,a1,48
    80001300:	0084b503          	ld	a0,8(s1)
    80001304:	00003097          	auipc	ra,0x3
    80001308:	350080e7          	jalr	848(ra) # 80004654 <_ZN6Buffer3putEi>
        i++;
    8000130c:	0019071b          	addiw	a4,s2,1
    80001310:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    80001314:	0004a683          	lw	a3,0(s1)
    80001318:	0026979b          	slliw	a5,a3,0x2
    8000131c:	00d787bb          	addw	a5,a5,a3
    80001320:	0017979b          	slliw	a5,a5,0x1
    80001324:	02f767bb          	remw	a5,a4,a5
    80001328:	fc0792e3          	bnez	a5,800012ec <_ZL8producerPv+0x2c>
    8000132c:	fb9ff06f          	j	800012e4 <_ZL8producerPv+0x24>
        }
    }

    sem_signal(data->wait);
    80001330:	0104b503          	ld	a0,16(s1)
    80001334:	00004097          	auipc	ra,0x4
    80001338:	818080e7          	jalr	-2024(ra) # 80004b4c <sem_signal>
}
    8000133c:	01813083          	ld	ra,24(sp)
    80001340:	01013403          	ld	s0,16(sp)
    80001344:	00813483          	ld	s1,8(sp)
    80001348:	00013903          	ld	s2,0(sp)
    8000134c:	02010113          	addi	sp,sp,32
    80001350:	00008067          	ret

0000000080001354 <_ZL8consumerPv>:

static void consumer(void *arg) {
    80001354:	fd010113          	addi	sp,sp,-48
    80001358:	02113423          	sd	ra,40(sp)
    8000135c:	02813023          	sd	s0,32(sp)
    80001360:	00913c23          	sd	s1,24(sp)
    80001364:	01213823          	sd	s2,16(sp)
    80001368:	01313423          	sd	s3,8(sp)
    8000136c:	03010413          	addi	s0,sp,48
    80001370:	00050913          	mv	s2,a0
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    80001374:	00000993          	li	s3,0
    80001378:	01c0006f          	j	80001394 <_ZL8consumerPv+0x40>
        i++;

        putc(key);

        if (i % (5 * data->id) == 0) {
            thread_dispatch();
    8000137c:	00003097          	auipc	ra,0x3
    80001380:	6d0080e7          	jalr	1744(ra) # 80004a4c <thread_dispatch>
    80001384:	0500006f          	j	800013d4 <_ZL8consumerPv+0x80>
        }

        if (i % 80 == 0) {
            putc('\n');
    80001388:	00a00513          	li	a0,10
    8000138c:	00004097          	auipc	ra,0x4
    80001390:	918080e7          	jalr	-1768(ra) # 80004ca4 <putc>
    while (!threadEnd) {
    80001394:	0000c797          	auipc	a5,0xc
    80001398:	b1c7a783          	lw	a5,-1252(a5) # 8000ceb0 <_ZL9threadEnd>
    8000139c:	06079063          	bnez	a5,800013fc <_ZL8consumerPv+0xa8>
        int key = data->buffer->get();
    800013a0:	00893503          	ld	a0,8(s2)
    800013a4:	00003097          	auipc	ra,0x3
    800013a8:	340080e7          	jalr	832(ra) # 800046e4 <_ZN6Buffer3getEv>
        i++;
    800013ac:	0019849b          	addiw	s1,s3,1
    800013b0:	0004899b          	sext.w	s3,s1
        putc(key);
    800013b4:	0ff57513          	andi	a0,a0,255
    800013b8:	00004097          	auipc	ra,0x4
    800013bc:	8ec080e7          	jalr	-1812(ra) # 80004ca4 <putc>
        if (i % (5 * data->id) == 0) {
    800013c0:	00092703          	lw	a4,0(s2)
    800013c4:	0027179b          	slliw	a5,a4,0x2
    800013c8:	00e787bb          	addw	a5,a5,a4
    800013cc:	02f4e7bb          	remw	a5,s1,a5
    800013d0:	fa0786e3          	beqz	a5,8000137c <_ZL8consumerPv+0x28>
        if (i % 80 == 0) {
    800013d4:	05000793          	li	a5,80
    800013d8:	02f4e4bb          	remw	s1,s1,a5
    800013dc:	fa049ce3          	bnez	s1,80001394 <_ZL8consumerPv+0x40>
    800013e0:	fa9ff06f          	j	80001388 <_ZL8consumerPv+0x34>
        }
    }

    while (data->buffer->getCnt() > 0) {
        int key = data->buffer->get();
    800013e4:	00893503          	ld	a0,8(s2)
    800013e8:	00003097          	auipc	ra,0x3
    800013ec:	2fc080e7          	jalr	764(ra) # 800046e4 <_ZN6Buffer3getEv>
        putc(key);
    800013f0:	0ff57513          	andi	a0,a0,255
    800013f4:	00004097          	auipc	ra,0x4
    800013f8:	8b0080e7          	jalr	-1872(ra) # 80004ca4 <putc>
    while (data->buffer->getCnt() > 0) {
    800013fc:	00893503          	ld	a0,8(s2)
    80001400:	00003097          	auipc	ra,0x3
    80001404:	370080e7          	jalr	880(ra) # 80004770 <_ZN6Buffer6getCntEv>
    80001408:	fca04ee3          	bgtz	a0,800013e4 <_ZL8consumerPv+0x90>
    }

    sem_signal(data->wait);
    8000140c:	01093503          	ld	a0,16(s2)
    80001410:	00003097          	auipc	ra,0x3
    80001414:	73c080e7          	jalr	1852(ra) # 80004b4c <sem_signal>
}
    80001418:	02813083          	ld	ra,40(sp)
    8000141c:	02013403          	ld	s0,32(sp)
    80001420:	01813483          	ld	s1,24(sp)
    80001424:	01013903          	ld	s2,16(sp)
    80001428:	00813983          	ld	s3,8(sp)
    8000142c:	03010113          	addi	sp,sp,48
    80001430:	00008067          	ret

0000000080001434 <_Z22producerConsumer_C_APIv>:

void producerConsumer_C_API() {
    80001434:	f9010113          	addi	sp,sp,-112
    80001438:	06113423          	sd	ra,104(sp)
    8000143c:	06813023          	sd	s0,96(sp)
    80001440:	04913c23          	sd	s1,88(sp)
    80001444:	05213823          	sd	s2,80(sp)
    80001448:	05313423          	sd	s3,72(sp)
    8000144c:	05413023          	sd	s4,64(sp)
    80001450:	03513c23          	sd	s5,56(sp)
    80001454:	03613823          	sd	s6,48(sp)
    80001458:	07010413          	addi	s0,sp,112
        sem_wait(waitForAll);
    }

    sem_close(waitForAll);

    delete buffer;
    8000145c:	00010b13          	mv	s6,sp
    printString("Unesite broj proizvodjaca?\n");
    80001460:	00009517          	auipc	a0,0x9
    80001464:	bc050513          	addi	a0,a0,-1088 # 8000a020 <CONSOLE_STATUS+0x10>
    80001468:	00002097          	auipc	ra,0x2
    8000146c:	220080e7          	jalr	544(ra) # 80003688 <_Z11printStringPKc>
    getString(input, 30);
    80001470:	01e00593          	li	a1,30
    80001474:	fa040493          	addi	s1,s0,-96
    80001478:	00048513          	mv	a0,s1
    8000147c:	00002097          	auipc	ra,0x2
    80001480:	294080e7          	jalr	660(ra) # 80003710 <_Z9getStringPci>
    threadNum = stringToInt(input);
    80001484:	00048513          	mv	a0,s1
    80001488:	00002097          	auipc	ra,0x2
    8000148c:	360080e7          	jalr	864(ra) # 800037e8 <_Z11stringToIntPKc>
    80001490:	00050913          	mv	s2,a0
    printString("Unesite velicinu bafera?\n");
    80001494:	00009517          	auipc	a0,0x9
    80001498:	bac50513          	addi	a0,a0,-1108 # 8000a040 <CONSOLE_STATUS+0x30>
    8000149c:	00002097          	auipc	ra,0x2
    800014a0:	1ec080e7          	jalr	492(ra) # 80003688 <_Z11printStringPKc>
    getString(input, 30);
    800014a4:	01e00593          	li	a1,30
    800014a8:	00048513          	mv	a0,s1
    800014ac:	00002097          	auipc	ra,0x2
    800014b0:	264080e7          	jalr	612(ra) # 80003710 <_Z9getStringPci>
    n = stringToInt(input);
    800014b4:	00048513          	mv	a0,s1
    800014b8:	00002097          	auipc	ra,0x2
    800014bc:	330080e7          	jalr	816(ra) # 800037e8 <_Z11stringToIntPKc>
    800014c0:	00050493          	mv	s1,a0
    printString("Broj proizvodjaca "); printInt(threadNum);
    800014c4:	00009517          	auipc	a0,0x9
    800014c8:	b9c50513          	addi	a0,a0,-1124 # 8000a060 <CONSOLE_STATUS+0x50>
    800014cc:	00002097          	auipc	ra,0x2
    800014d0:	1bc080e7          	jalr	444(ra) # 80003688 <_Z11printStringPKc>
    800014d4:	00000613          	li	a2,0
    800014d8:	00a00593          	li	a1,10
    800014dc:	00090513          	mv	a0,s2
    800014e0:	00002097          	auipc	ra,0x2
    800014e4:	358080e7          	jalr	856(ra) # 80003838 <_Z8printIntiii>
    printString(" i velicina bafera "); printInt(n);
    800014e8:	00009517          	auipc	a0,0x9
    800014ec:	b9050513          	addi	a0,a0,-1136 # 8000a078 <CONSOLE_STATUS+0x68>
    800014f0:	00002097          	auipc	ra,0x2
    800014f4:	198080e7          	jalr	408(ra) # 80003688 <_Z11printStringPKc>
    800014f8:	00000613          	li	a2,0
    800014fc:	00a00593          	li	a1,10
    80001500:	00048513          	mv	a0,s1
    80001504:	00002097          	auipc	ra,0x2
    80001508:	334080e7          	jalr	820(ra) # 80003838 <_Z8printIntiii>
    printString(".\n");
    8000150c:	00009517          	auipc	a0,0x9
    80001510:	1a450513          	addi	a0,a0,420 # 8000a6b0 <CONSOLE_STATUS+0x6a0>
    80001514:	00002097          	auipc	ra,0x2
    80001518:	174080e7          	jalr	372(ra) # 80003688 <_Z11printStringPKc>
    if(threadNum > n) {
    8000151c:	0324c463          	blt	s1,s2,80001544 <_Z22producerConsumer_C_APIv+0x110>
    } else if (threadNum < 1) {
    80001520:	03205c63          	blez	s2,80001558 <_Z22producerConsumer_C_APIv+0x124>
    Buffer *buffer = new Buffer(n);
    80001524:	03800513          	li	a0,56
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	430080e7          	jalr	1072(ra) # 80006958 <_Znwm>
    80001530:	00050a13          	mv	s4,a0
    80001534:	00048593          	mv	a1,s1
    80001538:	00003097          	auipc	ra,0x3
    8000153c:	080080e7          	jalr	128(ra) # 800045b8 <_ZN6BufferC1Ei>
    80001540:	0300006f          	j	80001570 <_Z22producerConsumer_C_APIv+0x13c>
        printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    80001544:	00009517          	auipc	a0,0x9
    80001548:	b4c50513          	addi	a0,a0,-1204 # 8000a090 <CONSOLE_STATUS+0x80>
    8000154c:	00002097          	auipc	ra,0x2
    80001550:	13c080e7          	jalr	316(ra) # 80003688 <_Z11printStringPKc>
        return;
    80001554:	0140006f          	j	80001568 <_Z22producerConsumer_C_APIv+0x134>
        printString("Broj proizvodjaca mora biti veci od nula!\n");
    80001558:	00009517          	auipc	a0,0x9
    8000155c:	b7850513          	addi	a0,a0,-1160 # 8000a0d0 <CONSOLE_STATUS+0xc0>
    80001560:	00002097          	auipc	ra,0x2
    80001564:	128080e7          	jalr	296(ra) # 80003688 <_Z11printStringPKc>
        return;
    80001568:	000b0113          	mv	sp,s6
    8000156c:	1500006f          	j	800016bc <_Z22producerConsumer_C_APIv+0x288>
    sem_open(&waitForAll, 0);
    80001570:	00000593          	li	a1,0
    80001574:	0000c517          	auipc	a0,0xc
    80001578:	94450513          	addi	a0,a0,-1724 # 8000ceb8 <_ZL10waitForAll>
    8000157c:	00003097          	auipc	ra,0x3
    80001580:	50c080e7          	jalr	1292(ra) # 80004a88 <sem_open>
    thread_t threads[threadNum];
    80001584:	00391793          	slli	a5,s2,0x3
    80001588:	00f78793          	addi	a5,a5,15
    8000158c:	ff07f793          	andi	a5,a5,-16
    80001590:	40f10133          	sub	sp,sp,a5
    80001594:	00010a93          	mv	s5,sp
    struct thread_data data[threadNum + 1];
    80001598:	0019071b          	addiw	a4,s2,1
    8000159c:	00171793          	slli	a5,a4,0x1
    800015a0:	00e787b3          	add	a5,a5,a4
    800015a4:	00379793          	slli	a5,a5,0x3
    800015a8:	00f78793          	addi	a5,a5,15
    800015ac:	ff07f793          	andi	a5,a5,-16
    800015b0:	40f10133          	sub	sp,sp,a5
    800015b4:	00010993          	mv	s3,sp
    data[threadNum].id = threadNum;
    800015b8:	00191613          	slli	a2,s2,0x1
    800015bc:	012607b3          	add	a5,a2,s2
    800015c0:	00379793          	slli	a5,a5,0x3
    800015c4:	00f987b3          	add	a5,s3,a5
    800015c8:	0127a023          	sw	s2,0(a5)
    data[threadNum].buffer = buffer;
    800015cc:	0147b423          	sd	s4,8(a5)
    data[threadNum].wait = waitForAll;
    800015d0:	0000c717          	auipc	a4,0xc
    800015d4:	8e873703          	ld	a4,-1816(a4) # 8000ceb8 <_ZL10waitForAll>
    800015d8:	00e7b823          	sd	a4,16(a5)
    thread_create(&consumerThread, consumer, data + threadNum);
    800015dc:	00078613          	mv	a2,a5
    800015e0:	00000597          	auipc	a1,0x0
    800015e4:	d7458593          	addi	a1,a1,-652 # 80001354 <_ZL8consumerPv>
    800015e8:	f9840513          	addi	a0,s0,-104
    800015ec:	00003097          	auipc	ra,0x3
    800015f0:	3a4080e7          	jalr	932(ra) # 80004990 <thread_create>
    for (int i = 0; i < threadNum; i++) {
    800015f4:	00000493          	li	s1,0
    800015f8:	0280006f          	j	80001620 <_Z22producerConsumer_C_APIv+0x1ec>
        thread_create(threads + i,
    800015fc:	00000597          	auipc	a1,0x0
    80001600:	c1458593          	addi	a1,a1,-1004 # 80001210 <_ZL16producerKeyboardPv>
                      data + i);
    80001604:	00179613          	slli	a2,a5,0x1
    80001608:	00f60633          	add	a2,a2,a5
    8000160c:	00361613          	slli	a2,a2,0x3
        thread_create(threads + i,
    80001610:	00c98633          	add	a2,s3,a2
    80001614:	00003097          	auipc	ra,0x3
    80001618:	37c080e7          	jalr	892(ra) # 80004990 <thread_create>
    for (int i = 0; i < threadNum; i++) {
    8000161c:	0014849b          	addiw	s1,s1,1
    80001620:	0524d263          	bge	s1,s2,80001664 <_Z22producerConsumer_C_APIv+0x230>
        data[i].id = i;
    80001624:	00149793          	slli	a5,s1,0x1
    80001628:	009787b3          	add	a5,a5,s1
    8000162c:	00379793          	slli	a5,a5,0x3
    80001630:	00f987b3          	add	a5,s3,a5
    80001634:	0097a023          	sw	s1,0(a5)
        data[i].buffer = buffer;
    80001638:	0147b423          	sd	s4,8(a5)
        data[i].wait = waitForAll;
    8000163c:	0000c717          	auipc	a4,0xc
    80001640:	87c73703          	ld	a4,-1924(a4) # 8000ceb8 <_ZL10waitForAll>
    80001644:	00e7b823          	sd	a4,16(a5)
        thread_create(threads + i,
    80001648:	00048793          	mv	a5,s1
    8000164c:	00349513          	slli	a0,s1,0x3
    80001650:	00aa8533          	add	a0,s5,a0
    80001654:	fa9054e3          	blez	s1,800015fc <_Z22producerConsumer_C_APIv+0x1c8>
    80001658:	00000597          	auipc	a1,0x0
    8000165c:	c6858593          	addi	a1,a1,-920 # 800012c0 <_ZL8producerPv>
    80001660:	fa5ff06f          	j	80001604 <_Z22producerConsumer_C_APIv+0x1d0>
    thread_dispatch();
    80001664:	00003097          	auipc	ra,0x3
    80001668:	3e8080e7          	jalr	1000(ra) # 80004a4c <thread_dispatch>
    for (int i = 0; i <= threadNum; i++) {
    8000166c:	00000493          	li	s1,0
    80001670:	00994e63          	blt	s2,s1,8000168c <_Z22producerConsumer_C_APIv+0x258>
        sem_wait(waitForAll);
    80001674:	0000c517          	auipc	a0,0xc
    80001678:	84453503          	ld	a0,-1980(a0) # 8000ceb8 <_ZL10waitForAll>
    8000167c:	00003097          	auipc	ra,0x3
    80001680:	490080e7          	jalr	1168(ra) # 80004b0c <sem_wait>
    for (int i = 0; i <= threadNum; i++) {
    80001684:	0014849b          	addiw	s1,s1,1
    80001688:	fe9ff06f          	j	80001670 <_Z22producerConsumer_C_APIv+0x23c>
    sem_close(waitForAll);
    8000168c:	0000c517          	auipc	a0,0xc
    80001690:	82c53503          	ld	a0,-2004(a0) # 8000ceb8 <_ZL10waitForAll>
    80001694:	00003097          	auipc	ra,0x3
    80001698:	438080e7          	jalr	1080(ra) # 80004acc <sem_close>
    delete buffer;
    8000169c:	000a0e63          	beqz	s4,800016b8 <_Z22producerConsumer_C_APIv+0x284>
    800016a0:	000a0513          	mv	a0,s4
    800016a4:	00003097          	auipc	ra,0x3
    800016a8:	154080e7          	jalr	340(ra) # 800047f8 <_ZN6BufferD1Ev>
    800016ac:	000a0513          	mv	a0,s4
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	2d0080e7          	jalr	720(ra) # 80006980 <_ZdlPv>
    800016b8:	000b0113          	mv	sp,s6

}
    800016bc:	f9040113          	addi	sp,s0,-112
    800016c0:	06813083          	ld	ra,104(sp)
    800016c4:	06013403          	ld	s0,96(sp)
    800016c8:	05813483          	ld	s1,88(sp)
    800016cc:	05013903          	ld	s2,80(sp)
    800016d0:	04813983          	ld	s3,72(sp)
    800016d4:	04013a03          	ld	s4,64(sp)
    800016d8:	03813a83          	ld	s5,56(sp)
    800016dc:	03013b03          	ld	s6,48(sp)
    800016e0:	07010113          	addi	sp,sp,112
    800016e4:	00008067          	ret
    800016e8:	00050493          	mv	s1,a0
    Buffer *buffer = new Buffer(n);
    800016ec:	000a0513          	mv	a0,s4
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	290080e7          	jalr	656(ra) # 80006980 <_ZdlPv>
    800016f8:	00048513          	mv	a0,s1
    800016fc:	0000d097          	auipc	ra,0xd
    80001700:	94c080e7          	jalr	-1716(ra) # 8000e048 <_Unwind_Resume>

0000000080001704 <_ZL9fibonaccim>:
static volatile bool finishedA = false;
static volatile bool finishedB = false;
static volatile bool finishedC = false;
static volatile bool finishedD = false;

static uint64 fibonacci(uint64 n) {
    80001704:	fe010113          	addi	sp,sp,-32
    80001708:	00113c23          	sd	ra,24(sp)
    8000170c:	00813823          	sd	s0,16(sp)
    80001710:	00913423          	sd	s1,8(sp)
    80001714:	01213023          	sd	s2,0(sp)
    80001718:	02010413          	addi	s0,sp,32
    8000171c:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    80001720:	00100793          	li	a5,1
    80001724:	02a7f863          	bgeu	a5,a0,80001754 <_ZL9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    80001728:	00a00793          	li	a5,10
    8000172c:	02f577b3          	remu	a5,a0,a5
    80001730:	02078e63          	beqz	a5,8000176c <_ZL9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    80001734:	fff48513          	addi	a0,s1,-1
    80001738:	00000097          	auipc	ra,0x0
    8000173c:	fcc080e7          	jalr	-52(ra) # 80001704 <_ZL9fibonaccim>
    80001740:	00050913          	mv	s2,a0
    80001744:	ffe48513          	addi	a0,s1,-2
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	fbc080e7          	jalr	-68(ra) # 80001704 <_ZL9fibonaccim>
    80001750:	00a90533          	add	a0,s2,a0
}
    80001754:	01813083          	ld	ra,24(sp)
    80001758:	01013403          	ld	s0,16(sp)
    8000175c:	00813483          	ld	s1,8(sp)
    80001760:	00013903          	ld	s2,0(sp)
    80001764:	02010113          	addi	sp,sp,32
    80001768:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    8000176c:	00003097          	auipc	ra,0x3
    80001770:	2e0080e7          	jalr	736(ra) # 80004a4c <thread_dispatch>
    80001774:	fc1ff06f          	j	80001734 <_ZL9fibonaccim+0x30>

0000000080001778 <_ZN7WorkerA11workerBodyAEPv>:
    void run() override {
        workerBodyD(nullptr);
    }
};

void WorkerA::workerBodyA(void *arg) {
    80001778:	fe010113          	addi	sp,sp,-32
    8000177c:	00113c23          	sd	ra,24(sp)
    80001780:	00813823          	sd	s0,16(sp)
    80001784:	00913423          	sd	s1,8(sp)
    80001788:	01213023          	sd	s2,0(sp)
    8000178c:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    80001790:	00000913          	li	s2,0
    80001794:	0380006f          	j	800017cc <_ZN7WorkerA11workerBodyAEPv+0x54>
        printString("A: i="); printInt(i); printString("\n");
        for (uint64 j = 0; j < 10000; j++) {
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
            thread_dispatch();
    80001798:	00003097          	auipc	ra,0x3
    8000179c:	2b4080e7          	jalr	692(ra) # 80004a4c <thread_dispatch>
        for (uint64 j = 0; j < 10000; j++) {
    800017a0:	00148493          	addi	s1,s1,1
    800017a4:	000027b7          	lui	a5,0x2
    800017a8:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    800017ac:	0097ee63          	bltu	a5,s1,800017c8 <_ZN7WorkerA11workerBodyAEPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    800017b0:	00000713          	li	a4,0
    800017b4:	000077b7          	lui	a5,0x7
    800017b8:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    800017bc:	fce7eee3          	bltu	a5,a4,80001798 <_ZN7WorkerA11workerBodyAEPv+0x20>
    800017c0:	00170713          	addi	a4,a4,1
    800017c4:	ff1ff06f          	j	800017b4 <_ZN7WorkerA11workerBodyAEPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    800017c8:	00190913          	addi	s2,s2,1
    800017cc:	00900793          	li	a5,9
    800017d0:	0527e063          	bltu	a5,s2,80001810 <_ZN7WorkerA11workerBodyAEPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    800017d4:	00009517          	auipc	a0,0x9
    800017d8:	92c50513          	addi	a0,a0,-1748 # 8000a100 <CONSOLE_STATUS+0xf0>
    800017dc:	00002097          	auipc	ra,0x2
    800017e0:	eac080e7          	jalr	-340(ra) # 80003688 <_Z11printStringPKc>
    800017e4:	00000613          	li	a2,0
    800017e8:	00a00593          	li	a1,10
    800017ec:	0009051b          	sext.w	a0,s2
    800017f0:	00002097          	auipc	ra,0x2
    800017f4:	048080e7          	jalr	72(ra) # 80003838 <_Z8printIntiii>
    800017f8:	00009517          	auipc	a0,0x9
    800017fc:	b5850513          	addi	a0,a0,-1192 # 8000a350 <CONSOLE_STATUS+0x340>
    80001800:	00002097          	auipc	ra,0x2
    80001804:	e88080e7          	jalr	-376(ra) # 80003688 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80001808:	00000493          	li	s1,0
    8000180c:	f99ff06f          	j	800017a4 <_ZN7WorkerA11workerBodyAEPv+0x2c>
        }
    }
    printString("A finished!\n");
    80001810:	00009517          	auipc	a0,0x9
    80001814:	8f850513          	addi	a0,a0,-1800 # 8000a108 <CONSOLE_STATUS+0xf8>
    80001818:	00002097          	auipc	ra,0x2
    8000181c:	e70080e7          	jalr	-400(ra) # 80003688 <_Z11printStringPKc>
    finishedA = true;
    80001820:	00100793          	li	a5,1
    80001824:	0000b717          	auipc	a4,0xb
    80001828:	68f70e23          	sb	a5,1692(a4) # 8000cec0 <_ZL9finishedA>
}
    8000182c:	01813083          	ld	ra,24(sp)
    80001830:	01013403          	ld	s0,16(sp)
    80001834:	00813483          	ld	s1,8(sp)
    80001838:	00013903          	ld	s2,0(sp)
    8000183c:	02010113          	addi	sp,sp,32
    80001840:	00008067          	ret

0000000080001844 <_ZN7WorkerB11workerBodyBEPv>:

void WorkerB::workerBodyB(void *arg) {
    80001844:	fe010113          	addi	sp,sp,-32
    80001848:	00113c23          	sd	ra,24(sp)
    8000184c:	00813823          	sd	s0,16(sp)
    80001850:	00913423          	sd	s1,8(sp)
    80001854:	01213023          	sd	s2,0(sp)
    80001858:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    8000185c:	00000913          	li	s2,0
    80001860:	0380006f          	j	80001898 <_ZN7WorkerB11workerBodyBEPv+0x54>
        printString("B: i="); printInt(i); printString("\n");
        for (uint64 j = 0; j < 10000; j++) {
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
            thread_dispatch();
    80001864:	00003097          	auipc	ra,0x3
    80001868:	1e8080e7          	jalr	488(ra) # 80004a4c <thread_dispatch>
        for (uint64 j = 0; j < 10000; j++) {
    8000186c:	00148493          	addi	s1,s1,1
    80001870:	000027b7          	lui	a5,0x2
    80001874:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80001878:	0097ee63          	bltu	a5,s1,80001894 <_ZN7WorkerB11workerBodyBEPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    8000187c:	00000713          	li	a4,0
    80001880:	000077b7          	lui	a5,0x7
    80001884:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80001888:	fce7eee3          	bltu	a5,a4,80001864 <_ZN7WorkerB11workerBodyBEPv+0x20>
    8000188c:	00170713          	addi	a4,a4,1
    80001890:	ff1ff06f          	j	80001880 <_ZN7WorkerB11workerBodyBEPv+0x3c>
    for (uint64 i = 0; i < 16; i++) {
    80001894:	00190913          	addi	s2,s2,1
    80001898:	00f00793          	li	a5,15
    8000189c:	0527e063          	bltu	a5,s2,800018dc <_ZN7WorkerB11workerBodyBEPv+0x98>
        printString("B: i="); printInt(i); printString("\n");
    800018a0:	00009517          	auipc	a0,0x9
    800018a4:	87850513          	addi	a0,a0,-1928 # 8000a118 <CONSOLE_STATUS+0x108>
    800018a8:	00002097          	auipc	ra,0x2
    800018ac:	de0080e7          	jalr	-544(ra) # 80003688 <_Z11printStringPKc>
    800018b0:	00000613          	li	a2,0
    800018b4:	00a00593          	li	a1,10
    800018b8:	0009051b          	sext.w	a0,s2
    800018bc:	00002097          	auipc	ra,0x2
    800018c0:	f7c080e7          	jalr	-132(ra) # 80003838 <_Z8printIntiii>
    800018c4:	00009517          	auipc	a0,0x9
    800018c8:	a8c50513          	addi	a0,a0,-1396 # 8000a350 <CONSOLE_STATUS+0x340>
    800018cc:	00002097          	auipc	ra,0x2
    800018d0:	dbc080e7          	jalr	-580(ra) # 80003688 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    800018d4:	00000493          	li	s1,0
    800018d8:	f99ff06f          	j	80001870 <_ZN7WorkerB11workerBodyBEPv+0x2c>
        }
    }
    printString("B finished!\n");
    800018dc:	00009517          	auipc	a0,0x9
    800018e0:	84450513          	addi	a0,a0,-1980 # 8000a120 <CONSOLE_STATUS+0x110>
    800018e4:	00002097          	auipc	ra,0x2
    800018e8:	da4080e7          	jalr	-604(ra) # 80003688 <_Z11printStringPKc>
    finishedB = true;
    800018ec:	00100793          	li	a5,1
    800018f0:	0000b717          	auipc	a4,0xb
    800018f4:	5cf708a3          	sb	a5,1489(a4) # 8000cec1 <_ZL9finishedB>
    thread_dispatch();
    800018f8:	00003097          	auipc	ra,0x3
    800018fc:	154080e7          	jalr	340(ra) # 80004a4c <thread_dispatch>
}
    80001900:	01813083          	ld	ra,24(sp)
    80001904:	01013403          	ld	s0,16(sp)
    80001908:	00813483          	ld	s1,8(sp)
    8000190c:	00013903          	ld	s2,0(sp)
    80001910:	02010113          	addi	sp,sp,32
    80001914:	00008067          	ret

0000000080001918 <_ZN7WorkerC11workerBodyCEPv>:

void WorkerC::workerBodyC(void *arg) {
    80001918:	fe010113          	addi	sp,sp,-32
    8000191c:	00113c23          	sd	ra,24(sp)
    80001920:	00813823          	sd	s0,16(sp)
    80001924:	00913423          	sd	s1,8(sp)
    80001928:	01213023          	sd	s2,0(sp)
    8000192c:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    80001930:	00000493          	li	s1,0
    80001934:	0400006f          	j	80001974 <_ZN7WorkerC11workerBodyCEPv+0x5c>
    for (; i < 3; i++) {
        printString("C: i="); printInt(i); printString("\n");
    80001938:	00008517          	auipc	a0,0x8
    8000193c:	7f850513          	addi	a0,a0,2040 # 8000a130 <CONSOLE_STATUS+0x120>
    80001940:	00002097          	auipc	ra,0x2
    80001944:	d48080e7          	jalr	-696(ra) # 80003688 <_Z11printStringPKc>
    80001948:	00000613          	li	a2,0
    8000194c:	00a00593          	li	a1,10
    80001950:	00048513          	mv	a0,s1
    80001954:	00002097          	auipc	ra,0x2
    80001958:	ee4080e7          	jalr	-284(ra) # 80003838 <_Z8printIntiii>
    8000195c:	00009517          	auipc	a0,0x9
    80001960:	9f450513          	addi	a0,a0,-1548 # 8000a350 <CONSOLE_STATUS+0x340>
    80001964:	00002097          	auipc	ra,0x2
    80001968:	d24080e7          	jalr	-732(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 3; i++) {
    8000196c:	0014849b          	addiw	s1,s1,1
    80001970:	0ff4f493          	andi	s1,s1,255
    80001974:	00200793          	li	a5,2
    80001978:	fc97f0e3          	bgeu	a5,s1,80001938 <_ZN7WorkerC11workerBodyCEPv+0x20>
    }

    printString("C: dispatch\n");
    8000197c:	00008517          	auipc	a0,0x8
    80001980:	7bc50513          	addi	a0,a0,1980 # 8000a138 <CONSOLE_STATUS+0x128>
    80001984:	00002097          	auipc	ra,0x2
    80001988:	d04080e7          	jalr	-764(ra) # 80003688 <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    8000198c:	00700313          	li	t1,7
    thread_dispatch();
    80001990:	00003097          	auipc	ra,0x3
    80001994:	0bc080e7          	jalr	188(ra) # 80004a4c <thread_dispatch>

    uint64 t1 = 0;
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    80001998:	00030913          	mv	s2,t1

    printString("C: t1="); printInt(t1); printString("\n");
    8000199c:	00008517          	auipc	a0,0x8
    800019a0:	7ac50513          	addi	a0,a0,1964 # 8000a148 <CONSOLE_STATUS+0x138>
    800019a4:	00002097          	auipc	ra,0x2
    800019a8:	ce4080e7          	jalr	-796(ra) # 80003688 <_Z11printStringPKc>
    800019ac:	00000613          	li	a2,0
    800019b0:	00a00593          	li	a1,10
    800019b4:	0009051b          	sext.w	a0,s2
    800019b8:	00002097          	auipc	ra,0x2
    800019bc:	e80080e7          	jalr	-384(ra) # 80003838 <_Z8printIntiii>
    800019c0:	00009517          	auipc	a0,0x9
    800019c4:	99050513          	addi	a0,a0,-1648 # 8000a350 <CONSOLE_STATUS+0x340>
    800019c8:	00002097          	auipc	ra,0x2
    800019cc:	cc0080e7          	jalr	-832(ra) # 80003688 <_Z11printStringPKc>

    uint64 result = fibonacci(12);
    800019d0:	00c00513          	li	a0,12
    800019d4:	00000097          	auipc	ra,0x0
    800019d8:	d30080e7          	jalr	-720(ra) # 80001704 <_ZL9fibonaccim>
    800019dc:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    800019e0:	00008517          	auipc	a0,0x8
    800019e4:	77050513          	addi	a0,a0,1904 # 8000a150 <CONSOLE_STATUS+0x140>
    800019e8:	00002097          	auipc	ra,0x2
    800019ec:	ca0080e7          	jalr	-864(ra) # 80003688 <_Z11printStringPKc>
    800019f0:	00000613          	li	a2,0
    800019f4:	00a00593          	li	a1,10
    800019f8:	0009051b          	sext.w	a0,s2
    800019fc:	00002097          	auipc	ra,0x2
    80001a00:	e3c080e7          	jalr	-452(ra) # 80003838 <_Z8printIntiii>
    80001a04:	00009517          	auipc	a0,0x9
    80001a08:	94c50513          	addi	a0,a0,-1716 # 8000a350 <CONSOLE_STATUS+0x340>
    80001a0c:	00002097          	auipc	ra,0x2
    80001a10:	c7c080e7          	jalr	-900(ra) # 80003688 <_Z11printStringPKc>
    80001a14:	0400006f          	j	80001a54 <_ZN7WorkerC11workerBodyCEPv+0x13c>

    for (; i < 6; i++) {
        printString("C: i="); printInt(i); printString("\n");
    80001a18:	00008517          	auipc	a0,0x8
    80001a1c:	71850513          	addi	a0,a0,1816 # 8000a130 <CONSOLE_STATUS+0x120>
    80001a20:	00002097          	auipc	ra,0x2
    80001a24:	c68080e7          	jalr	-920(ra) # 80003688 <_Z11printStringPKc>
    80001a28:	00000613          	li	a2,0
    80001a2c:	00a00593          	li	a1,10
    80001a30:	00048513          	mv	a0,s1
    80001a34:	00002097          	auipc	ra,0x2
    80001a38:	e04080e7          	jalr	-508(ra) # 80003838 <_Z8printIntiii>
    80001a3c:	00009517          	auipc	a0,0x9
    80001a40:	91450513          	addi	a0,a0,-1772 # 8000a350 <CONSOLE_STATUS+0x340>
    80001a44:	00002097          	auipc	ra,0x2
    80001a48:	c44080e7          	jalr	-956(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 6; i++) {
    80001a4c:	0014849b          	addiw	s1,s1,1
    80001a50:	0ff4f493          	andi	s1,s1,255
    80001a54:	00500793          	li	a5,5
    80001a58:	fc97f0e3          	bgeu	a5,s1,80001a18 <_ZN7WorkerC11workerBodyCEPv+0x100>
    }

    printString("A finished!\n");
    80001a5c:	00008517          	auipc	a0,0x8
    80001a60:	6ac50513          	addi	a0,a0,1708 # 8000a108 <CONSOLE_STATUS+0xf8>
    80001a64:	00002097          	auipc	ra,0x2
    80001a68:	c24080e7          	jalr	-988(ra) # 80003688 <_Z11printStringPKc>
    finishedC = true;
    80001a6c:	00100793          	li	a5,1
    80001a70:	0000b717          	auipc	a4,0xb
    80001a74:	44f70923          	sb	a5,1106(a4) # 8000cec2 <_ZL9finishedC>
    thread_dispatch();
    80001a78:	00003097          	auipc	ra,0x3
    80001a7c:	fd4080e7          	jalr	-44(ra) # 80004a4c <thread_dispatch>
}
    80001a80:	01813083          	ld	ra,24(sp)
    80001a84:	01013403          	ld	s0,16(sp)
    80001a88:	00813483          	ld	s1,8(sp)
    80001a8c:	00013903          	ld	s2,0(sp)
    80001a90:	02010113          	addi	sp,sp,32
    80001a94:	00008067          	ret

0000000080001a98 <_ZN7WorkerD11workerBodyDEPv>:

void WorkerD::workerBodyD(void* arg) {
    80001a98:	fe010113          	addi	sp,sp,-32
    80001a9c:	00113c23          	sd	ra,24(sp)
    80001aa0:	00813823          	sd	s0,16(sp)
    80001aa4:	00913423          	sd	s1,8(sp)
    80001aa8:	01213023          	sd	s2,0(sp)
    80001aac:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    80001ab0:	00a00493          	li	s1,10
    80001ab4:	0400006f          	j	80001af4 <_ZN7WorkerD11workerBodyDEPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80001ab8:	00008517          	auipc	a0,0x8
    80001abc:	6a850513          	addi	a0,a0,1704 # 8000a160 <CONSOLE_STATUS+0x150>
    80001ac0:	00002097          	auipc	ra,0x2
    80001ac4:	bc8080e7          	jalr	-1080(ra) # 80003688 <_Z11printStringPKc>
    80001ac8:	00000613          	li	a2,0
    80001acc:	00a00593          	li	a1,10
    80001ad0:	00048513          	mv	a0,s1
    80001ad4:	00002097          	auipc	ra,0x2
    80001ad8:	d64080e7          	jalr	-668(ra) # 80003838 <_Z8printIntiii>
    80001adc:	00009517          	auipc	a0,0x9
    80001ae0:	87450513          	addi	a0,a0,-1932 # 8000a350 <CONSOLE_STATUS+0x340>
    80001ae4:	00002097          	auipc	ra,0x2
    80001ae8:	ba4080e7          	jalr	-1116(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 13; i++) {
    80001aec:	0014849b          	addiw	s1,s1,1
    80001af0:	0ff4f493          	andi	s1,s1,255
    80001af4:	00c00793          	li	a5,12
    80001af8:	fc97f0e3          	bgeu	a5,s1,80001ab8 <_ZN7WorkerD11workerBodyDEPv+0x20>
    }

    printString("D: dispatch\n");
    80001afc:	00008517          	auipc	a0,0x8
    80001b00:	66c50513          	addi	a0,a0,1644 # 8000a168 <CONSOLE_STATUS+0x158>
    80001b04:	00002097          	auipc	ra,0x2
    80001b08:	b84080e7          	jalr	-1148(ra) # 80003688 <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    80001b0c:	00500313          	li	t1,5
    thread_dispatch();
    80001b10:	00003097          	auipc	ra,0x3
    80001b14:	f3c080e7          	jalr	-196(ra) # 80004a4c <thread_dispatch>

    uint64 result = fibonacci(16);
    80001b18:	01000513          	li	a0,16
    80001b1c:	00000097          	auipc	ra,0x0
    80001b20:	be8080e7          	jalr	-1048(ra) # 80001704 <_ZL9fibonaccim>
    80001b24:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    80001b28:	00008517          	auipc	a0,0x8
    80001b2c:	65050513          	addi	a0,a0,1616 # 8000a178 <CONSOLE_STATUS+0x168>
    80001b30:	00002097          	auipc	ra,0x2
    80001b34:	b58080e7          	jalr	-1192(ra) # 80003688 <_Z11printStringPKc>
    80001b38:	00000613          	li	a2,0
    80001b3c:	00a00593          	li	a1,10
    80001b40:	0009051b          	sext.w	a0,s2
    80001b44:	00002097          	auipc	ra,0x2
    80001b48:	cf4080e7          	jalr	-780(ra) # 80003838 <_Z8printIntiii>
    80001b4c:	00009517          	auipc	a0,0x9
    80001b50:	80450513          	addi	a0,a0,-2044 # 8000a350 <CONSOLE_STATUS+0x340>
    80001b54:	00002097          	auipc	ra,0x2
    80001b58:	b34080e7          	jalr	-1228(ra) # 80003688 <_Z11printStringPKc>
    80001b5c:	0400006f          	j	80001b9c <_ZN7WorkerD11workerBodyDEPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80001b60:	00008517          	auipc	a0,0x8
    80001b64:	60050513          	addi	a0,a0,1536 # 8000a160 <CONSOLE_STATUS+0x150>
    80001b68:	00002097          	auipc	ra,0x2
    80001b6c:	b20080e7          	jalr	-1248(ra) # 80003688 <_Z11printStringPKc>
    80001b70:	00000613          	li	a2,0
    80001b74:	00a00593          	li	a1,10
    80001b78:	00048513          	mv	a0,s1
    80001b7c:	00002097          	auipc	ra,0x2
    80001b80:	cbc080e7          	jalr	-836(ra) # 80003838 <_Z8printIntiii>
    80001b84:	00008517          	auipc	a0,0x8
    80001b88:	7cc50513          	addi	a0,a0,1996 # 8000a350 <CONSOLE_STATUS+0x340>
    80001b8c:	00002097          	auipc	ra,0x2
    80001b90:	afc080e7          	jalr	-1284(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 16; i++) {
    80001b94:	0014849b          	addiw	s1,s1,1
    80001b98:	0ff4f493          	andi	s1,s1,255
    80001b9c:	00f00793          	li	a5,15
    80001ba0:	fc97f0e3          	bgeu	a5,s1,80001b60 <_ZN7WorkerD11workerBodyDEPv+0xc8>
    }

    printString("D finished!\n");
    80001ba4:	00008517          	auipc	a0,0x8
    80001ba8:	5e450513          	addi	a0,a0,1508 # 8000a188 <CONSOLE_STATUS+0x178>
    80001bac:	00002097          	auipc	ra,0x2
    80001bb0:	adc080e7          	jalr	-1316(ra) # 80003688 <_Z11printStringPKc>
    finishedD = true;
    80001bb4:	00100793          	li	a5,1
    80001bb8:	0000b717          	auipc	a4,0xb
    80001bbc:	30f705a3          	sb	a5,779(a4) # 8000cec3 <_ZL9finishedD>
    thread_dispatch();
    80001bc0:	00003097          	auipc	ra,0x3
    80001bc4:	e8c080e7          	jalr	-372(ra) # 80004a4c <thread_dispatch>
}
    80001bc8:	01813083          	ld	ra,24(sp)
    80001bcc:	01013403          	ld	s0,16(sp)
    80001bd0:	00813483          	ld	s1,8(sp)
    80001bd4:	00013903          	ld	s2,0(sp)
    80001bd8:	02010113          	addi	sp,sp,32
    80001bdc:	00008067          	ret

0000000080001be0 <_Z20Threads_CPP_API_testv>:


void Threads_CPP_API_test() {
    80001be0:	fc010113          	addi	sp,sp,-64
    80001be4:	02113c23          	sd	ra,56(sp)
    80001be8:	02813823          	sd	s0,48(sp)
    80001bec:	02913423          	sd	s1,40(sp)
    80001bf0:	03213023          	sd	s2,32(sp)
    80001bf4:	04010413          	addi	s0,sp,64
    Thread* threads[4];

    threads[0] = new WorkerA();
    80001bf8:	02000513          	li	a0,32
    80001bfc:	00005097          	auipc	ra,0x5
    80001c00:	d5c080e7          	jalr	-676(ra) # 80006958 <_Znwm>
    80001c04:	00050493          	mv	s1,a0
    WorkerA():Thread() {}
    80001c08:	00005097          	auipc	ra,0x5
    80001c0c:	edc080e7          	jalr	-292(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    80001c10:	0000b797          	auipc	a5,0xb
    80001c14:	f8878793          	addi	a5,a5,-120 # 8000cb98 <_ZTV7WorkerA+0x10>
    80001c18:	00f4b023          	sd	a5,0(s1)
    threads[0] = new WorkerA();
    80001c1c:	fc943023          	sd	s1,-64(s0)
    printString("ThreadA created\n");
    80001c20:	00008517          	auipc	a0,0x8
    80001c24:	57850513          	addi	a0,a0,1400 # 8000a198 <CONSOLE_STATUS+0x188>
    80001c28:	00002097          	auipc	ra,0x2
    80001c2c:	a60080e7          	jalr	-1440(ra) # 80003688 <_Z11printStringPKc>

    threads[1] = new WorkerB();
    80001c30:	02000513          	li	a0,32
    80001c34:	00005097          	auipc	ra,0x5
    80001c38:	d24080e7          	jalr	-732(ra) # 80006958 <_Znwm>
    80001c3c:	00050493          	mv	s1,a0
    WorkerB():Thread() {}
    80001c40:	00005097          	auipc	ra,0x5
    80001c44:	ea4080e7          	jalr	-348(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    80001c48:	0000b797          	auipc	a5,0xb
    80001c4c:	f7878793          	addi	a5,a5,-136 # 8000cbc0 <_ZTV7WorkerB+0x10>
    80001c50:	00f4b023          	sd	a5,0(s1)
    threads[1] = new WorkerB();
    80001c54:	fc943423          	sd	s1,-56(s0)
    printString("ThreadB created\n");
    80001c58:	00008517          	auipc	a0,0x8
    80001c5c:	55850513          	addi	a0,a0,1368 # 8000a1b0 <CONSOLE_STATUS+0x1a0>
    80001c60:	00002097          	auipc	ra,0x2
    80001c64:	a28080e7          	jalr	-1496(ra) # 80003688 <_Z11printStringPKc>

    threads[2] = new WorkerC();
    80001c68:	02000513          	li	a0,32
    80001c6c:	00005097          	auipc	ra,0x5
    80001c70:	cec080e7          	jalr	-788(ra) # 80006958 <_Znwm>
    80001c74:	00050493          	mv	s1,a0
    WorkerC():Thread() {}
    80001c78:	00005097          	auipc	ra,0x5
    80001c7c:	e6c080e7          	jalr	-404(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    80001c80:	0000b797          	auipc	a5,0xb
    80001c84:	f6878793          	addi	a5,a5,-152 # 8000cbe8 <_ZTV7WorkerC+0x10>
    80001c88:	00f4b023          	sd	a5,0(s1)
    threads[2] = new WorkerC();
    80001c8c:	fc943823          	sd	s1,-48(s0)
    printString("ThreadC created\n");
    80001c90:	00008517          	auipc	a0,0x8
    80001c94:	53850513          	addi	a0,a0,1336 # 8000a1c8 <CONSOLE_STATUS+0x1b8>
    80001c98:	00002097          	auipc	ra,0x2
    80001c9c:	9f0080e7          	jalr	-1552(ra) # 80003688 <_Z11printStringPKc>

    threads[3] = new WorkerD();
    80001ca0:	02000513          	li	a0,32
    80001ca4:	00005097          	auipc	ra,0x5
    80001ca8:	cb4080e7          	jalr	-844(ra) # 80006958 <_Znwm>
    80001cac:	00050493          	mv	s1,a0
    WorkerD():Thread() {}
    80001cb0:	00005097          	auipc	ra,0x5
    80001cb4:	e34080e7          	jalr	-460(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    80001cb8:	0000b797          	auipc	a5,0xb
    80001cbc:	f5878793          	addi	a5,a5,-168 # 8000cc10 <_ZTV7WorkerD+0x10>
    80001cc0:	00f4b023          	sd	a5,0(s1)
    threads[3] = new WorkerD();
    80001cc4:	fc943c23          	sd	s1,-40(s0)
    printString("ThreadD created\n");
    80001cc8:	00008517          	auipc	a0,0x8
    80001ccc:	51850513          	addi	a0,a0,1304 # 8000a1e0 <CONSOLE_STATUS+0x1d0>
    80001cd0:	00002097          	auipc	ra,0x2
    80001cd4:	9b8080e7          	jalr	-1608(ra) # 80003688 <_Z11printStringPKc>

    for(int i=0; i<4; i++) {
    80001cd8:	00000493          	li	s1,0
    80001cdc:	00300793          	li	a5,3
    80001ce0:	0297c663          	blt	a5,s1,80001d0c <_Z20Threads_CPP_API_testv+0x12c>
        threads[i]->start();
    80001ce4:	00349793          	slli	a5,s1,0x3
    80001ce8:	fe040713          	addi	a4,s0,-32
    80001cec:	00f707b3          	add	a5,a4,a5
    80001cf0:	fe07b503          	ld	a0,-32(a5)
    80001cf4:	00005097          	auipc	ra,0x5
    80001cf8:	d4c080e7          	jalr	-692(ra) # 80006a40 <_ZN6Thread5startEv>
    for(int i=0; i<4; i++) {
    80001cfc:	0014849b          	addiw	s1,s1,1
    80001d00:	fddff06f          	j	80001cdc <_Z20Threads_CPP_API_testv+0xfc>
    }

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        Thread::dispatch();
    80001d04:	00005097          	auipc	ra,0x5
    80001d08:	d90080e7          	jalr	-624(ra) # 80006a94 <_ZN6Thread8dispatchEv>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    80001d0c:	0000b797          	auipc	a5,0xb
    80001d10:	1b47c783          	lbu	a5,436(a5) # 8000cec0 <_ZL9finishedA>
    80001d14:	fe0788e3          	beqz	a5,80001d04 <_Z20Threads_CPP_API_testv+0x124>
    80001d18:	0000b797          	auipc	a5,0xb
    80001d1c:	1a97c783          	lbu	a5,425(a5) # 8000cec1 <_ZL9finishedB>
    80001d20:	fe0782e3          	beqz	a5,80001d04 <_Z20Threads_CPP_API_testv+0x124>
    80001d24:	0000b797          	auipc	a5,0xb
    80001d28:	19e7c783          	lbu	a5,414(a5) # 8000cec2 <_ZL9finishedC>
    80001d2c:	fc078ce3          	beqz	a5,80001d04 <_Z20Threads_CPP_API_testv+0x124>
    80001d30:	0000b797          	auipc	a5,0xb
    80001d34:	1937c783          	lbu	a5,403(a5) # 8000cec3 <_ZL9finishedD>
    80001d38:	fc0786e3          	beqz	a5,80001d04 <_Z20Threads_CPP_API_testv+0x124>
    80001d3c:	fc040493          	addi	s1,s0,-64
    80001d40:	0080006f          	j	80001d48 <_Z20Threads_CPP_API_testv+0x168>
    }

    for (auto thread: threads) { delete thread; }
    80001d44:	00848493          	addi	s1,s1,8
    80001d48:	fe040793          	addi	a5,s0,-32
    80001d4c:	08f48663          	beq	s1,a5,80001dd8 <_Z20Threads_CPP_API_testv+0x1f8>
    80001d50:	0004b503          	ld	a0,0(s1)
    80001d54:	fe0508e3          	beqz	a0,80001d44 <_Z20Threads_CPP_API_testv+0x164>
    80001d58:	00053783          	ld	a5,0(a0)
    80001d5c:	0087b783          	ld	a5,8(a5)
    80001d60:	000780e7          	jalr	a5
    80001d64:	fe1ff06f          	j	80001d44 <_Z20Threads_CPP_API_testv+0x164>
    80001d68:	00050913          	mv	s2,a0
    threads[0] = new WorkerA();
    80001d6c:	00048513          	mv	a0,s1
    80001d70:	00005097          	auipc	ra,0x5
    80001d74:	c10080e7          	jalr	-1008(ra) # 80006980 <_ZdlPv>
    80001d78:	00090513          	mv	a0,s2
    80001d7c:	0000c097          	auipc	ra,0xc
    80001d80:	2cc080e7          	jalr	716(ra) # 8000e048 <_Unwind_Resume>
    80001d84:	00050913          	mv	s2,a0
    threads[1] = new WorkerB();
    80001d88:	00048513          	mv	a0,s1
    80001d8c:	00005097          	auipc	ra,0x5
    80001d90:	bf4080e7          	jalr	-1036(ra) # 80006980 <_ZdlPv>
    80001d94:	00090513          	mv	a0,s2
    80001d98:	0000c097          	auipc	ra,0xc
    80001d9c:	2b0080e7          	jalr	688(ra) # 8000e048 <_Unwind_Resume>
    80001da0:	00050913          	mv	s2,a0
    threads[2] = new WorkerC();
    80001da4:	00048513          	mv	a0,s1
    80001da8:	00005097          	auipc	ra,0x5
    80001dac:	bd8080e7          	jalr	-1064(ra) # 80006980 <_ZdlPv>
    80001db0:	00090513          	mv	a0,s2
    80001db4:	0000c097          	auipc	ra,0xc
    80001db8:	294080e7          	jalr	660(ra) # 8000e048 <_Unwind_Resume>
    80001dbc:	00050913          	mv	s2,a0
    threads[3] = new WorkerD();
    80001dc0:	00048513          	mv	a0,s1
    80001dc4:	00005097          	auipc	ra,0x5
    80001dc8:	bbc080e7          	jalr	-1092(ra) # 80006980 <_ZdlPv>
    80001dcc:	00090513          	mv	a0,s2
    80001dd0:	0000c097          	auipc	ra,0xc
    80001dd4:	278080e7          	jalr	632(ra) # 8000e048 <_Unwind_Resume>
}
    80001dd8:	03813083          	ld	ra,56(sp)
    80001ddc:	03013403          	ld	s0,48(sp)
    80001de0:	02813483          	ld	s1,40(sp)
    80001de4:	02013903          	ld	s2,32(sp)
    80001de8:	04010113          	addi	sp,sp,64
    80001dec:	00008067          	ret

0000000080001df0 <_ZN7WorkerAD1Ev>:
class WorkerA: public Thread {
    80001df0:	ff010113          	addi	sp,sp,-16
    80001df4:	00113423          	sd	ra,8(sp)
    80001df8:	00813023          	sd	s0,0(sp)
    80001dfc:	01010413          	addi	s0,sp,16
    80001e00:	0000b797          	auipc	a5,0xb
    80001e04:	d9878793          	addi	a5,a5,-616 # 8000cb98 <_ZTV7WorkerA+0x10>
    80001e08:	00f53023          	sd	a5,0(a0)
    80001e0c:	00005097          	auipc	ra,0x5
    80001e10:	ad0080e7          	jalr	-1328(ra) # 800068dc <_ZN6ThreadD1Ev>
    80001e14:	00813083          	ld	ra,8(sp)
    80001e18:	00013403          	ld	s0,0(sp)
    80001e1c:	01010113          	addi	sp,sp,16
    80001e20:	00008067          	ret

0000000080001e24 <_ZN7WorkerAD0Ev>:
    80001e24:	fe010113          	addi	sp,sp,-32
    80001e28:	00113c23          	sd	ra,24(sp)
    80001e2c:	00813823          	sd	s0,16(sp)
    80001e30:	00913423          	sd	s1,8(sp)
    80001e34:	02010413          	addi	s0,sp,32
    80001e38:	00050493          	mv	s1,a0
    80001e3c:	0000b797          	auipc	a5,0xb
    80001e40:	d5c78793          	addi	a5,a5,-676 # 8000cb98 <_ZTV7WorkerA+0x10>
    80001e44:	00f53023          	sd	a5,0(a0)
    80001e48:	00005097          	auipc	ra,0x5
    80001e4c:	a94080e7          	jalr	-1388(ra) # 800068dc <_ZN6ThreadD1Ev>
    80001e50:	00048513          	mv	a0,s1
    80001e54:	00005097          	auipc	ra,0x5
    80001e58:	b2c080e7          	jalr	-1236(ra) # 80006980 <_ZdlPv>
    80001e5c:	01813083          	ld	ra,24(sp)
    80001e60:	01013403          	ld	s0,16(sp)
    80001e64:	00813483          	ld	s1,8(sp)
    80001e68:	02010113          	addi	sp,sp,32
    80001e6c:	00008067          	ret

0000000080001e70 <_ZN7WorkerBD1Ev>:
class WorkerB: public Thread {
    80001e70:	ff010113          	addi	sp,sp,-16
    80001e74:	00113423          	sd	ra,8(sp)
    80001e78:	00813023          	sd	s0,0(sp)
    80001e7c:	01010413          	addi	s0,sp,16
    80001e80:	0000b797          	auipc	a5,0xb
    80001e84:	d4078793          	addi	a5,a5,-704 # 8000cbc0 <_ZTV7WorkerB+0x10>
    80001e88:	00f53023          	sd	a5,0(a0)
    80001e8c:	00005097          	auipc	ra,0x5
    80001e90:	a50080e7          	jalr	-1456(ra) # 800068dc <_ZN6ThreadD1Ev>
    80001e94:	00813083          	ld	ra,8(sp)
    80001e98:	00013403          	ld	s0,0(sp)
    80001e9c:	01010113          	addi	sp,sp,16
    80001ea0:	00008067          	ret

0000000080001ea4 <_ZN7WorkerBD0Ev>:
    80001ea4:	fe010113          	addi	sp,sp,-32
    80001ea8:	00113c23          	sd	ra,24(sp)
    80001eac:	00813823          	sd	s0,16(sp)
    80001eb0:	00913423          	sd	s1,8(sp)
    80001eb4:	02010413          	addi	s0,sp,32
    80001eb8:	00050493          	mv	s1,a0
    80001ebc:	0000b797          	auipc	a5,0xb
    80001ec0:	d0478793          	addi	a5,a5,-764 # 8000cbc0 <_ZTV7WorkerB+0x10>
    80001ec4:	00f53023          	sd	a5,0(a0)
    80001ec8:	00005097          	auipc	ra,0x5
    80001ecc:	a14080e7          	jalr	-1516(ra) # 800068dc <_ZN6ThreadD1Ev>
    80001ed0:	00048513          	mv	a0,s1
    80001ed4:	00005097          	auipc	ra,0x5
    80001ed8:	aac080e7          	jalr	-1364(ra) # 80006980 <_ZdlPv>
    80001edc:	01813083          	ld	ra,24(sp)
    80001ee0:	01013403          	ld	s0,16(sp)
    80001ee4:	00813483          	ld	s1,8(sp)
    80001ee8:	02010113          	addi	sp,sp,32
    80001eec:	00008067          	ret

0000000080001ef0 <_ZN7WorkerCD1Ev>:
class WorkerC: public Thread {
    80001ef0:	ff010113          	addi	sp,sp,-16
    80001ef4:	00113423          	sd	ra,8(sp)
    80001ef8:	00813023          	sd	s0,0(sp)
    80001efc:	01010413          	addi	s0,sp,16
    80001f00:	0000b797          	auipc	a5,0xb
    80001f04:	ce878793          	addi	a5,a5,-792 # 8000cbe8 <_ZTV7WorkerC+0x10>
    80001f08:	00f53023          	sd	a5,0(a0)
    80001f0c:	00005097          	auipc	ra,0x5
    80001f10:	9d0080e7          	jalr	-1584(ra) # 800068dc <_ZN6ThreadD1Ev>
    80001f14:	00813083          	ld	ra,8(sp)
    80001f18:	00013403          	ld	s0,0(sp)
    80001f1c:	01010113          	addi	sp,sp,16
    80001f20:	00008067          	ret

0000000080001f24 <_ZN7WorkerCD0Ev>:
    80001f24:	fe010113          	addi	sp,sp,-32
    80001f28:	00113c23          	sd	ra,24(sp)
    80001f2c:	00813823          	sd	s0,16(sp)
    80001f30:	00913423          	sd	s1,8(sp)
    80001f34:	02010413          	addi	s0,sp,32
    80001f38:	00050493          	mv	s1,a0
    80001f3c:	0000b797          	auipc	a5,0xb
    80001f40:	cac78793          	addi	a5,a5,-852 # 8000cbe8 <_ZTV7WorkerC+0x10>
    80001f44:	00f53023          	sd	a5,0(a0)
    80001f48:	00005097          	auipc	ra,0x5
    80001f4c:	994080e7          	jalr	-1644(ra) # 800068dc <_ZN6ThreadD1Ev>
    80001f50:	00048513          	mv	a0,s1
    80001f54:	00005097          	auipc	ra,0x5
    80001f58:	a2c080e7          	jalr	-1492(ra) # 80006980 <_ZdlPv>
    80001f5c:	01813083          	ld	ra,24(sp)
    80001f60:	01013403          	ld	s0,16(sp)
    80001f64:	00813483          	ld	s1,8(sp)
    80001f68:	02010113          	addi	sp,sp,32
    80001f6c:	00008067          	ret

0000000080001f70 <_ZN7WorkerDD1Ev>:
class WorkerD: public Thread {
    80001f70:	ff010113          	addi	sp,sp,-16
    80001f74:	00113423          	sd	ra,8(sp)
    80001f78:	00813023          	sd	s0,0(sp)
    80001f7c:	01010413          	addi	s0,sp,16
    80001f80:	0000b797          	auipc	a5,0xb
    80001f84:	c9078793          	addi	a5,a5,-880 # 8000cc10 <_ZTV7WorkerD+0x10>
    80001f88:	00f53023          	sd	a5,0(a0)
    80001f8c:	00005097          	auipc	ra,0x5
    80001f90:	950080e7          	jalr	-1712(ra) # 800068dc <_ZN6ThreadD1Ev>
    80001f94:	00813083          	ld	ra,8(sp)
    80001f98:	00013403          	ld	s0,0(sp)
    80001f9c:	01010113          	addi	sp,sp,16
    80001fa0:	00008067          	ret

0000000080001fa4 <_ZN7WorkerDD0Ev>:
    80001fa4:	fe010113          	addi	sp,sp,-32
    80001fa8:	00113c23          	sd	ra,24(sp)
    80001fac:	00813823          	sd	s0,16(sp)
    80001fb0:	00913423          	sd	s1,8(sp)
    80001fb4:	02010413          	addi	s0,sp,32
    80001fb8:	00050493          	mv	s1,a0
    80001fbc:	0000b797          	auipc	a5,0xb
    80001fc0:	c5478793          	addi	a5,a5,-940 # 8000cc10 <_ZTV7WorkerD+0x10>
    80001fc4:	00f53023          	sd	a5,0(a0)
    80001fc8:	00005097          	auipc	ra,0x5
    80001fcc:	914080e7          	jalr	-1772(ra) # 800068dc <_ZN6ThreadD1Ev>
    80001fd0:	00048513          	mv	a0,s1
    80001fd4:	00005097          	auipc	ra,0x5
    80001fd8:	9ac080e7          	jalr	-1620(ra) # 80006980 <_ZdlPv>
    80001fdc:	01813083          	ld	ra,24(sp)
    80001fe0:	01013403          	ld	s0,16(sp)
    80001fe4:	00813483          	ld	s1,8(sp)
    80001fe8:	02010113          	addi	sp,sp,32
    80001fec:	00008067          	ret

0000000080001ff0 <_ZN7WorkerA3runEv>:
    void run() override {
    80001ff0:	ff010113          	addi	sp,sp,-16
    80001ff4:	00113423          	sd	ra,8(sp)
    80001ff8:	00813023          	sd	s0,0(sp)
    80001ffc:	01010413          	addi	s0,sp,16
        workerBodyA(nullptr);
    80002000:	00000593          	li	a1,0
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	774080e7          	jalr	1908(ra) # 80001778 <_ZN7WorkerA11workerBodyAEPv>
    }
    8000200c:	00813083          	ld	ra,8(sp)
    80002010:	00013403          	ld	s0,0(sp)
    80002014:	01010113          	addi	sp,sp,16
    80002018:	00008067          	ret

000000008000201c <_ZN7WorkerB3runEv>:
    void run() override {
    8000201c:	ff010113          	addi	sp,sp,-16
    80002020:	00113423          	sd	ra,8(sp)
    80002024:	00813023          	sd	s0,0(sp)
    80002028:	01010413          	addi	s0,sp,16
        workerBodyB(nullptr);
    8000202c:	00000593          	li	a1,0
    80002030:	00000097          	auipc	ra,0x0
    80002034:	814080e7          	jalr	-2028(ra) # 80001844 <_ZN7WorkerB11workerBodyBEPv>
    }
    80002038:	00813083          	ld	ra,8(sp)
    8000203c:	00013403          	ld	s0,0(sp)
    80002040:	01010113          	addi	sp,sp,16
    80002044:	00008067          	ret

0000000080002048 <_ZN7WorkerC3runEv>:
    void run() override {
    80002048:	ff010113          	addi	sp,sp,-16
    8000204c:	00113423          	sd	ra,8(sp)
    80002050:	00813023          	sd	s0,0(sp)
    80002054:	01010413          	addi	s0,sp,16
        workerBodyC(nullptr);
    80002058:	00000593          	li	a1,0
    8000205c:	00000097          	auipc	ra,0x0
    80002060:	8bc080e7          	jalr	-1860(ra) # 80001918 <_ZN7WorkerC11workerBodyCEPv>
    }
    80002064:	00813083          	ld	ra,8(sp)
    80002068:	00013403          	ld	s0,0(sp)
    8000206c:	01010113          	addi	sp,sp,16
    80002070:	00008067          	ret

0000000080002074 <_ZN7WorkerD3runEv>:
    void run() override {
    80002074:	ff010113          	addi	sp,sp,-16
    80002078:	00113423          	sd	ra,8(sp)
    8000207c:	00813023          	sd	s0,0(sp)
    80002080:	01010413          	addi	s0,sp,16
        workerBodyD(nullptr);
    80002084:	00000593          	li	a1,0
    80002088:	00000097          	auipc	ra,0x0
    8000208c:	a10080e7          	jalr	-1520(ra) # 80001a98 <_ZN7WorkerD11workerBodyDEPv>
    }
    80002090:	00813083          	ld	ra,8(sp)
    80002094:	00013403          	ld	s0,0(sp)
    80002098:	01010113          	addi	sp,sp,16
    8000209c:	00008067          	ret

00000000800020a0 <_Z20testConsumerProducerv>:

        td->sem->signal();
    }
};

void testConsumerProducer() {
    800020a0:	f8010113          	addi	sp,sp,-128
    800020a4:	06113c23          	sd	ra,120(sp)
    800020a8:	06813823          	sd	s0,112(sp)
    800020ac:	06913423          	sd	s1,104(sp)
    800020b0:	07213023          	sd	s2,96(sp)
    800020b4:	05313c23          	sd	s3,88(sp)
    800020b8:	05413823          	sd	s4,80(sp)
    800020bc:	05513423          	sd	s5,72(sp)
    800020c0:	05613023          	sd	s6,64(sp)
    800020c4:	03713c23          	sd	s7,56(sp)
    800020c8:	03813823          	sd	s8,48(sp)
    800020cc:	03913423          	sd	s9,40(sp)
    800020d0:	08010413          	addi	s0,sp,128
    delete waitForAll;
    for (int i = 0; i < threadNum; i++) {
        delete producers[i];
    }
    delete consumer;
    delete buffer;
    800020d4:	00010c13          	mv	s8,sp
    printString("Unesite broj proizvodjaca?\n");
    800020d8:	00008517          	auipc	a0,0x8
    800020dc:	f4850513          	addi	a0,a0,-184 # 8000a020 <CONSOLE_STATUS+0x10>
    800020e0:	00001097          	auipc	ra,0x1
    800020e4:	5a8080e7          	jalr	1448(ra) # 80003688 <_Z11printStringPKc>
    getString(input, 30);
    800020e8:	01e00593          	li	a1,30
    800020ec:	f8040493          	addi	s1,s0,-128
    800020f0:	00048513          	mv	a0,s1
    800020f4:	00001097          	auipc	ra,0x1
    800020f8:	61c080e7          	jalr	1564(ra) # 80003710 <_Z9getStringPci>
    threadNum = stringToInt(input);
    800020fc:	00048513          	mv	a0,s1
    80002100:	00001097          	auipc	ra,0x1
    80002104:	6e8080e7          	jalr	1768(ra) # 800037e8 <_Z11stringToIntPKc>
    80002108:	00050993          	mv	s3,a0
    printString("Unesite velicinu bafera?\n");
    8000210c:	00008517          	auipc	a0,0x8
    80002110:	f3450513          	addi	a0,a0,-204 # 8000a040 <CONSOLE_STATUS+0x30>
    80002114:	00001097          	auipc	ra,0x1
    80002118:	574080e7          	jalr	1396(ra) # 80003688 <_Z11printStringPKc>
    getString(input, 30);
    8000211c:	01e00593          	li	a1,30
    80002120:	00048513          	mv	a0,s1
    80002124:	00001097          	auipc	ra,0x1
    80002128:	5ec080e7          	jalr	1516(ra) # 80003710 <_Z9getStringPci>
    n = stringToInt(input);
    8000212c:	00048513          	mv	a0,s1
    80002130:	00001097          	auipc	ra,0x1
    80002134:	6b8080e7          	jalr	1720(ra) # 800037e8 <_Z11stringToIntPKc>
    80002138:	00050493          	mv	s1,a0
    printString("Broj proizvodjaca ");
    8000213c:	00008517          	auipc	a0,0x8
    80002140:	f2450513          	addi	a0,a0,-220 # 8000a060 <CONSOLE_STATUS+0x50>
    80002144:	00001097          	auipc	ra,0x1
    80002148:	544080e7          	jalr	1348(ra) # 80003688 <_Z11printStringPKc>
    printInt(threadNum);
    8000214c:	00000613          	li	a2,0
    80002150:	00a00593          	li	a1,10
    80002154:	00098513          	mv	a0,s3
    80002158:	00001097          	auipc	ra,0x1
    8000215c:	6e0080e7          	jalr	1760(ra) # 80003838 <_Z8printIntiii>
    printString(" i velicina bafera ");
    80002160:	00008517          	auipc	a0,0x8
    80002164:	f1850513          	addi	a0,a0,-232 # 8000a078 <CONSOLE_STATUS+0x68>
    80002168:	00001097          	auipc	ra,0x1
    8000216c:	520080e7          	jalr	1312(ra) # 80003688 <_Z11printStringPKc>
    printInt(n);
    80002170:	00000613          	li	a2,0
    80002174:	00a00593          	li	a1,10
    80002178:	00048513          	mv	a0,s1
    8000217c:	00001097          	auipc	ra,0x1
    80002180:	6bc080e7          	jalr	1724(ra) # 80003838 <_Z8printIntiii>
    printString(".\n");
    80002184:	00008517          	auipc	a0,0x8
    80002188:	52c50513          	addi	a0,a0,1324 # 8000a6b0 <CONSOLE_STATUS+0x6a0>
    8000218c:	00001097          	auipc	ra,0x1
    80002190:	4fc080e7          	jalr	1276(ra) # 80003688 <_Z11printStringPKc>
    if (threadNum > n) {
    80002194:	0334c463          	blt	s1,s3,800021bc <_Z20testConsumerProducerv+0x11c>
    } else if (threadNum < 1) {
    80002198:	03305c63          	blez	s3,800021d0 <_Z20testConsumerProducerv+0x130>
    BufferCPP *buffer = new BufferCPP(n);
    8000219c:	03800513          	li	a0,56
    800021a0:	00004097          	auipc	ra,0x4
    800021a4:	7b8080e7          	jalr	1976(ra) # 80006958 <_Znwm>
    800021a8:	00050a93          	mv	s5,a0
    800021ac:	00048593          	mv	a1,s1
    800021b0:	00001097          	auipc	ra,0x1
    800021b4:	7a8080e7          	jalr	1960(ra) # 80003958 <_ZN9BufferCPPC1Ei>
    800021b8:	0300006f          	j	800021e8 <_Z20testConsumerProducerv+0x148>
        printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    800021bc:	00008517          	auipc	a0,0x8
    800021c0:	ed450513          	addi	a0,a0,-300 # 8000a090 <CONSOLE_STATUS+0x80>
    800021c4:	00001097          	auipc	ra,0x1
    800021c8:	4c4080e7          	jalr	1220(ra) # 80003688 <_Z11printStringPKc>
        return;
    800021cc:	0140006f          	j	800021e0 <_Z20testConsumerProducerv+0x140>
        printString("Broj proizvodjaca mora biti veci od nula!\n");
    800021d0:	00008517          	auipc	a0,0x8
    800021d4:	f0050513          	addi	a0,a0,-256 # 8000a0d0 <CONSOLE_STATUS+0xc0>
    800021d8:	00001097          	auipc	ra,0x1
    800021dc:	4b0080e7          	jalr	1200(ra) # 80003688 <_Z11printStringPKc>
        return;
    800021e0:	000c0113          	mv	sp,s8
    800021e4:	2140006f          	j	800023f8 <_Z20testConsumerProducerv+0x358>
    waitForAll = new Semaphore(0);
    800021e8:	01000513          	li	a0,16
    800021ec:	00004097          	auipc	ra,0x4
    800021f0:	76c080e7          	jalr	1900(ra) # 80006958 <_Znwm>
    800021f4:	00050913          	mv	s2,a0
    800021f8:	00000593          	li	a1,0
    800021fc:	00005097          	auipc	ra,0x5
    80002200:	918080e7          	jalr	-1768(ra) # 80006b14 <_ZN9SemaphoreC1Ej>
    80002204:	0000b797          	auipc	a5,0xb
    80002208:	cd27b623          	sd	s2,-820(a5) # 8000ced0 <_ZL10waitForAll>
    Thread *producers[threadNum];
    8000220c:	00399793          	slli	a5,s3,0x3
    80002210:	00f78793          	addi	a5,a5,15
    80002214:	ff07f793          	andi	a5,a5,-16
    80002218:	40f10133          	sub	sp,sp,a5
    8000221c:	00010a13          	mv	s4,sp
    thread_data threadData[threadNum + 1];
    80002220:	0019871b          	addiw	a4,s3,1
    80002224:	00171793          	slli	a5,a4,0x1
    80002228:	00e787b3          	add	a5,a5,a4
    8000222c:	00379793          	slli	a5,a5,0x3
    80002230:	00f78793          	addi	a5,a5,15
    80002234:	ff07f793          	andi	a5,a5,-16
    80002238:	40f10133          	sub	sp,sp,a5
    8000223c:	00010b13          	mv	s6,sp
    threadData[threadNum].id = threadNum;
    80002240:	00199493          	slli	s1,s3,0x1
    80002244:	013484b3          	add	s1,s1,s3
    80002248:	00349493          	slli	s1,s1,0x3
    8000224c:	009b04b3          	add	s1,s6,s1
    80002250:	0134a023          	sw	s3,0(s1)
    threadData[threadNum].buffer = buffer;
    80002254:	0154b423          	sd	s5,8(s1)
    threadData[threadNum].sem = waitForAll;
    80002258:	0124b823          	sd	s2,16(s1)
    Thread *consumer = new Consumer(&threadData[threadNum]);
    8000225c:	02800513          	li	a0,40
    80002260:	00004097          	auipc	ra,0x4
    80002264:	6f8080e7          	jalr	1784(ra) # 80006958 <_Znwm>
    80002268:	00050b93          	mv	s7,a0
    Consumer(thread_data *_td) : Thread(), td(_td) {}
    8000226c:	00005097          	auipc	ra,0x5
    80002270:	878080e7          	jalr	-1928(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    80002274:	0000b797          	auipc	a5,0xb
    80002278:	a1478793          	addi	a5,a5,-1516 # 8000cc88 <_ZTV8Consumer+0x10>
    8000227c:	00fbb023          	sd	a5,0(s7)
    80002280:	029bb023          	sd	s1,32(s7)
    consumer->start();
    80002284:	000b8513          	mv	a0,s7
    80002288:	00004097          	auipc	ra,0x4
    8000228c:	7b8080e7          	jalr	1976(ra) # 80006a40 <_ZN6Thread5startEv>
    threadData[0].id = 0;
    80002290:	000b2023          	sw	zero,0(s6)
    threadData[0].buffer = buffer;
    80002294:	015b3423          	sd	s5,8(s6)
    threadData[0].sem = waitForAll;
    80002298:	0000b797          	auipc	a5,0xb
    8000229c:	c387b783          	ld	a5,-968(a5) # 8000ced0 <_ZL10waitForAll>
    800022a0:	00fb3823          	sd	a5,16(s6)
    producers[0] = new ProducerKeyborad(&threadData[0]);
    800022a4:	02800513          	li	a0,40
    800022a8:	00004097          	auipc	ra,0x4
    800022ac:	6b0080e7          	jalr	1712(ra) # 80006958 <_Znwm>
    800022b0:	00050493          	mv	s1,a0
    ProducerKeyborad(thread_data *_td) : Thread(), td(_td) {}
    800022b4:	00005097          	auipc	ra,0x5
    800022b8:	830080e7          	jalr	-2000(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    800022bc:	0000b797          	auipc	a5,0xb
    800022c0:	97c78793          	addi	a5,a5,-1668 # 8000cc38 <_ZTV16ProducerKeyborad+0x10>
    800022c4:	00f4b023          	sd	a5,0(s1)
    800022c8:	0364b023          	sd	s6,32(s1)
    producers[0] = new ProducerKeyborad(&threadData[0]);
    800022cc:	009a3023          	sd	s1,0(s4)
    producers[0]->start();
    800022d0:	00048513          	mv	a0,s1
    800022d4:	00004097          	auipc	ra,0x4
    800022d8:	76c080e7          	jalr	1900(ra) # 80006a40 <_ZN6Thread5startEv>
    for (int i = 1; i < threadNum; i++) {
    800022dc:	00100913          	li	s2,1
    800022e0:	0300006f          	j	80002310 <_Z20testConsumerProducerv+0x270>
    Producer(thread_data *_td) : Thread(), td(_td) {}
    800022e4:	0000b797          	auipc	a5,0xb
    800022e8:	97c78793          	addi	a5,a5,-1668 # 8000cc60 <_ZTV8Producer+0x10>
    800022ec:	00fcb023          	sd	a5,0(s9)
    800022f0:	029cb023          	sd	s1,32(s9)
        producers[i] = new Producer(&threadData[i]);
    800022f4:	00391793          	slli	a5,s2,0x3
    800022f8:	00fa07b3          	add	a5,s4,a5
    800022fc:	0197b023          	sd	s9,0(a5)
        producers[i]->start();
    80002300:	000c8513          	mv	a0,s9
    80002304:	00004097          	auipc	ra,0x4
    80002308:	73c080e7          	jalr	1852(ra) # 80006a40 <_ZN6Thread5startEv>
    for (int i = 1; i < threadNum; i++) {
    8000230c:	0019091b          	addiw	s2,s2,1
    80002310:	05395263          	bge	s2,s3,80002354 <_Z20testConsumerProducerv+0x2b4>
        threadData[i].id = i;
    80002314:	00191493          	slli	s1,s2,0x1
    80002318:	012484b3          	add	s1,s1,s2
    8000231c:	00349493          	slli	s1,s1,0x3
    80002320:	009b04b3          	add	s1,s6,s1
    80002324:	0124a023          	sw	s2,0(s1)
        threadData[i].buffer = buffer;
    80002328:	0154b423          	sd	s5,8(s1)
        threadData[i].sem = waitForAll;
    8000232c:	0000b797          	auipc	a5,0xb
    80002330:	ba47b783          	ld	a5,-1116(a5) # 8000ced0 <_ZL10waitForAll>
    80002334:	00f4b823          	sd	a5,16(s1)
        producers[i] = new Producer(&threadData[i]);
    80002338:	02800513          	li	a0,40
    8000233c:	00004097          	auipc	ra,0x4
    80002340:	61c080e7          	jalr	1564(ra) # 80006958 <_Znwm>
    80002344:	00050c93          	mv	s9,a0
    Producer(thread_data *_td) : Thread(), td(_td) {}
    80002348:	00004097          	auipc	ra,0x4
    8000234c:	79c080e7          	jalr	1948(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    80002350:	f95ff06f          	j	800022e4 <_Z20testConsumerProducerv+0x244>
    Thread::dispatch();
    80002354:	00004097          	auipc	ra,0x4
    80002358:	740080e7          	jalr	1856(ra) # 80006a94 <_ZN6Thread8dispatchEv>
    for (int i = 0; i <= threadNum; i++) {
    8000235c:	00000493          	li	s1,0
    80002360:	0099ce63          	blt	s3,s1,8000237c <_Z20testConsumerProducerv+0x2dc>
        waitForAll->wait();
    80002364:	0000b517          	auipc	a0,0xb
    80002368:	b6c53503          	ld	a0,-1172(a0) # 8000ced0 <_ZL10waitForAll>
    8000236c:	00004097          	auipc	ra,0x4
    80002370:	7e4080e7          	jalr	2020(ra) # 80006b50 <_ZN9Semaphore4waitEv>
    for (int i = 0; i <= threadNum; i++) {
    80002374:	0014849b          	addiw	s1,s1,1
    80002378:	fe9ff06f          	j	80002360 <_Z20testConsumerProducerv+0x2c0>
    delete waitForAll;
    8000237c:	0000b517          	auipc	a0,0xb
    80002380:	b5453503          	ld	a0,-1196(a0) # 8000ced0 <_ZL10waitForAll>
    80002384:	00050863          	beqz	a0,80002394 <_Z20testConsumerProducerv+0x2f4>
    80002388:	00053783          	ld	a5,0(a0)
    8000238c:	0087b783          	ld	a5,8(a5)
    80002390:	000780e7          	jalr	a5
    for (int i = 0; i <= threadNum; i++) {
    80002394:	00000493          	li	s1,0
    80002398:	0080006f          	j	800023a0 <_Z20testConsumerProducerv+0x300>
    for (int i = 0; i < threadNum; i++) {
    8000239c:	0014849b          	addiw	s1,s1,1
    800023a0:	0334d263          	bge	s1,s3,800023c4 <_Z20testConsumerProducerv+0x324>
        delete producers[i];
    800023a4:	00349793          	slli	a5,s1,0x3
    800023a8:	00fa07b3          	add	a5,s4,a5
    800023ac:	0007b503          	ld	a0,0(a5)
    800023b0:	fe0506e3          	beqz	a0,8000239c <_Z20testConsumerProducerv+0x2fc>
    800023b4:	00053783          	ld	a5,0(a0)
    800023b8:	0087b783          	ld	a5,8(a5)
    800023bc:	000780e7          	jalr	a5
    800023c0:	fddff06f          	j	8000239c <_Z20testConsumerProducerv+0x2fc>
    delete consumer;
    800023c4:	000b8a63          	beqz	s7,800023d8 <_Z20testConsumerProducerv+0x338>
    800023c8:	000bb783          	ld	a5,0(s7)
    800023cc:	0087b783          	ld	a5,8(a5)
    800023d0:	000b8513          	mv	a0,s7
    800023d4:	000780e7          	jalr	a5
    delete buffer;
    800023d8:	000a8e63          	beqz	s5,800023f4 <_Z20testConsumerProducerv+0x354>
    800023dc:	000a8513          	mv	a0,s5
    800023e0:	00002097          	auipc	ra,0x2
    800023e4:	870080e7          	jalr	-1936(ra) # 80003c50 <_ZN9BufferCPPD1Ev>
    800023e8:	000a8513          	mv	a0,s5
    800023ec:	00004097          	auipc	ra,0x4
    800023f0:	594080e7          	jalr	1428(ra) # 80006980 <_ZdlPv>
    800023f4:	000c0113          	mv	sp,s8
}
    800023f8:	f8040113          	addi	sp,s0,-128
    800023fc:	07813083          	ld	ra,120(sp)
    80002400:	07013403          	ld	s0,112(sp)
    80002404:	06813483          	ld	s1,104(sp)
    80002408:	06013903          	ld	s2,96(sp)
    8000240c:	05813983          	ld	s3,88(sp)
    80002410:	05013a03          	ld	s4,80(sp)
    80002414:	04813a83          	ld	s5,72(sp)
    80002418:	04013b03          	ld	s6,64(sp)
    8000241c:	03813b83          	ld	s7,56(sp)
    80002420:	03013c03          	ld	s8,48(sp)
    80002424:	02813c83          	ld	s9,40(sp)
    80002428:	08010113          	addi	sp,sp,128
    8000242c:	00008067          	ret
    80002430:	00050493          	mv	s1,a0
    BufferCPP *buffer = new BufferCPP(n);
    80002434:	000a8513          	mv	a0,s5
    80002438:	00004097          	auipc	ra,0x4
    8000243c:	548080e7          	jalr	1352(ra) # 80006980 <_ZdlPv>
    80002440:	00048513          	mv	a0,s1
    80002444:	0000c097          	auipc	ra,0xc
    80002448:	c04080e7          	jalr	-1020(ra) # 8000e048 <_Unwind_Resume>
    8000244c:	00050493          	mv	s1,a0
    waitForAll = new Semaphore(0);
    80002450:	00090513          	mv	a0,s2
    80002454:	00004097          	auipc	ra,0x4
    80002458:	52c080e7          	jalr	1324(ra) # 80006980 <_ZdlPv>
    8000245c:	00048513          	mv	a0,s1
    80002460:	0000c097          	auipc	ra,0xc
    80002464:	be8080e7          	jalr	-1048(ra) # 8000e048 <_Unwind_Resume>
    80002468:	00050493          	mv	s1,a0
    Thread *consumer = new Consumer(&threadData[threadNum]);
    8000246c:	000b8513          	mv	a0,s7
    80002470:	00004097          	auipc	ra,0x4
    80002474:	510080e7          	jalr	1296(ra) # 80006980 <_ZdlPv>
    80002478:	00048513          	mv	a0,s1
    8000247c:	0000c097          	auipc	ra,0xc
    80002480:	bcc080e7          	jalr	-1076(ra) # 8000e048 <_Unwind_Resume>
    80002484:	00050913          	mv	s2,a0
    producers[0] = new ProducerKeyborad(&threadData[0]);
    80002488:	00048513          	mv	a0,s1
    8000248c:	00004097          	auipc	ra,0x4
    80002490:	4f4080e7          	jalr	1268(ra) # 80006980 <_ZdlPv>
    80002494:	00090513          	mv	a0,s2
    80002498:	0000c097          	auipc	ra,0xc
    8000249c:	bb0080e7          	jalr	-1104(ra) # 8000e048 <_Unwind_Resume>
    800024a0:	00050493          	mv	s1,a0
        producers[i] = new Producer(&threadData[i]);
    800024a4:	000c8513          	mv	a0,s9
    800024a8:	00004097          	auipc	ra,0x4
    800024ac:	4d8080e7          	jalr	1240(ra) # 80006980 <_ZdlPv>
    800024b0:	00048513          	mv	a0,s1
    800024b4:	0000c097          	auipc	ra,0xc
    800024b8:	b94080e7          	jalr	-1132(ra) # 8000e048 <_Unwind_Resume>

00000000800024bc <_ZN8Consumer3runEv>:
    void run() override {
    800024bc:	fd010113          	addi	sp,sp,-48
    800024c0:	02113423          	sd	ra,40(sp)
    800024c4:	02813023          	sd	s0,32(sp)
    800024c8:	00913c23          	sd	s1,24(sp)
    800024cc:	01213823          	sd	s2,16(sp)
    800024d0:	01313423          	sd	s3,8(sp)
    800024d4:	03010413          	addi	s0,sp,48
    800024d8:	00050913          	mv	s2,a0
        int i = 0;
    800024dc:	00000993          	li	s3,0
    800024e0:	0100006f          	j	800024f0 <_ZN8Consumer3runEv+0x34>
                Console::putc('\n');
    800024e4:	00a00513          	li	a0,10
    800024e8:	00004097          	auipc	ra,0x4
    800024ec:	790080e7          	jalr	1936(ra) # 80006c78 <_ZN7Console4putcEc>
        while (!threadEnd) {
    800024f0:	0000b797          	auipc	a5,0xb
    800024f4:	9d87a783          	lw	a5,-1576(a5) # 8000cec8 <_ZL9threadEnd>
    800024f8:	04079a63          	bnez	a5,8000254c <_ZN8Consumer3runEv+0x90>
            int key = td->buffer->get();
    800024fc:	02093783          	ld	a5,32(s2)
    80002500:	0087b503          	ld	a0,8(a5)
    80002504:	00001097          	auipc	ra,0x1
    80002508:	638080e7          	jalr	1592(ra) # 80003b3c <_ZN9BufferCPP3getEv>
            i++;
    8000250c:	0019849b          	addiw	s1,s3,1
    80002510:	0004899b          	sext.w	s3,s1
            Console::putc(key);
    80002514:	0ff57513          	andi	a0,a0,255
    80002518:	00004097          	auipc	ra,0x4
    8000251c:	760080e7          	jalr	1888(ra) # 80006c78 <_ZN7Console4putcEc>
            if (i % 80 == 0) {
    80002520:	05000793          	li	a5,80
    80002524:	02f4e4bb          	remw	s1,s1,a5
    80002528:	fc0494e3          	bnez	s1,800024f0 <_ZN8Consumer3runEv+0x34>
    8000252c:	fb9ff06f          	j	800024e4 <_ZN8Consumer3runEv+0x28>
            int key = td->buffer->get();
    80002530:	02093783          	ld	a5,32(s2)
    80002534:	0087b503          	ld	a0,8(a5)
    80002538:	00001097          	auipc	ra,0x1
    8000253c:	604080e7          	jalr	1540(ra) # 80003b3c <_ZN9BufferCPP3getEv>
            Console::putc(key);
    80002540:	0ff57513          	andi	a0,a0,255
    80002544:	00004097          	auipc	ra,0x4
    80002548:	734080e7          	jalr	1844(ra) # 80006c78 <_ZN7Console4putcEc>
        while (td->buffer->getCnt() > 0) {
    8000254c:	02093783          	ld	a5,32(s2)
    80002550:	0087b503          	ld	a0,8(a5)
    80002554:	00001097          	auipc	ra,0x1
    80002558:	674080e7          	jalr	1652(ra) # 80003bc8 <_ZN9BufferCPP6getCntEv>
    8000255c:	fca04ae3          	bgtz	a0,80002530 <_ZN8Consumer3runEv+0x74>
        td->sem->signal();
    80002560:	02093783          	ld	a5,32(s2)
    80002564:	0107b503          	ld	a0,16(a5)
    80002568:	00004097          	auipc	ra,0x4
    8000256c:	614080e7          	jalr	1556(ra) # 80006b7c <_ZN9Semaphore6signalEv>
    }
    80002570:	02813083          	ld	ra,40(sp)
    80002574:	02013403          	ld	s0,32(sp)
    80002578:	01813483          	ld	s1,24(sp)
    8000257c:	01013903          	ld	s2,16(sp)
    80002580:	00813983          	ld	s3,8(sp)
    80002584:	03010113          	addi	sp,sp,48
    80002588:	00008067          	ret

000000008000258c <_ZN8ConsumerD1Ev>:
class Consumer : public Thread {
    8000258c:	ff010113          	addi	sp,sp,-16
    80002590:	00113423          	sd	ra,8(sp)
    80002594:	00813023          	sd	s0,0(sp)
    80002598:	01010413          	addi	s0,sp,16
    8000259c:	0000a797          	auipc	a5,0xa
    800025a0:	6ec78793          	addi	a5,a5,1772 # 8000cc88 <_ZTV8Consumer+0x10>
    800025a4:	00f53023          	sd	a5,0(a0)
    800025a8:	00004097          	auipc	ra,0x4
    800025ac:	334080e7          	jalr	820(ra) # 800068dc <_ZN6ThreadD1Ev>
    800025b0:	00813083          	ld	ra,8(sp)
    800025b4:	00013403          	ld	s0,0(sp)
    800025b8:	01010113          	addi	sp,sp,16
    800025bc:	00008067          	ret

00000000800025c0 <_ZN8ConsumerD0Ev>:
    800025c0:	fe010113          	addi	sp,sp,-32
    800025c4:	00113c23          	sd	ra,24(sp)
    800025c8:	00813823          	sd	s0,16(sp)
    800025cc:	00913423          	sd	s1,8(sp)
    800025d0:	02010413          	addi	s0,sp,32
    800025d4:	00050493          	mv	s1,a0
    800025d8:	0000a797          	auipc	a5,0xa
    800025dc:	6b078793          	addi	a5,a5,1712 # 8000cc88 <_ZTV8Consumer+0x10>
    800025e0:	00f53023          	sd	a5,0(a0)
    800025e4:	00004097          	auipc	ra,0x4
    800025e8:	2f8080e7          	jalr	760(ra) # 800068dc <_ZN6ThreadD1Ev>
    800025ec:	00048513          	mv	a0,s1
    800025f0:	00004097          	auipc	ra,0x4
    800025f4:	390080e7          	jalr	912(ra) # 80006980 <_ZdlPv>
    800025f8:	01813083          	ld	ra,24(sp)
    800025fc:	01013403          	ld	s0,16(sp)
    80002600:	00813483          	ld	s1,8(sp)
    80002604:	02010113          	addi	sp,sp,32
    80002608:	00008067          	ret

000000008000260c <_ZN16ProducerKeyboradD1Ev>:
class ProducerKeyborad : public Thread {
    8000260c:	ff010113          	addi	sp,sp,-16
    80002610:	00113423          	sd	ra,8(sp)
    80002614:	00813023          	sd	s0,0(sp)
    80002618:	01010413          	addi	s0,sp,16
    8000261c:	0000a797          	auipc	a5,0xa
    80002620:	61c78793          	addi	a5,a5,1564 # 8000cc38 <_ZTV16ProducerKeyborad+0x10>
    80002624:	00f53023          	sd	a5,0(a0)
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	2b4080e7          	jalr	692(ra) # 800068dc <_ZN6ThreadD1Ev>
    80002630:	00813083          	ld	ra,8(sp)
    80002634:	00013403          	ld	s0,0(sp)
    80002638:	01010113          	addi	sp,sp,16
    8000263c:	00008067          	ret

0000000080002640 <_ZN16ProducerKeyboradD0Ev>:
    80002640:	fe010113          	addi	sp,sp,-32
    80002644:	00113c23          	sd	ra,24(sp)
    80002648:	00813823          	sd	s0,16(sp)
    8000264c:	00913423          	sd	s1,8(sp)
    80002650:	02010413          	addi	s0,sp,32
    80002654:	00050493          	mv	s1,a0
    80002658:	0000a797          	auipc	a5,0xa
    8000265c:	5e078793          	addi	a5,a5,1504 # 8000cc38 <_ZTV16ProducerKeyborad+0x10>
    80002660:	00f53023          	sd	a5,0(a0)
    80002664:	00004097          	auipc	ra,0x4
    80002668:	278080e7          	jalr	632(ra) # 800068dc <_ZN6ThreadD1Ev>
    8000266c:	00048513          	mv	a0,s1
    80002670:	00004097          	auipc	ra,0x4
    80002674:	310080e7          	jalr	784(ra) # 80006980 <_ZdlPv>
    80002678:	01813083          	ld	ra,24(sp)
    8000267c:	01013403          	ld	s0,16(sp)
    80002680:	00813483          	ld	s1,8(sp)
    80002684:	02010113          	addi	sp,sp,32
    80002688:	00008067          	ret

000000008000268c <_ZN8ProducerD1Ev>:
class Producer : public Thread {
    8000268c:	ff010113          	addi	sp,sp,-16
    80002690:	00113423          	sd	ra,8(sp)
    80002694:	00813023          	sd	s0,0(sp)
    80002698:	01010413          	addi	s0,sp,16
    8000269c:	0000a797          	auipc	a5,0xa
    800026a0:	5c478793          	addi	a5,a5,1476 # 8000cc60 <_ZTV8Producer+0x10>
    800026a4:	00f53023          	sd	a5,0(a0)
    800026a8:	00004097          	auipc	ra,0x4
    800026ac:	234080e7          	jalr	564(ra) # 800068dc <_ZN6ThreadD1Ev>
    800026b0:	00813083          	ld	ra,8(sp)
    800026b4:	00013403          	ld	s0,0(sp)
    800026b8:	01010113          	addi	sp,sp,16
    800026bc:	00008067          	ret

00000000800026c0 <_ZN8ProducerD0Ev>:
    800026c0:	fe010113          	addi	sp,sp,-32
    800026c4:	00113c23          	sd	ra,24(sp)
    800026c8:	00813823          	sd	s0,16(sp)
    800026cc:	00913423          	sd	s1,8(sp)
    800026d0:	02010413          	addi	s0,sp,32
    800026d4:	00050493          	mv	s1,a0
    800026d8:	0000a797          	auipc	a5,0xa
    800026dc:	58878793          	addi	a5,a5,1416 # 8000cc60 <_ZTV8Producer+0x10>
    800026e0:	00f53023          	sd	a5,0(a0)
    800026e4:	00004097          	auipc	ra,0x4
    800026e8:	1f8080e7          	jalr	504(ra) # 800068dc <_ZN6ThreadD1Ev>
    800026ec:	00048513          	mv	a0,s1
    800026f0:	00004097          	auipc	ra,0x4
    800026f4:	290080e7          	jalr	656(ra) # 80006980 <_ZdlPv>
    800026f8:	01813083          	ld	ra,24(sp)
    800026fc:	01013403          	ld	s0,16(sp)
    80002700:	00813483          	ld	s1,8(sp)
    80002704:	02010113          	addi	sp,sp,32
    80002708:	00008067          	ret

000000008000270c <_ZN16ProducerKeyborad3runEv>:
    void run() override {
    8000270c:	fe010113          	addi	sp,sp,-32
    80002710:	00113c23          	sd	ra,24(sp)
    80002714:	00813823          	sd	s0,16(sp)
    80002718:	00913423          	sd	s1,8(sp)
    8000271c:	02010413          	addi	s0,sp,32
    80002720:	00050493          	mv	s1,a0
        while ((key = getc()) != 0x1b) {
    80002724:	00002097          	auipc	ra,0x2
    80002728:	540080e7          	jalr	1344(ra) # 80004c64 <getc>
    8000272c:	0005059b          	sext.w	a1,a0
    80002730:	01b00793          	li	a5,27
    80002734:	00f58c63          	beq	a1,a5,8000274c <_ZN16ProducerKeyborad3runEv+0x40>
            td->buffer->put(key);
    80002738:	0204b783          	ld	a5,32(s1)
    8000273c:	0087b503          	ld	a0,8(a5)
    80002740:	00001097          	auipc	ra,0x1
    80002744:	36c080e7          	jalr	876(ra) # 80003aac <_ZN9BufferCPP3putEi>
        while ((key = getc()) != 0x1b) {
    80002748:	fddff06f          	j	80002724 <_ZN16ProducerKeyborad3runEv+0x18>
        threadEnd = 1;
    8000274c:	00100793          	li	a5,1
    80002750:	0000a717          	auipc	a4,0xa
    80002754:	76f72c23          	sw	a5,1912(a4) # 8000cec8 <_ZL9threadEnd>
        td->buffer->put('!');
    80002758:	0204b783          	ld	a5,32(s1)
    8000275c:	02100593          	li	a1,33
    80002760:	0087b503          	ld	a0,8(a5)
    80002764:	00001097          	auipc	ra,0x1
    80002768:	348080e7          	jalr	840(ra) # 80003aac <_ZN9BufferCPP3putEi>
        td->sem->signal();
    8000276c:	0204b783          	ld	a5,32(s1)
    80002770:	0107b503          	ld	a0,16(a5)
    80002774:	00004097          	auipc	ra,0x4
    80002778:	408080e7          	jalr	1032(ra) # 80006b7c <_ZN9Semaphore6signalEv>
    }
    8000277c:	01813083          	ld	ra,24(sp)
    80002780:	01013403          	ld	s0,16(sp)
    80002784:	00813483          	ld	s1,8(sp)
    80002788:	02010113          	addi	sp,sp,32
    8000278c:	00008067          	ret

0000000080002790 <_ZN8Producer3runEv>:
    void run() override {
    80002790:	fe010113          	addi	sp,sp,-32
    80002794:	00113c23          	sd	ra,24(sp)
    80002798:	00813823          	sd	s0,16(sp)
    8000279c:	00913423          	sd	s1,8(sp)
    800027a0:	01213023          	sd	s2,0(sp)
    800027a4:	02010413          	addi	s0,sp,32
    800027a8:	00050493          	mv	s1,a0
        int i = 0;
    800027ac:	00000913          	li	s2,0
        while (!threadEnd) {
    800027b0:	0000a797          	auipc	a5,0xa
    800027b4:	7187a783          	lw	a5,1816(a5) # 8000cec8 <_ZL9threadEnd>
    800027b8:	04079263          	bnez	a5,800027fc <_ZN8Producer3runEv+0x6c>
            td->buffer->put(td->id + '0');
    800027bc:	0204b783          	ld	a5,32(s1)
    800027c0:	0007a583          	lw	a1,0(a5)
    800027c4:	0305859b          	addiw	a1,a1,48
    800027c8:	0087b503          	ld	a0,8(a5)
    800027cc:	00001097          	auipc	ra,0x1
    800027d0:	2e0080e7          	jalr	736(ra) # 80003aac <_ZN9BufferCPP3putEi>
            i++;
    800027d4:	0019071b          	addiw	a4,s2,1
    800027d8:	0007091b          	sext.w	s2,a4
            Thread::sleep((i + td->id) % 5);
    800027dc:	0204b783          	ld	a5,32(s1)
    800027e0:	0007a783          	lw	a5,0(a5)
    800027e4:	00e787bb          	addw	a5,a5,a4
    800027e8:	00500513          	li	a0,5
    800027ec:	02a7e53b          	remw	a0,a5,a0
    800027f0:	00004097          	auipc	ra,0x4
    800027f4:	2cc080e7          	jalr	716(ra) # 80006abc <_ZN6Thread5sleepEm>
        while (!threadEnd) {
    800027f8:	fb9ff06f          	j	800027b0 <_ZN8Producer3runEv+0x20>
        td->sem->signal();
    800027fc:	0204b783          	ld	a5,32(s1)
    80002800:	0107b503          	ld	a0,16(a5)
    80002804:	00004097          	auipc	ra,0x4
    80002808:	378080e7          	jalr	888(ra) # 80006b7c <_ZN9Semaphore6signalEv>
    }
    8000280c:	01813083          	ld	ra,24(sp)
    80002810:	01013403          	ld	s0,16(sp)
    80002814:	00813483          	ld	s1,8(sp)
    80002818:	00013903          	ld	s2,0(sp)
    8000281c:	02010113          	addi	sp,sp,32
    80002820:	00008067          	ret

0000000080002824 <_ZL9fibonaccim>:
static volatile bool finishedA = false;
static volatile bool finishedB = false;
static volatile bool finishedC = false;
static volatile bool finishedD = false;

static uint64 fibonacci(uint64 n) {
    80002824:	fe010113          	addi	sp,sp,-32
    80002828:	00113c23          	sd	ra,24(sp)
    8000282c:	00813823          	sd	s0,16(sp)
    80002830:	00913423          	sd	s1,8(sp)
    80002834:	01213023          	sd	s2,0(sp)
    80002838:	02010413          	addi	s0,sp,32
    8000283c:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    80002840:	00100793          	li	a5,1
    80002844:	02a7f863          	bgeu	a5,a0,80002874 <_ZL9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    80002848:	00a00793          	li	a5,10
    8000284c:	02f577b3          	remu	a5,a0,a5
    80002850:	02078e63          	beqz	a5,8000288c <_ZL9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    80002854:	fff48513          	addi	a0,s1,-1
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	fcc080e7          	jalr	-52(ra) # 80002824 <_ZL9fibonaccim>
    80002860:	00050913          	mv	s2,a0
    80002864:	ffe48513          	addi	a0,s1,-2
    80002868:	00000097          	auipc	ra,0x0
    8000286c:	fbc080e7          	jalr	-68(ra) # 80002824 <_ZL9fibonaccim>
    80002870:	00a90533          	add	a0,s2,a0
}
    80002874:	01813083          	ld	ra,24(sp)
    80002878:	01013403          	ld	s0,16(sp)
    8000287c:	00813483          	ld	s1,8(sp)
    80002880:	00013903          	ld	s2,0(sp)
    80002884:	02010113          	addi	sp,sp,32
    80002888:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    8000288c:	00002097          	auipc	ra,0x2
    80002890:	1c0080e7          	jalr	448(ra) # 80004a4c <thread_dispatch>
    80002894:	fc1ff06f          	j	80002854 <_ZL9fibonaccim+0x30>

0000000080002898 <_ZL11workerBodyDPv>:
    printString("A finished!\n");
    finishedC = true;
    thread_dispatch();
}

static void workerBodyD(void* arg) {
    80002898:	fe010113          	addi	sp,sp,-32
    8000289c:	00113c23          	sd	ra,24(sp)
    800028a0:	00813823          	sd	s0,16(sp)
    800028a4:	00913423          	sd	s1,8(sp)
    800028a8:	01213023          	sd	s2,0(sp)
    800028ac:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    800028b0:	00a00493          	li	s1,10
    800028b4:	0400006f          	j	800028f4 <_ZL11workerBodyDPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    800028b8:	00008517          	auipc	a0,0x8
    800028bc:	8a850513          	addi	a0,a0,-1880 # 8000a160 <CONSOLE_STATUS+0x150>
    800028c0:	00001097          	auipc	ra,0x1
    800028c4:	dc8080e7          	jalr	-568(ra) # 80003688 <_Z11printStringPKc>
    800028c8:	00000613          	li	a2,0
    800028cc:	00a00593          	li	a1,10
    800028d0:	00048513          	mv	a0,s1
    800028d4:	00001097          	auipc	ra,0x1
    800028d8:	f64080e7          	jalr	-156(ra) # 80003838 <_Z8printIntiii>
    800028dc:	00008517          	auipc	a0,0x8
    800028e0:	a7450513          	addi	a0,a0,-1420 # 8000a350 <CONSOLE_STATUS+0x340>
    800028e4:	00001097          	auipc	ra,0x1
    800028e8:	da4080e7          	jalr	-604(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 13; i++) {
    800028ec:	0014849b          	addiw	s1,s1,1
    800028f0:	0ff4f493          	andi	s1,s1,255
    800028f4:	00c00793          	li	a5,12
    800028f8:	fc97f0e3          	bgeu	a5,s1,800028b8 <_ZL11workerBodyDPv+0x20>
    }

    printString("D: dispatch\n");
    800028fc:	00008517          	auipc	a0,0x8
    80002900:	86c50513          	addi	a0,a0,-1940 # 8000a168 <CONSOLE_STATUS+0x158>
    80002904:	00001097          	auipc	ra,0x1
    80002908:	d84080e7          	jalr	-636(ra) # 80003688 <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    8000290c:	00500313          	li	t1,5
    thread_dispatch();
    80002910:	00002097          	auipc	ra,0x2
    80002914:	13c080e7          	jalr	316(ra) # 80004a4c <thread_dispatch>

    uint64 result = fibonacci(16);
    80002918:	01000513          	li	a0,16
    8000291c:	00000097          	auipc	ra,0x0
    80002920:	f08080e7          	jalr	-248(ra) # 80002824 <_ZL9fibonaccim>
    80002924:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    80002928:	00008517          	auipc	a0,0x8
    8000292c:	85050513          	addi	a0,a0,-1968 # 8000a178 <CONSOLE_STATUS+0x168>
    80002930:	00001097          	auipc	ra,0x1
    80002934:	d58080e7          	jalr	-680(ra) # 80003688 <_Z11printStringPKc>
    80002938:	00000613          	li	a2,0
    8000293c:	00a00593          	li	a1,10
    80002940:	0009051b          	sext.w	a0,s2
    80002944:	00001097          	auipc	ra,0x1
    80002948:	ef4080e7          	jalr	-268(ra) # 80003838 <_Z8printIntiii>
    8000294c:	00008517          	auipc	a0,0x8
    80002950:	a0450513          	addi	a0,a0,-1532 # 8000a350 <CONSOLE_STATUS+0x340>
    80002954:	00001097          	auipc	ra,0x1
    80002958:	d34080e7          	jalr	-716(ra) # 80003688 <_Z11printStringPKc>
    8000295c:	0400006f          	j	8000299c <_ZL11workerBodyDPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80002960:	00008517          	auipc	a0,0x8
    80002964:	80050513          	addi	a0,a0,-2048 # 8000a160 <CONSOLE_STATUS+0x150>
    80002968:	00001097          	auipc	ra,0x1
    8000296c:	d20080e7          	jalr	-736(ra) # 80003688 <_Z11printStringPKc>
    80002970:	00000613          	li	a2,0
    80002974:	00a00593          	li	a1,10
    80002978:	00048513          	mv	a0,s1
    8000297c:	00001097          	auipc	ra,0x1
    80002980:	ebc080e7          	jalr	-324(ra) # 80003838 <_Z8printIntiii>
    80002984:	00008517          	auipc	a0,0x8
    80002988:	9cc50513          	addi	a0,a0,-1588 # 8000a350 <CONSOLE_STATUS+0x340>
    8000298c:	00001097          	auipc	ra,0x1
    80002990:	cfc080e7          	jalr	-772(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 16; i++) {
    80002994:	0014849b          	addiw	s1,s1,1
    80002998:	0ff4f493          	andi	s1,s1,255
    8000299c:	00f00793          	li	a5,15
    800029a0:	fc97f0e3          	bgeu	a5,s1,80002960 <_ZL11workerBodyDPv+0xc8>
    }

    printString("D finished!\n");
    800029a4:	00007517          	auipc	a0,0x7
    800029a8:	7e450513          	addi	a0,a0,2020 # 8000a188 <CONSOLE_STATUS+0x178>
    800029ac:	00001097          	auipc	ra,0x1
    800029b0:	cdc080e7          	jalr	-804(ra) # 80003688 <_Z11printStringPKc>
    finishedD = true;
    800029b4:	00100793          	li	a5,1
    800029b8:	0000a717          	auipc	a4,0xa
    800029bc:	52f70023          	sb	a5,1312(a4) # 8000ced8 <_ZL9finishedD>
    thread_dispatch();
    800029c0:	00002097          	auipc	ra,0x2
    800029c4:	08c080e7          	jalr	140(ra) # 80004a4c <thread_dispatch>
}
    800029c8:	01813083          	ld	ra,24(sp)
    800029cc:	01013403          	ld	s0,16(sp)
    800029d0:	00813483          	ld	s1,8(sp)
    800029d4:	00013903          	ld	s2,0(sp)
    800029d8:	02010113          	addi	sp,sp,32
    800029dc:	00008067          	ret

00000000800029e0 <_ZL11workerBodyCPv>:
static void workerBodyC(void* arg) {
    800029e0:	fe010113          	addi	sp,sp,-32
    800029e4:	00113c23          	sd	ra,24(sp)
    800029e8:	00813823          	sd	s0,16(sp)
    800029ec:	00913423          	sd	s1,8(sp)
    800029f0:	01213023          	sd	s2,0(sp)
    800029f4:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    800029f8:	00000493          	li	s1,0
    800029fc:	0400006f          	j	80002a3c <_ZL11workerBodyCPv+0x5c>
        printString("C: i="); printInt(i); printString("\n");
    80002a00:	00007517          	auipc	a0,0x7
    80002a04:	73050513          	addi	a0,a0,1840 # 8000a130 <CONSOLE_STATUS+0x120>
    80002a08:	00001097          	auipc	ra,0x1
    80002a0c:	c80080e7          	jalr	-896(ra) # 80003688 <_Z11printStringPKc>
    80002a10:	00000613          	li	a2,0
    80002a14:	00a00593          	li	a1,10
    80002a18:	00048513          	mv	a0,s1
    80002a1c:	00001097          	auipc	ra,0x1
    80002a20:	e1c080e7          	jalr	-484(ra) # 80003838 <_Z8printIntiii>
    80002a24:	00008517          	auipc	a0,0x8
    80002a28:	92c50513          	addi	a0,a0,-1748 # 8000a350 <CONSOLE_STATUS+0x340>
    80002a2c:	00001097          	auipc	ra,0x1
    80002a30:	c5c080e7          	jalr	-932(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 3; i++) {
    80002a34:	0014849b          	addiw	s1,s1,1
    80002a38:	0ff4f493          	andi	s1,s1,255
    80002a3c:	00200793          	li	a5,2
    80002a40:	fc97f0e3          	bgeu	a5,s1,80002a00 <_ZL11workerBodyCPv+0x20>
    printString("C: dispatch\n");
    80002a44:	00007517          	auipc	a0,0x7
    80002a48:	6f450513          	addi	a0,a0,1780 # 8000a138 <CONSOLE_STATUS+0x128>
    80002a4c:	00001097          	auipc	ra,0x1
    80002a50:	c3c080e7          	jalr	-964(ra) # 80003688 <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    80002a54:	00700313          	li	t1,7
    thread_dispatch();
    80002a58:	00002097          	auipc	ra,0x2
    80002a5c:	ff4080e7          	jalr	-12(ra) # 80004a4c <thread_dispatch>
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    80002a60:	00030913          	mv	s2,t1
    printString("C: t1="); printInt(t1); printString("\n");
    80002a64:	00007517          	auipc	a0,0x7
    80002a68:	6e450513          	addi	a0,a0,1764 # 8000a148 <CONSOLE_STATUS+0x138>
    80002a6c:	00001097          	auipc	ra,0x1
    80002a70:	c1c080e7          	jalr	-996(ra) # 80003688 <_Z11printStringPKc>
    80002a74:	00000613          	li	a2,0
    80002a78:	00a00593          	li	a1,10
    80002a7c:	0009051b          	sext.w	a0,s2
    80002a80:	00001097          	auipc	ra,0x1
    80002a84:	db8080e7          	jalr	-584(ra) # 80003838 <_Z8printIntiii>
    80002a88:	00008517          	auipc	a0,0x8
    80002a8c:	8c850513          	addi	a0,a0,-1848 # 8000a350 <CONSOLE_STATUS+0x340>
    80002a90:	00001097          	auipc	ra,0x1
    80002a94:	bf8080e7          	jalr	-1032(ra) # 80003688 <_Z11printStringPKc>
    uint64 result = fibonacci(12);
    80002a98:	00c00513          	li	a0,12
    80002a9c:	00000097          	auipc	ra,0x0
    80002aa0:	d88080e7          	jalr	-632(ra) # 80002824 <_ZL9fibonaccim>
    80002aa4:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    80002aa8:	00007517          	auipc	a0,0x7
    80002aac:	6a850513          	addi	a0,a0,1704 # 8000a150 <CONSOLE_STATUS+0x140>
    80002ab0:	00001097          	auipc	ra,0x1
    80002ab4:	bd8080e7          	jalr	-1064(ra) # 80003688 <_Z11printStringPKc>
    80002ab8:	00000613          	li	a2,0
    80002abc:	00a00593          	li	a1,10
    80002ac0:	0009051b          	sext.w	a0,s2
    80002ac4:	00001097          	auipc	ra,0x1
    80002ac8:	d74080e7          	jalr	-652(ra) # 80003838 <_Z8printIntiii>
    80002acc:	00008517          	auipc	a0,0x8
    80002ad0:	88450513          	addi	a0,a0,-1916 # 8000a350 <CONSOLE_STATUS+0x340>
    80002ad4:	00001097          	auipc	ra,0x1
    80002ad8:	bb4080e7          	jalr	-1100(ra) # 80003688 <_Z11printStringPKc>
    80002adc:	0400006f          	j	80002b1c <_ZL11workerBodyCPv+0x13c>
        printString("C: i="); printInt(i); printString("\n");
    80002ae0:	00007517          	auipc	a0,0x7
    80002ae4:	65050513          	addi	a0,a0,1616 # 8000a130 <CONSOLE_STATUS+0x120>
    80002ae8:	00001097          	auipc	ra,0x1
    80002aec:	ba0080e7          	jalr	-1120(ra) # 80003688 <_Z11printStringPKc>
    80002af0:	00000613          	li	a2,0
    80002af4:	00a00593          	li	a1,10
    80002af8:	00048513          	mv	a0,s1
    80002afc:	00001097          	auipc	ra,0x1
    80002b00:	d3c080e7          	jalr	-708(ra) # 80003838 <_Z8printIntiii>
    80002b04:	00008517          	auipc	a0,0x8
    80002b08:	84c50513          	addi	a0,a0,-1972 # 8000a350 <CONSOLE_STATUS+0x340>
    80002b0c:	00001097          	auipc	ra,0x1
    80002b10:	b7c080e7          	jalr	-1156(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 6; i++) {
    80002b14:	0014849b          	addiw	s1,s1,1
    80002b18:	0ff4f493          	andi	s1,s1,255
    80002b1c:	00500793          	li	a5,5
    80002b20:	fc97f0e3          	bgeu	a5,s1,80002ae0 <_ZL11workerBodyCPv+0x100>
    printString("A finished!\n");
    80002b24:	00007517          	auipc	a0,0x7
    80002b28:	5e450513          	addi	a0,a0,1508 # 8000a108 <CONSOLE_STATUS+0xf8>
    80002b2c:	00001097          	auipc	ra,0x1
    80002b30:	b5c080e7          	jalr	-1188(ra) # 80003688 <_Z11printStringPKc>
    finishedC = true;
    80002b34:	00100793          	li	a5,1
    80002b38:	0000a717          	auipc	a4,0xa
    80002b3c:	3af700a3          	sb	a5,929(a4) # 8000ced9 <_ZL9finishedC>
    thread_dispatch();
    80002b40:	00002097          	auipc	ra,0x2
    80002b44:	f0c080e7          	jalr	-244(ra) # 80004a4c <thread_dispatch>
}
    80002b48:	01813083          	ld	ra,24(sp)
    80002b4c:	01013403          	ld	s0,16(sp)
    80002b50:	00813483          	ld	s1,8(sp)
    80002b54:	00013903          	ld	s2,0(sp)
    80002b58:	02010113          	addi	sp,sp,32
    80002b5c:	00008067          	ret

0000000080002b60 <_ZL11workerBodyBPv>:
static void workerBodyB(void* arg) {
    80002b60:	fe010113          	addi	sp,sp,-32
    80002b64:	00113c23          	sd	ra,24(sp)
    80002b68:	00813823          	sd	s0,16(sp)
    80002b6c:	00913423          	sd	s1,8(sp)
    80002b70:	01213023          	sd	s2,0(sp)
    80002b74:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    80002b78:	00000913          	li	s2,0
    80002b7c:	0380006f          	j	80002bb4 <_ZL11workerBodyBPv+0x54>
            thread_dispatch();
    80002b80:	00002097          	auipc	ra,0x2
    80002b84:	ecc080e7          	jalr	-308(ra) # 80004a4c <thread_dispatch>
        for (uint64 j = 0; j < 10000; j++) {
    80002b88:	00148493          	addi	s1,s1,1
    80002b8c:	000027b7          	lui	a5,0x2
    80002b90:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80002b94:	0097ee63          	bltu	a5,s1,80002bb0 <_ZL11workerBodyBPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80002b98:	00000713          	li	a4,0
    80002b9c:	000077b7          	lui	a5,0x7
    80002ba0:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80002ba4:	fce7eee3          	bltu	a5,a4,80002b80 <_ZL11workerBodyBPv+0x20>
    80002ba8:	00170713          	addi	a4,a4,1
    80002bac:	ff1ff06f          	j	80002b9c <_ZL11workerBodyBPv+0x3c>
    for (uint64 i = 0; i < 16; i++) {
    80002bb0:	00190913          	addi	s2,s2,1
    80002bb4:	00f00793          	li	a5,15
    80002bb8:	0527e063          	bltu	a5,s2,80002bf8 <_ZL11workerBodyBPv+0x98>
        printString("B: i="); printInt(i); printString("\n");
    80002bbc:	00007517          	auipc	a0,0x7
    80002bc0:	55c50513          	addi	a0,a0,1372 # 8000a118 <CONSOLE_STATUS+0x108>
    80002bc4:	00001097          	auipc	ra,0x1
    80002bc8:	ac4080e7          	jalr	-1340(ra) # 80003688 <_Z11printStringPKc>
    80002bcc:	00000613          	li	a2,0
    80002bd0:	00a00593          	li	a1,10
    80002bd4:	0009051b          	sext.w	a0,s2
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	c60080e7          	jalr	-928(ra) # 80003838 <_Z8printIntiii>
    80002be0:	00007517          	auipc	a0,0x7
    80002be4:	77050513          	addi	a0,a0,1904 # 8000a350 <CONSOLE_STATUS+0x340>
    80002be8:	00001097          	auipc	ra,0x1
    80002bec:	aa0080e7          	jalr	-1376(ra) # 80003688 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80002bf0:	00000493          	li	s1,0
    80002bf4:	f99ff06f          	j	80002b8c <_ZL11workerBodyBPv+0x2c>
    printString("B finished!\n");
    80002bf8:	00007517          	auipc	a0,0x7
    80002bfc:	52850513          	addi	a0,a0,1320 # 8000a120 <CONSOLE_STATUS+0x110>
    80002c00:	00001097          	auipc	ra,0x1
    80002c04:	a88080e7          	jalr	-1400(ra) # 80003688 <_Z11printStringPKc>
    finishedB = true;
    80002c08:	00100793          	li	a5,1
    80002c0c:	0000a717          	auipc	a4,0xa
    80002c10:	2cf70723          	sb	a5,718(a4) # 8000ceda <_ZL9finishedB>
    thread_dispatch();
    80002c14:	00002097          	auipc	ra,0x2
    80002c18:	e38080e7          	jalr	-456(ra) # 80004a4c <thread_dispatch>
}
    80002c1c:	01813083          	ld	ra,24(sp)
    80002c20:	01013403          	ld	s0,16(sp)
    80002c24:	00813483          	ld	s1,8(sp)
    80002c28:	00013903          	ld	s2,0(sp)
    80002c2c:	02010113          	addi	sp,sp,32
    80002c30:	00008067          	ret

0000000080002c34 <_ZL11workerBodyAPv>:
static void workerBodyA(void* arg) {
    80002c34:	fe010113          	addi	sp,sp,-32
    80002c38:	00113c23          	sd	ra,24(sp)
    80002c3c:	00813823          	sd	s0,16(sp)
    80002c40:	00913423          	sd	s1,8(sp)
    80002c44:	01213023          	sd	s2,0(sp)
    80002c48:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    80002c4c:	00000913          	li	s2,0
    80002c50:	0380006f          	j	80002c88 <_ZL11workerBodyAPv+0x54>
            thread_dispatch();
    80002c54:	00002097          	auipc	ra,0x2
    80002c58:	df8080e7          	jalr	-520(ra) # 80004a4c <thread_dispatch>
        for (uint64 j = 0; j < 10000; j++) {
    80002c5c:	00148493          	addi	s1,s1,1
    80002c60:	000027b7          	lui	a5,0x2
    80002c64:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80002c68:	0097ee63          	bltu	a5,s1,80002c84 <_ZL11workerBodyAPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80002c6c:	00000713          	li	a4,0
    80002c70:	000077b7          	lui	a5,0x7
    80002c74:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80002c78:	fce7eee3          	bltu	a5,a4,80002c54 <_ZL11workerBodyAPv+0x20>
    80002c7c:	00170713          	addi	a4,a4,1
    80002c80:	ff1ff06f          	j	80002c70 <_ZL11workerBodyAPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    80002c84:	00190913          	addi	s2,s2,1
    80002c88:	00900793          	li	a5,9
    80002c8c:	0527e063          	bltu	a5,s2,80002ccc <_ZL11workerBodyAPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    80002c90:	00007517          	auipc	a0,0x7
    80002c94:	47050513          	addi	a0,a0,1136 # 8000a100 <CONSOLE_STATUS+0xf0>
    80002c98:	00001097          	auipc	ra,0x1
    80002c9c:	9f0080e7          	jalr	-1552(ra) # 80003688 <_Z11printStringPKc>
    80002ca0:	00000613          	li	a2,0
    80002ca4:	00a00593          	li	a1,10
    80002ca8:	0009051b          	sext.w	a0,s2
    80002cac:	00001097          	auipc	ra,0x1
    80002cb0:	b8c080e7          	jalr	-1140(ra) # 80003838 <_Z8printIntiii>
    80002cb4:	00007517          	auipc	a0,0x7
    80002cb8:	69c50513          	addi	a0,a0,1692 # 8000a350 <CONSOLE_STATUS+0x340>
    80002cbc:	00001097          	auipc	ra,0x1
    80002cc0:	9cc080e7          	jalr	-1588(ra) # 80003688 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80002cc4:	00000493          	li	s1,0
    80002cc8:	f99ff06f          	j	80002c60 <_ZL11workerBodyAPv+0x2c>
    printString("A finished!\n");
    80002ccc:	00007517          	auipc	a0,0x7
    80002cd0:	43c50513          	addi	a0,a0,1084 # 8000a108 <CONSOLE_STATUS+0xf8>
    80002cd4:	00001097          	auipc	ra,0x1
    80002cd8:	9b4080e7          	jalr	-1612(ra) # 80003688 <_Z11printStringPKc>
    finishedA = true;
    80002cdc:	00100793          	li	a5,1
    80002ce0:	0000a717          	auipc	a4,0xa
    80002ce4:	1ef70da3          	sb	a5,507(a4) # 8000cedb <_ZL9finishedA>
}
    80002ce8:	01813083          	ld	ra,24(sp)
    80002cec:	01013403          	ld	s0,16(sp)
    80002cf0:	00813483          	ld	s1,8(sp)
    80002cf4:	00013903          	ld	s2,0(sp)
    80002cf8:	02010113          	addi	sp,sp,32
    80002cfc:	00008067          	ret

0000000080002d00 <_Z18Threads_C_API_testv>:


void Threads_C_API_test() {
    80002d00:	fd010113          	addi	sp,sp,-48
    80002d04:	02113423          	sd	ra,40(sp)
    80002d08:	02813023          	sd	s0,32(sp)
    80002d0c:	03010413          	addi	s0,sp,48
    thread_t threads[4];
    thread_create(&threads[0], workerBodyA, nullptr);
    80002d10:	00000613          	li	a2,0
    80002d14:	00000597          	auipc	a1,0x0
    80002d18:	f2058593          	addi	a1,a1,-224 # 80002c34 <_ZL11workerBodyAPv>
    80002d1c:	fd040513          	addi	a0,s0,-48
    80002d20:	00002097          	auipc	ra,0x2
    80002d24:	c70080e7          	jalr	-912(ra) # 80004990 <thread_create>
    printString("ThreadA created\n");
    80002d28:	00007517          	auipc	a0,0x7
    80002d2c:	47050513          	addi	a0,a0,1136 # 8000a198 <CONSOLE_STATUS+0x188>
    80002d30:	00001097          	auipc	ra,0x1
    80002d34:	958080e7          	jalr	-1704(ra) # 80003688 <_Z11printStringPKc>

    thread_create(&threads[1], workerBodyB, nullptr);
    80002d38:	00000613          	li	a2,0
    80002d3c:	00000597          	auipc	a1,0x0
    80002d40:	e2458593          	addi	a1,a1,-476 # 80002b60 <_ZL11workerBodyBPv>
    80002d44:	fd840513          	addi	a0,s0,-40
    80002d48:	00002097          	auipc	ra,0x2
    80002d4c:	c48080e7          	jalr	-952(ra) # 80004990 <thread_create>
    printString("ThreadB created\n");
    80002d50:	00007517          	auipc	a0,0x7
    80002d54:	46050513          	addi	a0,a0,1120 # 8000a1b0 <CONSOLE_STATUS+0x1a0>
    80002d58:	00001097          	auipc	ra,0x1
    80002d5c:	930080e7          	jalr	-1744(ra) # 80003688 <_Z11printStringPKc>

    thread_create(&threads[2], workerBodyC, nullptr);
    80002d60:	00000613          	li	a2,0
    80002d64:	00000597          	auipc	a1,0x0
    80002d68:	c7c58593          	addi	a1,a1,-900 # 800029e0 <_ZL11workerBodyCPv>
    80002d6c:	fe040513          	addi	a0,s0,-32
    80002d70:	00002097          	auipc	ra,0x2
    80002d74:	c20080e7          	jalr	-992(ra) # 80004990 <thread_create>
    printString("ThreadC created\n");
    80002d78:	00007517          	auipc	a0,0x7
    80002d7c:	45050513          	addi	a0,a0,1104 # 8000a1c8 <CONSOLE_STATUS+0x1b8>
    80002d80:	00001097          	auipc	ra,0x1
    80002d84:	908080e7          	jalr	-1784(ra) # 80003688 <_Z11printStringPKc>

    thread_create(&threads[3], workerBodyD, nullptr);
    80002d88:	00000613          	li	a2,0
    80002d8c:	00000597          	auipc	a1,0x0
    80002d90:	b0c58593          	addi	a1,a1,-1268 # 80002898 <_ZL11workerBodyDPv>
    80002d94:	fe840513          	addi	a0,s0,-24
    80002d98:	00002097          	auipc	ra,0x2
    80002d9c:	bf8080e7          	jalr	-1032(ra) # 80004990 <thread_create>
    printString("ThreadD created\n");
    80002da0:	00007517          	auipc	a0,0x7
    80002da4:	44050513          	addi	a0,a0,1088 # 8000a1e0 <CONSOLE_STATUS+0x1d0>
    80002da8:	00001097          	auipc	ra,0x1
    80002dac:	8e0080e7          	jalr	-1824(ra) # 80003688 <_Z11printStringPKc>
    80002db0:	00c0006f          	j	80002dbc <_Z18Threads_C_API_testv+0xbc>

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        thread_dispatch();
    80002db4:	00002097          	auipc	ra,0x2
    80002db8:	c98080e7          	jalr	-872(ra) # 80004a4c <thread_dispatch>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    80002dbc:	0000a797          	auipc	a5,0xa
    80002dc0:	11f7c783          	lbu	a5,287(a5) # 8000cedb <_ZL9finishedA>
    80002dc4:	fe0788e3          	beqz	a5,80002db4 <_Z18Threads_C_API_testv+0xb4>
    80002dc8:	0000a797          	auipc	a5,0xa
    80002dcc:	1127c783          	lbu	a5,274(a5) # 8000ceda <_ZL9finishedB>
    80002dd0:	fe0782e3          	beqz	a5,80002db4 <_Z18Threads_C_API_testv+0xb4>
    80002dd4:	0000a797          	auipc	a5,0xa
    80002dd8:	1057c783          	lbu	a5,261(a5) # 8000ced9 <_ZL9finishedC>
    80002ddc:	fc078ce3          	beqz	a5,80002db4 <_Z18Threads_C_API_testv+0xb4>
    80002de0:	0000a797          	auipc	a5,0xa
    80002de4:	0f87c783          	lbu	a5,248(a5) # 8000ced8 <_ZL9finishedD>
    80002de8:	fc0786e3          	beqz	a5,80002db4 <_Z18Threads_C_API_testv+0xb4>
    }

}
    80002dec:	02813083          	ld	ra,40(sp)
    80002df0:	02013403          	ld	s0,32(sp)
    80002df4:	03010113          	addi	sp,sp,48
    80002df8:	00008067          	ret

0000000080002dfc <_ZN16ProducerKeyboard16producerKeyboardEPv>:
    void run() override {
        producerKeyboard(td);
    }
};

void ProducerKeyboard::producerKeyboard(void *arg) {
    80002dfc:	fd010113          	addi	sp,sp,-48
    80002e00:	02113423          	sd	ra,40(sp)
    80002e04:	02813023          	sd	s0,32(sp)
    80002e08:	00913c23          	sd	s1,24(sp)
    80002e0c:	01213823          	sd	s2,16(sp)
    80002e10:	01313423          	sd	s3,8(sp)
    80002e14:	03010413          	addi	s0,sp,48
    80002e18:	00050993          	mv	s3,a0
    80002e1c:	00058493          	mv	s1,a1
    struct thread_data *data = (struct thread_data *) arg;

    int key;
    int i = 0;
    80002e20:	00000913          	li	s2,0
    80002e24:	00c0006f          	j	80002e30 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x34>
    while ((key = getc()) != 0x1b) {
        data->buffer->put(key);
        i++;

        if (i % (10 * data->id) == 0) {
            Thread::dispatch();
    80002e28:	00004097          	auipc	ra,0x4
    80002e2c:	c6c080e7          	jalr	-916(ra) # 80006a94 <_ZN6Thread8dispatchEv>
    while ((key = getc()) != 0x1b) {
    80002e30:	00002097          	auipc	ra,0x2
    80002e34:	e34080e7          	jalr	-460(ra) # 80004c64 <getc>
    80002e38:	0005059b          	sext.w	a1,a0
    80002e3c:	01b00793          	li	a5,27
    80002e40:	02f58a63          	beq	a1,a5,80002e74 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x78>
        data->buffer->put(key);
    80002e44:	0084b503          	ld	a0,8(s1)
    80002e48:	00001097          	auipc	ra,0x1
    80002e4c:	c64080e7          	jalr	-924(ra) # 80003aac <_ZN9BufferCPP3putEi>
        i++;
    80002e50:	0019071b          	addiw	a4,s2,1
    80002e54:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    80002e58:	0004a683          	lw	a3,0(s1)
    80002e5c:	0026979b          	slliw	a5,a3,0x2
    80002e60:	00d787bb          	addw	a5,a5,a3
    80002e64:	0017979b          	slliw	a5,a5,0x1
    80002e68:	02f767bb          	remw	a5,a4,a5
    80002e6c:	fc0792e3          	bnez	a5,80002e30 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x34>
    80002e70:	fb9ff06f          	j	80002e28 <_ZN16ProducerKeyboard16producerKeyboardEPv+0x2c>
        }
    }

    threadEnd = 1;
    80002e74:	00100793          	li	a5,1
    80002e78:	0000a717          	auipc	a4,0xa
    80002e7c:	06f72423          	sw	a5,104(a4) # 8000cee0 <_ZL9threadEnd>
    td->buffer->put('!');
    80002e80:	0209b783          	ld	a5,32(s3)
    80002e84:	02100593          	li	a1,33
    80002e88:	0087b503          	ld	a0,8(a5)
    80002e8c:	00001097          	auipc	ra,0x1
    80002e90:	c20080e7          	jalr	-992(ra) # 80003aac <_ZN9BufferCPP3putEi>

    data->wait->signal();
    80002e94:	0104b503          	ld	a0,16(s1)
    80002e98:	00004097          	auipc	ra,0x4
    80002e9c:	ce4080e7          	jalr	-796(ra) # 80006b7c <_ZN9Semaphore6signalEv>
}
    80002ea0:	02813083          	ld	ra,40(sp)
    80002ea4:	02013403          	ld	s0,32(sp)
    80002ea8:	01813483          	ld	s1,24(sp)
    80002eac:	01013903          	ld	s2,16(sp)
    80002eb0:	00813983          	ld	s3,8(sp)
    80002eb4:	03010113          	addi	sp,sp,48
    80002eb8:	00008067          	ret

0000000080002ebc <_ZN12ProducerSync8producerEPv>:
    void run() override {
        producer(td);
    }
};

void ProducerSync::producer(void *arg) {
    80002ebc:	fe010113          	addi	sp,sp,-32
    80002ec0:	00113c23          	sd	ra,24(sp)
    80002ec4:	00813823          	sd	s0,16(sp)
    80002ec8:	00913423          	sd	s1,8(sp)
    80002ecc:	01213023          	sd	s2,0(sp)
    80002ed0:	02010413          	addi	s0,sp,32
    80002ed4:	00058493          	mv	s1,a1
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    80002ed8:	00000913          	li	s2,0
    80002edc:	00c0006f          	j	80002ee8 <_ZN12ProducerSync8producerEPv+0x2c>
    while (!threadEnd) {
        data->buffer->put(data->id + '0');
        i++;

        if (i % (10 * data->id) == 0) {
            Thread::dispatch();
    80002ee0:	00004097          	auipc	ra,0x4
    80002ee4:	bb4080e7          	jalr	-1100(ra) # 80006a94 <_ZN6Thread8dispatchEv>
    while (!threadEnd) {
    80002ee8:	0000a797          	auipc	a5,0xa
    80002eec:	ff87a783          	lw	a5,-8(a5) # 8000cee0 <_ZL9threadEnd>
    80002ef0:	02079e63          	bnez	a5,80002f2c <_ZN12ProducerSync8producerEPv+0x70>
        data->buffer->put(data->id + '0');
    80002ef4:	0004a583          	lw	a1,0(s1)
    80002ef8:	0305859b          	addiw	a1,a1,48
    80002efc:	0084b503          	ld	a0,8(s1)
    80002f00:	00001097          	auipc	ra,0x1
    80002f04:	bac080e7          	jalr	-1108(ra) # 80003aac <_ZN9BufferCPP3putEi>
        i++;
    80002f08:	0019071b          	addiw	a4,s2,1
    80002f0c:	0007091b          	sext.w	s2,a4
        if (i % (10 * data->id) == 0) {
    80002f10:	0004a683          	lw	a3,0(s1)
    80002f14:	0026979b          	slliw	a5,a3,0x2
    80002f18:	00d787bb          	addw	a5,a5,a3
    80002f1c:	0017979b          	slliw	a5,a5,0x1
    80002f20:	02f767bb          	remw	a5,a4,a5
    80002f24:	fc0792e3          	bnez	a5,80002ee8 <_ZN12ProducerSync8producerEPv+0x2c>
    80002f28:	fb9ff06f          	j	80002ee0 <_ZN12ProducerSync8producerEPv+0x24>
        }
    }

    data->wait->signal();
    80002f2c:	0104b503          	ld	a0,16(s1)
    80002f30:	00004097          	auipc	ra,0x4
    80002f34:	c4c080e7          	jalr	-948(ra) # 80006b7c <_ZN9Semaphore6signalEv>
}
    80002f38:	01813083          	ld	ra,24(sp)
    80002f3c:	01013403          	ld	s0,16(sp)
    80002f40:	00813483          	ld	s1,8(sp)
    80002f44:	00013903          	ld	s2,0(sp)
    80002f48:	02010113          	addi	sp,sp,32
    80002f4c:	00008067          	ret

0000000080002f50 <_ZN12ConsumerSync8consumerEPv>:
    void run() override {
        consumer(td);
    }
};

void ConsumerSync::consumer(void *arg) {
    80002f50:	fd010113          	addi	sp,sp,-48
    80002f54:	02113423          	sd	ra,40(sp)
    80002f58:	02813023          	sd	s0,32(sp)
    80002f5c:	00913c23          	sd	s1,24(sp)
    80002f60:	01213823          	sd	s2,16(sp)
    80002f64:	01313423          	sd	s3,8(sp)
    80002f68:	01413023          	sd	s4,0(sp)
    80002f6c:	03010413          	addi	s0,sp,48
    80002f70:	00050993          	mv	s3,a0
    80002f74:	00058913          	mv	s2,a1
    struct thread_data *data = (struct thread_data *) arg;

    int i = 0;
    80002f78:	00000a13          	li	s4,0
    80002f7c:	01c0006f          	j	80002f98 <_ZN12ConsumerSync8consumerEPv+0x48>
        i++;

        putc(key);

        if (i % (5 * data->id) == 0) {
            Thread::dispatch();
    80002f80:	00004097          	auipc	ra,0x4
    80002f84:	b14080e7          	jalr	-1260(ra) # 80006a94 <_ZN6Thread8dispatchEv>
    80002f88:	0500006f          	j	80002fd8 <_ZN12ConsumerSync8consumerEPv+0x88>
        }

        if (i % 80 == 0) {
            putc('\n');
    80002f8c:	00a00513          	li	a0,10
    80002f90:	00002097          	auipc	ra,0x2
    80002f94:	d14080e7          	jalr	-748(ra) # 80004ca4 <putc>
    while (!threadEnd) {
    80002f98:	0000a797          	auipc	a5,0xa
    80002f9c:	f487a783          	lw	a5,-184(a5) # 8000cee0 <_ZL9threadEnd>
    80002fa0:	06079263          	bnez	a5,80003004 <_ZN12ConsumerSync8consumerEPv+0xb4>
        int key = data->buffer->get();
    80002fa4:	00893503          	ld	a0,8(s2)
    80002fa8:	00001097          	auipc	ra,0x1
    80002fac:	b94080e7          	jalr	-1132(ra) # 80003b3c <_ZN9BufferCPP3getEv>
        i++;
    80002fb0:	001a049b          	addiw	s1,s4,1
    80002fb4:	00048a1b          	sext.w	s4,s1
        putc(key);
    80002fb8:	0ff57513          	andi	a0,a0,255
    80002fbc:	00002097          	auipc	ra,0x2
    80002fc0:	ce8080e7          	jalr	-792(ra) # 80004ca4 <putc>
        if (i % (5 * data->id) == 0) {
    80002fc4:	00092703          	lw	a4,0(s2)
    80002fc8:	0027179b          	slliw	a5,a4,0x2
    80002fcc:	00e787bb          	addw	a5,a5,a4
    80002fd0:	02f4e7bb          	remw	a5,s1,a5
    80002fd4:	fa0786e3          	beqz	a5,80002f80 <_ZN12ConsumerSync8consumerEPv+0x30>
        if (i % 80 == 0) {
    80002fd8:	05000793          	li	a5,80
    80002fdc:	02f4e4bb          	remw	s1,s1,a5
    80002fe0:	fa049ce3          	bnez	s1,80002f98 <_ZN12ConsumerSync8consumerEPv+0x48>
    80002fe4:	fa9ff06f          	j	80002f8c <_ZN12ConsumerSync8consumerEPv+0x3c>
        }
    }


    while (td->buffer->getCnt() > 0) {
        int key = td->buffer->get();
    80002fe8:	0209b783          	ld	a5,32(s3)
    80002fec:	0087b503          	ld	a0,8(a5)
    80002ff0:	00001097          	auipc	ra,0x1
    80002ff4:	b4c080e7          	jalr	-1204(ra) # 80003b3c <_ZN9BufferCPP3getEv>
        Console::putc(key);
    80002ff8:	0ff57513          	andi	a0,a0,255
    80002ffc:	00004097          	auipc	ra,0x4
    80003000:	c7c080e7          	jalr	-900(ra) # 80006c78 <_ZN7Console4putcEc>
    while (td->buffer->getCnt() > 0) {
    80003004:	0209b783          	ld	a5,32(s3)
    80003008:	0087b503          	ld	a0,8(a5)
    8000300c:	00001097          	auipc	ra,0x1
    80003010:	bbc080e7          	jalr	-1092(ra) # 80003bc8 <_ZN9BufferCPP6getCntEv>
    80003014:	fca04ae3          	bgtz	a0,80002fe8 <_ZN12ConsumerSync8consumerEPv+0x98>
    }

    data->wait->signal();
    80003018:	01093503          	ld	a0,16(s2)
    8000301c:	00004097          	auipc	ra,0x4
    80003020:	b60080e7          	jalr	-1184(ra) # 80006b7c <_ZN9Semaphore6signalEv>
}
    80003024:	02813083          	ld	ra,40(sp)
    80003028:	02013403          	ld	s0,32(sp)
    8000302c:	01813483          	ld	s1,24(sp)
    80003030:	01013903          	ld	s2,16(sp)
    80003034:	00813983          	ld	s3,8(sp)
    80003038:	00013a03          	ld	s4,0(sp)
    8000303c:	03010113          	addi	sp,sp,48
    80003040:	00008067          	ret

0000000080003044 <_Z29producerConsumer_CPP_Sync_APIv>:

void producerConsumer_CPP_Sync_API() {
    80003044:	f8010113          	addi	sp,sp,-128
    80003048:	06113c23          	sd	ra,120(sp)
    8000304c:	06813823          	sd	s0,112(sp)
    80003050:	06913423          	sd	s1,104(sp)
    80003054:	07213023          	sd	s2,96(sp)
    80003058:	05313c23          	sd	s3,88(sp)
    8000305c:	05413823          	sd	s4,80(sp)
    80003060:	05513423          	sd	s5,72(sp)
    80003064:	05613023          	sd	s6,64(sp)
    80003068:	03713c23          	sd	s7,56(sp)
    8000306c:	03813823          	sd	s8,48(sp)
    80003070:	03913423          	sd	s9,40(sp)
    80003074:	08010413          	addi	s0,sp,128
    for (int i = 0; i < threadNum; i++) {
        delete threads[i];
    }
    delete consumerThread;
    delete waitForAll;
    delete buffer;
    80003078:	00010b93          	mv	s7,sp
    printString("Unesite broj proizvodjaca?\n");
    8000307c:	00007517          	auipc	a0,0x7
    80003080:	fa450513          	addi	a0,a0,-92 # 8000a020 <CONSOLE_STATUS+0x10>
    80003084:	00000097          	auipc	ra,0x0
    80003088:	604080e7          	jalr	1540(ra) # 80003688 <_Z11printStringPKc>
    getString(input, 30);
    8000308c:	01e00593          	li	a1,30
    80003090:	f8040493          	addi	s1,s0,-128
    80003094:	00048513          	mv	a0,s1
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	678080e7          	jalr	1656(ra) # 80003710 <_Z9getStringPci>
    threadNum = stringToInt(input);
    800030a0:	00048513          	mv	a0,s1
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	744080e7          	jalr	1860(ra) # 800037e8 <_Z11stringToIntPKc>
    800030ac:	00050913          	mv	s2,a0
    printString("Unesite velicinu bafera?\n");
    800030b0:	00007517          	auipc	a0,0x7
    800030b4:	f9050513          	addi	a0,a0,-112 # 8000a040 <CONSOLE_STATUS+0x30>
    800030b8:	00000097          	auipc	ra,0x0
    800030bc:	5d0080e7          	jalr	1488(ra) # 80003688 <_Z11printStringPKc>
    getString(input, 30);
    800030c0:	01e00593          	li	a1,30
    800030c4:	00048513          	mv	a0,s1
    800030c8:	00000097          	auipc	ra,0x0
    800030cc:	648080e7          	jalr	1608(ra) # 80003710 <_Z9getStringPci>
    n = stringToInt(input);
    800030d0:	00048513          	mv	a0,s1
    800030d4:	00000097          	auipc	ra,0x0
    800030d8:	714080e7          	jalr	1812(ra) # 800037e8 <_Z11stringToIntPKc>
    800030dc:	00050493          	mv	s1,a0
    printString("Broj proizvodjaca "); printInt(threadNum);
    800030e0:	00007517          	auipc	a0,0x7
    800030e4:	f8050513          	addi	a0,a0,-128 # 8000a060 <CONSOLE_STATUS+0x50>
    800030e8:	00000097          	auipc	ra,0x0
    800030ec:	5a0080e7          	jalr	1440(ra) # 80003688 <_Z11printStringPKc>
    800030f0:	00000613          	li	a2,0
    800030f4:	00a00593          	li	a1,10
    800030f8:	00090513          	mv	a0,s2
    800030fc:	00000097          	auipc	ra,0x0
    80003100:	73c080e7          	jalr	1852(ra) # 80003838 <_Z8printIntiii>
    printString(" i velicina bafera "); printInt(n);
    80003104:	00007517          	auipc	a0,0x7
    80003108:	f7450513          	addi	a0,a0,-140 # 8000a078 <CONSOLE_STATUS+0x68>
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	57c080e7          	jalr	1404(ra) # 80003688 <_Z11printStringPKc>
    80003114:	00000613          	li	a2,0
    80003118:	00a00593          	li	a1,10
    8000311c:	00048513          	mv	a0,s1
    80003120:	00000097          	auipc	ra,0x0
    80003124:	718080e7          	jalr	1816(ra) # 80003838 <_Z8printIntiii>
    printString(".\n");
    80003128:	00007517          	auipc	a0,0x7
    8000312c:	58850513          	addi	a0,a0,1416 # 8000a6b0 <CONSOLE_STATUS+0x6a0>
    80003130:	00000097          	auipc	ra,0x0
    80003134:	558080e7          	jalr	1368(ra) # 80003688 <_Z11printStringPKc>
    if(threadNum > n) {
    80003138:	0324c463          	blt	s1,s2,80003160 <_Z29producerConsumer_CPP_Sync_APIv+0x11c>
    } else if (threadNum < 1) {
    8000313c:	03205c63          	blez	s2,80003174 <_Z29producerConsumer_CPP_Sync_APIv+0x130>
    BufferCPP *buffer = new BufferCPP(n);
    80003140:	03800513          	li	a0,56
    80003144:	00004097          	auipc	ra,0x4
    80003148:	814080e7          	jalr	-2028(ra) # 80006958 <_Znwm>
    8000314c:	00050a93          	mv	s5,a0
    80003150:	00048593          	mv	a1,s1
    80003154:	00001097          	auipc	ra,0x1
    80003158:	804080e7          	jalr	-2044(ra) # 80003958 <_ZN9BufferCPPC1Ei>
    8000315c:	0300006f          	j	8000318c <_Z29producerConsumer_CPP_Sync_APIv+0x148>
        printString("Broj proizvodjaca ne sme biti manji od velicine bafera!\n");
    80003160:	00007517          	auipc	a0,0x7
    80003164:	f3050513          	addi	a0,a0,-208 # 8000a090 <CONSOLE_STATUS+0x80>
    80003168:	00000097          	auipc	ra,0x0
    8000316c:	520080e7          	jalr	1312(ra) # 80003688 <_Z11printStringPKc>
        return;
    80003170:	0140006f          	j	80003184 <_Z29producerConsumer_CPP_Sync_APIv+0x140>
        printString("Broj proizvodjaca mora biti veci od nula!\n");
    80003174:	00007517          	auipc	a0,0x7
    80003178:	f5c50513          	addi	a0,a0,-164 # 8000a0d0 <CONSOLE_STATUS+0xc0>
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	50c080e7          	jalr	1292(ra) # 80003688 <_Z11printStringPKc>
        return;
    80003184:	000b8113          	mv	sp,s7
    80003188:	2380006f          	j	800033c0 <_Z29producerConsumer_CPP_Sync_APIv+0x37c>
    waitForAll = new Semaphore(0);
    8000318c:	01000513          	li	a0,16
    80003190:	00003097          	auipc	ra,0x3
    80003194:	7c8080e7          	jalr	1992(ra) # 80006958 <_Znwm>
    80003198:	00050493          	mv	s1,a0
    8000319c:	00000593          	li	a1,0
    800031a0:	00004097          	auipc	ra,0x4
    800031a4:	974080e7          	jalr	-1676(ra) # 80006b14 <_ZN9SemaphoreC1Ej>
    800031a8:	0000a797          	auipc	a5,0xa
    800031ac:	d497b023          	sd	s1,-704(a5) # 8000cee8 <_ZL10waitForAll>
    Thread* threads[threadNum];
    800031b0:	00391793          	slli	a5,s2,0x3
    800031b4:	00f78793          	addi	a5,a5,15
    800031b8:	ff07f793          	andi	a5,a5,-16
    800031bc:	40f10133          	sub	sp,sp,a5
    800031c0:	00010993          	mv	s3,sp
    struct thread_data data[threadNum + 1];
    800031c4:	0019071b          	addiw	a4,s2,1
    800031c8:	00171793          	slli	a5,a4,0x1
    800031cc:	00e787b3          	add	a5,a5,a4
    800031d0:	00379793          	slli	a5,a5,0x3
    800031d4:	00f78793          	addi	a5,a5,15
    800031d8:	ff07f793          	andi	a5,a5,-16
    800031dc:	40f10133          	sub	sp,sp,a5
    800031e0:	00010a13          	mv	s4,sp
    data[threadNum].id = threadNum;
    800031e4:	00191c13          	slli	s8,s2,0x1
    800031e8:	012c07b3          	add	a5,s8,s2
    800031ec:	00379793          	slli	a5,a5,0x3
    800031f0:	00fa07b3          	add	a5,s4,a5
    800031f4:	0127a023          	sw	s2,0(a5)
    data[threadNum].buffer = buffer;
    800031f8:	0157b423          	sd	s5,8(a5)
    data[threadNum].wait = waitForAll;
    800031fc:	0097b823          	sd	s1,16(a5)
    consumerThread = new ConsumerSync(data+threadNum);
    80003200:	02800513          	li	a0,40
    80003204:	00003097          	auipc	ra,0x3
    80003208:	754080e7          	jalr	1876(ra) # 80006958 <_Znwm>
    8000320c:	00050b13          	mv	s6,a0
    80003210:	012c0c33          	add	s8,s8,s2
    80003214:	003c1c13          	slli	s8,s8,0x3
    80003218:	018a0c33          	add	s8,s4,s8
    ConsumerSync(thread_data* _td):Thread(), td(_td) {}
    8000321c:	00004097          	auipc	ra,0x4
    80003220:	8c8080e7          	jalr	-1848(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    80003224:	0000a797          	auipc	a5,0xa
    80003228:	adc78793          	addi	a5,a5,-1316 # 8000cd00 <_ZTV12ConsumerSync+0x10>
    8000322c:	00fb3023          	sd	a5,0(s6)
    80003230:	038b3023          	sd	s8,32(s6)
    consumerThread->start();
    80003234:	000b0513          	mv	a0,s6
    80003238:	00004097          	auipc	ra,0x4
    8000323c:	808080e7          	jalr	-2040(ra) # 80006a40 <_ZN6Thread5startEv>
    for (int i = 0; i < threadNum; i++) {
    80003240:	00000493          	li	s1,0
    80003244:	0380006f          	j	8000327c <_Z29producerConsumer_CPP_Sync_APIv+0x238>
    ProducerSync(thread_data* _td):Thread(), td(_td) {}
    80003248:	0000a797          	auipc	a5,0xa
    8000324c:	a9078793          	addi	a5,a5,-1392 # 8000ccd8 <_ZTV12ProducerSync+0x10>
    80003250:	00fcb023          	sd	a5,0(s9)
    80003254:	038cb023          	sd	s8,32(s9)
            threads[i] = new ProducerSync(data+i);
    80003258:	00349793          	slli	a5,s1,0x3
    8000325c:	00f987b3          	add	a5,s3,a5
    80003260:	0197b023          	sd	s9,0(a5)
        threads[i]->start();
    80003264:	00349793          	slli	a5,s1,0x3
    80003268:	00f987b3          	add	a5,s3,a5
    8000326c:	0007b503          	ld	a0,0(a5)
    80003270:	00003097          	auipc	ra,0x3
    80003274:	7d0080e7          	jalr	2000(ra) # 80006a40 <_ZN6Thread5startEv>
    for (int i = 0; i < threadNum; i++) {
    80003278:	0014849b          	addiw	s1,s1,1
    8000327c:	0b24d063          	bge	s1,s2,8000331c <_Z29producerConsumer_CPP_Sync_APIv+0x2d8>
        data[i].id = i;
    80003280:	00149793          	slli	a5,s1,0x1
    80003284:	009787b3          	add	a5,a5,s1
    80003288:	00379793          	slli	a5,a5,0x3
    8000328c:	00fa07b3          	add	a5,s4,a5
    80003290:	0097a023          	sw	s1,0(a5)
        data[i].buffer = buffer;
    80003294:	0157b423          	sd	s5,8(a5)
        data[i].wait = waitForAll;
    80003298:	0000a717          	auipc	a4,0xa
    8000329c:	c5073703          	ld	a4,-944(a4) # 8000cee8 <_ZL10waitForAll>
    800032a0:	00e7b823          	sd	a4,16(a5)
        if(i>0) {
    800032a4:	02905863          	blez	s1,800032d4 <_Z29producerConsumer_CPP_Sync_APIv+0x290>
            threads[i] = new ProducerSync(data+i);
    800032a8:	02800513          	li	a0,40
    800032ac:	00003097          	auipc	ra,0x3
    800032b0:	6ac080e7          	jalr	1708(ra) # 80006958 <_Znwm>
    800032b4:	00050c93          	mv	s9,a0
    800032b8:	00149c13          	slli	s8,s1,0x1
    800032bc:	009c0c33          	add	s8,s8,s1
    800032c0:	003c1c13          	slli	s8,s8,0x3
    800032c4:	018a0c33          	add	s8,s4,s8
    ProducerSync(thread_data* _td):Thread(), td(_td) {}
    800032c8:	00004097          	auipc	ra,0x4
    800032cc:	81c080e7          	jalr	-2020(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    800032d0:	f79ff06f          	j	80003248 <_Z29producerConsumer_CPP_Sync_APIv+0x204>
            threads[i] = new ProducerKeyboard(data+i);
    800032d4:	02800513          	li	a0,40
    800032d8:	00003097          	auipc	ra,0x3
    800032dc:	680080e7          	jalr	1664(ra) # 80006958 <_Znwm>
    800032e0:	00050c93          	mv	s9,a0
    800032e4:	00149c13          	slli	s8,s1,0x1
    800032e8:	009c0c33          	add	s8,s8,s1
    800032ec:	003c1c13          	slli	s8,s8,0x3
    800032f0:	018a0c33          	add	s8,s4,s8
    ProducerKeyboard(thread_data* _td):Thread(), td(_td) {}
    800032f4:	00003097          	auipc	ra,0x3
    800032f8:	7f0080e7          	jalr	2032(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    800032fc:	0000a797          	auipc	a5,0xa
    80003300:	9b478793          	addi	a5,a5,-1612 # 8000ccb0 <_ZTV16ProducerKeyboard+0x10>
    80003304:	00fcb023          	sd	a5,0(s9)
    80003308:	038cb023          	sd	s8,32(s9)
            threads[i] = new ProducerKeyboard(data+i);
    8000330c:	00349793          	slli	a5,s1,0x3
    80003310:	00f987b3          	add	a5,s3,a5
    80003314:	0197b023          	sd	s9,0(a5)
    80003318:	f4dff06f          	j	80003264 <_Z29producerConsumer_CPP_Sync_APIv+0x220>
    Thread::dispatch();
    8000331c:	00003097          	auipc	ra,0x3
    80003320:	778080e7          	jalr	1912(ra) # 80006a94 <_ZN6Thread8dispatchEv>
    for (int i = 0; i <= threadNum; i++) {
    80003324:	00000493          	li	s1,0
    80003328:	00994e63          	blt	s2,s1,80003344 <_Z29producerConsumer_CPP_Sync_APIv+0x300>
        waitForAll->wait();
    8000332c:	0000a517          	auipc	a0,0xa
    80003330:	bbc53503          	ld	a0,-1092(a0) # 8000cee8 <_ZL10waitForAll>
    80003334:	00004097          	auipc	ra,0x4
    80003338:	81c080e7          	jalr	-2020(ra) # 80006b50 <_ZN9Semaphore4waitEv>
    for (int i = 0; i <= threadNum; i++) {
    8000333c:	0014849b          	addiw	s1,s1,1
    80003340:	fe9ff06f          	j	80003328 <_Z29producerConsumer_CPP_Sync_APIv+0x2e4>
    for (int i = 0; i < threadNum; i++) {
    80003344:	00000493          	li	s1,0
    80003348:	0080006f          	j	80003350 <_Z29producerConsumer_CPP_Sync_APIv+0x30c>
    8000334c:	0014849b          	addiw	s1,s1,1
    80003350:	0324d263          	bge	s1,s2,80003374 <_Z29producerConsumer_CPP_Sync_APIv+0x330>
        delete threads[i];
    80003354:	00349793          	slli	a5,s1,0x3
    80003358:	00f987b3          	add	a5,s3,a5
    8000335c:	0007b503          	ld	a0,0(a5)
    80003360:	fe0506e3          	beqz	a0,8000334c <_Z29producerConsumer_CPP_Sync_APIv+0x308>
    80003364:	00053783          	ld	a5,0(a0)
    80003368:	0087b783          	ld	a5,8(a5)
    8000336c:	000780e7          	jalr	a5
    80003370:	fddff06f          	j	8000334c <_Z29producerConsumer_CPP_Sync_APIv+0x308>
    delete consumerThread;
    80003374:	000b0a63          	beqz	s6,80003388 <_Z29producerConsumer_CPP_Sync_APIv+0x344>
    80003378:	000b3783          	ld	a5,0(s6)
    8000337c:	0087b783          	ld	a5,8(a5)
    80003380:	000b0513          	mv	a0,s6
    80003384:	000780e7          	jalr	a5
    delete waitForAll;
    80003388:	0000a517          	auipc	a0,0xa
    8000338c:	b6053503          	ld	a0,-1184(a0) # 8000cee8 <_ZL10waitForAll>
    80003390:	00050863          	beqz	a0,800033a0 <_Z29producerConsumer_CPP_Sync_APIv+0x35c>
    80003394:	00053783          	ld	a5,0(a0)
    80003398:	0087b783          	ld	a5,8(a5)
    8000339c:	000780e7          	jalr	a5
    delete buffer;
    800033a0:	000a8e63          	beqz	s5,800033bc <_Z29producerConsumer_CPP_Sync_APIv+0x378>
    800033a4:	000a8513          	mv	a0,s5
    800033a8:	00001097          	auipc	ra,0x1
    800033ac:	8a8080e7          	jalr	-1880(ra) # 80003c50 <_ZN9BufferCPPD1Ev>
    800033b0:	000a8513          	mv	a0,s5
    800033b4:	00003097          	auipc	ra,0x3
    800033b8:	5cc080e7          	jalr	1484(ra) # 80006980 <_ZdlPv>
    800033bc:	000b8113          	mv	sp,s7

}
    800033c0:	f8040113          	addi	sp,s0,-128
    800033c4:	07813083          	ld	ra,120(sp)
    800033c8:	07013403          	ld	s0,112(sp)
    800033cc:	06813483          	ld	s1,104(sp)
    800033d0:	06013903          	ld	s2,96(sp)
    800033d4:	05813983          	ld	s3,88(sp)
    800033d8:	05013a03          	ld	s4,80(sp)
    800033dc:	04813a83          	ld	s5,72(sp)
    800033e0:	04013b03          	ld	s6,64(sp)
    800033e4:	03813b83          	ld	s7,56(sp)
    800033e8:	03013c03          	ld	s8,48(sp)
    800033ec:	02813c83          	ld	s9,40(sp)
    800033f0:	08010113          	addi	sp,sp,128
    800033f4:	00008067          	ret
    800033f8:	00050493          	mv	s1,a0
    BufferCPP *buffer = new BufferCPP(n);
    800033fc:	000a8513          	mv	a0,s5
    80003400:	00003097          	auipc	ra,0x3
    80003404:	580080e7          	jalr	1408(ra) # 80006980 <_ZdlPv>
    80003408:	00048513          	mv	a0,s1
    8000340c:	0000b097          	auipc	ra,0xb
    80003410:	c3c080e7          	jalr	-964(ra) # 8000e048 <_Unwind_Resume>
    80003414:	00050913          	mv	s2,a0
    waitForAll = new Semaphore(0);
    80003418:	00048513          	mv	a0,s1
    8000341c:	00003097          	auipc	ra,0x3
    80003420:	564080e7          	jalr	1380(ra) # 80006980 <_ZdlPv>
    80003424:	00090513          	mv	a0,s2
    80003428:	0000b097          	auipc	ra,0xb
    8000342c:	c20080e7          	jalr	-992(ra) # 8000e048 <_Unwind_Resume>
    80003430:	00050493          	mv	s1,a0
    consumerThread = new ConsumerSync(data+threadNum);
    80003434:	000b0513          	mv	a0,s6
    80003438:	00003097          	auipc	ra,0x3
    8000343c:	548080e7          	jalr	1352(ra) # 80006980 <_ZdlPv>
    80003440:	00048513          	mv	a0,s1
    80003444:	0000b097          	auipc	ra,0xb
    80003448:	c04080e7          	jalr	-1020(ra) # 8000e048 <_Unwind_Resume>
    8000344c:	00050493          	mv	s1,a0
            threads[i] = new ProducerSync(data+i);
    80003450:	000c8513          	mv	a0,s9
    80003454:	00003097          	auipc	ra,0x3
    80003458:	52c080e7          	jalr	1324(ra) # 80006980 <_ZdlPv>
    8000345c:	00048513          	mv	a0,s1
    80003460:	0000b097          	auipc	ra,0xb
    80003464:	be8080e7          	jalr	-1048(ra) # 8000e048 <_Unwind_Resume>
    80003468:	00050493          	mv	s1,a0
            threads[i] = new ProducerKeyboard(data+i);
    8000346c:	000c8513          	mv	a0,s9
    80003470:	00003097          	auipc	ra,0x3
    80003474:	510080e7          	jalr	1296(ra) # 80006980 <_ZdlPv>
    80003478:	00048513          	mv	a0,s1
    8000347c:	0000b097          	auipc	ra,0xb
    80003480:	bcc080e7          	jalr	-1076(ra) # 8000e048 <_Unwind_Resume>

0000000080003484 <_ZN12ConsumerSyncD1Ev>:
class ConsumerSync:public Thread {
    80003484:	ff010113          	addi	sp,sp,-16
    80003488:	00113423          	sd	ra,8(sp)
    8000348c:	00813023          	sd	s0,0(sp)
    80003490:	01010413          	addi	s0,sp,16
    80003494:	0000a797          	auipc	a5,0xa
    80003498:	86c78793          	addi	a5,a5,-1940 # 8000cd00 <_ZTV12ConsumerSync+0x10>
    8000349c:	00f53023          	sd	a5,0(a0)
    800034a0:	00003097          	auipc	ra,0x3
    800034a4:	43c080e7          	jalr	1084(ra) # 800068dc <_ZN6ThreadD1Ev>
    800034a8:	00813083          	ld	ra,8(sp)
    800034ac:	00013403          	ld	s0,0(sp)
    800034b0:	01010113          	addi	sp,sp,16
    800034b4:	00008067          	ret

00000000800034b8 <_ZN12ConsumerSyncD0Ev>:
    800034b8:	fe010113          	addi	sp,sp,-32
    800034bc:	00113c23          	sd	ra,24(sp)
    800034c0:	00813823          	sd	s0,16(sp)
    800034c4:	00913423          	sd	s1,8(sp)
    800034c8:	02010413          	addi	s0,sp,32
    800034cc:	00050493          	mv	s1,a0
    800034d0:	0000a797          	auipc	a5,0xa
    800034d4:	83078793          	addi	a5,a5,-2000 # 8000cd00 <_ZTV12ConsumerSync+0x10>
    800034d8:	00f53023          	sd	a5,0(a0)
    800034dc:	00003097          	auipc	ra,0x3
    800034e0:	400080e7          	jalr	1024(ra) # 800068dc <_ZN6ThreadD1Ev>
    800034e4:	00048513          	mv	a0,s1
    800034e8:	00003097          	auipc	ra,0x3
    800034ec:	498080e7          	jalr	1176(ra) # 80006980 <_ZdlPv>
    800034f0:	01813083          	ld	ra,24(sp)
    800034f4:	01013403          	ld	s0,16(sp)
    800034f8:	00813483          	ld	s1,8(sp)
    800034fc:	02010113          	addi	sp,sp,32
    80003500:	00008067          	ret

0000000080003504 <_ZN12ProducerSyncD1Ev>:
class ProducerSync:public Thread {
    80003504:	ff010113          	addi	sp,sp,-16
    80003508:	00113423          	sd	ra,8(sp)
    8000350c:	00813023          	sd	s0,0(sp)
    80003510:	01010413          	addi	s0,sp,16
    80003514:	00009797          	auipc	a5,0x9
    80003518:	7c478793          	addi	a5,a5,1988 # 8000ccd8 <_ZTV12ProducerSync+0x10>
    8000351c:	00f53023          	sd	a5,0(a0)
    80003520:	00003097          	auipc	ra,0x3
    80003524:	3bc080e7          	jalr	956(ra) # 800068dc <_ZN6ThreadD1Ev>
    80003528:	00813083          	ld	ra,8(sp)
    8000352c:	00013403          	ld	s0,0(sp)
    80003530:	01010113          	addi	sp,sp,16
    80003534:	00008067          	ret

0000000080003538 <_ZN12ProducerSyncD0Ev>:
    80003538:	fe010113          	addi	sp,sp,-32
    8000353c:	00113c23          	sd	ra,24(sp)
    80003540:	00813823          	sd	s0,16(sp)
    80003544:	00913423          	sd	s1,8(sp)
    80003548:	02010413          	addi	s0,sp,32
    8000354c:	00050493          	mv	s1,a0
    80003550:	00009797          	auipc	a5,0x9
    80003554:	78878793          	addi	a5,a5,1928 # 8000ccd8 <_ZTV12ProducerSync+0x10>
    80003558:	00f53023          	sd	a5,0(a0)
    8000355c:	00003097          	auipc	ra,0x3
    80003560:	380080e7          	jalr	896(ra) # 800068dc <_ZN6ThreadD1Ev>
    80003564:	00048513          	mv	a0,s1
    80003568:	00003097          	auipc	ra,0x3
    8000356c:	418080e7          	jalr	1048(ra) # 80006980 <_ZdlPv>
    80003570:	01813083          	ld	ra,24(sp)
    80003574:	01013403          	ld	s0,16(sp)
    80003578:	00813483          	ld	s1,8(sp)
    8000357c:	02010113          	addi	sp,sp,32
    80003580:	00008067          	ret

0000000080003584 <_ZN16ProducerKeyboardD1Ev>:
class ProducerKeyboard:public Thread {
    80003584:	ff010113          	addi	sp,sp,-16
    80003588:	00113423          	sd	ra,8(sp)
    8000358c:	00813023          	sd	s0,0(sp)
    80003590:	01010413          	addi	s0,sp,16
    80003594:	00009797          	auipc	a5,0x9
    80003598:	71c78793          	addi	a5,a5,1820 # 8000ccb0 <_ZTV16ProducerKeyboard+0x10>
    8000359c:	00f53023          	sd	a5,0(a0)
    800035a0:	00003097          	auipc	ra,0x3
    800035a4:	33c080e7          	jalr	828(ra) # 800068dc <_ZN6ThreadD1Ev>
    800035a8:	00813083          	ld	ra,8(sp)
    800035ac:	00013403          	ld	s0,0(sp)
    800035b0:	01010113          	addi	sp,sp,16
    800035b4:	00008067          	ret

00000000800035b8 <_ZN16ProducerKeyboardD0Ev>:
    800035b8:	fe010113          	addi	sp,sp,-32
    800035bc:	00113c23          	sd	ra,24(sp)
    800035c0:	00813823          	sd	s0,16(sp)
    800035c4:	00913423          	sd	s1,8(sp)
    800035c8:	02010413          	addi	s0,sp,32
    800035cc:	00050493          	mv	s1,a0
    800035d0:	00009797          	auipc	a5,0x9
    800035d4:	6e078793          	addi	a5,a5,1760 # 8000ccb0 <_ZTV16ProducerKeyboard+0x10>
    800035d8:	00f53023          	sd	a5,0(a0)
    800035dc:	00003097          	auipc	ra,0x3
    800035e0:	300080e7          	jalr	768(ra) # 800068dc <_ZN6ThreadD1Ev>
    800035e4:	00048513          	mv	a0,s1
    800035e8:	00003097          	auipc	ra,0x3
    800035ec:	398080e7          	jalr	920(ra) # 80006980 <_ZdlPv>
    800035f0:	01813083          	ld	ra,24(sp)
    800035f4:	01013403          	ld	s0,16(sp)
    800035f8:	00813483          	ld	s1,8(sp)
    800035fc:	02010113          	addi	sp,sp,32
    80003600:	00008067          	ret

0000000080003604 <_ZN16ProducerKeyboard3runEv>:
    void run() override {
    80003604:	ff010113          	addi	sp,sp,-16
    80003608:	00113423          	sd	ra,8(sp)
    8000360c:	00813023          	sd	s0,0(sp)
    80003610:	01010413          	addi	s0,sp,16
        producerKeyboard(td);
    80003614:	02053583          	ld	a1,32(a0)
    80003618:	fffff097          	auipc	ra,0xfffff
    8000361c:	7e4080e7          	jalr	2020(ra) # 80002dfc <_ZN16ProducerKeyboard16producerKeyboardEPv>
    }
    80003620:	00813083          	ld	ra,8(sp)
    80003624:	00013403          	ld	s0,0(sp)
    80003628:	01010113          	addi	sp,sp,16
    8000362c:	00008067          	ret

0000000080003630 <_ZN12ProducerSync3runEv>:
    void run() override {
    80003630:	ff010113          	addi	sp,sp,-16
    80003634:	00113423          	sd	ra,8(sp)
    80003638:	00813023          	sd	s0,0(sp)
    8000363c:	01010413          	addi	s0,sp,16
        producer(td);
    80003640:	02053583          	ld	a1,32(a0)
    80003644:	00000097          	auipc	ra,0x0
    80003648:	878080e7          	jalr	-1928(ra) # 80002ebc <_ZN12ProducerSync8producerEPv>
    }
    8000364c:	00813083          	ld	ra,8(sp)
    80003650:	00013403          	ld	s0,0(sp)
    80003654:	01010113          	addi	sp,sp,16
    80003658:	00008067          	ret

000000008000365c <_ZN12ConsumerSync3runEv>:
    void run() override {
    8000365c:	ff010113          	addi	sp,sp,-16
    80003660:	00113423          	sd	ra,8(sp)
    80003664:	00813023          	sd	s0,0(sp)
    80003668:	01010413          	addi	s0,sp,16
        consumer(td);
    8000366c:	02053583          	ld	a1,32(a0)
    80003670:	00000097          	auipc	ra,0x0
    80003674:	8e0080e7          	jalr	-1824(ra) # 80002f50 <_ZN12ConsumerSync8consumerEPv>
    }
    80003678:	00813083          	ld	ra,8(sp)
    8000367c:	00013403          	ld	s0,0(sp)
    80003680:	01010113          	addi	sp,sp,16
    80003684:	00008067          	ret

0000000080003688 <_Z11printStringPKc>:

#define LOCK() while(copy_and_swap(lockPrint, 0, 1)) thread_dispatch()
#define UNLOCK() while(copy_and_swap(lockPrint, 1, 0))

void printString(char const *string)
{
    80003688:	fe010113          	addi	sp,sp,-32
    8000368c:	00113c23          	sd	ra,24(sp)
    80003690:	00813823          	sd	s0,16(sp)
    80003694:	00913423          	sd	s1,8(sp)
    80003698:	02010413          	addi	s0,sp,32
    8000369c:	00050493          	mv	s1,a0
    LOCK();
    800036a0:	00100613          	li	a2,1
    800036a4:	00000593          	li	a1,0
    800036a8:	0000a517          	auipc	a0,0xa
    800036ac:	84850513          	addi	a0,a0,-1976 # 8000cef0 <lockPrint>
    800036b0:	ffffe097          	auipc	ra,0xffffe
    800036b4:	950080e7          	jalr	-1712(ra) # 80001000 <copy_and_swap>
    800036b8:	00050863          	beqz	a0,800036c8 <_Z11printStringPKc+0x40>
    800036bc:	00001097          	auipc	ra,0x1
    800036c0:	390080e7          	jalr	912(ra) # 80004a4c <thread_dispatch>
    800036c4:	fddff06f          	j	800036a0 <_Z11printStringPKc+0x18>
    while (*string != '\0')
    800036c8:	0004c503          	lbu	a0,0(s1)
    800036cc:	00050a63          	beqz	a0,800036e0 <_Z11printStringPKc+0x58>
    {
        putc(*string);
    800036d0:	00001097          	auipc	ra,0x1
    800036d4:	5d4080e7          	jalr	1492(ra) # 80004ca4 <putc>
        string++;
    800036d8:	00148493          	addi	s1,s1,1
    while (*string != '\0')
    800036dc:	fedff06f          	j	800036c8 <_Z11printStringPKc+0x40>
    }
    UNLOCK();
    800036e0:	00000613          	li	a2,0
    800036e4:	00100593          	li	a1,1
    800036e8:	0000a517          	auipc	a0,0xa
    800036ec:	80850513          	addi	a0,a0,-2040 # 8000cef0 <lockPrint>
    800036f0:	ffffe097          	auipc	ra,0xffffe
    800036f4:	910080e7          	jalr	-1776(ra) # 80001000 <copy_and_swap>
    800036f8:	fe0514e3          	bnez	a0,800036e0 <_Z11printStringPKc+0x58>
}
    800036fc:	01813083          	ld	ra,24(sp)
    80003700:	01013403          	ld	s0,16(sp)
    80003704:	00813483          	ld	s1,8(sp)
    80003708:	02010113          	addi	sp,sp,32
    8000370c:	00008067          	ret

0000000080003710 <_Z9getStringPci>:

char* getString(char *buf, int max) {
    80003710:	fd010113          	addi	sp,sp,-48
    80003714:	02113423          	sd	ra,40(sp)
    80003718:	02813023          	sd	s0,32(sp)
    8000371c:	00913c23          	sd	s1,24(sp)
    80003720:	01213823          	sd	s2,16(sp)
    80003724:	01313423          	sd	s3,8(sp)
    80003728:	01413023          	sd	s4,0(sp)
    8000372c:	03010413          	addi	s0,sp,48
    80003730:	00050993          	mv	s3,a0
    80003734:	00058a13          	mv	s4,a1
    LOCK();
    80003738:	00100613          	li	a2,1
    8000373c:	00000593          	li	a1,0
    80003740:	00009517          	auipc	a0,0x9
    80003744:	7b050513          	addi	a0,a0,1968 # 8000cef0 <lockPrint>
    80003748:	ffffe097          	auipc	ra,0xffffe
    8000374c:	8b8080e7          	jalr	-1864(ra) # 80001000 <copy_and_swap>
    80003750:	00050863          	beqz	a0,80003760 <_Z9getStringPci+0x50>
    80003754:	00001097          	auipc	ra,0x1
    80003758:	2f8080e7          	jalr	760(ra) # 80004a4c <thread_dispatch>
    8000375c:	fddff06f          	j	80003738 <_Z9getStringPci+0x28>
    int i, cc;
    char c;

    for(i=0; i+1 < max; ){
    80003760:	00000913          	li	s2,0
    80003764:	00090493          	mv	s1,s2
    80003768:	0019091b          	addiw	s2,s2,1
    8000376c:	03495a63          	bge	s2,s4,800037a0 <_Z9getStringPci+0x90>
        cc = getc();
    80003770:	00001097          	auipc	ra,0x1
    80003774:	4f4080e7          	jalr	1268(ra) # 80004c64 <getc>
        if(cc < 1)
    80003778:	02050463          	beqz	a0,800037a0 <_Z9getStringPci+0x90>
            break;
        c = cc;
        buf[i++] = c;
    8000377c:	009984b3          	add	s1,s3,s1
    80003780:	00a48023          	sb	a0,0(s1)
        if(c == '\n' || c == '\r')
    80003784:	00a00793          	li	a5,10
    80003788:	00f50a63          	beq	a0,a5,8000379c <_Z9getStringPci+0x8c>
    8000378c:	00d00793          	li	a5,13
    80003790:	fcf51ae3          	bne	a0,a5,80003764 <_Z9getStringPci+0x54>
        buf[i++] = c;
    80003794:	00090493          	mv	s1,s2
    80003798:	0080006f          	j	800037a0 <_Z9getStringPci+0x90>
    8000379c:	00090493          	mv	s1,s2
            break;
    }
    buf[i] = '\0';
    800037a0:	009984b3          	add	s1,s3,s1
    800037a4:	00048023          	sb	zero,0(s1)

    UNLOCK();
    800037a8:	00000613          	li	a2,0
    800037ac:	00100593          	li	a1,1
    800037b0:	00009517          	auipc	a0,0x9
    800037b4:	74050513          	addi	a0,a0,1856 # 8000cef0 <lockPrint>
    800037b8:	ffffe097          	auipc	ra,0xffffe
    800037bc:	848080e7          	jalr	-1976(ra) # 80001000 <copy_and_swap>
    800037c0:	fe0514e3          	bnez	a0,800037a8 <_Z9getStringPci+0x98>
    return buf;
}
    800037c4:	00098513          	mv	a0,s3
    800037c8:	02813083          	ld	ra,40(sp)
    800037cc:	02013403          	ld	s0,32(sp)
    800037d0:	01813483          	ld	s1,24(sp)
    800037d4:	01013903          	ld	s2,16(sp)
    800037d8:	00813983          	ld	s3,8(sp)
    800037dc:	00013a03          	ld	s4,0(sp)
    800037e0:	03010113          	addi	sp,sp,48
    800037e4:	00008067          	ret

00000000800037e8 <_Z11stringToIntPKc>:

int stringToInt(const char *s) {
    800037e8:	ff010113          	addi	sp,sp,-16
    800037ec:	00813423          	sd	s0,8(sp)
    800037f0:	01010413          	addi	s0,sp,16
    800037f4:	00050693          	mv	a3,a0
    int n;

    n = 0;
    800037f8:	00000513          	li	a0,0
    while ('0' <= *s && *s <= '9')
    800037fc:	0006c603          	lbu	a2,0(a3)
    80003800:	fd06071b          	addiw	a4,a2,-48
    80003804:	0ff77713          	andi	a4,a4,255
    80003808:	00900793          	li	a5,9
    8000380c:	02e7e063          	bltu	a5,a4,8000382c <_Z11stringToIntPKc+0x44>
        n = n * 10 + *s++ - '0';
    80003810:	0025179b          	slliw	a5,a0,0x2
    80003814:	00a787bb          	addw	a5,a5,a0
    80003818:	0017979b          	slliw	a5,a5,0x1
    8000381c:	00168693          	addi	a3,a3,1
    80003820:	00c787bb          	addw	a5,a5,a2
    80003824:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    80003828:	fd5ff06f          	j	800037fc <_Z11stringToIntPKc+0x14>
    return n;
}
    8000382c:	00813403          	ld	s0,8(sp)
    80003830:	01010113          	addi	sp,sp,16
    80003834:	00008067          	ret

0000000080003838 <_Z8printIntiii>:

char digits[] = "0123456789ABCDEF";

void printInt(int xx, int base, int sgn)
{
    80003838:	fc010113          	addi	sp,sp,-64
    8000383c:	02113c23          	sd	ra,56(sp)
    80003840:	02813823          	sd	s0,48(sp)
    80003844:	02913423          	sd	s1,40(sp)
    80003848:	03213023          	sd	s2,32(sp)
    8000384c:	01313c23          	sd	s3,24(sp)
    80003850:	04010413          	addi	s0,sp,64
    80003854:	00050493          	mv	s1,a0
    80003858:	00058913          	mv	s2,a1
    8000385c:	00060993          	mv	s3,a2
    LOCK();
    80003860:	00100613          	li	a2,1
    80003864:	00000593          	li	a1,0
    80003868:	00009517          	auipc	a0,0x9
    8000386c:	68850513          	addi	a0,a0,1672 # 8000cef0 <lockPrint>
    80003870:	ffffd097          	auipc	ra,0xffffd
    80003874:	790080e7          	jalr	1936(ra) # 80001000 <copy_and_swap>
    80003878:	00050863          	beqz	a0,80003888 <_Z8printIntiii+0x50>
    8000387c:	00001097          	auipc	ra,0x1
    80003880:	1d0080e7          	jalr	464(ra) # 80004a4c <thread_dispatch>
    80003884:	fddff06f          	j	80003860 <_Z8printIntiii+0x28>
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if(sgn && xx < 0){
    80003888:	00098463          	beqz	s3,80003890 <_Z8printIntiii+0x58>
    8000388c:	0804c463          	bltz	s1,80003914 <_Z8printIntiii+0xdc>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    80003890:	0004851b          	sext.w	a0,s1
    neg = 0;
    80003894:	00000593          	li	a1,0
    }

    i = 0;
    80003898:	00000493          	li	s1,0
    do{
        buf[i++] = digits[x % base];
    8000389c:	0009079b          	sext.w	a5,s2
    800038a0:	0325773b          	remuw	a4,a0,s2
    800038a4:	00048613          	mv	a2,s1
    800038a8:	0014849b          	addiw	s1,s1,1
    800038ac:	02071693          	slli	a3,a4,0x20
    800038b0:	0206d693          	srli	a3,a3,0x20
    800038b4:	00009717          	auipc	a4,0x9
    800038b8:	46470713          	addi	a4,a4,1124 # 8000cd18 <digits>
    800038bc:	00d70733          	add	a4,a4,a3
    800038c0:	00074683          	lbu	a3,0(a4)
    800038c4:	fd040713          	addi	a4,s0,-48
    800038c8:	00c70733          	add	a4,a4,a2
    800038cc:	fed70823          	sb	a3,-16(a4)
    }while((x /= base) != 0);
    800038d0:	0005071b          	sext.w	a4,a0
    800038d4:	0325553b          	divuw	a0,a0,s2
    800038d8:	fcf772e3          	bgeu	a4,a5,8000389c <_Z8printIntiii+0x64>
    if(neg)
    800038dc:	00058c63          	beqz	a1,800038f4 <_Z8printIntiii+0xbc>
        buf[i++] = '-';
    800038e0:	fd040793          	addi	a5,s0,-48
    800038e4:	009784b3          	add	s1,a5,s1
    800038e8:	02d00793          	li	a5,45
    800038ec:	fef48823          	sb	a5,-16(s1)
    800038f0:	0026049b          	addiw	s1,a2,2

    while(--i >= 0)
    800038f4:	fff4849b          	addiw	s1,s1,-1
    800038f8:	0204c463          	bltz	s1,80003920 <_Z8printIntiii+0xe8>
        putc(buf[i]);
    800038fc:	fd040793          	addi	a5,s0,-48
    80003900:	009787b3          	add	a5,a5,s1
    80003904:	ff07c503          	lbu	a0,-16(a5)
    80003908:	00001097          	auipc	ra,0x1
    8000390c:	39c080e7          	jalr	924(ra) # 80004ca4 <putc>
    80003910:	fe5ff06f          	j	800038f4 <_Z8printIntiii+0xbc>
        x = -xx;
    80003914:	4090053b          	negw	a0,s1
        neg = 1;
    80003918:	00100593          	li	a1,1
        x = -xx;
    8000391c:	f7dff06f          	j	80003898 <_Z8printIntiii+0x60>

    UNLOCK();
    80003920:	00000613          	li	a2,0
    80003924:	00100593          	li	a1,1
    80003928:	00009517          	auipc	a0,0x9
    8000392c:	5c850513          	addi	a0,a0,1480 # 8000cef0 <lockPrint>
    80003930:	ffffd097          	auipc	ra,0xffffd
    80003934:	6d0080e7          	jalr	1744(ra) # 80001000 <copy_and_swap>
    80003938:	fe0514e3          	bnez	a0,80003920 <_Z8printIntiii+0xe8>
    8000393c:	03813083          	ld	ra,56(sp)
    80003940:	03013403          	ld	s0,48(sp)
    80003944:	02813483          	ld	s1,40(sp)
    80003948:	02013903          	ld	s2,32(sp)
    8000394c:	01813983          	ld	s3,24(sp)
    80003950:	04010113          	addi	sp,sp,64
    80003954:	00008067          	ret

0000000080003958 <_ZN9BufferCPPC1Ei>:
#include "buffer_CPP_API.hpp"

BufferCPP::BufferCPP(int _cap) : cap(_cap + 1), head(0), tail(0) {
    80003958:	fd010113          	addi	sp,sp,-48
    8000395c:	02113423          	sd	ra,40(sp)
    80003960:	02813023          	sd	s0,32(sp)
    80003964:	00913c23          	sd	s1,24(sp)
    80003968:	01213823          	sd	s2,16(sp)
    8000396c:	01313423          	sd	s3,8(sp)
    80003970:	03010413          	addi	s0,sp,48
    80003974:	00050493          	mv	s1,a0
    80003978:	00058913          	mv	s2,a1
    8000397c:	0015879b          	addiw	a5,a1,1
    80003980:	0007851b          	sext.w	a0,a5
    80003984:	00f4a023          	sw	a5,0(s1)
    80003988:	0004a823          	sw	zero,16(s1)
    8000398c:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    80003990:	00251513          	slli	a0,a0,0x2
    80003994:	00001097          	auipc	ra,0x1
    80003998:	f74080e7          	jalr	-140(ra) # 80004908 <mem_alloc>
    8000399c:	00a4b423          	sd	a0,8(s1)
    itemAvailable = new Semaphore(0);
    800039a0:	01000513          	li	a0,16
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	fb4080e7          	jalr	-76(ra) # 80006958 <_Znwm>
    800039ac:	00050993          	mv	s3,a0
    800039b0:	00000593          	li	a1,0
    800039b4:	00003097          	auipc	ra,0x3
    800039b8:	160080e7          	jalr	352(ra) # 80006b14 <_ZN9SemaphoreC1Ej>
    800039bc:	0334b023          	sd	s3,32(s1)
    spaceAvailable = new Semaphore(_cap);
    800039c0:	01000513          	li	a0,16
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	f94080e7          	jalr	-108(ra) # 80006958 <_Znwm>
    800039cc:	00050993          	mv	s3,a0
    800039d0:	00090593          	mv	a1,s2
    800039d4:	00003097          	auipc	ra,0x3
    800039d8:	140080e7          	jalr	320(ra) # 80006b14 <_ZN9SemaphoreC1Ej>
    800039dc:	0134bc23          	sd	s3,24(s1)
    mutexHead = new Semaphore(1);
    800039e0:	01000513          	li	a0,16
    800039e4:	00003097          	auipc	ra,0x3
    800039e8:	f74080e7          	jalr	-140(ra) # 80006958 <_Znwm>
    800039ec:	00050913          	mv	s2,a0
    800039f0:	00100593          	li	a1,1
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	120080e7          	jalr	288(ra) # 80006b14 <_ZN9SemaphoreC1Ej>
    800039fc:	0324b423          	sd	s2,40(s1)
    mutexTail = new Semaphore(1);
    80003a00:	01000513          	li	a0,16
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	f54080e7          	jalr	-172(ra) # 80006958 <_Znwm>
    80003a0c:	00050913          	mv	s2,a0
    80003a10:	00100593          	li	a1,1
    80003a14:	00003097          	auipc	ra,0x3
    80003a18:	100080e7          	jalr	256(ra) # 80006b14 <_ZN9SemaphoreC1Ej>
    80003a1c:	0324b823          	sd	s2,48(s1)
}
    80003a20:	02813083          	ld	ra,40(sp)
    80003a24:	02013403          	ld	s0,32(sp)
    80003a28:	01813483          	ld	s1,24(sp)
    80003a2c:	01013903          	ld	s2,16(sp)
    80003a30:	00813983          	ld	s3,8(sp)
    80003a34:	03010113          	addi	sp,sp,48
    80003a38:	00008067          	ret
    80003a3c:	00050493          	mv	s1,a0
    itemAvailable = new Semaphore(0);
    80003a40:	00098513          	mv	a0,s3
    80003a44:	00003097          	auipc	ra,0x3
    80003a48:	f3c080e7          	jalr	-196(ra) # 80006980 <_ZdlPv>
    80003a4c:	00048513          	mv	a0,s1
    80003a50:	0000a097          	auipc	ra,0xa
    80003a54:	5f8080e7          	jalr	1528(ra) # 8000e048 <_Unwind_Resume>
    80003a58:	00050493          	mv	s1,a0
    spaceAvailable = new Semaphore(_cap);
    80003a5c:	00098513          	mv	a0,s3
    80003a60:	00003097          	auipc	ra,0x3
    80003a64:	f20080e7          	jalr	-224(ra) # 80006980 <_ZdlPv>
    80003a68:	00048513          	mv	a0,s1
    80003a6c:	0000a097          	auipc	ra,0xa
    80003a70:	5dc080e7          	jalr	1500(ra) # 8000e048 <_Unwind_Resume>
    80003a74:	00050493          	mv	s1,a0
    mutexHead = new Semaphore(1);
    80003a78:	00090513          	mv	a0,s2
    80003a7c:	00003097          	auipc	ra,0x3
    80003a80:	f04080e7          	jalr	-252(ra) # 80006980 <_ZdlPv>
    80003a84:	00048513          	mv	a0,s1
    80003a88:	0000a097          	auipc	ra,0xa
    80003a8c:	5c0080e7          	jalr	1472(ra) # 8000e048 <_Unwind_Resume>
    80003a90:	00050493          	mv	s1,a0
    mutexTail = new Semaphore(1);
    80003a94:	00090513          	mv	a0,s2
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	ee8080e7          	jalr	-280(ra) # 80006980 <_ZdlPv>
    80003aa0:	00048513          	mv	a0,s1
    80003aa4:	0000a097          	auipc	ra,0xa
    80003aa8:	5a4080e7          	jalr	1444(ra) # 8000e048 <_Unwind_Resume>

0000000080003aac <_ZN9BufferCPP3putEi>:
    delete mutexTail;
    delete mutexHead;

}

void BufferCPP::put(int val) {
    80003aac:	fe010113          	addi	sp,sp,-32
    80003ab0:	00113c23          	sd	ra,24(sp)
    80003ab4:	00813823          	sd	s0,16(sp)
    80003ab8:	00913423          	sd	s1,8(sp)
    80003abc:	01213023          	sd	s2,0(sp)
    80003ac0:	02010413          	addi	s0,sp,32
    80003ac4:	00050493          	mv	s1,a0
    80003ac8:	00058913          	mv	s2,a1
    spaceAvailable->wait();
    80003acc:	01853503          	ld	a0,24(a0)
    80003ad0:	00003097          	auipc	ra,0x3
    80003ad4:	080080e7          	jalr	128(ra) # 80006b50 <_ZN9Semaphore4waitEv>

    mutexTail->wait();
    80003ad8:	0304b503          	ld	a0,48(s1)
    80003adc:	00003097          	auipc	ra,0x3
    80003ae0:	074080e7          	jalr	116(ra) # 80006b50 <_ZN9Semaphore4waitEv>
    buffer[tail] = val;
    80003ae4:	0084b783          	ld	a5,8(s1)
    80003ae8:	0144a703          	lw	a4,20(s1)
    80003aec:	00271713          	slli	a4,a4,0x2
    80003af0:	00e787b3          	add	a5,a5,a4
    80003af4:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    80003af8:	0144a783          	lw	a5,20(s1)
    80003afc:	0017879b          	addiw	a5,a5,1
    80003b00:	0004a703          	lw	a4,0(s1)
    80003b04:	02e7e7bb          	remw	a5,a5,a4
    80003b08:	00f4aa23          	sw	a5,20(s1)
    mutexTail->signal();
    80003b0c:	0304b503          	ld	a0,48(s1)
    80003b10:	00003097          	auipc	ra,0x3
    80003b14:	06c080e7          	jalr	108(ra) # 80006b7c <_ZN9Semaphore6signalEv>

    itemAvailable->signal();
    80003b18:	0204b503          	ld	a0,32(s1)
    80003b1c:	00003097          	auipc	ra,0x3
    80003b20:	060080e7          	jalr	96(ra) # 80006b7c <_ZN9Semaphore6signalEv>

}
    80003b24:	01813083          	ld	ra,24(sp)
    80003b28:	01013403          	ld	s0,16(sp)
    80003b2c:	00813483          	ld	s1,8(sp)
    80003b30:	00013903          	ld	s2,0(sp)
    80003b34:	02010113          	addi	sp,sp,32
    80003b38:	00008067          	ret

0000000080003b3c <_ZN9BufferCPP3getEv>:

int BufferCPP::get() {
    80003b3c:	fe010113          	addi	sp,sp,-32
    80003b40:	00113c23          	sd	ra,24(sp)
    80003b44:	00813823          	sd	s0,16(sp)
    80003b48:	00913423          	sd	s1,8(sp)
    80003b4c:	01213023          	sd	s2,0(sp)
    80003b50:	02010413          	addi	s0,sp,32
    80003b54:	00050493          	mv	s1,a0
    itemAvailable->wait();
    80003b58:	02053503          	ld	a0,32(a0)
    80003b5c:	00003097          	auipc	ra,0x3
    80003b60:	ff4080e7          	jalr	-12(ra) # 80006b50 <_ZN9Semaphore4waitEv>

    mutexHead->wait();
    80003b64:	0284b503          	ld	a0,40(s1)
    80003b68:	00003097          	auipc	ra,0x3
    80003b6c:	fe8080e7          	jalr	-24(ra) # 80006b50 <_ZN9Semaphore4waitEv>

    int ret = buffer[head];
    80003b70:	0084b703          	ld	a4,8(s1)
    80003b74:	0104a783          	lw	a5,16(s1)
    80003b78:	00279693          	slli	a3,a5,0x2
    80003b7c:	00d70733          	add	a4,a4,a3
    80003b80:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    80003b84:	0017879b          	addiw	a5,a5,1
    80003b88:	0004a703          	lw	a4,0(s1)
    80003b8c:	02e7e7bb          	remw	a5,a5,a4
    80003b90:	00f4a823          	sw	a5,16(s1)
    mutexHead->signal();
    80003b94:	0284b503          	ld	a0,40(s1)
    80003b98:	00003097          	auipc	ra,0x3
    80003b9c:	fe4080e7          	jalr	-28(ra) # 80006b7c <_ZN9Semaphore6signalEv>

    spaceAvailable->signal();
    80003ba0:	0184b503          	ld	a0,24(s1)
    80003ba4:	00003097          	auipc	ra,0x3
    80003ba8:	fd8080e7          	jalr	-40(ra) # 80006b7c <_ZN9Semaphore6signalEv>

    return ret;
}
    80003bac:	00090513          	mv	a0,s2
    80003bb0:	01813083          	ld	ra,24(sp)
    80003bb4:	01013403          	ld	s0,16(sp)
    80003bb8:	00813483          	ld	s1,8(sp)
    80003bbc:	00013903          	ld	s2,0(sp)
    80003bc0:	02010113          	addi	sp,sp,32
    80003bc4:	00008067          	ret

0000000080003bc8 <_ZN9BufferCPP6getCntEv>:

int BufferCPP::getCnt() {
    80003bc8:	fe010113          	addi	sp,sp,-32
    80003bcc:	00113c23          	sd	ra,24(sp)
    80003bd0:	00813823          	sd	s0,16(sp)
    80003bd4:	00913423          	sd	s1,8(sp)
    80003bd8:	01213023          	sd	s2,0(sp)
    80003bdc:	02010413          	addi	s0,sp,32
    80003be0:	00050493          	mv	s1,a0
    int ret;

    mutexHead->wait();
    80003be4:	02853503          	ld	a0,40(a0)
    80003be8:	00003097          	auipc	ra,0x3
    80003bec:	f68080e7          	jalr	-152(ra) # 80006b50 <_ZN9Semaphore4waitEv>
    mutexTail->wait();
    80003bf0:	0304b503          	ld	a0,48(s1)
    80003bf4:	00003097          	auipc	ra,0x3
    80003bf8:	f5c080e7          	jalr	-164(ra) # 80006b50 <_ZN9Semaphore4waitEv>

    if (tail >= head) {
    80003bfc:	0144a783          	lw	a5,20(s1)
    80003c00:	0104a903          	lw	s2,16(s1)
    80003c04:	0327ce63          	blt	a5,s2,80003c40 <_ZN9BufferCPP6getCntEv+0x78>
        ret = tail - head;
    80003c08:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    mutexTail->signal();
    80003c0c:	0304b503          	ld	a0,48(s1)
    80003c10:	00003097          	auipc	ra,0x3
    80003c14:	f6c080e7          	jalr	-148(ra) # 80006b7c <_ZN9Semaphore6signalEv>
    mutexHead->signal();
    80003c18:	0284b503          	ld	a0,40(s1)
    80003c1c:	00003097          	auipc	ra,0x3
    80003c20:	f60080e7          	jalr	-160(ra) # 80006b7c <_ZN9Semaphore6signalEv>

    return ret;
}
    80003c24:	00090513          	mv	a0,s2
    80003c28:	01813083          	ld	ra,24(sp)
    80003c2c:	01013403          	ld	s0,16(sp)
    80003c30:	00813483          	ld	s1,8(sp)
    80003c34:	00013903          	ld	s2,0(sp)
    80003c38:	02010113          	addi	sp,sp,32
    80003c3c:	00008067          	ret
        ret = cap - head + tail;
    80003c40:	0004a703          	lw	a4,0(s1)
    80003c44:	4127093b          	subw	s2,a4,s2
    80003c48:	00f9093b          	addw	s2,s2,a5
    80003c4c:	fc1ff06f          	j	80003c0c <_ZN9BufferCPP6getCntEv+0x44>

0000000080003c50 <_ZN9BufferCPPD1Ev>:
BufferCPP::~BufferCPP() {
    80003c50:	fe010113          	addi	sp,sp,-32
    80003c54:	00113c23          	sd	ra,24(sp)
    80003c58:	00813823          	sd	s0,16(sp)
    80003c5c:	00913423          	sd	s1,8(sp)
    80003c60:	02010413          	addi	s0,sp,32
    80003c64:	00050493          	mv	s1,a0
    Console::putc('\n');
    80003c68:	00a00513          	li	a0,10
    80003c6c:	00003097          	auipc	ra,0x3
    80003c70:	00c080e7          	jalr	12(ra) # 80006c78 <_ZN7Console4putcEc>
    printString("Buffer deleted!\n");
    80003c74:	00006517          	auipc	a0,0x6
    80003c78:	58450513          	addi	a0,a0,1412 # 8000a1f8 <CONSOLE_STATUS+0x1e8>
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	a0c080e7          	jalr	-1524(ra) # 80003688 <_Z11printStringPKc>
    while (getCnt()) {
    80003c84:	00048513          	mv	a0,s1
    80003c88:	00000097          	auipc	ra,0x0
    80003c8c:	f40080e7          	jalr	-192(ra) # 80003bc8 <_ZN9BufferCPP6getCntEv>
    80003c90:	02050c63          	beqz	a0,80003cc8 <_ZN9BufferCPPD1Ev+0x78>
        char ch = buffer[head];
    80003c94:	0084b783          	ld	a5,8(s1)
    80003c98:	0104a703          	lw	a4,16(s1)
    80003c9c:	00271713          	slli	a4,a4,0x2
    80003ca0:	00e787b3          	add	a5,a5,a4
        Console::putc(ch);
    80003ca4:	0007c503          	lbu	a0,0(a5)
    80003ca8:	00003097          	auipc	ra,0x3
    80003cac:	fd0080e7          	jalr	-48(ra) # 80006c78 <_ZN7Console4putcEc>
        head = (head + 1) % cap;
    80003cb0:	0104a783          	lw	a5,16(s1)
    80003cb4:	0017879b          	addiw	a5,a5,1
    80003cb8:	0004a703          	lw	a4,0(s1)
    80003cbc:	02e7e7bb          	remw	a5,a5,a4
    80003cc0:	00f4a823          	sw	a5,16(s1)
    while (getCnt()) {
    80003cc4:	fc1ff06f          	j	80003c84 <_ZN9BufferCPPD1Ev+0x34>
    Console::putc('!');
    80003cc8:	02100513          	li	a0,33
    80003ccc:	00003097          	auipc	ra,0x3
    80003cd0:	fac080e7          	jalr	-84(ra) # 80006c78 <_ZN7Console4putcEc>
    Console::putc('\n');
    80003cd4:	00a00513          	li	a0,10
    80003cd8:	00003097          	auipc	ra,0x3
    80003cdc:	fa0080e7          	jalr	-96(ra) # 80006c78 <_ZN7Console4putcEc>
    mem_free(buffer);
    80003ce0:	0084b503          	ld	a0,8(s1)
    80003ce4:	00001097          	auipc	ra,0x1
    80003ce8:	c6c080e7          	jalr	-916(ra) # 80004950 <mem_free>
    delete itemAvailable;
    80003cec:	0204b503          	ld	a0,32(s1)
    80003cf0:	00050863          	beqz	a0,80003d00 <_ZN9BufferCPPD1Ev+0xb0>
    80003cf4:	00053783          	ld	a5,0(a0)
    80003cf8:	0087b783          	ld	a5,8(a5)
    80003cfc:	000780e7          	jalr	a5
    delete spaceAvailable;
    80003d00:	0184b503          	ld	a0,24(s1)
    80003d04:	00050863          	beqz	a0,80003d14 <_ZN9BufferCPPD1Ev+0xc4>
    80003d08:	00053783          	ld	a5,0(a0)
    80003d0c:	0087b783          	ld	a5,8(a5)
    80003d10:	000780e7          	jalr	a5
    delete mutexTail;
    80003d14:	0304b503          	ld	a0,48(s1)
    80003d18:	00050863          	beqz	a0,80003d28 <_ZN9BufferCPPD1Ev+0xd8>
    80003d1c:	00053783          	ld	a5,0(a0)
    80003d20:	0087b783          	ld	a5,8(a5)
    80003d24:	000780e7          	jalr	a5
    delete mutexHead;
    80003d28:	0284b503          	ld	a0,40(s1)
    80003d2c:	00050863          	beqz	a0,80003d3c <_ZN9BufferCPPD1Ev+0xec>
    80003d30:	00053783          	ld	a5,0(a0)
    80003d34:	0087b783          	ld	a5,8(a5)
    80003d38:	000780e7          	jalr	a5
}
    80003d3c:	01813083          	ld	ra,24(sp)
    80003d40:	01013403          	ld	s0,16(sp)
    80003d44:	00813483          	ld	s1,8(sp)
    80003d48:	02010113          	addi	sp,sp,32
    80003d4c:	00008067          	ret

0000000080003d50 <_Z8userMainv>:
#include "ConsumerProducer_CPP_API_test.hpp"
#include "System_Mode_test.hpp"

#endif

void userMain() {
    80003d50:	fe010113          	addi	sp,sp,-32
    80003d54:	00113c23          	sd	ra,24(sp)
    80003d58:	00813823          	sd	s0,16(sp)
    80003d5c:	00913423          	sd	s1,8(sp)
    80003d60:	02010413          	addi	s0,sp,32
    printString("Unesite broj testa? [1-7]\n");
    80003d64:	00006517          	auipc	a0,0x6
    80003d68:	4ac50513          	addi	a0,a0,1196 # 8000a210 <CONSOLE_STATUS+0x200>
    80003d6c:	00000097          	auipc	ra,0x0
    80003d70:	91c080e7          	jalr	-1764(ra) # 80003688 <_Z11printStringPKc>
    int test = getc() - '0';
    80003d74:	00001097          	auipc	ra,0x1
    80003d78:	ef0080e7          	jalr	-272(ra) # 80004c64 <getc>
    80003d7c:	fd05049b          	addiw	s1,a0,-48
    getc(); // Enter posle broja
    80003d80:	00001097          	auipc	ra,0x1
    80003d84:	ee4080e7          	jalr	-284(ra) # 80004c64 <getc>
            printString("Nije navedeno da je zadatak 4 implementiran\n");
            return;
        }
    }

    switch (test) {
    80003d88:	00700793          	li	a5,7
    80003d8c:	1097e263          	bltu	a5,s1,80003e90 <_Z8userMainv+0x140>
    80003d90:	00249493          	slli	s1,s1,0x2
    80003d94:	00006717          	auipc	a4,0x6
    80003d98:	6d470713          	addi	a4,a4,1748 # 8000a468 <CONSOLE_STATUS+0x458>
    80003d9c:	00e484b3          	add	s1,s1,a4
    80003da0:	0004a783          	lw	a5,0(s1)
    80003da4:	00e787b3          	add	a5,a5,a4
    80003da8:	00078067          	jr	a5
        case 1:
#if LEVEL_2_IMPLEMENTED == 1
            Threads_C_API_test();
    80003dac:	fffff097          	auipc	ra,0xfffff
    80003db0:	f54080e7          	jalr	-172(ra) # 80002d00 <_Z18Threads_C_API_testv>
            printString("TEST 1 (zadatak 2, niti C API i sinhrona promena konteksta)\n");
    80003db4:	00006517          	auipc	a0,0x6
    80003db8:	47c50513          	addi	a0,a0,1148 # 8000a230 <CONSOLE_STATUS+0x220>
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	8cc080e7          	jalr	-1844(ra) # 80003688 <_Z11printStringPKc>
#endif
            break;
        default:
            printString("Niste uneli odgovarajuci broj za test\n");
    }
    80003dc4:	01813083          	ld	ra,24(sp)
    80003dc8:	01013403          	ld	s0,16(sp)
    80003dcc:	00813483          	ld	s1,8(sp)
    80003dd0:	02010113          	addi	sp,sp,32
    80003dd4:	00008067          	ret
            Threads_CPP_API_test();
    80003dd8:	ffffe097          	auipc	ra,0xffffe
    80003ddc:	e08080e7          	jalr	-504(ra) # 80001be0 <_Z20Threads_CPP_API_testv>
            printString("TEST 2 (zadatak 2., niti CPP API i sinhrona promena konteksta)\n");
    80003de0:	00006517          	auipc	a0,0x6
    80003de4:	49050513          	addi	a0,a0,1168 # 8000a270 <CONSOLE_STATUS+0x260>
    80003de8:	00000097          	auipc	ra,0x0
    80003dec:	8a0080e7          	jalr	-1888(ra) # 80003688 <_Z11printStringPKc>
            break;
    80003df0:	fd5ff06f          	j	80003dc4 <_Z8userMainv+0x74>
            producerConsumer_C_API();
    80003df4:	ffffd097          	auipc	ra,0xffffd
    80003df8:	640080e7          	jalr	1600(ra) # 80001434 <_Z22producerConsumer_C_APIv>
            printString("TEST 3 (zadatak 3., kompletan C API sa semaforima, sinhrona promena konteksta)\n");
    80003dfc:	00006517          	auipc	a0,0x6
    80003e00:	4b450513          	addi	a0,a0,1204 # 8000a2b0 <CONSOLE_STATUS+0x2a0>
    80003e04:	00000097          	auipc	ra,0x0
    80003e08:	884080e7          	jalr	-1916(ra) # 80003688 <_Z11printStringPKc>
            break;
    80003e0c:	fb9ff06f          	j	80003dc4 <_Z8userMainv+0x74>
            producerConsumer_CPP_Sync_API();
    80003e10:	fffff097          	auipc	ra,0xfffff
    80003e14:	234080e7          	jalr	564(ra) # 80003044 <_Z29producerConsumer_CPP_Sync_APIv>
            printString("TEST 4 (zadatak 3., kompletan CPP API sa semaforima, sinhrona promena konteksta)\n");
    80003e18:	00006517          	auipc	a0,0x6
    80003e1c:	4e850513          	addi	a0,a0,1256 # 8000a300 <CONSOLE_STATUS+0x2f0>
    80003e20:	00000097          	auipc	ra,0x0
    80003e24:	868080e7          	jalr	-1944(ra) # 80003688 <_Z11printStringPKc>
            break;
    80003e28:	f9dff06f          	j	80003dc4 <_Z8userMainv+0x74>
            testSleeping();
    80003e2c:	00000097          	auipc	ra,0x0
    80003e30:	11c080e7          	jalr	284(ra) # 80003f48 <_Z12testSleepingv>
            printString("TEST 5 (zadatak 4., thread_sleep test C API)\n");
    80003e34:	00006517          	auipc	a0,0x6
    80003e38:	52450513          	addi	a0,a0,1316 # 8000a358 <CONSOLE_STATUS+0x348>
    80003e3c:	00000097          	auipc	ra,0x0
    80003e40:	84c080e7          	jalr	-1972(ra) # 80003688 <_Z11printStringPKc>
            break;
    80003e44:	f81ff06f          	j	80003dc4 <_Z8userMainv+0x74>
            testConsumerProducer();
    80003e48:	ffffe097          	auipc	ra,0xffffe
    80003e4c:	258080e7          	jalr	600(ra) # 800020a0 <_Z20testConsumerProducerv>
            printString("TEST 6 (zadatak 4. CPP API i asinhrona promena konteksta)\n");
    80003e50:	00006517          	auipc	a0,0x6
    80003e54:	53850513          	addi	a0,a0,1336 # 8000a388 <CONSOLE_STATUS+0x378>
    80003e58:	00000097          	auipc	ra,0x0
    80003e5c:	830080e7          	jalr	-2000(ra) # 80003688 <_Z11printStringPKc>
            break;
    80003e60:	f65ff06f          	j	80003dc4 <_Z8userMainv+0x74>
            System_Mode_test();
    80003e64:	00000097          	auipc	ra,0x0
    80003e68:	658080e7          	jalr	1624(ra) # 800044bc <_Z16System_Mode_testv>
            printString("Test se nije uspesno zavrsio\n");
    80003e6c:	00006517          	auipc	a0,0x6
    80003e70:	55c50513          	addi	a0,a0,1372 # 8000a3c8 <CONSOLE_STATUS+0x3b8>
    80003e74:	00000097          	auipc	ra,0x0
    80003e78:	814080e7          	jalr	-2028(ra) # 80003688 <_Z11printStringPKc>
            printString("TEST 7 (zadatak 2., testiranje da li se korisnicki kod izvrsava u korisnickom rezimu)\n");
    80003e7c:	00006517          	auipc	a0,0x6
    80003e80:	56c50513          	addi	a0,a0,1388 # 8000a3e8 <CONSOLE_STATUS+0x3d8>
    80003e84:	00000097          	auipc	ra,0x0
    80003e88:	804080e7          	jalr	-2044(ra) # 80003688 <_Z11printStringPKc>
            break;
    80003e8c:	f39ff06f          	j	80003dc4 <_Z8userMainv+0x74>
            printString("Niste uneli odgovarajuci broj za test\n");
    80003e90:	00006517          	auipc	a0,0x6
    80003e94:	5b050513          	addi	a0,a0,1456 # 8000a440 <CONSOLE_STATUS+0x430>
    80003e98:	fffff097          	auipc	ra,0xfffff
    80003e9c:	7f0080e7          	jalr	2032(ra) # 80003688 <_Z11printStringPKc>
    80003ea0:	f25ff06f          	j	80003dc4 <_Z8userMainv+0x74>

0000000080003ea4 <_ZL9sleepyRunPv>:

#include "printing.hpp"

static volatile bool finished[2];

static void sleepyRun(void *arg) {
    80003ea4:	fe010113          	addi	sp,sp,-32
    80003ea8:	00113c23          	sd	ra,24(sp)
    80003eac:	00813823          	sd	s0,16(sp)
    80003eb0:	00913423          	sd	s1,8(sp)
    80003eb4:	01213023          	sd	s2,0(sp)
    80003eb8:	02010413          	addi	s0,sp,32
    time_t sleep_time = *((time_t *) arg);
    80003ebc:	00053903          	ld	s2,0(a0)
    int i = 6;
    80003ec0:	00600493          	li	s1,6
    while (--i > 0) {
    80003ec4:	fff4849b          	addiw	s1,s1,-1
    80003ec8:	04905463          	blez	s1,80003f10 <_ZL9sleepyRunPv+0x6c>

        printString("Hello ");
    80003ecc:	00006517          	auipc	a0,0x6
    80003ed0:	5bc50513          	addi	a0,a0,1468 # 8000a488 <CONSOLE_STATUS+0x478>
    80003ed4:	fffff097          	auipc	ra,0xfffff
    80003ed8:	7b4080e7          	jalr	1972(ra) # 80003688 <_Z11printStringPKc>
        printInt(sleep_time);
    80003edc:	00000613          	li	a2,0
    80003ee0:	00a00593          	li	a1,10
    80003ee4:	0009051b          	sext.w	a0,s2
    80003ee8:	00000097          	auipc	ra,0x0
    80003eec:	950080e7          	jalr	-1712(ra) # 80003838 <_Z8printIntiii>
        printString(" !\n");
    80003ef0:	00006517          	auipc	a0,0x6
    80003ef4:	5a050513          	addi	a0,a0,1440 # 8000a490 <CONSOLE_STATUS+0x480>
    80003ef8:	fffff097          	auipc	ra,0xfffff
    80003efc:	790080e7          	jalr	1936(ra) # 80003688 <_Z11printStringPKc>
        time_sleep(sleep_time);
    80003f00:	00090513          	mv	a0,s2
    80003f04:	00001097          	auipc	ra,0x1
    80003f08:	d14080e7          	jalr	-748(ra) # 80004c18 <time_sleep>
    while (--i > 0) {
    80003f0c:	fb9ff06f          	j	80003ec4 <_ZL9sleepyRunPv+0x20>
    }
    finished[sleep_time/10-1] = true;
    80003f10:	00a00793          	li	a5,10
    80003f14:	02f95933          	divu	s2,s2,a5
    80003f18:	fff90913          	addi	s2,s2,-1
    80003f1c:	00009797          	auipc	a5,0x9
    80003f20:	fdc78793          	addi	a5,a5,-36 # 8000cef8 <_ZL8finished>
    80003f24:	01278933          	add	s2,a5,s2
    80003f28:	00100793          	li	a5,1
    80003f2c:	00f90023          	sb	a5,0(s2)
}
    80003f30:	01813083          	ld	ra,24(sp)
    80003f34:	01013403          	ld	s0,16(sp)
    80003f38:	00813483          	ld	s1,8(sp)
    80003f3c:	00013903          	ld	s2,0(sp)
    80003f40:	02010113          	addi	sp,sp,32
    80003f44:	00008067          	ret

0000000080003f48 <_Z12testSleepingv>:

void testSleeping() {
    80003f48:	fc010113          	addi	sp,sp,-64
    80003f4c:	02113c23          	sd	ra,56(sp)
    80003f50:	02813823          	sd	s0,48(sp)
    80003f54:	02913423          	sd	s1,40(sp)
    80003f58:	04010413          	addi	s0,sp,64
    const int sleepy_thread_count = 2;
    time_t sleep_times[sleepy_thread_count] = {10, 20};
    80003f5c:	00a00793          	li	a5,10
    80003f60:	fcf43823          	sd	a5,-48(s0)
    80003f64:	01400793          	li	a5,20
    80003f68:	fcf43c23          	sd	a5,-40(s0)
    thread_t sleepyThread[sleepy_thread_count];

    for (int i = 0; i < sleepy_thread_count; i++) {
    80003f6c:	00000493          	li	s1,0
    80003f70:	02c0006f          	j	80003f9c <_Z12testSleepingv+0x54>
        thread_create(&sleepyThread[i], sleepyRun, sleep_times + i);
    80003f74:	00349793          	slli	a5,s1,0x3
    80003f78:	fd040613          	addi	a2,s0,-48
    80003f7c:	00f60633          	add	a2,a2,a5
    80003f80:	00000597          	auipc	a1,0x0
    80003f84:	f2458593          	addi	a1,a1,-220 # 80003ea4 <_ZL9sleepyRunPv>
    80003f88:	fc040513          	addi	a0,s0,-64
    80003f8c:	00f50533          	add	a0,a0,a5
    80003f90:	00001097          	auipc	ra,0x1
    80003f94:	a00080e7          	jalr	-1536(ra) # 80004990 <thread_create>
    for (int i = 0; i < sleepy_thread_count; i++) {
    80003f98:	0014849b          	addiw	s1,s1,1
    80003f9c:	00100793          	li	a5,1
    80003fa0:	fc97dae3          	bge	a5,s1,80003f74 <_Z12testSleepingv+0x2c>
    }

    while (!(finished[0] && finished[1])) {}
    80003fa4:	00009797          	auipc	a5,0x9
    80003fa8:	f547c783          	lbu	a5,-172(a5) # 8000cef8 <_ZL8finished>
    80003fac:	fe078ce3          	beqz	a5,80003fa4 <_Z12testSleepingv+0x5c>
    80003fb0:	00009797          	auipc	a5,0x9
    80003fb4:	f497c783          	lbu	a5,-183(a5) # 8000cef9 <_ZL8finished+0x1>
    80003fb8:	fe0786e3          	beqz	a5,80003fa4 <_Z12testSleepingv+0x5c>
}
    80003fbc:	03813083          	ld	ra,56(sp)
    80003fc0:	03013403          	ld	s0,48(sp)
    80003fc4:	02813483          	ld	s1,40(sp)
    80003fc8:	04010113          	addi	sp,sp,64
    80003fcc:	00008067          	ret

0000000080003fd0 <_ZL9fibonaccim>:
static volatile bool finishedA = false;
static volatile bool finishedB = false;
static volatile bool finishedC = false;
static volatile bool finishedD = false;

static uint64 fibonacci(uint64 n) {
    80003fd0:	fe010113          	addi	sp,sp,-32
    80003fd4:	00113c23          	sd	ra,24(sp)
    80003fd8:	00813823          	sd	s0,16(sp)
    80003fdc:	00913423          	sd	s1,8(sp)
    80003fe0:	01213023          	sd	s2,0(sp)
    80003fe4:	02010413          	addi	s0,sp,32
    80003fe8:	00050493          	mv	s1,a0
    if (n == 0 || n == 1) { return n; }
    80003fec:	00100793          	li	a5,1
    80003ff0:	02a7f863          	bgeu	a5,a0,80004020 <_ZL9fibonaccim+0x50>
    if (n % 10 == 0) { thread_dispatch(); }
    80003ff4:	00a00793          	li	a5,10
    80003ff8:	02f577b3          	remu	a5,a0,a5
    80003ffc:	02078e63          	beqz	a5,80004038 <_ZL9fibonaccim+0x68>
    return fibonacci(n - 1) + fibonacci(n - 2);
    80004000:	fff48513          	addi	a0,s1,-1
    80004004:	00000097          	auipc	ra,0x0
    80004008:	fcc080e7          	jalr	-52(ra) # 80003fd0 <_ZL9fibonaccim>
    8000400c:	00050913          	mv	s2,a0
    80004010:	ffe48513          	addi	a0,s1,-2
    80004014:	00000097          	auipc	ra,0x0
    80004018:	fbc080e7          	jalr	-68(ra) # 80003fd0 <_ZL9fibonaccim>
    8000401c:	00a90533          	add	a0,s2,a0
}
    80004020:	01813083          	ld	ra,24(sp)
    80004024:	01013403          	ld	s0,16(sp)
    80004028:	00813483          	ld	s1,8(sp)
    8000402c:	00013903          	ld	s2,0(sp)
    80004030:	02010113          	addi	sp,sp,32
    80004034:	00008067          	ret
    if (n % 10 == 0) { thread_dispatch(); }
    80004038:	00001097          	auipc	ra,0x1
    8000403c:	a14080e7          	jalr	-1516(ra) # 80004a4c <thread_dispatch>
    80004040:	fc1ff06f          	j	80004000 <_ZL9fibonaccim+0x30>

0000000080004044 <_ZL11workerBodyDPv>:
    printString("A finished!\n");
    finishedC = true;
    thread_dispatch();
}

static void workerBodyD(void* arg) {
    80004044:	fe010113          	addi	sp,sp,-32
    80004048:	00113c23          	sd	ra,24(sp)
    8000404c:	00813823          	sd	s0,16(sp)
    80004050:	00913423          	sd	s1,8(sp)
    80004054:	01213023          	sd	s2,0(sp)
    80004058:	02010413          	addi	s0,sp,32
    uint8 i = 10;
    8000405c:	00a00493          	li	s1,10
    80004060:	0400006f          	j	800040a0 <_ZL11workerBodyDPv+0x5c>
    for (; i < 13; i++) {
        printString("D: i="); printInt(i); printString("\n");
    80004064:	00006517          	auipc	a0,0x6
    80004068:	0fc50513          	addi	a0,a0,252 # 8000a160 <CONSOLE_STATUS+0x150>
    8000406c:	fffff097          	auipc	ra,0xfffff
    80004070:	61c080e7          	jalr	1564(ra) # 80003688 <_Z11printStringPKc>
    80004074:	00000613          	li	a2,0
    80004078:	00a00593          	li	a1,10
    8000407c:	00048513          	mv	a0,s1
    80004080:	fffff097          	auipc	ra,0xfffff
    80004084:	7b8080e7          	jalr	1976(ra) # 80003838 <_Z8printIntiii>
    80004088:	00006517          	auipc	a0,0x6
    8000408c:	2c850513          	addi	a0,a0,712 # 8000a350 <CONSOLE_STATUS+0x340>
    80004090:	fffff097          	auipc	ra,0xfffff
    80004094:	5f8080e7          	jalr	1528(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 13; i++) {
    80004098:	0014849b          	addiw	s1,s1,1
    8000409c:	0ff4f493          	andi	s1,s1,255
    800040a0:	00c00793          	li	a5,12
    800040a4:	fc97f0e3          	bgeu	a5,s1,80004064 <_ZL11workerBodyDPv+0x20>
    }

    printString("D: dispatch\n");
    800040a8:	00006517          	auipc	a0,0x6
    800040ac:	0c050513          	addi	a0,a0,192 # 8000a168 <CONSOLE_STATUS+0x158>
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	5d8080e7          	jalr	1496(ra) # 80003688 <_Z11printStringPKc>
    __asm__ ("li t1, 5");
    800040b8:	00500313          	li	t1,5
    thread_dispatch();
    800040bc:	00001097          	auipc	ra,0x1
    800040c0:	990080e7          	jalr	-1648(ra) # 80004a4c <thread_dispatch>

    uint64 result = fibonacci(16);
    800040c4:	01000513          	li	a0,16
    800040c8:	00000097          	auipc	ra,0x0
    800040cc:	f08080e7          	jalr	-248(ra) # 80003fd0 <_ZL9fibonaccim>
    800040d0:	00050913          	mv	s2,a0
    printString("D: fibonaci="); printInt(result); printString("\n");
    800040d4:	00006517          	auipc	a0,0x6
    800040d8:	0a450513          	addi	a0,a0,164 # 8000a178 <CONSOLE_STATUS+0x168>
    800040dc:	fffff097          	auipc	ra,0xfffff
    800040e0:	5ac080e7          	jalr	1452(ra) # 80003688 <_Z11printStringPKc>
    800040e4:	00000613          	li	a2,0
    800040e8:	00a00593          	li	a1,10
    800040ec:	0009051b          	sext.w	a0,s2
    800040f0:	fffff097          	auipc	ra,0xfffff
    800040f4:	748080e7          	jalr	1864(ra) # 80003838 <_Z8printIntiii>
    800040f8:	00006517          	auipc	a0,0x6
    800040fc:	25850513          	addi	a0,a0,600 # 8000a350 <CONSOLE_STATUS+0x340>
    80004100:	fffff097          	auipc	ra,0xfffff
    80004104:	588080e7          	jalr	1416(ra) # 80003688 <_Z11printStringPKc>
    80004108:	0400006f          	j	80004148 <_ZL11workerBodyDPv+0x104>

    for (; i < 16; i++) {
        printString("D: i="); printInt(i); printString("\n");
    8000410c:	00006517          	auipc	a0,0x6
    80004110:	05450513          	addi	a0,a0,84 # 8000a160 <CONSOLE_STATUS+0x150>
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	574080e7          	jalr	1396(ra) # 80003688 <_Z11printStringPKc>
    8000411c:	00000613          	li	a2,0
    80004120:	00a00593          	li	a1,10
    80004124:	00048513          	mv	a0,s1
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	710080e7          	jalr	1808(ra) # 80003838 <_Z8printIntiii>
    80004130:	00006517          	auipc	a0,0x6
    80004134:	22050513          	addi	a0,a0,544 # 8000a350 <CONSOLE_STATUS+0x340>
    80004138:	fffff097          	auipc	ra,0xfffff
    8000413c:	550080e7          	jalr	1360(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 16; i++) {
    80004140:	0014849b          	addiw	s1,s1,1
    80004144:	0ff4f493          	andi	s1,s1,255
    80004148:	00f00793          	li	a5,15
    8000414c:	fc97f0e3          	bgeu	a5,s1,8000410c <_ZL11workerBodyDPv+0xc8>
    }

    printString("D finished!\n");
    80004150:	00006517          	auipc	a0,0x6
    80004154:	03850513          	addi	a0,a0,56 # 8000a188 <CONSOLE_STATUS+0x178>
    80004158:	fffff097          	auipc	ra,0xfffff
    8000415c:	530080e7          	jalr	1328(ra) # 80003688 <_Z11printStringPKc>
    finishedD = true;
    80004160:	00100793          	li	a5,1
    80004164:	00009717          	auipc	a4,0x9
    80004168:	d8f70b23          	sb	a5,-618(a4) # 8000cefa <_ZL9finishedD>
    thread_dispatch();
    8000416c:	00001097          	auipc	ra,0x1
    80004170:	8e0080e7          	jalr	-1824(ra) # 80004a4c <thread_dispatch>
}
    80004174:	01813083          	ld	ra,24(sp)
    80004178:	01013403          	ld	s0,16(sp)
    8000417c:	00813483          	ld	s1,8(sp)
    80004180:	00013903          	ld	s2,0(sp)
    80004184:	02010113          	addi	sp,sp,32
    80004188:	00008067          	ret

000000008000418c <_ZL11workerBodyCPv>:
static void workerBodyC(void* arg) {
    8000418c:	fe010113          	addi	sp,sp,-32
    80004190:	00113c23          	sd	ra,24(sp)
    80004194:	00813823          	sd	s0,16(sp)
    80004198:	00913423          	sd	s1,8(sp)
    8000419c:	01213023          	sd	s2,0(sp)
    800041a0:	02010413          	addi	s0,sp,32
    uint8 i = 0;
    800041a4:	00000493          	li	s1,0
    800041a8:	0400006f          	j	800041e8 <_ZL11workerBodyCPv+0x5c>
        printString("C: i="); printInt(i); printString("\n");
    800041ac:	00006517          	auipc	a0,0x6
    800041b0:	f8450513          	addi	a0,a0,-124 # 8000a130 <CONSOLE_STATUS+0x120>
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	4d4080e7          	jalr	1236(ra) # 80003688 <_Z11printStringPKc>
    800041bc:	00000613          	li	a2,0
    800041c0:	00a00593          	li	a1,10
    800041c4:	00048513          	mv	a0,s1
    800041c8:	fffff097          	auipc	ra,0xfffff
    800041cc:	670080e7          	jalr	1648(ra) # 80003838 <_Z8printIntiii>
    800041d0:	00006517          	auipc	a0,0x6
    800041d4:	18050513          	addi	a0,a0,384 # 8000a350 <CONSOLE_STATUS+0x340>
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	4b0080e7          	jalr	1200(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 3; i++) {
    800041e0:	0014849b          	addiw	s1,s1,1
    800041e4:	0ff4f493          	andi	s1,s1,255
    800041e8:	00200793          	li	a5,2
    800041ec:	fc97f0e3          	bgeu	a5,s1,800041ac <_ZL11workerBodyCPv+0x20>
    printString("C: dispatch\n");
    800041f0:	00006517          	auipc	a0,0x6
    800041f4:	f4850513          	addi	a0,a0,-184 # 8000a138 <CONSOLE_STATUS+0x128>
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	490080e7          	jalr	1168(ra) # 80003688 <_Z11printStringPKc>
    __asm__ ("li t1, 7");
    80004200:	00700313          	li	t1,7
    thread_dispatch();
    80004204:	00001097          	auipc	ra,0x1
    80004208:	848080e7          	jalr	-1976(ra) # 80004a4c <thread_dispatch>
    __asm__ ("mv %[t1], t1" : [t1] "=r"(t1));
    8000420c:	00030913          	mv	s2,t1
    printString("C: t1="); printInt(t1); printString("\n");
    80004210:	00006517          	auipc	a0,0x6
    80004214:	f3850513          	addi	a0,a0,-200 # 8000a148 <CONSOLE_STATUS+0x138>
    80004218:	fffff097          	auipc	ra,0xfffff
    8000421c:	470080e7          	jalr	1136(ra) # 80003688 <_Z11printStringPKc>
    80004220:	00000613          	li	a2,0
    80004224:	00a00593          	li	a1,10
    80004228:	0009051b          	sext.w	a0,s2
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	60c080e7          	jalr	1548(ra) # 80003838 <_Z8printIntiii>
    80004234:	00006517          	auipc	a0,0x6
    80004238:	11c50513          	addi	a0,a0,284 # 8000a350 <CONSOLE_STATUS+0x340>
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	44c080e7          	jalr	1100(ra) # 80003688 <_Z11printStringPKc>
    uint64 result = fibonacci(12);
    80004244:	00c00513          	li	a0,12
    80004248:	00000097          	auipc	ra,0x0
    8000424c:	d88080e7          	jalr	-632(ra) # 80003fd0 <_ZL9fibonaccim>
    80004250:	00050913          	mv	s2,a0
    printString("C: fibonaci="); printInt(result); printString("\n");
    80004254:	00006517          	auipc	a0,0x6
    80004258:	efc50513          	addi	a0,a0,-260 # 8000a150 <CONSOLE_STATUS+0x140>
    8000425c:	fffff097          	auipc	ra,0xfffff
    80004260:	42c080e7          	jalr	1068(ra) # 80003688 <_Z11printStringPKc>
    80004264:	00000613          	li	a2,0
    80004268:	00a00593          	li	a1,10
    8000426c:	0009051b          	sext.w	a0,s2
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	5c8080e7          	jalr	1480(ra) # 80003838 <_Z8printIntiii>
    80004278:	00006517          	auipc	a0,0x6
    8000427c:	0d850513          	addi	a0,a0,216 # 8000a350 <CONSOLE_STATUS+0x340>
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	408080e7          	jalr	1032(ra) # 80003688 <_Z11printStringPKc>
    80004288:	0400006f          	j	800042c8 <_ZL11workerBodyCPv+0x13c>
        printString("C: i="); printInt(i); printString("\n");
    8000428c:	00006517          	auipc	a0,0x6
    80004290:	ea450513          	addi	a0,a0,-348 # 8000a130 <CONSOLE_STATUS+0x120>
    80004294:	fffff097          	auipc	ra,0xfffff
    80004298:	3f4080e7          	jalr	1012(ra) # 80003688 <_Z11printStringPKc>
    8000429c:	00000613          	li	a2,0
    800042a0:	00a00593          	li	a1,10
    800042a4:	00048513          	mv	a0,s1
    800042a8:	fffff097          	auipc	ra,0xfffff
    800042ac:	590080e7          	jalr	1424(ra) # 80003838 <_Z8printIntiii>
    800042b0:	00006517          	auipc	a0,0x6
    800042b4:	0a050513          	addi	a0,a0,160 # 8000a350 <CONSOLE_STATUS+0x340>
    800042b8:	fffff097          	auipc	ra,0xfffff
    800042bc:	3d0080e7          	jalr	976(ra) # 80003688 <_Z11printStringPKc>
    for (; i < 6; i++) {
    800042c0:	0014849b          	addiw	s1,s1,1
    800042c4:	0ff4f493          	andi	s1,s1,255
    800042c8:	00500793          	li	a5,5
    800042cc:	fc97f0e3          	bgeu	a5,s1,8000428c <_ZL11workerBodyCPv+0x100>
    printString("A finished!\n");
    800042d0:	00006517          	auipc	a0,0x6
    800042d4:	e3850513          	addi	a0,a0,-456 # 8000a108 <CONSOLE_STATUS+0xf8>
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	3b0080e7          	jalr	944(ra) # 80003688 <_Z11printStringPKc>
    finishedC = true;
    800042e0:	00100793          	li	a5,1
    800042e4:	00009717          	auipc	a4,0x9
    800042e8:	c0f70ba3          	sb	a5,-1001(a4) # 8000cefb <_ZL9finishedC>
    thread_dispatch();
    800042ec:	00000097          	auipc	ra,0x0
    800042f0:	760080e7          	jalr	1888(ra) # 80004a4c <thread_dispatch>
}
    800042f4:	01813083          	ld	ra,24(sp)
    800042f8:	01013403          	ld	s0,16(sp)
    800042fc:	00813483          	ld	s1,8(sp)
    80004300:	00013903          	ld	s2,0(sp)
    80004304:	02010113          	addi	sp,sp,32
    80004308:	00008067          	ret

000000008000430c <_ZL11workerBodyBPv>:
static void workerBodyB(void* arg) {
    8000430c:	fe010113          	addi	sp,sp,-32
    80004310:	00113c23          	sd	ra,24(sp)
    80004314:	00813823          	sd	s0,16(sp)
    80004318:	00913423          	sd	s1,8(sp)
    8000431c:	01213023          	sd	s2,0(sp)
    80004320:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 16; i++) {
    80004324:	00000913          	li	s2,0
    80004328:	0400006f          	j	80004368 <_ZL11workerBodyBPv+0x5c>
            thread_dispatch();
    8000432c:	00000097          	auipc	ra,0x0
    80004330:	720080e7          	jalr	1824(ra) # 80004a4c <thread_dispatch>
        for (uint64 j = 0; j < 10000; j++) {
    80004334:	00148493          	addi	s1,s1,1
    80004338:	000027b7          	lui	a5,0x2
    8000433c:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80004340:	0097ee63          	bltu	a5,s1,8000435c <_ZL11workerBodyBPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80004344:	00000713          	li	a4,0
    80004348:	000077b7          	lui	a5,0x7
    8000434c:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80004350:	fce7eee3          	bltu	a5,a4,8000432c <_ZL11workerBodyBPv+0x20>
    80004354:	00170713          	addi	a4,a4,1
    80004358:	ff1ff06f          	j	80004348 <_ZL11workerBodyBPv+0x3c>
        if (i == 10) {
    8000435c:	00a00793          	li	a5,10
    80004360:	04f90663          	beq	s2,a5,800043ac <_ZL11workerBodyBPv+0xa0>
    for (uint64 i = 0; i < 16; i++) {
    80004364:	00190913          	addi	s2,s2,1
    80004368:	00f00793          	li	a5,15
    8000436c:	0527e463          	bltu	a5,s2,800043b4 <_ZL11workerBodyBPv+0xa8>
        printString("B: i="); printInt(i); printString("\n");
    80004370:	00006517          	auipc	a0,0x6
    80004374:	da850513          	addi	a0,a0,-600 # 8000a118 <CONSOLE_STATUS+0x108>
    80004378:	fffff097          	auipc	ra,0xfffff
    8000437c:	310080e7          	jalr	784(ra) # 80003688 <_Z11printStringPKc>
    80004380:	00000613          	li	a2,0
    80004384:	00a00593          	li	a1,10
    80004388:	0009051b          	sext.w	a0,s2
    8000438c:	fffff097          	auipc	ra,0xfffff
    80004390:	4ac080e7          	jalr	1196(ra) # 80003838 <_Z8printIntiii>
    80004394:	00006517          	auipc	a0,0x6
    80004398:	fbc50513          	addi	a0,a0,-68 # 8000a350 <CONSOLE_STATUS+0x340>
    8000439c:	fffff097          	auipc	ra,0xfffff
    800043a0:	2ec080e7          	jalr	748(ra) # 80003688 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    800043a4:	00000493          	li	s1,0
    800043a8:	f91ff06f          	j	80004338 <_ZL11workerBodyBPv+0x2c>
            asm volatile("csrr t6, sepc");
    800043ac:	14102ff3          	csrr	t6,sepc
    800043b0:	fb5ff06f          	j	80004364 <_ZL11workerBodyBPv+0x58>
    printString("B finished!\n");
    800043b4:	00006517          	auipc	a0,0x6
    800043b8:	d6c50513          	addi	a0,a0,-660 # 8000a120 <CONSOLE_STATUS+0x110>
    800043bc:	fffff097          	auipc	ra,0xfffff
    800043c0:	2cc080e7          	jalr	716(ra) # 80003688 <_Z11printStringPKc>
    finishedB = true;
    800043c4:	00100793          	li	a5,1
    800043c8:	00009717          	auipc	a4,0x9
    800043cc:	b2f70a23          	sb	a5,-1228(a4) # 8000cefc <_ZL9finishedB>
    thread_dispatch();
    800043d0:	00000097          	auipc	ra,0x0
    800043d4:	67c080e7          	jalr	1660(ra) # 80004a4c <thread_dispatch>
}
    800043d8:	01813083          	ld	ra,24(sp)
    800043dc:	01013403          	ld	s0,16(sp)
    800043e0:	00813483          	ld	s1,8(sp)
    800043e4:	00013903          	ld	s2,0(sp)
    800043e8:	02010113          	addi	sp,sp,32
    800043ec:	00008067          	ret

00000000800043f0 <_ZL11workerBodyAPv>:
static void workerBodyA(void* arg) {
    800043f0:	fe010113          	addi	sp,sp,-32
    800043f4:	00113c23          	sd	ra,24(sp)
    800043f8:	00813823          	sd	s0,16(sp)
    800043fc:	00913423          	sd	s1,8(sp)
    80004400:	01213023          	sd	s2,0(sp)
    80004404:	02010413          	addi	s0,sp,32
    for (uint64 i = 0; i < 10; i++) {
    80004408:	00000913          	li	s2,0
    8000440c:	0380006f          	j	80004444 <_ZL11workerBodyAPv+0x54>
            thread_dispatch();
    80004410:	00000097          	auipc	ra,0x0
    80004414:	63c080e7          	jalr	1596(ra) # 80004a4c <thread_dispatch>
        for (uint64 j = 0; j < 10000; j++) {
    80004418:	00148493          	addi	s1,s1,1
    8000441c:	000027b7          	lui	a5,0x2
    80004420:	70f78793          	addi	a5,a5,1807 # 270f <_entry-0x7fffd8f1>
    80004424:	0097ee63          	bltu	a5,s1,80004440 <_ZL11workerBodyAPv+0x50>
            for (uint64 k = 0; k < 30000; k++) { /* busy wait */ }
    80004428:	00000713          	li	a4,0
    8000442c:	000077b7          	lui	a5,0x7
    80004430:	52f78793          	addi	a5,a5,1327 # 752f <_entry-0x7fff8ad1>
    80004434:	fce7eee3          	bltu	a5,a4,80004410 <_ZL11workerBodyAPv+0x20>
    80004438:	00170713          	addi	a4,a4,1
    8000443c:	ff1ff06f          	j	8000442c <_ZL11workerBodyAPv+0x3c>
    for (uint64 i = 0; i < 10; i++) {
    80004440:	00190913          	addi	s2,s2,1
    80004444:	00900793          	li	a5,9
    80004448:	0527e063          	bltu	a5,s2,80004488 <_ZL11workerBodyAPv+0x98>
        printString("A: i="); printInt(i); printString("\n");
    8000444c:	00006517          	auipc	a0,0x6
    80004450:	cb450513          	addi	a0,a0,-844 # 8000a100 <CONSOLE_STATUS+0xf0>
    80004454:	fffff097          	auipc	ra,0xfffff
    80004458:	234080e7          	jalr	564(ra) # 80003688 <_Z11printStringPKc>
    8000445c:	00000613          	li	a2,0
    80004460:	00a00593          	li	a1,10
    80004464:	0009051b          	sext.w	a0,s2
    80004468:	fffff097          	auipc	ra,0xfffff
    8000446c:	3d0080e7          	jalr	976(ra) # 80003838 <_Z8printIntiii>
    80004470:	00006517          	auipc	a0,0x6
    80004474:	ee050513          	addi	a0,a0,-288 # 8000a350 <CONSOLE_STATUS+0x340>
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	210080e7          	jalr	528(ra) # 80003688 <_Z11printStringPKc>
        for (uint64 j = 0; j < 10000; j++) {
    80004480:	00000493          	li	s1,0
    80004484:	f99ff06f          	j	8000441c <_ZL11workerBodyAPv+0x2c>
    printString("A finished!\n");
    80004488:	00006517          	auipc	a0,0x6
    8000448c:	c8050513          	addi	a0,a0,-896 # 8000a108 <CONSOLE_STATUS+0xf8>
    80004490:	fffff097          	auipc	ra,0xfffff
    80004494:	1f8080e7          	jalr	504(ra) # 80003688 <_Z11printStringPKc>
    finishedA = true;
    80004498:	00100793          	li	a5,1
    8000449c:	00009717          	auipc	a4,0x9
    800044a0:	a6f700a3          	sb	a5,-1439(a4) # 8000cefd <_ZL9finishedA>
}
    800044a4:	01813083          	ld	ra,24(sp)
    800044a8:	01013403          	ld	s0,16(sp)
    800044ac:	00813483          	ld	s1,8(sp)
    800044b0:	00013903          	ld	s2,0(sp)
    800044b4:	02010113          	addi	sp,sp,32
    800044b8:	00008067          	ret

00000000800044bc <_Z16System_Mode_testv>:


void System_Mode_test() {
    800044bc:	fd010113          	addi	sp,sp,-48
    800044c0:	02113423          	sd	ra,40(sp)
    800044c4:	02813023          	sd	s0,32(sp)
    800044c8:	03010413          	addi	s0,sp,48
    thread_t threads[4];
    thread_create(&threads[0], workerBodyA, nullptr);
    800044cc:	00000613          	li	a2,0
    800044d0:	00000597          	auipc	a1,0x0
    800044d4:	f2058593          	addi	a1,a1,-224 # 800043f0 <_ZL11workerBodyAPv>
    800044d8:	fd040513          	addi	a0,s0,-48
    800044dc:	00000097          	auipc	ra,0x0
    800044e0:	4b4080e7          	jalr	1204(ra) # 80004990 <thread_create>
    printString("ThreadA created\n");
    800044e4:	00006517          	auipc	a0,0x6
    800044e8:	cb450513          	addi	a0,a0,-844 # 8000a198 <CONSOLE_STATUS+0x188>
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	19c080e7          	jalr	412(ra) # 80003688 <_Z11printStringPKc>

    thread_create(&threads[1], workerBodyB, nullptr);
    800044f4:	00000613          	li	a2,0
    800044f8:	00000597          	auipc	a1,0x0
    800044fc:	e1458593          	addi	a1,a1,-492 # 8000430c <_ZL11workerBodyBPv>
    80004500:	fd840513          	addi	a0,s0,-40
    80004504:	00000097          	auipc	ra,0x0
    80004508:	48c080e7          	jalr	1164(ra) # 80004990 <thread_create>
    printString("ThreadB created\n");
    8000450c:	00006517          	auipc	a0,0x6
    80004510:	ca450513          	addi	a0,a0,-860 # 8000a1b0 <CONSOLE_STATUS+0x1a0>
    80004514:	fffff097          	auipc	ra,0xfffff
    80004518:	174080e7          	jalr	372(ra) # 80003688 <_Z11printStringPKc>

    thread_create(&threads[2], workerBodyC, nullptr);
    8000451c:	00000613          	li	a2,0
    80004520:	00000597          	auipc	a1,0x0
    80004524:	c6c58593          	addi	a1,a1,-916 # 8000418c <_ZL11workerBodyCPv>
    80004528:	fe040513          	addi	a0,s0,-32
    8000452c:	00000097          	auipc	ra,0x0
    80004530:	464080e7          	jalr	1124(ra) # 80004990 <thread_create>
    printString("ThreadC created\n");
    80004534:	00006517          	auipc	a0,0x6
    80004538:	c9450513          	addi	a0,a0,-876 # 8000a1c8 <CONSOLE_STATUS+0x1b8>
    8000453c:	fffff097          	auipc	ra,0xfffff
    80004540:	14c080e7          	jalr	332(ra) # 80003688 <_Z11printStringPKc>

    thread_create(&threads[3], workerBodyD, nullptr);
    80004544:	00000613          	li	a2,0
    80004548:	00000597          	auipc	a1,0x0
    8000454c:	afc58593          	addi	a1,a1,-1284 # 80004044 <_ZL11workerBodyDPv>
    80004550:	fe840513          	addi	a0,s0,-24
    80004554:	00000097          	auipc	ra,0x0
    80004558:	43c080e7          	jalr	1084(ra) # 80004990 <thread_create>
    printString("ThreadD created\n");
    8000455c:	00006517          	auipc	a0,0x6
    80004560:	c8450513          	addi	a0,a0,-892 # 8000a1e0 <CONSOLE_STATUS+0x1d0>
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	124080e7          	jalr	292(ra) # 80003688 <_Z11printStringPKc>
    8000456c:	00c0006f          	j	80004578 <_Z16System_Mode_testv+0xbc>

    while (!(finishedA && finishedB && finishedC && finishedD)) {
        thread_dispatch();
    80004570:	00000097          	auipc	ra,0x0
    80004574:	4dc080e7          	jalr	1244(ra) # 80004a4c <thread_dispatch>
    while (!(finishedA && finishedB && finishedC && finishedD)) {
    80004578:	00009797          	auipc	a5,0x9
    8000457c:	9857c783          	lbu	a5,-1659(a5) # 8000cefd <_ZL9finishedA>
    80004580:	fe0788e3          	beqz	a5,80004570 <_Z16System_Mode_testv+0xb4>
    80004584:	00009797          	auipc	a5,0x9
    80004588:	9787c783          	lbu	a5,-1672(a5) # 8000cefc <_ZL9finishedB>
    8000458c:	fe0782e3          	beqz	a5,80004570 <_Z16System_Mode_testv+0xb4>
    80004590:	00009797          	auipc	a5,0x9
    80004594:	96b7c783          	lbu	a5,-1685(a5) # 8000cefb <_ZL9finishedC>
    80004598:	fc078ce3          	beqz	a5,80004570 <_Z16System_Mode_testv+0xb4>
    8000459c:	00009797          	auipc	a5,0x9
    800045a0:	95e7c783          	lbu	a5,-1698(a5) # 8000cefa <_ZL9finishedD>
    800045a4:	fc0786e3          	beqz	a5,80004570 <_Z16System_Mode_testv+0xb4>
    }

}
    800045a8:	02813083          	ld	ra,40(sp)
    800045ac:	02013403          	ld	s0,32(sp)
    800045b0:	03010113          	addi	sp,sp,48
    800045b4:	00008067          	ret

00000000800045b8 <_ZN6BufferC1Ei>:
#include "buffer.hpp"

Buffer::Buffer(int _cap) : cap(_cap + 1), head(0), tail(0) {
    800045b8:	fe010113          	addi	sp,sp,-32
    800045bc:	00113c23          	sd	ra,24(sp)
    800045c0:	00813823          	sd	s0,16(sp)
    800045c4:	00913423          	sd	s1,8(sp)
    800045c8:	01213023          	sd	s2,0(sp)
    800045cc:	02010413          	addi	s0,sp,32
    800045d0:	00050493          	mv	s1,a0
    800045d4:	00058913          	mv	s2,a1
    800045d8:	0015879b          	addiw	a5,a1,1
    800045dc:	0007851b          	sext.w	a0,a5
    800045e0:	00f4a023          	sw	a5,0(s1)
    800045e4:	0004a823          	sw	zero,16(s1)
    800045e8:	0004aa23          	sw	zero,20(s1)
    buffer = (int *)mem_alloc(sizeof(int) * cap);
    800045ec:	00251513          	slli	a0,a0,0x2
    800045f0:	00000097          	auipc	ra,0x0
    800045f4:	318080e7          	jalr	792(ra) # 80004908 <mem_alloc>
    800045f8:	00a4b423          	sd	a0,8(s1)
    sem_open(&itemAvailable, 0);
    800045fc:	00000593          	li	a1,0
    80004600:	02048513          	addi	a0,s1,32
    80004604:	00000097          	auipc	ra,0x0
    80004608:	484080e7          	jalr	1156(ra) # 80004a88 <sem_open>
    sem_open(&spaceAvailable, _cap);
    8000460c:	00090593          	mv	a1,s2
    80004610:	01848513          	addi	a0,s1,24
    80004614:	00000097          	auipc	ra,0x0
    80004618:	474080e7          	jalr	1140(ra) # 80004a88 <sem_open>
    sem_open(&mutexHead, 1);
    8000461c:	00100593          	li	a1,1
    80004620:	02848513          	addi	a0,s1,40
    80004624:	00000097          	auipc	ra,0x0
    80004628:	464080e7          	jalr	1124(ra) # 80004a88 <sem_open>
    sem_open(&mutexTail, 1);
    8000462c:	00100593          	li	a1,1
    80004630:	03048513          	addi	a0,s1,48
    80004634:	00000097          	auipc	ra,0x0
    80004638:	454080e7          	jalr	1108(ra) # 80004a88 <sem_open>
}
    8000463c:	01813083          	ld	ra,24(sp)
    80004640:	01013403          	ld	s0,16(sp)
    80004644:	00813483          	ld	s1,8(sp)
    80004648:	00013903          	ld	s2,0(sp)
    8000464c:	02010113          	addi	sp,sp,32
    80004650:	00008067          	ret

0000000080004654 <_ZN6Buffer3putEi>:
    sem_close(spaceAvailable);
    sem_close(mutexTail);
    sem_close(mutexHead);
}

void Buffer::put(int val) {
    80004654:	fe010113          	addi	sp,sp,-32
    80004658:	00113c23          	sd	ra,24(sp)
    8000465c:	00813823          	sd	s0,16(sp)
    80004660:	00913423          	sd	s1,8(sp)
    80004664:	01213023          	sd	s2,0(sp)
    80004668:	02010413          	addi	s0,sp,32
    8000466c:	00050493          	mv	s1,a0
    80004670:	00058913          	mv	s2,a1
    sem_wait(spaceAvailable);
    80004674:	01853503          	ld	a0,24(a0)
    80004678:	00000097          	auipc	ra,0x0
    8000467c:	494080e7          	jalr	1172(ra) # 80004b0c <sem_wait>

    sem_wait(mutexTail);
    80004680:	0304b503          	ld	a0,48(s1)
    80004684:	00000097          	auipc	ra,0x0
    80004688:	488080e7          	jalr	1160(ra) # 80004b0c <sem_wait>
    buffer[tail] = val;
    8000468c:	0084b783          	ld	a5,8(s1)
    80004690:	0144a703          	lw	a4,20(s1)
    80004694:	00271713          	slli	a4,a4,0x2
    80004698:	00e787b3          	add	a5,a5,a4
    8000469c:	0127a023          	sw	s2,0(a5)
    tail = (tail + 1) % cap;
    800046a0:	0144a783          	lw	a5,20(s1)
    800046a4:	0017879b          	addiw	a5,a5,1
    800046a8:	0004a703          	lw	a4,0(s1)
    800046ac:	02e7e7bb          	remw	a5,a5,a4
    800046b0:	00f4aa23          	sw	a5,20(s1)
    sem_signal(mutexTail);
    800046b4:	0304b503          	ld	a0,48(s1)
    800046b8:	00000097          	auipc	ra,0x0
    800046bc:	494080e7          	jalr	1172(ra) # 80004b4c <sem_signal>

    sem_signal(itemAvailable);
    800046c0:	0204b503          	ld	a0,32(s1)
    800046c4:	00000097          	auipc	ra,0x0
    800046c8:	488080e7          	jalr	1160(ra) # 80004b4c <sem_signal>

}
    800046cc:	01813083          	ld	ra,24(sp)
    800046d0:	01013403          	ld	s0,16(sp)
    800046d4:	00813483          	ld	s1,8(sp)
    800046d8:	00013903          	ld	s2,0(sp)
    800046dc:	02010113          	addi	sp,sp,32
    800046e0:	00008067          	ret

00000000800046e4 <_ZN6Buffer3getEv>:

int Buffer::get() {
    800046e4:	fe010113          	addi	sp,sp,-32
    800046e8:	00113c23          	sd	ra,24(sp)
    800046ec:	00813823          	sd	s0,16(sp)
    800046f0:	00913423          	sd	s1,8(sp)
    800046f4:	01213023          	sd	s2,0(sp)
    800046f8:	02010413          	addi	s0,sp,32
    800046fc:	00050493          	mv	s1,a0
    sem_wait(itemAvailable);
    80004700:	02053503          	ld	a0,32(a0)
    80004704:	00000097          	auipc	ra,0x0
    80004708:	408080e7          	jalr	1032(ra) # 80004b0c <sem_wait>

    sem_wait(mutexHead);
    8000470c:	0284b503          	ld	a0,40(s1)
    80004710:	00000097          	auipc	ra,0x0
    80004714:	3fc080e7          	jalr	1020(ra) # 80004b0c <sem_wait>

    int ret = buffer[head];
    80004718:	0084b703          	ld	a4,8(s1)
    8000471c:	0104a783          	lw	a5,16(s1)
    80004720:	00279693          	slli	a3,a5,0x2
    80004724:	00d70733          	add	a4,a4,a3
    80004728:	00072903          	lw	s2,0(a4)
    head = (head + 1) % cap;
    8000472c:	0017879b          	addiw	a5,a5,1
    80004730:	0004a703          	lw	a4,0(s1)
    80004734:	02e7e7bb          	remw	a5,a5,a4
    80004738:	00f4a823          	sw	a5,16(s1)
    sem_signal(mutexHead);
    8000473c:	0284b503          	ld	a0,40(s1)
    80004740:	00000097          	auipc	ra,0x0
    80004744:	40c080e7          	jalr	1036(ra) # 80004b4c <sem_signal>

    sem_signal(spaceAvailable);
    80004748:	0184b503          	ld	a0,24(s1)
    8000474c:	00000097          	auipc	ra,0x0
    80004750:	400080e7          	jalr	1024(ra) # 80004b4c <sem_signal>

    return ret;
}
    80004754:	00090513          	mv	a0,s2
    80004758:	01813083          	ld	ra,24(sp)
    8000475c:	01013403          	ld	s0,16(sp)
    80004760:	00813483          	ld	s1,8(sp)
    80004764:	00013903          	ld	s2,0(sp)
    80004768:	02010113          	addi	sp,sp,32
    8000476c:	00008067          	ret

0000000080004770 <_ZN6Buffer6getCntEv>:

int Buffer::getCnt() {
    80004770:	fe010113          	addi	sp,sp,-32
    80004774:	00113c23          	sd	ra,24(sp)
    80004778:	00813823          	sd	s0,16(sp)
    8000477c:	00913423          	sd	s1,8(sp)
    80004780:	01213023          	sd	s2,0(sp)
    80004784:	02010413          	addi	s0,sp,32
    80004788:	00050493          	mv	s1,a0
    int ret;

    sem_wait(mutexHead);
    8000478c:	02853503          	ld	a0,40(a0)
    80004790:	00000097          	auipc	ra,0x0
    80004794:	37c080e7          	jalr	892(ra) # 80004b0c <sem_wait>
    sem_wait(mutexTail);
    80004798:	0304b503          	ld	a0,48(s1)
    8000479c:	00000097          	auipc	ra,0x0
    800047a0:	370080e7          	jalr	880(ra) # 80004b0c <sem_wait>

    if (tail >= head) {
    800047a4:	0144a783          	lw	a5,20(s1)
    800047a8:	0104a903          	lw	s2,16(s1)
    800047ac:	0327ce63          	blt	a5,s2,800047e8 <_ZN6Buffer6getCntEv+0x78>
        ret = tail - head;
    800047b0:	4127893b          	subw	s2,a5,s2
    } else {
        ret = cap - head + tail;
    }

    sem_signal(mutexTail);
    800047b4:	0304b503          	ld	a0,48(s1)
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	394080e7          	jalr	916(ra) # 80004b4c <sem_signal>
    sem_signal(mutexHead);
    800047c0:	0284b503          	ld	a0,40(s1)
    800047c4:	00000097          	auipc	ra,0x0
    800047c8:	388080e7          	jalr	904(ra) # 80004b4c <sem_signal>

    return ret;
}
    800047cc:	00090513          	mv	a0,s2
    800047d0:	01813083          	ld	ra,24(sp)
    800047d4:	01013403          	ld	s0,16(sp)
    800047d8:	00813483          	ld	s1,8(sp)
    800047dc:	00013903          	ld	s2,0(sp)
    800047e0:	02010113          	addi	sp,sp,32
    800047e4:	00008067          	ret
        ret = cap - head + tail;
    800047e8:	0004a703          	lw	a4,0(s1)
    800047ec:	4127093b          	subw	s2,a4,s2
    800047f0:	00f9093b          	addw	s2,s2,a5
    800047f4:	fc1ff06f          	j	800047b4 <_ZN6Buffer6getCntEv+0x44>

00000000800047f8 <_ZN6BufferD1Ev>:
Buffer::~Buffer() {
    800047f8:	fe010113          	addi	sp,sp,-32
    800047fc:	00113c23          	sd	ra,24(sp)
    80004800:	00813823          	sd	s0,16(sp)
    80004804:	00913423          	sd	s1,8(sp)
    80004808:	02010413          	addi	s0,sp,32
    8000480c:	00050493          	mv	s1,a0
    putc('\n');
    80004810:	00a00513          	li	a0,10
    80004814:	00000097          	auipc	ra,0x0
    80004818:	490080e7          	jalr	1168(ra) # 80004ca4 <putc>
    printString("Buffer deleted!\n");
    8000481c:	00006517          	auipc	a0,0x6
    80004820:	9dc50513          	addi	a0,a0,-1572 # 8000a1f8 <CONSOLE_STATUS+0x1e8>
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	e64080e7          	jalr	-412(ra) # 80003688 <_Z11printStringPKc>
    while (getCnt() > 0) {
    8000482c:	00048513          	mv	a0,s1
    80004830:	00000097          	auipc	ra,0x0
    80004834:	f40080e7          	jalr	-192(ra) # 80004770 <_ZN6Buffer6getCntEv>
    80004838:	02a05c63          	blez	a0,80004870 <_ZN6BufferD1Ev+0x78>
        char ch = buffer[head];
    8000483c:	0084b783          	ld	a5,8(s1)
    80004840:	0104a703          	lw	a4,16(s1)
    80004844:	00271713          	slli	a4,a4,0x2
    80004848:	00e787b3          	add	a5,a5,a4
        putc(ch);
    8000484c:	0007c503          	lbu	a0,0(a5)
    80004850:	00000097          	auipc	ra,0x0
    80004854:	454080e7          	jalr	1108(ra) # 80004ca4 <putc>
        head = (head + 1) % cap;
    80004858:	0104a783          	lw	a5,16(s1)
    8000485c:	0017879b          	addiw	a5,a5,1
    80004860:	0004a703          	lw	a4,0(s1)
    80004864:	02e7e7bb          	remw	a5,a5,a4
    80004868:	00f4a823          	sw	a5,16(s1)
    while (getCnt() > 0) {
    8000486c:	fc1ff06f          	j	8000482c <_ZN6BufferD1Ev+0x34>
    putc('!');
    80004870:	02100513          	li	a0,33
    80004874:	00000097          	auipc	ra,0x0
    80004878:	430080e7          	jalr	1072(ra) # 80004ca4 <putc>
    putc('\n');
    8000487c:	00a00513          	li	a0,10
    80004880:	00000097          	auipc	ra,0x0
    80004884:	424080e7          	jalr	1060(ra) # 80004ca4 <putc>
    mem_free(buffer);
    80004888:	0084b503          	ld	a0,8(s1)
    8000488c:	00000097          	auipc	ra,0x0
    80004890:	0c4080e7          	jalr	196(ra) # 80004950 <mem_free>
    sem_close(itemAvailable);
    80004894:	0204b503          	ld	a0,32(s1)
    80004898:	00000097          	auipc	ra,0x0
    8000489c:	234080e7          	jalr	564(ra) # 80004acc <sem_close>
    sem_close(spaceAvailable);
    800048a0:	0184b503          	ld	a0,24(s1)
    800048a4:	00000097          	auipc	ra,0x0
    800048a8:	228080e7          	jalr	552(ra) # 80004acc <sem_close>
    sem_close(mutexTail);
    800048ac:	0304b503          	ld	a0,48(s1)
    800048b0:	00000097          	auipc	ra,0x0
    800048b4:	21c080e7          	jalr	540(ra) # 80004acc <sem_close>
    sem_close(mutexHead);
    800048b8:	0284b503          	ld	a0,40(s1)
    800048bc:	00000097          	auipc	ra,0x0
    800048c0:	210080e7          	jalr	528(ra) # 80004acc <sem_close>
}
    800048c4:	01813083          	ld	ra,24(sp)
    800048c8:	01013403          	ld	s0,16(sp)
    800048cc:	00813483          	ld	s1,8(sp)
    800048d0:	02010113          	addi	sp,sp,32
    800048d4:	00008067          	ret

00000000800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>:
#include "../inc/syscall_c.hpp"
#include "../inc/riscv.hpp" // included sysID, printingSupervisor


uint64 syscall_wrapper(sysID id, void* a1 = 0, void* a2 = 0, void* a3 = 0, void* a4 = 0){
    800048d8:	fe010113          	addi	sp,sp,-32
    800048dc:	00813c23          	sd	s0,24(sp)
    800048e0:	02010413          	addi	s0,sp,32

// ========================================================================


inline void Riscv::ecall() {
    __asm__ volatile ("ecall");
    800048e4:	00000073          	ecall
}

inline uint64 Riscv::r_a0() {
    uint64 volatile a0;
    __asm__ volatile ("mv %[a0], a0" : [a0] "=r"(a0));
    800048e8:	00050793          	mv	a5,a0
    800048ec:	fef43023          	sd	a5,-32(s0)
    return a0;
    800048f0:	fe043783          	ld	a5,-32(s0)
    /// arguments are implicitly stored in a0-a5 registers
    Riscv::ecall();
    uint64 volatile ret;
    ret = Riscv::r_a0();
    800048f4:	fef43423          	sd	a5,-24(s0)
    return ret;
    800048f8:	fe843503          	ld	a0,-24(s0)
}
    800048fc:	01813403          	ld	s0,24(sp)
    80004900:	02010113          	addi	sp,sp,32
    80004904:	00008067          	ret

0000000080004908 <mem_alloc>:

void *mem_alloc(size_t size) {
    80004908:	fe010113          	addi	sp,sp,-32
    8000490c:	00113c23          	sd	ra,24(sp)
    80004910:	00813823          	sd	s0,16(sp)
    80004914:	02010413          	addi	s0,sp,32
    uint64 volatile mem_in_blocks;
    mem_in_blocks = (size + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
    80004918:	03f50513          	addi	a0,a0,63
    8000491c:	00655513          	srli	a0,a0,0x6
    80004920:	fea43423          	sd	a0,-24(s0)
    return (void*) syscall_wrapper(sysID::MEM_ALLOC, (void*)mem_in_blocks);
    80004924:	fe843583          	ld	a1,-24(s0)
    80004928:	00000713          	li	a4,0
    8000492c:	00000693          	li	a3,0
    80004930:	00000613          	li	a2,0
    80004934:	00100513          	li	a0,1
    80004938:	00000097          	auipc	ra,0x0
    8000493c:	fa0080e7          	jalr	-96(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    80004940:	01813083          	ld	ra,24(sp)
    80004944:	01013403          	ld	s0,16(sp)
    80004948:	02010113          	addi	sp,sp,32
    8000494c:	00008067          	ret

0000000080004950 <mem_free>:

int mem_free(void *ptr) {
    80004950:	ff010113          	addi	sp,sp,-16
    80004954:	00113423          	sd	ra,8(sp)
    80004958:	00813023          	sd	s0,0(sp)
    8000495c:	01010413          	addi	s0,sp,16
    80004960:	00050593          	mv	a1,a0
    return (int)syscall_wrapper(sysID::MEM_FREE, ptr);
    80004964:	00000713          	li	a4,0
    80004968:	00000693          	li	a3,0
    8000496c:	00000613          	li	a2,0
    80004970:	00200513          	li	a0,2
    80004974:	00000097          	auipc	ra,0x0
    80004978:	f64080e7          	jalr	-156(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    8000497c:	0005051b          	sext.w	a0,a0
    80004980:	00813083          	ld	ra,8(sp)
    80004984:	00013403          	ld	s0,0(sp)
    80004988:	01010113          	addi	sp,sp,16
    8000498c:	00008067          	ret

0000000080004990 <thread_create>:

int thread_create(thread_t *handle, void (*start_routine)(void *), void *arg) {
    80004990:	fd010113          	addi	sp,sp,-48
    80004994:	02113423          	sd	ra,40(sp)
    80004998:	02813023          	sd	s0,32(sp)
    8000499c:	00913c23          	sd	s1,24(sp)
    800049a0:	01213823          	sd	s2,16(sp)
    800049a4:	01313423          	sd	s3,8(sp)
    800049a8:	03010413          	addi	s0,sp,48
    800049ac:	00050493          	mv	s1,a0
    800049b0:	00058913          	mv	s2,a1
    800049b4:	00060993          	mv	s3,a2
    void* stack_space = mem_alloc(DEFAULT_STACK_SIZE); /// allocate stack
    800049b8:	00001537          	lui	a0,0x1
    800049bc:	00000097          	auipc	ra,0x0
    800049c0:	f4c080e7          	jalr	-180(ra) # 80004908 <mem_alloc>
    if(!stack_space) return -1; /// no space for stack
    800049c4:	04050063          	beqz	a0,80004a04 <thread_create+0x74>
    800049c8:	00050713          	mv	a4,a0
    return (int) syscall_wrapper(sysID::THREAD_CREATE, (void *)handle,(void *)start_routine, arg, stack_space);
    800049cc:	00098693          	mv	a3,s3
    800049d0:	00090613          	mv	a2,s2
    800049d4:	00048593          	mv	a1,s1
    800049d8:	01100513          	li	a0,17
    800049dc:	00000097          	auipc	ra,0x0
    800049e0:	efc080e7          	jalr	-260(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
    800049e4:	0005051b          	sext.w	a0,a0
}
    800049e8:	02813083          	ld	ra,40(sp)
    800049ec:	02013403          	ld	s0,32(sp)
    800049f0:	01813483          	ld	s1,24(sp)
    800049f4:	01013903          	ld	s2,16(sp)
    800049f8:	00813983          	ld	s3,8(sp)
    800049fc:	03010113          	addi	sp,sp,48
    80004a00:	00008067          	ret
    if(!stack_space) return -1; /// no space for stack
    80004a04:	fff00513          	li	a0,-1
    80004a08:	fe1ff06f          	j	800049e8 <thread_create+0x58>

0000000080004a0c <thread_exit>:

int thread_exit() {
    80004a0c:	ff010113          	addi	sp,sp,-16
    80004a10:	00113423          	sd	ra,8(sp)
    80004a14:	00813023          	sd	s0,0(sp)
    80004a18:	01010413          	addi	s0,sp,16
    return (int) syscall_wrapper(sysID::THREAD_EXIT);
    80004a1c:	00000713          	li	a4,0
    80004a20:	00000693          	li	a3,0
    80004a24:	00000613          	li	a2,0
    80004a28:	00000593          	li	a1,0
    80004a2c:	01200513          	li	a0,18
    80004a30:	00000097          	auipc	ra,0x0
    80004a34:	ea8080e7          	jalr	-344(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    80004a38:	0005051b          	sext.w	a0,a0
    80004a3c:	00813083          	ld	ra,8(sp)
    80004a40:	00013403          	ld	s0,0(sp)
    80004a44:	01010113          	addi	sp,sp,16
    80004a48:	00008067          	ret

0000000080004a4c <thread_dispatch>:

void thread_dispatch() {
    80004a4c:	ff010113          	addi	sp,sp,-16
    80004a50:	00113423          	sd	ra,8(sp)
    80004a54:	00813023          	sd	s0,0(sp)
    80004a58:	01010413          	addi	s0,sp,16
    //uint64 volatile save_a0 = Riscv::r_a0();
    syscall_wrapper(sysID::THREAD_DISPATCH);
    80004a5c:	00000713          	li	a4,0
    80004a60:	00000693          	li	a3,0
    80004a64:	00000613          	li	a2,0
    80004a68:	00000593          	li	a1,0
    80004a6c:	01300513          	li	a0,19
    80004a70:	00000097          	auipc	ra,0x0
    80004a74:	e68080e7          	jalr	-408(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
    //Riscv::w_a0(save_a0);
}
    80004a78:	00813083          	ld	ra,8(sp)
    80004a7c:	00013403          	ld	s0,0(sp)
    80004a80:	01010113          	addi	sp,sp,16
    80004a84:	00008067          	ret

0000000080004a88 <sem_open>:

int sem_open(sem_t *handle, unsigned int init) {
    80004a88:	ff010113          	addi	sp,sp,-16
    80004a8c:	00113423          	sd	ra,8(sp)
    80004a90:	00813023          	sd	s0,0(sp)
    80004a94:	01010413          	addi	s0,sp,16
    return (int) syscall_wrapper(sysID::SEM_OPEN, (void *)handle, (void *)(uint64)init);
    80004a98:	00000713          	li	a4,0
    80004a9c:	00000693          	li	a3,0
    80004aa0:	02059613          	slli	a2,a1,0x20
    80004aa4:	02065613          	srli	a2,a2,0x20
    80004aa8:	00050593          	mv	a1,a0
    80004aac:	02100513          	li	a0,33
    80004ab0:	00000097          	auipc	ra,0x0
    80004ab4:	e28080e7          	jalr	-472(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    80004ab8:	0005051b          	sext.w	a0,a0
    80004abc:	00813083          	ld	ra,8(sp)
    80004ac0:	00013403          	ld	s0,0(sp)
    80004ac4:	01010113          	addi	sp,sp,16
    80004ac8:	00008067          	ret

0000000080004acc <sem_close>:

int sem_close(sem_t handle) {
    80004acc:	ff010113          	addi	sp,sp,-16
    80004ad0:	00113423          	sd	ra,8(sp)
    80004ad4:	00813023          	sd	s0,0(sp)
    80004ad8:	01010413          	addi	s0,sp,16
    80004adc:	00050593          	mv	a1,a0
    return (int) syscall_wrapper(sysID::SEM_CLOSE, handle);
    80004ae0:	00000713          	li	a4,0
    80004ae4:	00000693          	li	a3,0
    80004ae8:	00000613          	li	a2,0
    80004aec:	02200513          	li	a0,34
    80004af0:	00000097          	auipc	ra,0x0
    80004af4:	de8080e7          	jalr	-536(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    80004af8:	0005051b          	sext.w	a0,a0
    80004afc:	00813083          	ld	ra,8(sp)
    80004b00:	00013403          	ld	s0,0(sp)
    80004b04:	01010113          	addi	sp,sp,16
    80004b08:	00008067          	ret

0000000080004b0c <sem_wait>:

int sem_wait(sem_t id) {
    80004b0c:	ff010113          	addi	sp,sp,-16
    80004b10:	00113423          	sd	ra,8(sp)
    80004b14:	00813023          	sd	s0,0(sp)
    80004b18:	01010413          	addi	s0,sp,16
    80004b1c:	00050593          	mv	a1,a0
    return (int) syscall_wrapper(sysID::SEM_WAIT, (void *)id);
    80004b20:	00000713          	li	a4,0
    80004b24:	00000693          	li	a3,0
    80004b28:	00000613          	li	a2,0
    80004b2c:	02300513          	li	a0,35
    80004b30:	00000097          	auipc	ra,0x0
    80004b34:	da8080e7          	jalr	-600(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    80004b38:	0005051b          	sext.w	a0,a0
    80004b3c:	00813083          	ld	ra,8(sp)
    80004b40:	00013403          	ld	s0,0(sp)
    80004b44:	01010113          	addi	sp,sp,16
    80004b48:	00008067          	ret

0000000080004b4c <sem_signal>:

int sem_signal(sem_t id) {
    80004b4c:	ff010113          	addi	sp,sp,-16
    80004b50:	00113423          	sd	ra,8(sp)
    80004b54:	00813023          	sd	s0,0(sp)
    80004b58:	01010413          	addi	s0,sp,16
    80004b5c:	00050593          	mv	a1,a0
    return (int) syscall_wrapper(sysID::SEM_SIGNAL, (void *)id);
    80004b60:	00000713          	li	a4,0
    80004b64:	00000693          	li	a3,0
    80004b68:	00000613          	li	a2,0
    80004b6c:	02400513          	li	a0,36
    80004b70:	00000097          	auipc	ra,0x0
    80004b74:	d68080e7          	jalr	-664(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    80004b78:	0005051b          	sext.w	a0,a0
    80004b7c:	00813083          	ld	ra,8(sp)
    80004b80:	00013403          	ld	s0,0(sp)
    80004b84:	01010113          	addi	sp,sp,16
    80004b88:	00008067          	ret

0000000080004b8c <sem_timedwait>:

int sem_timedwait(sem_t id, time_t timeout) {
    if(timeout <= 0)return -2; // TIMEOUT
    80004b8c:	04058263          	beqz	a1,80004bd0 <sem_timedwait+0x44>
int sem_timedwait(sem_t id, time_t timeout) {
    80004b90:	ff010113          	addi	sp,sp,-16
    80004b94:	00113423          	sd	ra,8(sp)
    80004b98:	00813023          	sd	s0,0(sp)
    80004b9c:	01010413          	addi	s0,sp,16
    80004ba0:	00058613          	mv	a2,a1
    return (int)syscall_wrapper(sysID::SEM_TIMEDWAIT, (void *)id, (void *)timeout);
    80004ba4:	00000713          	li	a4,0
    80004ba8:	00000693          	li	a3,0
    80004bac:	00050593          	mv	a1,a0
    80004bb0:	02500513          	li	a0,37
    80004bb4:	00000097          	auipc	ra,0x0
    80004bb8:	d24080e7          	jalr	-732(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
    80004bbc:	0005051b          	sext.w	a0,a0
}
    80004bc0:	00813083          	ld	ra,8(sp)
    80004bc4:	00013403          	ld	s0,0(sp)
    80004bc8:	01010113          	addi	sp,sp,16
    80004bcc:	00008067          	ret
    if(timeout <= 0)return -2; // TIMEOUT
    80004bd0:	ffe00513          	li	a0,-2
}
    80004bd4:	00008067          	ret

0000000080004bd8 <sem_trywait>:

int sem_trywait(sem_t id) {
    80004bd8:	ff010113          	addi	sp,sp,-16
    80004bdc:	00113423          	sd	ra,8(sp)
    80004be0:	00813023          	sd	s0,0(sp)
    80004be4:	01010413          	addi	s0,sp,16
    80004be8:	00050593          	mv	a1,a0
    return (int)syscall_wrapper(sysID::SEM_TRYWAIT, (void *)id);
    80004bec:	00000713          	li	a4,0
    80004bf0:	00000693          	li	a3,0
    80004bf4:	00000613          	li	a2,0
    80004bf8:	02600513          	li	a0,38
    80004bfc:	00000097          	auipc	ra,0x0
    80004c00:	cdc080e7          	jalr	-804(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    80004c04:	0005051b          	sext.w	a0,a0
    80004c08:	00813083          	ld	ra,8(sp)
    80004c0c:	00013403          	ld	s0,0(sp)
    80004c10:	01010113          	addi	sp,sp,16
    80004c14:	00008067          	ret

0000000080004c18 <time_sleep>:

int time_sleep(time_t time) {
    if(time <= 0) return -1;
    80004c18:	04050263          	beqz	a0,80004c5c <time_sleep+0x44>
int time_sleep(time_t time) {
    80004c1c:	ff010113          	addi	sp,sp,-16
    80004c20:	00113423          	sd	ra,8(sp)
    80004c24:	00813023          	sd	s0,0(sp)
    80004c28:	01010413          	addi	s0,sp,16
    80004c2c:	00050593          	mv	a1,a0
    return (int) syscall_wrapper(sysID::TIME_SLEEP, (void *)time);
    80004c30:	00000713          	li	a4,0
    80004c34:	00000693          	li	a3,0
    80004c38:	00000613          	li	a2,0
    80004c3c:	03100513          	li	a0,49
    80004c40:	00000097          	auipc	ra,0x0
    80004c44:	c98080e7          	jalr	-872(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
    80004c48:	0005051b          	sext.w	a0,a0
}
    80004c4c:	00813083          	ld	ra,8(sp)
    80004c50:	00013403          	ld	s0,0(sp)
    80004c54:	01010113          	addi	sp,sp,16
    80004c58:	00008067          	ret
    if(time <= 0) return -1;
    80004c5c:	fff00513          	li	a0,-1
}
    80004c60:	00008067          	ret

0000000080004c64 <getc>:


char getc() {
    80004c64:	ff010113          	addi	sp,sp,-16
    80004c68:	00113423          	sd	ra,8(sp)
    80004c6c:	00813023          	sd	s0,0(sp)
    80004c70:	01010413          	addi	s0,sp,16
    return (char)syscall_wrapper(sysID::GET_C);
    80004c74:	00000713          	li	a4,0
    80004c78:	00000693          	li	a3,0
    80004c7c:	00000613          	li	a2,0
    80004c80:	00000593          	li	a1,0
    80004c84:	04100513          	li	a0,65
    80004c88:	00000097          	auipc	ra,0x0
    80004c8c:	c50080e7          	jalr	-944(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    80004c90:	0ff57513          	andi	a0,a0,255
    80004c94:	00813083          	ld	ra,8(sp)
    80004c98:	00013403          	ld	s0,0(sp)
    80004c9c:	01010113          	addi	sp,sp,16
    80004ca0:	00008067          	ret

0000000080004ca4 <putc>:

void putc(char c) {
    80004ca4:	ff010113          	addi	sp,sp,-16
    80004ca8:	00113423          	sd	ra,8(sp)
    80004cac:	00813023          	sd	s0,0(sp)
    80004cb0:	01010413          	addi	s0,sp,16
    80004cb4:	00050593          	mv	a1,a0
    syscall_wrapper(sysID::PUT_C, (void *)(uint64)c);
    80004cb8:	00000713          	li	a4,0
    80004cbc:	00000693          	li	a3,0
    80004cc0:	00000613          	li	a2,0
    80004cc4:	04200513          	li	a0,66
    80004cc8:	00000097          	auipc	ra,0x0
    80004ccc:	c10080e7          	jalr	-1008(ra) # 800048d8 <_Z15syscall_wrapper5sysIDPvS0_S0_S0_>
}
    80004cd0:	00813083          	ld	ra,8(sp)
    80004cd4:	00013403          	ld	s0,0(sp)
    80004cd8:	01010113          	addi	sp,sp,16
    80004cdc:	00008067          	ret

0000000080004ce0 <_ZN8Handlers14handleSyscallsEv>:
#include "../inc/_thread.hpp"
#include "../inc/_console.hpp"



void Handlers::handleSyscalls() {
    80004ce0:	e6010113          	addi	sp,sp,-416
    80004ce4:	18113c23          	sd	ra,408(sp)
    80004ce8:	18813823          	sd	s0,400(sp)
    80004cec:	1a010413          	addi	s0,sp,416
    __asm__ volatile ("mv %[a0], a0" : [a0] "=r"(a0));
    80004cf0:	00050793          	mv	a5,a0
    80004cf4:	e8f43c23          	sd	a5,-360(s0)
    return a0;
    80004cf8:	e9843783          	ld	a5,-360(s0)

    uint64 volatile sys_id = Riscv::r_a0();
    80004cfc:	fef43423          	sd	a5,-24(s0)
    __asm__ volatile ("mv a0, %[a0]" : : [a0] "r"(a0));
}

inline uint64 Riscv::r_a1() {
    uint64 volatile a1;
    __asm__ volatile ("mv %[a1], a1" : [a1] "=r"(a1));
    80004d00:	00058793          	mv	a5,a1
    80004d04:	e8f43823          	sd	a5,-368(s0)
    return a1;
    80004d08:	e9043783          	ld	a5,-368(s0)
    uint64 volatile a1, a2, a3, a4;
    a1 = Riscv::r_a1();
    80004d0c:	fef43023          	sd	a5,-32(s0)
    __asm__ volatile ("mv a1, %[a1]" : : [a1] "r"(a1));
}

inline uint64 Riscv::r_a2() {
    uint64 volatile a2;
    __asm__ volatile ("mv %[a2], a2" : [a2] "=r"(a2));
    80004d10:	00060793          	mv	a5,a2
    80004d14:	e8f43423          	sd	a5,-376(s0)
    return a2;
    80004d18:	e8843783          	ld	a5,-376(s0)
    a2 = Riscv::r_a2();
    80004d1c:	fcf43c23          	sd	a5,-40(s0)
    __asm__ volatile ("mv a2, %[a2]" : : [a2] "r"(a2));
}

inline uint64 Riscv::r_a3() {
    uint64 volatile a3;
    __asm__ volatile ("mv %[a3], a3" : [a3] "=r"(a3));
    80004d20:	00068793          	mv	a5,a3
    80004d24:	e8f43023          	sd	a5,-384(s0)
    return a3;
    80004d28:	e8043783          	ld	a5,-384(s0)
    a3 = Riscv::r_a3();
    80004d2c:	fcf43823          	sd	a5,-48(s0)
    __asm__ volatile ("mv a3, %[a3]" : : [a3] "r"(a3));
}

inline uint64 Riscv::r_a4() {
    uint64 volatile a4;
    __asm__ volatile ("mv %[a4], a4" : [a4] "=r"(a4));
    80004d30:	00070793          	mv	a5,a4
    80004d34:	e6f43c23          	sd	a5,-392(s0)
    return a4;
    80004d38:	e7843783          	ld	a5,-392(s0)
    a4 = Riscv::r_a4();
    80004d3c:	fcf43423          	sd	a5,-56(s0)

    uint64 volatile ret = 0;
    80004d40:	fc043023          	sd	zero,-64(s0)
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80004d44:	141027f3          	csrr	a5,sepc
    80004d48:	e6f43823          	sd	a5,-400(s0)
    return sepc;
    80004d4c:	e7043783          	ld	a5,-400(s0)

    uint64 volatile sepc = Riscv::r_sepc();
    80004d50:	faf43c23          	sd	a5,-72(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    80004d54:	100027f3          	csrr	a5,sstatus
    80004d58:	e6f43423          	sd	a5,-408(s0)
    return sstatus;
    80004d5c:	e6843783          	ld	a5,-408(s0)
    uint64 volatile sstatus = Riscv::r_sstatus(); // implicitly save sstatus on stack
    80004d60:	faf43823          	sd	a5,-80(s0)
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    80004d64:	142027f3          	csrr	a5,scause
    80004d68:	e6f43023          	sd	a5,-416(s0)
    return scause;
    80004d6c:	e6043783          	ld	a5,-416(s0)
    uint64 volatile cause = Riscv::r_scause();
    80004d70:	faf43423          	sd	a5,-88(s0)
    /// ecall from S mode or U mode
    if (cause != 0x0000000000000009UL && cause != 0x0000000000000008UL) {
    80004d74:	fa843703          	ld	a4,-88(s0)
    80004d78:	00900793          	li	a5,9
    80004d7c:	00f70863          	beq	a4,a5,80004d8c <_ZN8Handlers14handleSyscallsEv+0xac>
    80004d80:	fa843703          	ld	a4,-88(s0)
    80004d84:	00800793          	li	a5,8
    80004d88:	02f71a63          	bne	a4,a5,80004dbc <_ZN8Handlers14handleSyscallsEv+0xdc>
        Riscv::halt();
        return;
    }


    switch (sys_id) {
    80004d8c:	fe843783          	ld	a5,-24(s0)
    80004d90:	04200713          	li	a4,66
    80004d94:	30f76e63          	bltu	a4,a5,800050b0 <_ZN8Handlers14handleSyscallsEv+0x3d0>
    80004d98:	08078ee3          	beqz	a5,80005634 <_ZN8Handlers14handleSyscallsEv+0x954>
    80004d9c:	08f76ce3          	bltu	a4,a5,80005634 <_ZN8Handlers14handleSyscallsEv+0x954>
    80004da0:	00279793          	slli	a5,a5,0x2
    80004da4:	00005717          	auipc	a4,0x5
    80004da8:	7ec70713          	addi	a4,a4,2028 # 8000a590 <CONSOLE_STATUS+0x580>
    80004dac:	00e787b3          	add	a5,a5,a4
    80004db0:	0007a783          	lw	a5,0(a5)
    80004db4:	00e787b3          	add	a5,a5,a4
    80004db8:	00078067          	jr	a5
        printStringS("SCAUSE ERROR: Not syscall.\n");
    80004dbc:	00005517          	auipc	a0,0x5
    80004dc0:	6dc50513          	addi	a0,a0,1756 # 8000a498 <CONSOLE_STATUS+0x488>
    80004dc4:	00003097          	auipc	ra,0x3
    80004dc8:	d14080e7          	jalr	-748(ra) # 80007ad8 <_Z12printStringSPKc>
    Riscv::w_a1(mode); // 0 is user mode
    Riscv::ecall();
}

inline void Riscv::printStats() {
    printStringS("\t\t");
    80004dcc:	00005517          	auipc	a0,0x5
    80004dd0:	6ec50513          	addi	a0,a0,1772 # 8000a4b8 <CONSOLE_STATUS+0x4a8>
    80004dd4:	00003097          	auipc	ra,0x3
    80004dd8:	d04080e7          	jalr	-764(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("scause: ");printIntS(r_scause(), 16);printStringS("\t");
    80004ddc:	00005517          	auipc	a0,0x5
    80004de0:	6e450513          	addi	a0,a0,1764 # 8000a4c0 <CONSOLE_STATUS+0x4b0>
    80004de4:	00003097          	auipc	ra,0x3
    80004de8:	cf4080e7          	jalr	-780(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    80004dec:	142027f3          	csrr	a5,scause
    80004df0:	eaf43023          	sd	a5,-352(s0)
    return scause;
    80004df4:	ea043503          	ld	a0,-352(s0)
    printStringS("scause: ");printIntS(r_scause(), 16);printStringS("\t");
    80004df8:	00000613          	li	a2,0
    80004dfc:	01000593          	li	a1,16
    80004e00:	0005051b          	sext.w	a0,a0
    80004e04:	00003097          	auipc	ra,0x3
    80004e08:	d68080e7          	jalr	-664(ra) # 80007b6c <_Z9printIntSiii>
    80004e0c:	00005517          	auipc	a0,0x5
    80004e10:	6c450513          	addi	a0,a0,1732 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80004e14:	00003097          	auipc	ra,0x3
    80004e18:	cc4080e7          	jalr	-828(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("sstatus: ");printIntS(r_sstatus(), 16);printStringS("\t");
    80004e1c:	00005517          	auipc	a0,0x5
    80004e20:	6bc50513          	addi	a0,a0,1724 # 8000a4d8 <CONSOLE_STATUS+0x4c8>
    80004e24:	00003097          	auipc	ra,0x3
    80004e28:	cb4080e7          	jalr	-844(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    80004e2c:	100027f3          	csrr	a5,sstatus
    80004e30:	eaf43423          	sd	a5,-344(s0)
    return sstatus;
    80004e34:	ea843503          	ld	a0,-344(s0)
    printStringS("sstatus: ");printIntS(r_sstatus(), 16);printStringS("\t");
    80004e38:	00000613          	li	a2,0
    80004e3c:	01000593          	li	a1,16
    80004e40:	0005051b          	sext.w	a0,a0
    80004e44:	00003097          	auipc	ra,0x3
    80004e48:	d28080e7          	jalr	-728(ra) # 80007b6c <_Z9printIntSiii>
    80004e4c:	00005517          	auipc	a0,0x5
    80004e50:	68450513          	addi	a0,a0,1668 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80004e54:	00003097          	auipc	ra,0x3
    80004e58:	c84080e7          	jalr	-892(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("sepc: ");printIntS(r_sepc(), 16);printStringS("\t");
    80004e5c:	00005517          	auipc	a0,0x5
    80004e60:	68c50513          	addi	a0,a0,1676 # 8000a4e8 <CONSOLE_STATUS+0x4d8>
    80004e64:	00003097          	auipc	ra,0x3
    80004e68:	c74080e7          	jalr	-908(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80004e6c:	141027f3          	csrr	a5,sepc
    80004e70:	eaf43823          	sd	a5,-336(s0)
    return sepc;
    80004e74:	eb043503          	ld	a0,-336(s0)
    printStringS("sepc: ");printIntS(r_sepc(), 16);printStringS("\t");
    80004e78:	00000613          	li	a2,0
    80004e7c:	01000593          	li	a1,16
    80004e80:	0005051b          	sext.w	a0,a0
    80004e84:	00003097          	auipc	ra,0x3
    80004e88:	ce8080e7          	jalr	-792(ra) # 80007b6c <_Z9printIntSiii>
    80004e8c:	00005517          	auipc	a0,0x5
    80004e90:	64450513          	addi	a0,a0,1604 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80004e94:	00003097          	auipc	ra,0x3
    80004e98:	c44080e7          	jalr	-956(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("sip: ");printIntS(r_sip(), 16);printStringS("\t");
    80004e9c:	00005517          	auipc	a0,0x5
    80004ea0:	65450513          	addi	a0,a0,1620 # 8000a4f0 <CONSOLE_STATUS+0x4e0>
    80004ea4:	00003097          	auipc	ra,0x3
    80004ea8:	c34080e7          	jalr	-972(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[sip], sip" : [sip] "=r"(sip));
    80004eac:	144027f3          	csrr	a5,sip
    80004eb0:	eaf43c23          	sd	a5,-328(s0)
    return sip;
    80004eb4:	eb843503          	ld	a0,-328(s0)
    printStringS("sip: ");printIntS(r_sip(), 16);printStringS("\t");
    80004eb8:	00000613          	li	a2,0
    80004ebc:	01000593          	li	a1,16
    80004ec0:	0005051b          	sext.w	a0,a0
    80004ec4:	00003097          	auipc	ra,0x3
    80004ec8:	ca8080e7          	jalr	-856(ra) # 80007b6c <_Z9printIntSiii>
    80004ecc:	00005517          	auipc	a0,0x5
    80004ed0:	60450513          	addi	a0,a0,1540 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80004ed4:	00003097          	auipc	ra,0x3
    80004ed8:	c04080e7          	jalr	-1020(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("stval: ");printIntS(r_stval(), 16);printStringS("\t");
    80004edc:	00005517          	auipc	a0,0x5
    80004ee0:	61c50513          	addi	a0,a0,1564 # 8000a4f8 <CONSOLE_STATUS+0x4e8>
    80004ee4:	00003097          	auipc	ra,0x3
    80004ee8:	bf4080e7          	jalr	-1036(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    80004eec:	143027f3          	csrr	a5,stval
    80004ef0:	ecf43023          	sd	a5,-320(s0)
    return stval;
    80004ef4:	ec043503          	ld	a0,-320(s0)
    printStringS("stval: ");printIntS(r_stval(), 16);printStringS("\t");
    80004ef8:	00000613          	li	a2,0
    80004efc:	01000593          	li	a1,16
    80004f00:	0005051b          	sext.w	a0,a0
    80004f04:	00003097          	auipc	ra,0x3
    80004f08:	c68080e7          	jalr	-920(ra) # 80007b6c <_Z9printIntSiii>
    80004f0c:	00005517          	auipc	a0,0x5
    80004f10:	5c450513          	addi	a0,a0,1476 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80004f14:	00003097          	auipc	ra,0x3
    80004f18:	bc4080e7          	jalr	-1084(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("stvec: ");printIntS(r_stvec(), 16);printStringS("\n\t\t");
    80004f1c:	00005517          	auipc	a0,0x5
    80004f20:	5e450513          	addi	a0,a0,1508 # 8000a500 <CONSOLE_STATUS+0x4f0>
    80004f24:	00003097          	auipc	ra,0x3
    80004f28:	bb4080e7          	jalr	-1100(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[stvec], stvec" : [stvec] "=r"(stvec));
    80004f2c:	105027f3          	csrr	a5,stvec
    80004f30:	ecf43423          	sd	a5,-312(s0)
    return stvec;
    80004f34:	ec843503          	ld	a0,-312(s0)
    printStringS("stvec: ");printIntS(r_stvec(), 16);printStringS("\n\t\t");
    80004f38:	00000613          	li	a2,0
    80004f3c:	01000593          	li	a1,16
    80004f40:	0005051b          	sext.w	a0,a0
    80004f44:	00003097          	auipc	ra,0x3
    80004f48:	c28080e7          	jalr	-984(ra) # 80007b6c <_Z9printIntSiii>
    80004f4c:	00005517          	auipc	a0,0x5
    80004f50:	5bc50513          	addi	a0,a0,1468 # 8000a508 <CONSOLE_STATUS+0x4f8>
    80004f54:	00003097          	auipc	ra,0x3
    80004f58:	b84080e7          	jalr	-1148(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a0: ");printIntS(r_a0(), 16);printStringS("\t");
    80004f5c:	00005517          	auipc	a0,0x5
    80004f60:	5b450513          	addi	a0,a0,1460 # 8000a510 <CONSOLE_STATUS+0x500>
    80004f64:	00003097          	auipc	ra,0x3
    80004f68:	b74080e7          	jalr	-1164(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a0], a0" : [a0] "=r"(a0));
    80004f6c:	00050793          	mv	a5,a0
    80004f70:	ecf43823          	sd	a5,-304(s0)
    return a0;
    80004f74:	ed043503          	ld	a0,-304(s0)
    printStringS("a0: ");printIntS(r_a0(), 16);printStringS("\t");
    80004f78:	00000613          	li	a2,0
    80004f7c:	01000593          	li	a1,16
    80004f80:	0005051b          	sext.w	a0,a0
    80004f84:	00003097          	auipc	ra,0x3
    80004f88:	be8080e7          	jalr	-1048(ra) # 80007b6c <_Z9printIntSiii>
    80004f8c:	00005517          	auipc	a0,0x5
    80004f90:	54450513          	addi	a0,a0,1348 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80004f94:	00003097          	auipc	ra,0x3
    80004f98:	b44080e7          	jalr	-1212(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a1: ");printIntS(r_a1(), 16);printStringS("\t");
    80004f9c:	00005517          	auipc	a0,0x5
    80004fa0:	57c50513          	addi	a0,a0,1404 # 8000a518 <CONSOLE_STATUS+0x508>
    80004fa4:	00003097          	auipc	ra,0x3
    80004fa8:	b34080e7          	jalr	-1228(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a1], a1" : [a1] "=r"(a1));
    80004fac:	00058793          	mv	a5,a1
    80004fb0:	ecf43c23          	sd	a5,-296(s0)
    return a1;
    80004fb4:	ed843503          	ld	a0,-296(s0)
    printStringS("a1: ");printIntS(r_a1(), 16);printStringS("\t");
    80004fb8:	00000613          	li	a2,0
    80004fbc:	01000593          	li	a1,16
    80004fc0:	0005051b          	sext.w	a0,a0
    80004fc4:	00003097          	auipc	ra,0x3
    80004fc8:	ba8080e7          	jalr	-1112(ra) # 80007b6c <_Z9printIntSiii>
    80004fcc:	00005517          	auipc	a0,0x5
    80004fd0:	50450513          	addi	a0,a0,1284 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80004fd4:	00003097          	auipc	ra,0x3
    80004fd8:	b04080e7          	jalr	-1276(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a2: ");printIntS(r_a2(), 16);printStringS("\t");
    80004fdc:	00005517          	auipc	a0,0x5
    80004fe0:	54450513          	addi	a0,a0,1348 # 8000a520 <CONSOLE_STATUS+0x510>
    80004fe4:	00003097          	auipc	ra,0x3
    80004fe8:	af4080e7          	jalr	-1292(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a2], a2" : [a2] "=r"(a2));
    80004fec:	00060793          	mv	a5,a2
    80004ff0:	eef43023          	sd	a5,-288(s0)
    return a2;
    80004ff4:	ee043503          	ld	a0,-288(s0)
    printStringS("a2: ");printIntS(r_a2(), 16);printStringS("\t");
    80004ff8:	00000613          	li	a2,0
    80004ffc:	01000593          	li	a1,16
    80005000:	0005051b          	sext.w	a0,a0
    80005004:	00003097          	auipc	ra,0x3
    80005008:	b68080e7          	jalr	-1176(ra) # 80007b6c <_Z9printIntSiii>
    8000500c:	00005517          	auipc	a0,0x5
    80005010:	4c450513          	addi	a0,a0,1220 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80005014:	00003097          	auipc	ra,0x3
    80005018:	ac4080e7          	jalr	-1340(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a3: ");printIntS(r_a3(), 16);printStringS("\t");
    8000501c:	00005517          	auipc	a0,0x5
    80005020:	50c50513          	addi	a0,a0,1292 # 8000a528 <CONSOLE_STATUS+0x518>
    80005024:	00003097          	auipc	ra,0x3
    80005028:	ab4080e7          	jalr	-1356(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a3], a3" : [a3] "=r"(a3));
    8000502c:	00068793          	mv	a5,a3
    80005030:	eef43423          	sd	a5,-280(s0)
    return a3;
    80005034:	ee843503          	ld	a0,-280(s0)
    printStringS("a3: ");printIntS(r_a3(), 16);printStringS("\t");
    80005038:	00000613          	li	a2,0
    8000503c:	01000593          	li	a1,16
    80005040:	0005051b          	sext.w	a0,a0
    80005044:	00003097          	auipc	ra,0x3
    80005048:	b28080e7          	jalr	-1240(ra) # 80007b6c <_Z9printIntSiii>
    8000504c:	00005517          	auipc	a0,0x5
    80005050:	48450513          	addi	a0,a0,1156 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80005054:	00003097          	auipc	ra,0x3
    80005058:	a84080e7          	jalr	-1404(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a4: ");printIntS(r_a4(), 16);printStringS("\n\t\t");
    8000505c:	00005517          	auipc	a0,0x5
    80005060:	4d450513          	addi	a0,a0,1236 # 8000a530 <CONSOLE_STATUS+0x520>
    80005064:	00003097          	auipc	ra,0x3
    80005068:	a74080e7          	jalr	-1420(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a4], a4" : [a4] "=r"(a4));
    8000506c:	00070793          	mv	a5,a4
    80005070:	eef43823          	sd	a5,-272(s0)
    return a4;
    80005074:	ef043503          	ld	a0,-272(s0)
    printStringS("a4: ");printIntS(r_a4(), 16);printStringS("\n\t\t");
    80005078:	00000613          	li	a2,0
    8000507c:	01000593          	li	a1,16
    80005080:	0005051b          	sext.w	a0,a0
    80005084:	00003097          	auipc	ra,0x3
    80005088:	ae8080e7          	jalr	-1304(ra) # 80007b6c <_Z9printIntSiii>
    8000508c:	00005517          	auipc	a0,0x5
    80005090:	47c50513          	addi	a0,a0,1148 # 8000a508 <CONSOLE_STATUS+0x4f8>
    80005094:	00003097          	auipc	ra,0x3
    80005098:	a44080e7          	jalr	-1468(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile("li t0, 0x5555");
    8000509c:	000052b7          	lui	t0,0x5
    800050a0:	5552829b          	addiw	t0,t0,1365
    __asm__ volatile("li t1, 0x100000");
    800050a4:	00100337          	lui	t1,0x100
    __asm__ volatile("sw t0, 0(t1) ");
    800050a8:	00532023          	sw	t0,0(t1) # 100000 <_entry-0x7ff00000>
        return;
    800050ac:	08c0006f          	j	80005138 <_ZN8Handlers14handleSyscallsEv+0x458>
    switch (sys_id) {
    800050b0:	09900713          	li	a4,153
    800050b4:	58e79063          	bne	a5,a4,80005634 <_ZN8Handlers14handleSyscallsEv+0x954>
        case sysID::PUT_C:
            _console::putcBuffer->put(a1);
            break;
        case sysID::CHANGE_MODE:
            /// in a1 is what mode to change
            if(_thread::running != _thread::mainThread) // don't allow user threads to change mode
    800050b8:	00008797          	auipc	a5,0x8
    800050bc:	d487b783          	ld	a5,-696(a5) # 8000ce00 <_GLOBAL_OFFSET_TABLE_+0x20>
    800050c0:	0007b703          	ld	a4,0(a5)
    800050c4:	00008797          	auipc	a5,0x8
    800050c8:	d8c7b783          	ld	a5,-628(a5) # 8000ce50 <_GLOBAL_OFFSET_TABLE_+0x70>
    800050cc:	0007b783          	ld	a5,0(a5)
    800050d0:	24f71e63          	bne	a4,a5,8000532c <_ZN8Handlers14handleSyscallsEv+0x64c>
                printStringS("sysID::CHANGE_MODE ERROR: Change not granted.\n");
                Riscv::printStats();
                Riscv::halt();
                return;
            }
            ret = 0;
    800050d4:	fc043023          	sd	zero,-64(s0)
            Riscv::swMode((Riscv::Mode)a1);
    800050d8:	fe043783          	ld	a5,-32(s0)
    800050dc:	0007879b          	sext.w	a5,a5
    if(mode == USER) // change to user mode
    800050e0:	54079063          	bnez	a5,80005620 <_ZN8Handlers14handleSyscallsEv+0x940>
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    800050e4:	10000793          	li	a5,256
    800050e8:	1007b073          	csrc	sstatus,a5
            Riscv::w_sepc(sepc + 4);
    800050ec:	fb843783          	ld	a5,-72(s0)
    800050f0:	00478793          	addi	a5,a5,4
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    800050f4:	14179073          	csrw	sepc,a5
            Riscv::w_a0(ret);
    800050f8:	fc043783          	ld	a5,-64(s0)
    __asm__ volatile ("mv a0, %[a0]" : : [a0] "r"(a0));
    800050fc:	00078513          	mv	a0,a5
}
    80005100:	0380006f          	j	80005138 <_ZN8Handlers14handleSyscallsEv+0x458>
            ret = (uint64) MemoryAllocator::instance().malloc_blocks(a1);
    80005104:	00002097          	auipc	ra,0x2
    80005108:	5fc080e7          	jalr	1532(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    8000510c:	fe043583          	ld	a1,-32(s0)
    80005110:	00002097          	auipc	ra,0x2
    80005114:	748080e7          	jalr	1864(ra) # 80007858 <_ZN15MemoryAllocator13malloc_blocksEm>
    80005118:	fca43023          	sd	a0,-64(s0)

            ret = 0;
            return;
        }
        // prekidna rutina obradjena
        Riscv::w_sstatus(sstatus);
    8000511c:	fb043783          	ld	a5,-80(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    80005120:	10079073          	csrw	sstatus,a5
        Riscv::w_sepc(sepc + 4); /// in spec is ecall and +4 is next instruction
    80005124:	fb843783          	ld	a5,-72(s0)
    80005128:	00478793          	addi	a5,a5,4
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    8000512c:	14179073          	csrw	sepc,a5
        Riscv::w_a0(ret); /// write return value
    80005130:	fc043783          	ld	a5,-64(s0)
    __asm__ volatile ("mv a0, %[a0]" : : [a0] "r"(a0));
    80005134:	00078513          	mv	a0,a5


}
    80005138:	19813083          	ld	ra,408(sp)
    8000513c:	19013403          	ld	s0,400(sp)
    80005140:	1a010113          	addi	sp,sp,416
    80005144:	00008067          	ret
            ret = (int) MemoryAllocator::instance().free((void *) a1);
    80005148:	00002097          	auipc	ra,0x2
    8000514c:	5b8080e7          	jalr	1464(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80005150:	fe043583          	ld	a1,-32(s0)
    80005154:	00003097          	auipc	ra,0x3
    80005158:	85c080e7          	jalr	-1956(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
    8000515c:	fca43023          	sd	a0,-64(s0)
            break;
    80005160:	fbdff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ret = (int) _thread::threadCreate((thread_t *) a1, (_thread::Body) a2, (void *) a3, (void *) a4);
    80005164:	fe043503          	ld	a0,-32(s0)
    80005168:	fd843583          	ld	a1,-40(s0)
    8000516c:	fd043603          	ld	a2,-48(s0)
    80005170:	fc843683          	ld	a3,-56(s0)
    80005174:	00001097          	auipc	ra,0x1
    80005178:	e28080e7          	jalr	-472(ra) # 80005f9c <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_>
    8000517c:	fca43023          	sd	a0,-64(s0)
            break;
    80005180:	f9dff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ret = (int) _thread::threadExit(); /// will return if error
    80005184:	00001097          	auipc	ra,0x1
    80005188:	d08080e7          	jalr	-760(ra) # 80005e8c <_ZN7_thread10threadExitEv>
    8000518c:	fca43023          	sd	a0,-64(s0)
            break;
    80005190:	f8dff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            _thread::timeSliceCounter = 0;
    80005194:	00008797          	auipc	a5,0x8
    80005198:	cc47b783          	ld	a5,-828(a5) # 8000ce58 <_GLOBAL_OFFSET_TABLE_+0x78>
    8000519c:	0007b023          	sd	zero,0(a5)
            _thread::dispatch();
    800051a0:	00001097          	auipc	ra,0x1
    800051a4:	c3c080e7          	jalr	-964(ra) # 80005ddc <_ZN7_thread8dispatchEv>
            break;
    800051a8:	f75ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ret = (int)_sem::semOpen((sem_t *)a1, (int)a2);
    800051ac:	fe043503          	ld	a0,-32(s0)
    800051b0:	fd843583          	ld	a1,-40(s0)
    800051b4:	0005859b          	sext.w	a1,a1
    800051b8:	00002097          	auipc	ra,0x2
    800051bc:	e64080e7          	jalr	-412(ra) # 8000701c <_ZN4_sem7semOpenEPPS_i>
    800051c0:	fca43023          	sd	a0,-64(s0)
            break;
    800051c4:	f59ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            if(!_sem::validSemaphore((sem_t)a1)){
    800051c8:	fe043503          	ld	a0,-32(s0)
    800051cc:	00002097          	auipc	ra,0x2
    800051d0:	160080e7          	jalr	352(ra) # 8000732c <_ZN4_sem14validSemaphoreEPS_>
    800051d4:	00051863          	bnez	a0,800051e4 <_ZN8Handlers14handleSyscallsEv+0x504>
                ret = -1;
    800051d8:	fff00793          	li	a5,-1
    800051dc:	fcf43023          	sd	a5,-64(s0)
                break;
    800051e0:	f3dff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ((sem_t)a1)->semClose();
    800051e4:	fe043503          	ld	a0,-32(s0)
    800051e8:	00002097          	auipc	ra,0x2
    800051ec:	f54080e7          	jalr	-172(ra) # 8000713c <_ZN4_sem8semCloseEv>
            ret = MemoryAllocator::instance().free((void *)a1); // deallocate semaphore, used in C and CPP api
    800051f0:	00002097          	auipc	ra,0x2
    800051f4:	510080e7          	jalr	1296(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    800051f8:	fe043583          	ld	a1,-32(s0)
    800051fc:	00002097          	auipc	ra,0x2
    80005200:	7b4080e7          	jalr	1972(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
    80005204:	fca43023          	sd	a0,-64(s0)
            break;
    80005208:	f15ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            if(!_sem::validSemaphore((sem_t)a1)){
    8000520c:	fe043503          	ld	a0,-32(s0)
    80005210:	00002097          	auipc	ra,0x2
    80005214:	11c080e7          	jalr	284(ra) # 8000732c <_ZN4_sem14validSemaphoreEPS_>
    80005218:	00051863          	bnez	a0,80005228 <_ZN8Handlers14handleSyscallsEv+0x548>
                ret = -1;
    8000521c:	fff00793          	li	a5,-1
    80005220:	fcf43023          	sd	a5,-64(s0)
                break;
    80005224:	ef9ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ret = (int)((sem_t)a1)->semWait();
    80005228:	fe043503          	ld	a0,-32(s0)
    8000522c:	00000613          	li	a2,0
    80005230:	00000593          	li	a1,0
    80005234:	00002097          	auipc	ra,0x2
    80005238:	c38080e7          	jalr	-968(ra) # 80006e6c <_ZN4_sem7semWaitEmb>
    8000523c:	fca43023          	sd	a0,-64(s0)
            break;
    80005240:	eddff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            if(!_sem::validSemaphore((sem_t)a1)){
    80005244:	fe043503          	ld	a0,-32(s0)
    80005248:	00002097          	auipc	ra,0x2
    8000524c:	0e4080e7          	jalr	228(ra) # 8000732c <_ZN4_sem14validSemaphoreEPS_>
    80005250:	00051863          	bnez	a0,80005260 <_ZN8Handlers14handleSyscallsEv+0x580>
                ret = -1;
    80005254:	fff00793          	li	a5,-1
    80005258:	fcf43023          	sd	a5,-64(s0)
                break;
    8000525c:	ec1ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ret = (int)((sem_t)a1)->semSignal();
    80005260:	fe043503          	ld	a0,-32(s0)
    80005264:	00002097          	auipc	ra,0x2
    80005268:	d2c080e7          	jalr	-724(ra) # 80006f90 <_ZN4_sem9semSignalEv>
    8000526c:	fca43023          	sd	a0,-64(s0)
            break;
    80005270:	eadff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            if(!_sem::validSemaphore((sem_t)a1)){
    80005274:	fe043503          	ld	a0,-32(s0)
    80005278:	00002097          	auipc	ra,0x2
    8000527c:	0b4080e7          	jalr	180(ra) # 8000732c <_ZN4_sem14validSemaphoreEPS_>
    80005280:	00051863          	bnez	a0,80005290 <_ZN8Handlers14handleSyscallsEv+0x5b0>
                ret = -1; // SEMDEAD
    80005284:	fff00793          	li	a5,-1
    80005288:	fcf43023          	sd	a5,-64(s0)
                break;
    8000528c:	e91ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ret = (int)((sem_t)a1)->semWait((time_t)a2, true);
    80005290:	fe043503          	ld	a0,-32(s0)
    80005294:	fd843583          	ld	a1,-40(s0)
    80005298:	00100613          	li	a2,1
    8000529c:	00002097          	auipc	ra,0x2
    800052a0:	bd0080e7          	jalr	-1072(ra) # 80006e6c <_ZN4_sem7semWaitEmb>
    800052a4:	fca43023          	sd	a0,-64(s0)
            break;
    800052a8:	e75ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            if(!_sem::validSemaphore((sem_t)a1)){
    800052ac:	fe043503          	ld	a0,-32(s0)
    800052b0:	00002097          	auipc	ra,0x2
    800052b4:	07c080e7          	jalr	124(ra) # 8000732c <_ZN4_sem14validSemaphoreEPS_>
    800052b8:	00051863          	bnez	a0,800052c8 <_ZN8Handlers14handleSyscallsEv+0x5e8>
                ret = -1;
    800052bc:	fff00793          	li	a5,-1
    800052c0:	fcf43023          	sd	a5,-64(s0)
                break;
    800052c4:	e59ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ret = (int)((sem_t)a1)->semTryWait();
    800052c8:	fe043503          	ld	a0,-32(s0)
    800052cc:	00002097          	auipc	ra,0x2
    800052d0:	adc080e7          	jalr	-1316(ra) # 80006da8 <_ZN4_sem10semTryWaitEv>
    800052d4:	fca43023          	sd	a0,-64(s0)
            break;
    800052d8:	e45ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ret = (int)(_thread::timeSleep((time_t)a1));
    800052dc:	fe043503          	ld	a0,-32(s0)
    800052e0:	00001097          	auipc	ra,0x1
    800052e4:	90c080e7          	jalr	-1780(ra) # 80005bec <_ZN7_thread9timeSleepEm>
    800052e8:	fca43023          	sd	a0,-64(s0)
            break;
    800052ec:	e31ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            ret = (char)_console::getcBuffer->get();
    800052f0:	00008797          	auipc	a5,0x8
    800052f4:	b307b783          	ld	a5,-1232(a5) # 8000ce20 <_GLOBAL_OFFSET_TABLE_+0x40>
    800052f8:	0007b503          	ld	a0,0(a5)
    800052fc:	00002097          	auipc	ra,0x2
    80005300:	160080e7          	jalr	352(ra) # 8000745c <_ZN13ConsoleBuffer3getEv>
    80005304:	fca43023          	sd	a0,-64(s0)
            break;
    80005308:	e15ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
            _console::putcBuffer->put(a1);
    8000530c:	fe043583          	ld	a1,-32(s0)
    80005310:	0ff5f593          	andi	a1,a1,255
    80005314:	00008797          	auipc	a5,0x8
    80005318:	b347b783          	ld	a5,-1228(a5) # 8000ce48 <_GLOBAL_OFFSET_TABLE_+0x68>
    8000531c:	0007b503          	ld	a0,0(a5)
    80005320:	00002097          	auipc	ra,0x2
    80005324:	0c0080e7          	jalr	192(ra) # 800073e0 <_ZN13ConsoleBuffer3putEc>
            break;
    80005328:	df5ff06f          	j	8000511c <_ZN8Handlers14handleSyscallsEv+0x43c>
                printStringS("sysID::CHANGE_MODE ERROR: Change not granted.\n");
    8000532c:	00005517          	auipc	a0,0x5
    80005330:	20c50513          	addi	a0,a0,524 # 8000a538 <CONSOLE_STATUS+0x528>
    80005334:	00002097          	auipc	ra,0x2
    80005338:	7a4080e7          	jalr	1956(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("\t\t");
    8000533c:	00005517          	auipc	a0,0x5
    80005340:	17c50513          	addi	a0,a0,380 # 8000a4b8 <CONSOLE_STATUS+0x4a8>
    80005344:	00002097          	auipc	ra,0x2
    80005348:	794080e7          	jalr	1940(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("scause: ");printIntS(r_scause(), 16);printStringS("\t");
    8000534c:	00005517          	auipc	a0,0x5
    80005350:	17450513          	addi	a0,a0,372 # 8000a4c0 <CONSOLE_STATUS+0x4b0>
    80005354:	00002097          	auipc	ra,0x2
    80005358:	784080e7          	jalr	1924(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    8000535c:	142027f3          	csrr	a5,scause
    80005360:	eef43c23          	sd	a5,-264(s0)
    return scause;
    80005364:	ef843503          	ld	a0,-264(s0)
    printStringS("scause: ");printIntS(r_scause(), 16);printStringS("\t");
    80005368:	00000613          	li	a2,0
    8000536c:	01000593          	li	a1,16
    80005370:	0005051b          	sext.w	a0,a0
    80005374:	00002097          	auipc	ra,0x2
    80005378:	7f8080e7          	jalr	2040(ra) # 80007b6c <_Z9printIntSiii>
    8000537c:	00005517          	auipc	a0,0x5
    80005380:	15450513          	addi	a0,a0,340 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80005384:	00002097          	auipc	ra,0x2
    80005388:	754080e7          	jalr	1876(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("sstatus: ");printIntS(r_sstatus(), 16);printStringS("\t");
    8000538c:	00005517          	auipc	a0,0x5
    80005390:	14c50513          	addi	a0,a0,332 # 8000a4d8 <CONSOLE_STATUS+0x4c8>
    80005394:	00002097          	auipc	ra,0x2
    80005398:	744080e7          	jalr	1860(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    8000539c:	100027f3          	csrr	a5,sstatus
    800053a0:	f0f43023          	sd	a5,-256(s0)
    return sstatus;
    800053a4:	f0043503          	ld	a0,-256(s0)
    printStringS("sstatus: ");printIntS(r_sstatus(), 16);printStringS("\t");
    800053a8:	00000613          	li	a2,0
    800053ac:	01000593          	li	a1,16
    800053b0:	0005051b          	sext.w	a0,a0
    800053b4:	00002097          	auipc	ra,0x2
    800053b8:	7b8080e7          	jalr	1976(ra) # 80007b6c <_Z9printIntSiii>
    800053bc:	00005517          	auipc	a0,0x5
    800053c0:	11450513          	addi	a0,a0,276 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    800053c4:	00002097          	auipc	ra,0x2
    800053c8:	714080e7          	jalr	1812(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("sepc: ");printIntS(r_sepc(), 16);printStringS("\t");
    800053cc:	00005517          	auipc	a0,0x5
    800053d0:	11c50513          	addi	a0,a0,284 # 8000a4e8 <CONSOLE_STATUS+0x4d8>
    800053d4:	00002097          	auipc	ra,0x2
    800053d8:	704080e7          	jalr	1796(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    800053dc:	141027f3          	csrr	a5,sepc
    800053e0:	f0f43423          	sd	a5,-248(s0)
    return sepc;
    800053e4:	f0843503          	ld	a0,-248(s0)
    printStringS("sepc: ");printIntS(r_sepc(), 16);printStringS("\t");
    800053e8:	00000613          	li	a2,0
    800053ec:	01000593          	li	a1,16
    800053f0:	0005051b          	sext.w	a0,a0
    800053f4:	00002097          	auipc	ra,0x2
    800053f8:	778080e7          	jalr	1912(ra) # 80007b6c <_Z9printIntSiii>
    800053fc:	00005517          	auipc	a0,0x5
    80005400:	0d450513          	addi	a0,a0,212 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80005404:	00002097          	auipc	ra,0x2
    80005408:	6d4080e7          	jalr	1748(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("sip: ");printIntS(r_sip(), 16);printStringS("\t");
    8000540c:	00005517          	auipc	a0,0x5
    80005410:	0e450513          	addi	a0,a0,228 # 8000a4f0 <CONSOLE_STATUS+0x4e0>
    80005414:	00002097          	auipc	ra,0x2
    80005418:	6c4080e7          	jalr	1732(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[sip], sip" : [sip] "=r"(sip));
    8000541c:	144027f3          	csrr	a5,sip
    80005420:	f0f43823          	sd	a5,-240(s0)
    return sip;
    80005424:	f1043503          	ld	a0,-240(s0)
    printStringS("sip: ");printIntS(r_sip(), 16);printStringS("\t");
    80005428:	00000613          	li	a2,0
    8000542c:	01000593          	li	a1,16
    80005430:	0005051b          	sext.w	a0,a0
    80005434:	00002097          	auipc	ra,0x2
    80005438:	738080e7          	jalr	1848(ra) # 80007b6c <_Z9printIntSiii>
    8000543c:	00005517          	auipc	a0,0x5
    80005440:	09450513          	addi	a0,a0,148 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80005444:	00002097          	auipc	ra,0x2
    80005448:	694080e7          	jalr	1684(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("stval: ");printIntS(r_stval(), 16);printStringS("\t");
    8000544c:	00005517          	auipc	a0,0x5
    80005450:	0ac50513          	addi	a0,a0,172 # 8000a4f8 <CONSOLE_STATUS+0x4e8>
    80005454:	00002097          	auipc	ra,0x2
    80005458:	684080e7          	jalr	1668(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    8000545c:	143027f3          	csrr	a5,stval
    80005460:	f0f43c23          	sd	a5,-232(s0)
    return stval;
    80005464:	f1843503          	ld	a0,-232(s0)
    printStringS("stval: ");printIntS(r_stval(), 16);printStringS("\t");
    80005468:	00000613          	li	a2,0
    8000546c:	01000593          	li	a1,16
    80005470:	0005051b          	sext.w	a0,a0
    80005474:	00002097          	auipc	ra,0x2
    80005478:	6f8080e7          	jalr	1784(ra) # 80007b6c <_Z9printIntSiii>
    8000547c:	00005517          	auipc	a0,0x5
    80005480:	05450513          	addi	a0,a0,84 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80005484:	00002097          	auipc	ra,0x2
    80005488:	654080e7          	jalr	1620(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("stvec: ");printIntS(r_stvec(), 16);printStringS("\n\t\t");
    8000548c:	00005517          	auipc	a0,0x5
    80005490:	07450513          	addi	a0,a0,116 # 8000a500 <CONSOLE_STATUS+0x4f0>
    80005494:	00002097          	auipc	ra,0x2
    80005498:	644080e7          	jalr	1604(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[stvec], stvec" : [stvec] "=r"(stvec));
    8000549c:	105027f3          	csrr	a5,stvec
    800054a0:	f2f43023          	sd	a5,-224(s0)
    return stvec;
    800054a4:	f2043503          	ld	a0,-224(s0)
    printStringS("stvec: ");printIntS(r_stvec(), 16);printStringS("\n\t\t");
    800054a8:	00000613          	li	a2,0
    800054ac:	01000593          	li	a1,16
    800054b0:	0005051b          	sext.w	a0,a0
    800054b4:	00002097          	auipc	ra,0x2
    800054b8:	6b8080e7          	jalr	1720(ra) # 80007b6c <_Z9printIntSiii>
    800054bc:	00005517          	auipc	a0,0x5
    800054c0:	04c50513          	addi	a0,a0,76 # 8000a508 <CONSOLE_STATUS+0x4f8>
    800054c4:	00002097          	auipc	ra,0x2
    800054c8:	614080e7          	jalr	1556(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a0: ");printIntS(r_a0(), 16);printStringS("\t");
    800054cc:	00005517          	auipc	a0,0x5
    800054d0:	04450513          	addi	a0,a0,68 # 8000a510 <CONSOLE_STATUS+0x500>
    800054d4:	00002097          	auipc	ra,0x2
    800054d8:	604080e7          	jalr	1540(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a0], a0" : [a0] "=r"(a0));
    800054dc:	00050793          	mv	a5,a0
    800054e0:	f2f43423          	sd	a5,-216(s0)
    return a0;
    800054e4:	f2843503          	ld	a0,-216(s0)
    printStringS("a0: ");printIntS(r_a0(), 16);printStringS("\t");
    800054e8:	00000613          	li	a2,0
    800054ec:	01000593          	li	a1,16
    800054f0:	0005051b          	sext.w	a0,a0
    800054f4:	00002097          	auipc	ra,0x2
    800054f8:	678080e7          	jalr	1656(ra) # 80007b6c <_Z9printIntSiii>
    800054fc:	00005517          	auipc	a0,0x5
    80005500:	fd450513          	addi	a0,a0,-44 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80005504:	00002097          	auipc	ra,0x2
    80005508:	5d4080e7          	jalr	1492(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a1: ");printIntS(r_a1(), 16);printStringS("\t");
    8000550c:	00005517          	auipc	a0,0x5
    80005510:	00c50513          	addi	a0,a0,12 # 8000a518 <CONSOLE_STATUS+0x508>
    80005514:	00002097          	auipc	ra,0x2
    80005518:	5c4080e7          	jalr	1476(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a1], a1" : [a1] "=r"(a1));
    8000551c:	00058793          	mv	a5,a1
    80005520:	f2f43823          	sd	a5,-208(s0)
    return a1;
    80005524:	f3043503          	ld	a0,-208(s0)
    printStringS("a1: ");printIntS(r_a1(), 16);printStringS("\t");
    80005528:	00000613          	li	a2,0
    8000552c:	01000593          	li	a1,16
    80005530:	0005051b          	sext.w	a0,a0
    80005534:	00002097          	auipc	ra,0x2
    80005538:	638080e7          	jalr	1592(ra) # 80007b6c <_Z9printIntSiii>
    8000553c:	00005517          	auipc	a0,0x5
    80005540:	f9450513          	addi	a0,a0,-108 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80005544:	00002097          	auipc	ra,0x2
    80005548:	594080e7          	jalr	1428(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a2: ");printIntS(r_a2(), 16);printStringS("\t");
    8000554c:	00005517          	auipc	a0,0x5
    80005550:	fd450513          	addi	a0,a0,-44 # 8000a520 <CONSOLE_STATUS+0x510>
    80005554:	00002097          	auipc	ra,0x2
    80005558:	584080e7          	jalr	1412(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a2], a2" : [a2] "=r"(a2));
    8000555c:	00060793          	mv	a5,a2
    80005560:	f2f43c23          	sd	a5,-200(s0)
    return a2;
    80005564:	f3843503          	ld	a0,-200(s0)
    printStringS("a2: ");printIntS(r_a2(), 16);printStringS("\t");
    80005568:	00000613          	li	a2,0
    8000556c:	01000593          	li	a1,16
    80005570:	0005051b          	sext.w	a0,a0
    80005574:	00002097          	auipc	ra,0x2
    80005578:	5f8080e7          	jalr	1528(ra) # 80007b6c <_Z9printIntSiii>
    8000557c:	00005517          	auipc	a0,0x5
    80005580:	f5450513          	addi	a0,a0,-172 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    80005584:	00002097          	auipc	ra,0x2
    80005588:	554080e7          	jalr	1364(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a3: ");printIntS(r_a3(), 16);printStringS("\t");
    8000558c:	00005517          	auipc	a0,0x5
    80005590:	f9c50513          	addi	a0,a0,-100 # 8000a528 <CONSOLE_STATUS+0x518>
    80005594:	00002097          	auipc	ra,0x2
    80005598:	544080e7          	jalr	1348(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a3], a3" : [a3] "=r"(a3));
    8000559c:	00068793          	mv	a5,a3
    800055a0:	f4f43023          	sd	a5,-192(s0)
    return a3;
    800055a4:	f4043503          	ld	a0,-192(s0)
    printStringS("a3: ");printIntS(r_a3(), 16);printStringS("\t");
    800055a8:	00000613          	li	a2,0
    800055ac:	01000593          	li	a1,16
    800055b0:	0005051b          	sext.w	a0,a0
    800055b4:	00002097          	auipc	ra,0x2
    800055b8:	5b8080e7          	jalr	1464(ra) # 80007b6c <_Z9printIntSiii>
    800055bc:	00005517          	auipc	a0,0x5
    800055c0:	f1450513          	addi	a0,a0,-236 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    800055c4:	00002097          	auipc	ra,0x2
    800055c8:	514080e7          	jalr	1300(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a4: ");printIntS(r_a4(), 16);printStringS("\n\t\t");
    800055cc:	00005517          	auipc	a0,0x5
    800055d0:	f6450513          	addi	a0,a0,-156 # 8000a530 <CONSOLE_STATUS+0x520>
    800055d4:	00002097          	auipc	ra,0x2
    800055d8:	504080e7          	jalr	1284(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a4], a4" : [a4] "=r"(a4));
    800055dc:	00070793          	mv	a5,a4
    800055e0:	f4f43423          	sd	a5,-184(s0)
    return a4;
    800055e4:	f4843503          	ld	a0,-184(s0)
    printStringS("a4: ");printIntS(r_a4(), 16);printStringS("\n\t\t");
    800055e8:	00000613          	li	a2,0
    800055ec:	01000593          	li	a1,16
    800055f0:	0005051b          	sext.w	a0,a0
    800055f4:	00002097          	auipc	ra,0x2
    800055f8:	578080e7          	jalr	1400(ra) # 80007b6c <_Z9printIntSiii>
    800055fc:	00005517          	auipc	a0,0x5
    80005600:	f0c50513          	addi	a0,a0,-244 # 8000a508 <CONSOLE_STATUS+0x4f8>
    80005604:	00002097          	auipc	ra,0x2
    80005608:	4d4080e7          	jalr	1236(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile("li t0, 0x5555");
    8000560c:	000052b7          	lui	t0,0x5
    80005610:	5552829b          	addiw	t0,t0,1365
    __asm__ volatile("li t1, 0x100000");
    80005614:	00100337          	lui	t1,0x100
    __asm__ volatile("sw t0, 0(t1) ");
    80005618:	00532023          	sw	t0,0(t1) # 100000 <_entry-0x7ff00000>
                return;
    8000561c:	b1dff06f          	j	80005138 <_ZN8Handlers14handleSyscallsEv+0x458>
    else if(mode == SUPERVISOR)
    80005620:	00100713          	li	a4,1
    80005624:	ace794e3          	bne	a5,a4,800050ec <_ZN8Handlers14handleSyscallsEv+0x40c>
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
    80005628:	10000793          	li	a5,256
    8000562c:	1007a073          	csrs	sstatus,a5
}
    80005630:	abdff06f          	j	800050ec <_ZN8Handlers14handleSyscallsEv+0x40c>
            printStringS("ERROR: handleSyscalls.switch.default: \n");
    80005634:	00005517          	auipc	a0,0x5
    80005638:	f3450513          	addi	a0,a0,-204 # 8000a568 <CONSOLE_STATUS+0x558>
    8000563c:	00002097          	auipc	ra,0x2
    80005640:	49c080e7          	jalr	1180(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("\t\t");
    80005644:	00005517          	auipc	a0,0x5
    80005648:	e7450513          	addi	a0,a0,-396 # 8000a4b8 <CONSOLE_STATUS+0x4a8>
    8000564c:	00002097          	auipc	ra,0x2
    80005650:	48c080e7          	jalr	1164(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("scause: ");printIntS(r_scause(), 16);printStringS("\t");
    80005654:	00005517          	auipc	a0,0x5
    80005658:	e6c50513          	addi	a0,a0,-404 # 8000a4c0 <CONSOLE_STATUS+0x4b0>
    8000565c:	00002097          	auipc	ra,0x2
    80005660:	47c080e7          	jalr	1148(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    80005664:	142027f3          	csrr	a5,scause
    80005668:	f4f43823          	sd	a5,-176(s0)
    return scause;
    8000566c:	f5043503          	ld	a0,-176(s0)
    printStringS("scause: ");printIntS(r_scause(), 16);printStringS("\t");
    80005670:	00000613          	li	a2,0
    80005674:	01000593          	li	a1,16
    80005678:	0005051b          	sext.w	a0,a0
    8000567c:	00002097          	auipc	ra,0x2
    80005680:	4f0080e7          	jalr	1264(ra) # 80007b6c <_Z9printIntSiii>
    80005684:	00005517          	auipc	a0,0x5
    80005688:	e4c50513          	addi	a0,a0,-436 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    8000568c:	00002097          	auipc	ra,0x2
    80005690:	44c080e7          	jalr	1100(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("sstatus: ");printIntS(r_sstatus(), 16);printStringS("\t");
    80005694:	00005517          	auipc	a0,0x5
    80005698:	e4450513          	addi	a0,a0,-444 # 8000a4d8 <CONSOLE_STATUS+0x4c8>
    8000569c:	00002097          	auipc	ra,0x2
    800056a0:	43c080e7          	jalr	1084(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    800056a4:	100027f3          	csrr	a5,sstatus
    800056a8:	f4f43c23          	sd	a5,-168(s0)
    return sstatus;
    800056ac:	f5843503          	ld	a0,-168(s0)
    printStringS("sstatus: ");printIntS(r_sstatus(), 16);printStringS("\t");
    800056b0:	00000613          	li	a2,0
    800056b4:	01000593          	li	a1,16
    800056b8:	0005051b          	sext.w	a0,a0
    800056bc:	00002097          	auipc	ra,0x2
    800056c0:	4b0080e7          	jalr	1200(ra) # 80007b6c <_Z9printIntSiii>
    800056c4:	00005517          	auipc	a0,0x5
    800056c8:	e0c50513          	addi	a0,a0,-500 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    800056cc:	00002097          	auipc	ra,0x2
    800056d0:	40c080e7          	jalr	1036(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("sepc: ");printIntS(r_sepc(), 16);printStringS("\t");
    800056d4:	00005517          	auipc	a0,0x5
    800056d8:	e1450513          	addi	a0,a0,-492 # 8000a4e8 <CONSOLE_STATUS+0x4d8>
    800056dc:	00002097          	auipc	ra,0x2
    800056e0:	3fc080e7          	jalr	1020(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    800056e4:	141027f3          	csrr	a5,sepc
    800056e8:	f6f43023          	sd	a5,-160(s0)
    return sepc;
    800056ec:	f6043503          	ld	a0,-160(s0)
    printStringS("sepc: ");printIntS(r_sepc(), 16);printStringS("\t");
    800056f0:	00000613          	li	a2,0
    800056f4:	01000593          	li	a1,16
    800056f8:	0005051b          	sext.w	a0,a0
    800056fc:	00002097          	auipc	ra,0x2
    80005700:	470080e7          	jalr	1136(ra) # 80007b6c <_Z9printIntSiii>
    80005704:	00005517          	auipc	a0,0x5
    80005708:	dcc50513          	addi	a0,a0,-564 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    8000570c:	00002097          	auipc	ra,0x2
    80005710:	3cc080e7          	jalr	972(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("sip: ");printIntS(r_sip(), 16);printStringS("\t");
    80005714:	00005517          	auipc	a0,0x5
    80005718:	ddc50513          	addi	a0,a0,-548 # 8000a4f0 <CONSOLE_STATUS+0x4e0>
    8000571c:	00002097          	auipc	ra,0x2
    80005720:	3bc080e7          	jalr	956(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[sip], sip" : [sip] "=r"(sip));
    80005724:	144027f3          	csrr	a5,sip
    80005728:	f6f43423          	sd	a5,-152(s0)
    return sip;
    8000572c:	f6843503          	ld	a0,-152(s0)
    printStringS("sip: ");printIntS(r_sip(), 16);printStringS("\t");
    80005730:	00000613          	li	a2,0
    80005734:	01000593          	li	a1,16
    80005738:	0005051b          	sext.w	a0,a0
    8000573c:	00002097          	auipc	ra,0x2
    80005740:	430080e7          	jalr	1072(ra) # 80007b6c <_Z9printIntSiii>
    80005744:	00005517          	auipc	a0,0x5
    80005748:	d8c50513          	addi	a0,a0,-628 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    8000574c:	00002097          	auipc	ra,0x2
    80005750:	38c080e7          	jalr	908(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("stval: ");printIntS(r_stval(), 16);printStringS("\t");
    80005754:	00005517          	auipc	a0,0x5
    80005758:	da450513          	addi	a0,a0,-604 # 8000a4f8 <CONSOLE_STATUS+0x4e8>
    8000575c:	00002097          	auipc	ra,0x2
    80005760:	37c080e7          	jalr	892(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[stval], stval" : [stval] "=r"(stval));
    80005764:	143027f3          	csrr	a5,stval
    80005768:	f6f43823          	sd	a5,-144(s0)
    return stval;
    8000576c:	f7043503          	ld	a0,-144(s0)
    printStringS("stval: ");printIntS(r_stval(), 16);printStringS("\t");
    80005770:	00000613          	li	a2,0
    80005774:	01000593          	li	a1,16
    80005778:	0005051b          	sext.w	a0,a0
    8000577c:	00002097          	auipc	ra,0x2
    80005780:	3f0080e7          	jalr	1008(ra) # 80007b6c <_Z9printIntSiii>
    80005784:	00005517          	auipc	a0,0x5
    80005788:	d4c50513          	addi	a0,a0,-692 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    8000578c:	00002097          	auipc	ra,0x2
    80005790:	34c080e7          	jalr	844(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("stvec: ");printIntS(r_stvec(), 16);printStringS("\n\t\t");
    80005794:	00005517          	auipc	a0,0x5
    80005798:	d6c50513          	addi	a0,a0,-660 # 8000a500 <CONSOLE_STATUS+0x4f0>
    8000579c:	00002097          	auipc	ra,0x2
    800057a0:	33c080e7          	jalr	828(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("csrr %[stvec], stvec" : [stvec] "=r"(stvec));
    800057a4:	105027f3          	csrr	a5,stvec
    800057a8:	f6f43c23          	sd	a5,-136(s0)
    return stvec;
    800057ac:	f7843503          	ld	a0,-136(s0)
    printStringS("stvec: ");printIntS(r_stvec(), 16);printStringS("\n\t\t");
    800057b0:	00000613          	li	a2,0
    800057b4:	01000593          	li	a1,16
    800057b8:	0005051b          	sext.w	a0,a0
    800057bc:	00002097          	auipc	ra,0x2
    800057c0:	3b0080e7          	jalr	944(ra) # 80007b6c <_Z9printIntSiii>
    800057c4:	00005517          	auipc	a0,0x5
    800057c8:	d4450513          	addi	a0,a0,-700 # 8000a508 <CONSOLE_STATUS+0x4f8>
    800057cc:	00002097          	auipc	ra,0x2
    800057d0:	30c080e7          	jalr	780(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a0: ");printIntS(r_a0(), 16);printStringS("\t");
    800057d4:	00005517          	auipc	a0,0x5
    800057d8:	d3c50513          	addi	a0,a0,-708 # 8000a510 <CONSOLE_STATUS+0x500>
    800057dc:	00002097          	auipc	ra,0x2
    800057e0:	2fc080e7          	jalr	764(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a0], a0" : [a0] "=r"(a0));
    800057e4:	00050793          	mv	a5,a0
    800057e8:	f8f43023          	sd	a5,-128(s0)
    return a0;
    800057ec:	f8043503          	ld	a0,-128(s0)
    printStringS("a0: ");printIntS(r_a0(), 16);printStringS("\t");
    800057f0:	00000613          	li	a2,0
    800057f4:	01000593          	li	a1,16
    800057f8:	0005051b          	sext.w	a0,a0
    800057fc:	00002097          	auipc	ra,0x2
    80005800:	370080e7          	jalr	880(ra) # 80007b6c <_Z9printIntSiii>
    80005804:	00005517          	auipc	a0,0x5
    80005808:	ccc50513          	addi	a0,a0,-820 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    8000580c:	00002097          	auipc	ra,0x2
    80005810:	2cc080e7          	jalr	716(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a1: ");printIntS(r_a1(), 16);printStringS("\t");
    80005814:	00005517          	auipc	a0,0x5
    80005818:	d0450513          	addi	a0,a0,-764 # 8000a518 <CONSOLE_STATUS+0x508>
    8000581c:	00002097          	auipc	ra,0x2
    80005820:	2bc080e7          	jalr	700(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a1], a1" : [a1] "=r"(a1));
    80005824:	00058793          	mv	a5,a1
    80005828:	f8f43423          	sd	a5,-120(s0)
    return a1;
    8000582c:	f8843503          	ld	a0,-120(s0)
    printStringS("a1: ");printIntS(r_a1(), 16);printStringS("\t");
    80005830:	00000613          	li	a2,0
    80005834:	01000593          	li	a1,16
    80005838:	0005051b          	sext.w	a0,a0
    8000583c:	00002097          	auipc	ra,0x2
    80005840:	330080e7          	jalr	816(ra) # 80007b6c <_Z9printIntSiii>
    80005844:	00005517          	auipc	a0,0x5
    80005848:	c8c50513          	addi	a0,a0,-884 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    8000584c:	00002097          	auipc	ra,0x2
    80005850:	28c080e7          	jalr	652(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a2: ");printIntS(r_a2(), 16);printStringS("\t");
    80005854:	00005517          	auipc	a0,0x5
    80005858:	ccc50513          	addi	a0,a0,-820 # 8000a520 <CONSOLE_STATUS+0x510>
    8000585c:	00002097          	auipc	ra,0x2
    80005860:	27c080e7          	jalr	636(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a2], a2" : [a2] "=r"(a2));
    80005864:	00060793          	mv	a5,a2
    80005868:	f8f43823          	sd	a5,-112(s0)
    return a2;
    8000586c:	f9043503          	ld	a0,-112(s0)
    printStringS("a2: ");printIntS(r_a2(), 16);printStringS("\t");
    80005870:	00000613          	li	a2,0
    80005874:	01000593          	li	a1,16
    80005878:	0005051b          	sext.w	a0,a0
    8000587c:	00002097          	auipc	ra,0x2
    80005880:	2f0080e7          	jalr	752(ra) # 80007b6c <_Z9printIntSiii>
    80005884:	00005517          	auipc	a0,0x5
    80005888:	c4c50513          	addi	a0,a0,-948 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    8000588c:	00002097          	auipc	ra,0x2
    80005890:	24c080e7          	jalr	588(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a3: ");printIntS(r_a3(), 16);printStringS("\t");
    80005894:	00005517          	auipc	a0,0x5
    80005898:	c9450513          	addi	a0,a0,-876 # 8000a528 <CONSOLE_STATUS+0x518>
    8000589c:	00002097          	auipc	ra,0x2
    800058a0:	23c080e7          	jalr	572(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a3], a3" : [a3] "=r"(a3));
    800058a4:	00068793          	mv	a5,a3
    800058a8:	f8f43c23          	sd	a5,-104(s0)
    return a3;
    800058ac:	f9843503          	ld	a0,-104(s0)
    printStringS("a3: ");printIntS(r_a3(), 16);printStringS("\t");
    800058b0:	00000613          	li	a2,0
    800058b4:	01000593          	li	a1,16
    800058b8:	0005051b          	sext.w	a0,a0
    800058bc:	00002097          	auipc	ra,0x2
    800058c0:	2b0080e7          	jalr	688(ra) # 80007b6c <_Z9printIntSiii>
    800058c4:	00005517          	auipc	a0,0x5
    800058c8:	c0c50513          	addi	a0,a0,-1012 # 8000a4d0 <CONSOLE_STATUS+0x4c0>
    800058cc:	00002097          	auipc	ra,0x2
    800058d0:	20c080e7          	jalr	524(ra) # 80007ad8 <_Z12printStringSPKc>
    printStringS("a4: ");printIntS(r_a4(), 16);printStringS("\n\t\t");
    800058d4:	00005517          	auipc	a0,0x5
    800058d8:	c5c50513          	addi	a0,a0,-932 # 8000a530 <CONSOLE_STATUS+0x520>
    800058dc:	00002097          	auipc	ra,0x2
    800058e0:	1fc080e7          	jalr	508(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile ("mv %[a4], a4" : [a4] "=r"(a4));
    800058e4:	00070793          	mv	a5,a4
    800058e8:	faf43023          	sd	a5,-96(s0)
    return a4;
    800058ec:	fa043503          	ld	a0,-96(s0)
    printStringS("a4: ");printIntS(r_a4(), 16);printStringS("\n\t\t");
    800058f0:	00000613          	li	a2,0
    800058f4:	01000593          	li	a1,16
    800058f8:	0005051b          	sext.w	a0,a0
    800058fc:	00002097          	auipc	ra,0x2
    80005900:	270080e7          	jalr	624(ra) # 80007b6c <_Z9printIntSiii>
    80005904:	00005517          	auipc	a0,0x5
    80005908:	c0450513          	addi	a0,a0,-1020 # 8000a508 <CONSOLE_STATUS+0x4f8>
    8000590c:	00002097          	auipc	ra,0x2
    80005910:	1cc080e7          	jalr	460(ra) # 80007ad8 <_Z12printStringSPKc>
            ret = 0;
    80005914:	fc043023          	sd	zero,-64(s0)
            return;
    80005918:	821ff06f          	j	80005138 <_ZN8Handlers14handleSyscallsEv+0x458>

000000008000591c <_ZN8Handlers11handleTimerEv>:

int Handlers::handleTimer() {
    8000591c:	fb010113          	addi	sp,sp,-80
    80005920:	04113423          	sd	ra,72(sp)
    80005924:	04813023          	sd	s0,64(sp)
    80005928:	02913c23          	sd	s1,56(sp)
    8000592c:	05010413          	addi	s0,sp,80
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    80005930:	142027f3          	csrr	a5,scause
    80005934:	fcf43023          	sd	a5,-64(s0)
    return scause;
    80005938:	fc043783          	ld	a5,-64(s0)
    uint64 volatile cause = Riscv::r_scause();
    8000593c:	fcf43c23          	sd	a5,-40(s0)

    if(cause == 0x8000000000000001UL){ /// TIMER
    80005940:	fd843703          	ld	a4,-40(s0)
    80005944:	fff00793          	li	a5,-1
    80005948:	03f79793          	slli	a5,a5,0x3f
    8000594c:	00178793          	addi	a5,a5,1
    80005950:	00f70e63          	beq	a4,a5,8000596c <_ZN8Handlers11handleTimerEv+0x50>


        return 1;
    }

    return 0;
    80005954:	00000513          	li	a0,0
}
    80005958:	04813083          	ld	ra,72(sp)
    8000595c:	04013403          	ld	s0,64(sp)
    80005960:	03813483          	ld	s1,56(sp)
    80005964:	05010113          	addi	sp,sp,80
    80005968:	00008067          	ret
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
    8000596c:	00200793          	li	a5,2
    80005970:	1447b073          	csrc	sip,a5
        _thread::timeSliceCounter++;
    80005974:	00007497          	auipc	s1,0x7
    80005978:	4e44b483          	ld	s1,1252(s1) # 8000ce58 <_GLOBAL_OFFSET_TABLE_+0x78>
    8000597c:	0004b783          	ld	a5,0(s1)
    80005980:	00178793          	addi	a5,a5,1
    80005984:	00f4b023          	sd	a5,0(s1)
        _thread::timedWaitingHandler(); // timed waiting on semaphores
    80005988:	00000097          	auipc	ra,0x0
    8000598c:	328080e7          	jalr	808(ra) # 80005cb0 <_ZN7_thread19timedWaitingHandlerEv>
        _thread::timeSleepHandler(); // time_sleep wake up needed threads
    80005990:	00000097          	auipc	ra,0x0
    80005994:	174080e7          	jalr	372(ra) # 80005b04 <_ZN7_thread16timeSleepHandlerEv>
        if (_thread::timeSliceCounter >= _thread::running->getTimeSlice()){ // if time is up
    80005998:	00007797          	auipc	a5,0x7
    8000599c:	4687b783          	ld	a5,1128(a5) # 8000ce00 <_GLOBAL_OFFSET_TABLE_+0x20>
    800059a0:	0007b783          	ld	a5,0(a5)

    /// getters and setters
    enum State{RUNNING, READY, EXITED, FINISHED, BLOCKED, SLEEPING};

    void *getArg() const { return arg; }
    uint64 getTimeSlice() const { return timeSlice; }
    800059a4:	0307b783          	ld	a5,48(a5)
    800059a8:	0004b703          	ld	a4,0(s1)
    800059ac:	00f77663          	bgeu	a4,a5,800059b8 <_ZN8Handlers11handleTimerEv+0x9c>
        return 1;
    800059b0:	00100513          	li	a0,1
    800059b4:	fa5ff06f          	j	80005958 <_ZN8Handlers11handleTimerEv+0x3c>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    800059b8:	141027f3          	csrr	a5,sepc
    800059bc:	fcf43823          	sd	a5,-48(s0)
    return sepc;
    800059c0:	fd043783          	ld	a5,-48(s0)
            uint64 volatile sepc = Riscv::r_sepc();
    800059c4:	faf43823          	sd	a5,-80(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    800059c8:	100027f3          	csrr	a5,sstatus
    800059cc:	fcf43423          	sd	a5,-56(s0)
    return sstatus;
    800059d0:	fc843783          	ld	a5,-56(s0)
            uint64 volatile sstatus = Riscv::r_sstatus();
    800059d4:	faf43c23          	sd	a5,-72(s0)
            _thread::timeSliceCounter = 0;
    800059d8:	0004b023          	sd	zero,0(s1)
            _thread::dispatch();
    800059dc:	00000097          	auipc	ra,0x0
    800059e0:	400080e7          	jalr	1024(ra) # 80005ddc <_ZN7_thread8dispatchEv>
            Riscv::w_sstatus(sstatus);
    800059e4:	fb843783          	ld	a5,-72(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    800059e8:	10079073          	csrw	sstatus,a5
            Riscv::w_sepc(sepc);
    800059ec:	fb043783          	ld	a5,-80(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    800059f0:	14179073          	csrw	sepc,a5
}
    800059f4:	fbdff06f          	j	800059b0 <_ZN8Handlers11handleTimerEv+0x94>

00000000800059f8 <_ZN8Handlers13handleConsoleEv>:


int Handlers::handleConsole() {
    800059f8:	fe010113          	addi	sp,sp,-32
    800059fc:	00113c23          	sd	ra,24(sp)
    80005a00:	00813823          	sd	s0,16(sp)
    80005a04:	02010413          	addi	s0,sp,32
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    80005a08:	142027f3          	csrr	a5,scause
    80005a0c:	fef43023          	sd	a5,-32(s0)
    return scause;
    80005a10:	fe043783          	ld	a5,-32(s0)
    uint64 volatile cause = Riscv::r_scause();
    80005a14:	fef43423          	sd	a5,-24(s0)
    if(cause == 0x8000000000000009UL){ /// CONSOLE
    80005a18:	fe843703          	ld	a4,-24(s0)
    80005a1c:	fff00793          	li	a5,-1
    80005a20:	03f79793          	slli	a5,a5,0x3f
    80005a24:	00978793          	addi	a5,a5,9
    80005a28:	00f70c63          	beq	a4,a5,80005a40 <_ZN8Handlers13handleConsoleEv+0x48>
        _console::getcHandle();
       // console_handler(); // uncomment this to use GETC from lib
        Riscv::mc_sip(Riscv::SIP_SSIE); // interrupt done
        return 1;
    }
    return 0;
    80005a2c:	00000513          	li	a0,0
}
    80005a30:	01813083          	ld	ra,24(sp)
    80005a34:	01013403          	ld	s0,16(sp)
    80005a38:	02010113          	addi	sp,sp,32
    80005a3c:	00008067          	ret
        _console::getcHandle();
    80005a40:	00002097          	auipc	ra,0x2
    80005a44:	ba8080e7          	jalr	-1112(ra) # 800075e8 <_ZN8_console10getcHandleEv>
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
    80005a48:	00200793          	li	a5,2
    80005a4c:	1447b073          	csrc	sip,a5
        return 1;
    80005a50:	00100513          	li	a0,1
    80005a54:	fddff06f          	j	80005a30 <_ZN8Handlers13handleConsoleEv+0x38>

0000000080005a58 <_Z41__static_initialization_and_destruction_0ii>:
        } else { // if it doesn't have body, optimise and delete thread instantly
            this->setState(State::FINISHED);
            setFinished(true);
        }
    }
}
    80005a58:	ff010113          	addi	sp,sp,-16
    80005a5c:	00813423          	sd	s0,8(sp)
    80005a60:	01010413          	addi	s0,sp,16
    80005a64:	00100793          	li	a5,1
    80005a68:	00f50863          	beq	a0,a5,80005a78 <_Z41__static_initialization_and_destruction_0ii+0x20>
    80005a6c:	00813403          	ld	s0,8(sp)
    80005a70:	01010113          	addi	sp,sp,16
    80005a74:	00008067          	ret
    80005a78:	000107b7          	lui	a5,0x10
    80005a7c:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a80:	fef596e3          	bne	a1,a5,80005a6c <_Z41__static_initialization_and_destruction_0ii+0x14>

    Elem *head;

public:

    ListSorted() : head(0) {}
    80005a84:	00007797          	auipc	a5,0x7
    80005a88:	4607be23          	sd	zero,1148(a5) # 8000cf00 <_ZN7_thread8sleepingE>
    80005a8c:	fe1ff06f          	j	80005a6c <_Z41__static_initialization_and_destruction_0ii+0x14>

0000000080005a90 <_ZN7_thread13threadWrapperEv>:
void _thread::threadWrapper() {
    80005a90:	fe010113          	addi	sp,sp,-32
    80005a94:	00113c23          	sd	ra,24(sp)
    80005a98:	00813823          	sd	s0,16(sp)
    80005a9c:	00913423          	sd	s1,8(sp)
    80005aa0:	02010413          	addi	s0,sp,32
    Riscv::popSstatusSPPandSPIE(_thread::running != putcThr); /// go to previous privileges (exit supervisor)
    80005aa4:	00007497          	auipc	s1,0x7
    80005aa8:	45c48493          	addi	s1,s1,1116 # 8000cf00 <_ZN7_thread8sleepingE>
    80005aac:	0084b503          	ld	a0,8(s1)
    80005ab0:	0104b783          	ld	a5,16(s1)
    80005ab4:	40f50533          	sub	a0,a0,a5
    80005ab8:	00a03533          	snez	a0,a0
    80005abc:	00001097          	auipc	ra,0x1
    80005ac0:	2c0080e7          	jalr	704(ra) # 80006d7c <_ZN5Riscv20popSstatusSPPandSPIEEb>
    running->body(_thread::running->getArg()); /// running a function
    80005ac4:	0084b783          	ld	a5,8(s1)
    80005ac8:	0087b703          	ld	a4,8(a5)
    80005acc:	0107b503          	ld	a0,16(a5)
    80005ad0:	000700e7          	jalr	a4
    running->setFinished(true); /// it won't be put back in scheduler
    80005ad4:	0084b783          	ld	a5,8(s1)
    static int threadCreate(thread_t *handle, Body start_routine, void *arg, void* stack);
    static int threadExit();
    static int timeSleep(time_t time);

    /// some setters
    void setFinished(bool val) { _thread::finished = val; }
    80005ad8:	00100713          	li	a4,1
    80005adc:	02e78c23          	sb	a4,56(a5)
    void setState(State val) { _thread::state = val; }
    80005ae0:	00300713          	li	a4,3
    80005ae4:	02e7ae23          	sw	a4,60(a5)
    thread_dispatch(); // yield?
    80005ae8:	fffff097          	auipc	ra,0xfffff
    80005aec:	f64080e7          	jalr	-156(ra) # 80004a4c <thread_dispatch>
}
    80005af0:	01813083          	ld	ra,24(sp)
    80005af4:	01013403          	ld	s0,16(sp)
    80005af8:	00813483          	ld	s1,8(sp)
    80005afc:	02010113          	addi	sp,sp,32
    80005b00:	00008067          	ret

0000000080005b04 <_ZN7_thread16timeSleepHandlerEv>:
    for (ListSorted<_thread, time_t>::Elem* h = sleeping.head; h; h = h->next) {
    80005b04:	00007797          	auipc	a5,0x7
    80005b08:	3fc7b783          	ld	a5,1020(a5) # 8000cf00 <_ZN7_thread8sleepingE>
    80005b0c:	0080006f          	j	80005b14 <_ZN7_thread16timeSleepHandlerEv+0x10>
    80005b10:	0107b783          	ld	a5,16(a5)
    80005b14:	08078e63          	beqz	a5,80005bb0 <_ZN7_thread16timeSleepHandlerEv+0xac>
        if(h->data->time_sleeping > 0) h->data->time_sleeping--; // dec sleeping time
    80005b18:	0007b683          	ld	a3,0(a5)
    80005b1c:	0586b703          	ld	a4,88(a3)
    80005b20:	fe0708e3          	beqz	a4,80005b10 <_ZN7_thread16timeSleepHandlerEv+0xc>
    80005b24:	fff70713          	addi	a4,a4,-1
    80005b28:	04e6bc23          	sd	a4,88(a3)
    80005b2c:	fe5ff06f          	j	80005b10 <_ZN7_thread16timeSleepHandlerEv+0xc>

    T* removeFirst(){
        if (!head) { return 0; }

        Elem *el = head;
        head = head->next;
    80005b30:	0104b783          	ld	a5,16(s1)
    80005b34:	00007717          	auipc	a4,0x7
    80005b38:	3cf73623          	sd	a5,972(a4) # 8000cf00 <_ZN7_thread8sleepingE>

        T *ret = el->data;
    80005b3c:	0004b903          	ld	s2,0(s1)
            MemoryAllocator::instance().free(chunk);
    80005b40:	00002097          	auipc	ra,0x2
    80005b44:	bc0080e7          	jalr	-1088(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80005b48:	00048593          	mv	a1,s1
    80005b4c:	00002097          	auipc	ra,0x2
    80005b50:	e64080e7          	jalr	-412(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
    80005b54:	00100793          	li	a5,1
    80005b58:	02f92e23          	sw	a5,60(s2)
        Scheduler::put(t);
    80005b5c:	00090513          	mv	a0,s2
    80005b60:	00001097          	auipc	ra,0x1
    80005b64:	8d4080e7          	jalr	-1836(ra) # 80006434 <_ZN9Scheduler3putEP7_thread>
        return ret;
    }

    T *peekFirst()
    {
        if (!head) { return 0; }
    80005b68:	00007797          	auipc	a5,0x7
    80005b6c:	3987b783          	ld	a5,920(a5) # 8000cf00 <_ZN7_thread8sleepingE>
    80005b70:	02078463          	beqz	a5,80005b98 <_ZN7_thread16timeSleepHandlerEv+0x94>
        return head->data;
    80005b74:	0007b783          	ld	a5,0(a5)
    while (sleeping.peekFirst() && sleeping.peekFirst()->shouldWakeUp()){ // since it's sorted list, first elements should always wake up first
    80005b78:	02078063          	beqz	a5,80005b98 <_ZN7_thread16timeSleepHandlerEv+0x94>
    void setArg(void *val) { _thread::arg = val; }
    void setTimeSlice(uint64 val) { _thread::timeSlice = val; }

    /// for sleeping
    static void timeSleepHandler();
    bool shouldWakeUp() const { return time_sleeping <= 0; }
    80005b7c:	0587b783          	ld	a5,88(a5)
    80005b80:	00079c63          	bnez	a5,80005b98 <_ZN7_thread16timeSleepHandlerEv+0x94>
        if (!head) { return 0; }
    80005b84:	00007497          	auipc	s1,0x7
    80005b88:	37c4b483          	ld	s1,892(s1) # 8000cf00 <_ZN7_thread8sleepingE>
    80005b8c:	fa0492e3          	bnez	s1,80005b30 <_ZN7_thread16timeSleepHandlerEv+0x2c>
    80005b90:	00048913          	mv	s2,s1
    80005b94:	fc1ff06f          	j	80005b54 <_ZN7_thread16timeSleepHandlerEv+0x50>
}
    80005b98:	01813083          	ld	ra,24(sp)
    80005b9c:	01013403          	ld	s0,16(sp)
    80005ba0:	00813483          	ld	s1,8(sp)
    80005ba4:	00013903          	ld	s2,0(sp)
    80005ba8:	02010113          	addi	sp,sp,32
    80005bac:	00008067          	ret
        if (!head) { return 0; }
    80005bb0:	00007797          	auipc	a5,0x7
    80005bb4:	3507b783          	ld	a5,848(a5) # 8000cf00 <_ZN7_thread8sleepingE>
    80005bb8:	02078863          	beqz	a5,80005be8 <_ZN7_thread16timeSleepHandlerEv+0xe4>
        return head->data;
    80005bbc:	0007b783          	ld	a5,0(a5)
    while (sleeping.peekFirst() && sleeping.peekFirst()->shouldWakeUp()){ // since it's sorted list, first elements should always wake up first
    80005bc0:	02078463          	beqz	a5,80005be8 <_ZN7_thread16timeSleepHandlerEv+0xe4>
    80005bc4:	0587b783          	ld	a5,88(a5)
    80005bc8:	02079063          	bnez	a5,80005be8 <_ZN7_thread16timeSleepHandlerEv+0xe4>
void _thread::timeSleepHandler(){
    80005bcc:	fe010113          	addi	sp,sp,-32
    80005bd0:	00113c23          	sd	ra,24(sp)
    80005bd4:	00813823          	sd	s0,16(sp)
    80005bd8:	00913423          	sd	s1,8(sp)
    80005bdc:	01213023          	sd	s2,0(sp)
    80005be0:	02010413          	addi	s0,sp,32
    80005be4:	fa1ff06f          	j	80005b84 <_ZN7_thread16timeSleepHandlerEv+0x80>
    80005be8:	00008067          	ret

0000000080005bec <_ZN7_thread9timeSleepEm>:
int _thread::timeSleep(time_t time) {
    80005bec:	fd010113          	addi	sp,sp,-48
    80005bf0:	02113423          	sd	ra,40(sp)
    80005bf4:	02813023          	sd	s0,32(sp)
    80005bf8:	00913c23          	sd	s1,24(sp)
    80005bfc:	01213823          	sd	s2,16(sp)
    80005c00:	01313423          	sd	s3,8(sp)
    80005c04:	01413023          	sd	s4,0(sp)
    80005c08:	03010413          	addi	s0,sp,48
    running->time_sleeping = time;
    80005c0c:	00007797          	auipc	a5,0x7
    80005c10:	2f478793          	addi	a5,a5,756 # 8000cf00 <_ZN7_thread8sleepingE>
    80005c14:	0087b903          	ld	s2,8(a5)
    80005c18:	04a93c23          	sd	a0,88(s2)
    sleeping.add(running, &running->time_sleeping);
    80005c1c:	05890a13          	addi	s4,s2,88
        Elem* h = head, *prev = nullptr;
    80005c20:	0007b483          	ld	s1,0(a5)
    80005c24:	00000993          	li	s3,0
        while (h && h->param <= param){
    80005c28:	00048c63          	beqz	s1,80005c40 <_ZN7_thread9timeSleepEm+0x54>
    80005c2c:	0084b783          	ld	a5,8(s1)
    80005c30:	00fa6863          	bltu	s4,a5,80005c40 <_ZN7_thread9timeSleepEm+0x54>
            prev = h;
    80005c34:	00048993          	mv	s3,s1
            h = h->next;
    80005c38:	0104b483          	ld	s1,16(s1)
        while (h && h->param <= param){
    80005c3c:	fedff06f          	j	80005c28 <_ZN7_thread9timeSleepEm+0x3c>
            return MemoryAllocator::instance().malloc(size);
    80005c40:	00002097          	auipc	ra,0x2
    80005c44:	ac0080e7          	jalr	-1344(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80005c48:	01800593          	li	a1,24
    80005c4c:	00002097          	auipc	ra,0x2
    80005c50:	bd4080e7          	jalr	-1068(ra) # 80007820 <_ZN15MemoryAllocator6mallocEm>
        Elem(T *data, P* param, Elem *next = nullptr) : data(data), param(param), next(next) {}
    80005c54:	01253023          	sd	s2,0(a0)
    80005c58:	01453423          	sd	s4,8(a0)
    80005c5c:	00953823          	sd	s1,16(a0)
        if(!prev) // first
    80005c60:	04098263          	beqz	s3,80005ca4 <_ZN7_thread9timeSleepEm+0xb8>
            prev->next = el;
    80005c64:	00a9b823          	sd	a0,16(s3)
    void setState(State val) { _thread::state = val; }
    80005c68:	00007797          	auipc	a5,0x7
    80005c6c:	2a07b783          	ld	a5,672(a5) # 8000cf08 <_ZN7_thread7runningE>
    80005c70:	00500713          	li	a4,5
    80005c74:	02e7ae23          	sw	a4,60(a5)
    thread_dispatch();
    80005c78:	fffff097          	auipc	ra,0xfffff
    80005c7c:	dd4080e7          	jalr	-556(ra) # 80004a4c <thread_dispatch>
}
    80005c80:	00000513          	li	a0,0
    80005c84:	02813083          	ld	ra,40(sp)
    80005c88:	02013403          	ld	s0,32(sp)
    80005c8c:	01813483          	ld	s1,24(sp)
    80005c90:	01013903          	ld	s2,16(sp)
    80005c94:	00813983          	ld	s3,8(sp)
    80005c98:	00013a03          	ld	s4,0(sp)
    80005c9c:	03010113          	addi	sp,sp,48
    80005ca0:	00008067          	ret
            head = el;
    80005ca4:	00007797          	auipc	a5,0x7
    80005ca8:	24a7be23          	sd	a0,604(a5) # 8000cf00 <_ZN7_thread8sleepingE>
    80005cac:	fbdff06f          	j	80005c68 <_ZN7_thread9timeSleepEm+0x7c>

0000000080005cb0 <_ZN7_thread19timedWaitingHandlerEv>:
void _thread::timedWaitingHandler(){
    80005cb0:	fd010113          	addi	sp,sp,-48
    80005cb4:	02113423          	sd	ra,40(sp)
    80005cb8:	02813023          	sd	s0,32(sp)
    80005cbc:	00913c23          	sd	s1,24(sp)
    80005cc0:	01213823          	sd	s2,16(sp)
    80005cc4:	01313423          	sd	s3,8(sp)
    80005cc8:	03010413          	addi	s0,sp,48
    for (_sem* s = _sem::head; s ;) { // all semaphores
    80005ccc:	00007797          	auipc	a5,0x7
    80005cd0:	1647b783          	ld	a5,356(a5) # 8000ce30 <_GLOBAL_OFFSET_TABLE_+0x50>
    80005cd4:	0007b903          	ld	s2,0(a5)
    80005cd8:	0080006f          	j	80005ce0 <_ZN7_thread19timedWaitingHandlerEv+0x30>
        s = snext;
    80005cdc:	00098913          	mv	s2,s3
    for (_sem* s = _sem::head; s ;) { // all semaphores
    80005ce0:	04090c63          	beqz	s2,80005d38 <_ZN7_thread19timedWaitingHandlerEv+0x88>
        _sem* snext = s->next;
    80005ce4:	01893983          	ld	s3,24(s2)
        for (List<_thread>::Elem* t = s->blocked.head; t ; ) { // all blocked threads
    80005ce8:	00893783          	ld	a5,8(s2)
    80005cec:	0140006f          	j	80005d00 <_ZN7_thread19timedWaitingHandlerEv+0x50>
                if(t->data->isTimedout()){
    80005cf0:	0007b583          	ld	a1,0(a5)
    _sem* getTimedSem() const { return timed_sem; }

    bool isTimedWaiting() const { return timed_sem != nullptr; }

    void setTimeout(time_t to) { timeout = to; }
    bool isTimedout() const { return timeout <=0; }
    80005cf4:	0505b783          	ld	a5,80(a1)
    80005cf8:	02078863          	beqz	a5,80005d28 <_ZN7_thread19timedWaitingHandlerEv+0x78>
        s = snext;
    80005cfc:	00048793          	mv	a5,s1
        for (List<_thread>::Elem* t = s->blocked.head; t ; ) { // all blocked threads
    80005d00:	fc078ee3          	beqz	a5,80005cdc <_ZN7_thread19timedWaitingHandlerEv+0x2c>
            List<_thread>::Elem* nxt = t->next;
    80005d04:	0087b483          	ld	s1,8(a5)
            if(t->data->isTimedWaiting()){
    80005d08:	0007b703          	ld	a4,0(a5)
    bool isTimedWaiting() const { return timed_sem != nullptr; }
    80005d0c:	04873683          	ld	a3,72(a4)
    80005d10:	fe0686e3          	beqz	a3,80005cfc <_ZN7_thread19timedWaitingHandlerEv+0x4c>
                if(t->data->timeout > 0) t->data->timeout--; // dec timeout
    80005d14:	05073683          	ld	a3,80(a4)
    80005d18:	fc068ce3          	beqz	a3,80005cf0 <_ZN7_thread19timedWaitingHandlerEv+0x40>
    80005d1c:	fff68693          	addi	a3,a3,-1
    80005d20:	04d73823          	sd	a3,80(a4)
    80005d24:	fcdff06f          	j	80005cf0 <_ZN7_thread19timedWaitingHandlerEv+0x40>
                    s->unblock_timedout(t->data);
    80005d28:	00090513          	mv	a0,s2
    80005d2c:	00001097          	auipc	ra,0x1
    80005d30:	4c4080e7          	jalr	1220(ra) # 800071f0 <_ZN4_sem16unblock_timedoutEP7_thread>
    80005d34:	fc9ff06f          	j	80005cfc <_ZN7_thread19timedWaitingHandlerEv+0x4c>
}
    80005d38:	02813083          	ld	ra,40(sp)
    80005d3c:	02013403          	ld	s0,32(sp)
    80005d40:	01813483          	ld	s1,24(sp)
    80005d44:	01013903          	ld	s2,16(sp)
    80005d48:	00813983          	ld	s3,8(sp)
    80005d4c:	03010113          	addi	sp,sp,48
    80005d50:	00008067          	ret

0000000080005d54 <_ZN7_thread14schedulerEmptyEv>:
bool _thread::schedulerEmpty() {
    80005d54:	ff010113          	addi	sp,sp,-16
    80005d58:	00113423          	sd	ra,8(sp)
    80005d5c:	00813023          	sd	s0,0(sp)
    80005d60:	01010413          	addi	s0,sp,16
    return Scheduler::peek_first() == nullptr;
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	744080e7          	jalr	1860(ra) # 800064a8 <_ZN9Scheduler10peek_firstEv>
}
    80005d6c:	00153513          	seqz	a0,a0
    80005d70:	00813083          	ld	ra,8(sp)
    80005d74:	00013403          	ld	s0,0(sp)
    80005d78:	01010113          	addi	sp,sp,16
    80005d7c:	00008067          	ret

0000000080005d80 <_ZN7_thread23schedulerOnlyMainThreadEv>:
bool _thread::schedulerOnlyMainThread() {
    80005d80:	ff010113          	addi	sp,sp,-16
    80005d84:	00113423          	sd	ra,8(sp)
    80005d88:	00813023          	sd	s0,0(sp)
    80005d8c:	01010413          	addi	s0,sp,16
    return Scheduler::peek_first() == mainThread && Scheduler::peek_last() == mainThread;
    80005d90:	00000097          	auipc	ra,0x0
    80005d94:	718080e7          	jalr	1816(ra) # 800064a8 <_ZN9Scheduler10peek_firstEv>
    80005d98:	00007797          	auipc	a5,0x7
    80005d9c:	1807b783          	ld	a5,384(a5) # 8000cf18 <_ZN7_thread10mainThreadE>
    80005da0:	00a78c63          	beq	a5,a0,80005db8 <_ZN7_thread23schedulerOnlyMainThreadEv+0x38>
    80005da4:	00000513          	li	a0,0
}
    80005da8:	00813083          	ld	ra,8(sp)
    80005dac:	00013403          	ld	s0,0(sp)
    80005db0:	01010113          	addi	sp,sp,16
    80005db4:	00008067          	ret
    return Scheduler::peek_first() == mainThread && Scheduler::peek_last() == mainThread;
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	718080e7          	jalr	1816(ra) # 800064d0 <_ZN9Scheduler9peek_lastEv>
    80005dc0:	00007797          	auipc	a5,0x7
    80005dc4:	1587b783          	ld	a5,344(a5) # 8000cf18 <_ZN7_thread10mainThreadE>
    80005dc8:	00a78663          	beq	a5,a0,80005dd4 <_ZN7_thread23schedulerOnlyMainThreadEv+0x54>
    80005dcc:	00000513          	li	a0,0
    80005dd0:	fd9ff06f          	j	80005da8 <_ZN7_thread23schedulerOnlyMainThreadEv+0x28>
    80005dd4:	00100513          	li	a0,1
    80005dd8:	fd1ff06f          	j	80005da8 <_ZN7_thread23schedulerOnlyMainThreadEv+0x28>

0000000080005ddc <_ZN7_thread8dispatchEv>:
void _thread::dispatch() {
    80005ddc:	fe010113          	addi	sp,sp,-32
    80005de0:	00113c23          	sd	ra,24(sp)
    80005de4:	00813823          	sd	s0,16(sp)
    80005de8:	00913423          	sd	s1,8(sp)
    80005dec:	01213023          	sd	s2,0(sp)
    80005df0:	02010413          	addi	s0,sp,32
    _thread* old = running;
    80005df4:	00007497          	auipc	s1,0x7
    80005df8:	1144b483          	ld	s1,276(s1) # 8000cf08 <_ZN7_thread7runningE>
    bool isFinished() const { return finished; }
    80005dfc:	0384c783          	lbu	a5,56(s1)
    if(!old->isFinished() && old->state != BLOCKED && old->state != SLEEPING){
    80005e00:	00079c63          	bnez	a5,80005e18 <_ZN7_thread8dispatchEv+0x3c>
    80005e04:	03c4a783          	lw	a5,60(s1)
    80005e08:	00400713          	li	a4,4
    80005e0c:	00e78663          	beq	a5,a4,80005e18 <_ZN7_thread8dispatchEv+0x3c>
    80005e10:	00500713          	li	a4,5
    80005e14:	06e79063          	bne	a5,a4,80005e74 <_ZN7_thread8dispatchEv+0x98>
    80005e18:	0384c903          	lbu	s2,56(s1)
    if (old_finished){
    80005e1c:	00090c63          	beqz	s2,80005e34 <_ZN7_thread8dispatchEv+0x58>
        delete old;
    80005e20:	00048a63          	beqz	s1,80005e34 <_ZN7_thread8dispatchEv+0x58>
    80005e24:	0004b783          	ld	a5,0(s1)
    80005e28:	0087b783          	ld	a5,8(a5)
    80005e2c:	00048513          	mv	a0,s1
    80005e30:	000780e7          	jalr	a5
    running = Scheduler::get();
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	584080e7          	jalr	1412(ra) # 800063b8 <_ZN9Scheduler3getEv>
    80005e3c:	00007797          	auipc	a5,0x7
    80005e40:	0ca7b623          	sd	a0,204(a5) # 8000cf08 <_ZN7_thread7runningE>
    void setState(State val) { _thread::state = val; }
    80005e44:	02052e23          	sw	zero,60(a0)
    _thread::contextSwitch(&old->context, &running->context, old_finished);
    80005e48:	00090613          	mv	a2,s2
    80005e4c:	02050593          	addi	a1,a0,32
    80005e50:	02048513          	addi	a0,s1,32
    80005e54:	ffffb097          	auipc	ra,0xffffb
    80005e58:	3a0080e7          	jalr	928(ra) # 800011f4 <_ZN7_thread13contextSwitchEPNS_7ContextES1_b>
}
    80005e5c:	01813083          	ld	ra,24(sp)
    80005e60:	01013403          	ld	s0,16(sp)
    80005e64:	00813483          	ld	s1,8(sp)
    80005e68:	00013903          	ld	s2,0(sp)
    80005e6c:	02010113          	addi	sp,sp,32
    80005e70:	00008067          	ret
        Scheduler::put(old);
    80005e74:	00048513          	mv	a0,s1
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	5bc080e7          	jalr	1468(ra) # 80006434 <_ZN9Scheduler3putEP7_thread>
    80005e80:	00100793          	li	a5,1
    80005e84:	02f4ae23          	sw	a5,60(s1)
    80005e88:	f91ff06f          	j	80005e18 <_ZN7_thread8dispatchEv+0x3c>

0000000080005e8c <_ZN7_thread10threadExitEv>:
int _thread::threadExit() {
    80005e8c:	ff010113          	addi	sp,sp,-16
    80005e90:	00113423          	sd	ra,8(sp)
    80005e94:	00813023          	sd	s0,0(sp)
    80005e98:	01010413          	addi	s0,sp,16
    running->setFinished(true);
    80005e9c:	00007797          	auipc	a5,0x7
    80005ea0:	06c7b783          	ld	a5,108(a5) # 8000cf08 <_ZN7_thread7runningE>
    void setFinished(bool val) { _thread::finished = val; }
    80005ea4:	00100713          	li	a4,1
    80005ea8:	02e78c23          	sb	a4,56(a5)
    void setState(State val) { _thread::state = val; }
    80005eac:	00200713          	li	a4,2
    80005eb0:	02e7ae23          	sw	a4,60(a5)
    thread_dispatch(); // yield?
    80005eb4:	fffff097          	auipc	ra,0xfffff
    80005eb8:	b98080e7          	jalr	-1128(ra) # 80004a4c <thread_dispatch>
}
    80005ebc:	fff00513          	li	a0,-1
    80005ec0:	00813083          	ld	ra,8(sp)
    80005ec4:	00013403          	ld	s0,0(sp)
    80005ec8:	01010113          	addi	sp,sp,16
    80005ecc:	00008067          	ret

0000000080005ed0 <_ZN7_threadC1EPFvPvES0_Pcm>:
        time_sleeping(0)
    80005ed0:	00007797          	auipc	a5,0x7
    80005ed4:	e7078793          	addi	a5,a5,-400 # 8000cd40 <_ZTV7_thread+0x10>
    80005ed8:	00f53023          	sd	a5,0(a0)
    80005edc:	00b53423          	sd	a1,8(a0)
    80005ee0:	00c53823          	sd	a2,16(a0)
    80005ee4:	00d53c23          	sd	a3,24(a0)
                        body != nullptr ? (uint64) &threadWrapper : 0,
    80005ee8:	06058663          	beqz	a1,80005f54 <_ZN7_threadC1EPFvPvES0_Pcm+0x84>
    80005eec:	00000797          	auipc	a5,0x0
    80005ef0:	ba478793          	addi	a5,a5,-1116 # 80005a90 <_ZN7_thread13threadWrapperEv>
        time_sleeping(0)
    80005ef4:	02f53023          	sd	a5,32(a0)
                        stack != nullptr ? (uint64) &stack[DEFAULT_STACK_SIZE] : 0  // top to bottom stack
    80005ef8:	06068263          	beqz	a3,80005f5c <_ZN7_threadC1EPFvPvES0_Pcm+0x8c>
    80005efc:	000017b7          	lui	a5,0x1
    80005f00:	00f686b3          	add	a3,a3,a5
        time_sleeping(0)
    80005f04:	02d53423          	sd	a3,40(a0)
    80005f08:	02e53823          	sd	a4,48(a0)
    80005f0c:	02050c23          	sb	zero,56(a0)
    80005f10:	00100793          	li	a5,1
    80005f14:	02f52e23          	sw	a5,60(a0)
    80005f18:	04052023          	sw	zero,64(a0)
    80005f1c:	04053423          	sd	zero,72(a0)
    80005f20:	04053823          	sd	zero,80(a0)
    80005f24:	04053c23          	sd	zero,88(a0)
    if(body != nullptr) {
    80005f28:	02058e63          	beqz	a1,80005f64 <_ZN7_threadC1EPFvPvES0_Pcm+0x94>
_thread::_thread(_thread::Body body, void *arg, char *stack, uint64 time_slice):
    80005f2c:	ff010113          	addi	sp,sp,-16
    80005f30:	00113423          	sd	ra,8(sp)
    80005f34:	00813023          	sd	s0,0(sp)
    80005f38:	01010413          	addi	s0,sp,16
            Scheduler::put(this);
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	4f8080e7          	jalr	1272(ra) # 80006434 <_ZN9Scheduler3putEP7_thread>
}
    80005f44:	00813083          	ld	ra,8(sp)
    80005f48:	00013403          	ld	s0,0(sp)
    80005f4c:	01010113          	addi	sp,sp,16
    80005f50:	00008067          	ret
                        body != nullptr ? (uint64) &threadWrapper : 0,
    80005f54:	00000793          	li	a5,0
    80005f58:	f9dff06f          	j	80005ef4 <_ZN7_threadC1EPFvPvES0_Pcm+0x24>
                        stack != nullptr ? (uint64) &stack[DEFAULT_STACK_SIZE] : 0  // top to bottom stack
    80005f5c:	00000693          	li	a3,0
    80005f60:	fa5ff06f          	j	80005f04 <_ZN7_threadC1EPFvPvES0_Pcm+0x34>
        if (!mainThread && body == nullptr) { // first thread is main thread
    80005f64:	00007797          	auipc	a5,0x7
    80005f68:	fb47b783          	ld	a5,-76(a5) # 8000cf18 <_ZN7_thread10mainThreadE>
    80005f6c:	00078c63          	beqz	a5,80005f84 <_ZN7_threadC1EPFvPvES0_Pcm+0xb4>
    80005f70:	00300793          	li	a5,3
    80005f74:	02f52e23          	sw	a5,60(a0)
    void setFinished(bool val) { _thread::finished = val; }
    80005f78:	00100793          	li	a5,1
    80005f7c:	02f50c23          	sb	a5,56(a0)
    80005f80:	00008067          	ret
            mainThread = this;
    80005f84:	00007797          	auipc	a5,0x7
    80005f88:	f7c78793          	addi	a5,a5,-132 # 8000cf00 <_ZN7_thread8sleepingE>
    80005f8c:	00a7bc23          	sd	a0,24(a5)
            running = this;
    80005f90:	00a7b423          	sd	a0,8(a5)
    void setState(State val) { _thread::state = val; }
    80005f94:	02052e23          	sw	zero,60(a0)
    80005f98:	00008067          	ret

0000000080005f9c <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_>:
int _thread::threadCreate(thread_t *handle, Body start_routine, void *arg, void* stack_space) {
    80005f9c:	fc010113          	addi	sp,sp,-64
    80005fa0:	02113c23          	sd	ra,56(sp)
    80005fa4:	02813823          	sd	s0,48(sp)
    80005fa8:	02913423          	sd	s1,40(sp)
    80005fac:	03213023          	sd	s2,32(sp)
    80005fb0:	01313c23          	sd	s3,24(sp)
    80005fb4:	01413823          	sd	s4,16(sp)
    80005fb8:	01513423          	sd	s5,8(sp)
    80005fbc:	04010413          	addi	s0,sp,64
    80005fc0:	00050a93          	mv	s5,a0
    80005fc4:	00058993          	mv	s3,a1
    80005fc8:	00060a13          	mv	s4,a2
    80005fcc:	00068493          	mv	s1,a3
    if (!stack_space){
    80005fd0:	02068c63          	beqz	a3,80006008 <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_+0x6c>
    void *operator new(size_t n){ return MemoryAllocator::instance().malloc(n); }
    80005fd4:	00001097          	auipc	ra,0x1
    80005fd8:	72c080e7          	jalr	1836(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80005fdc:	06000593          	li	a1,96
    80005fe0:	00002097          	auipc	ra,0x2
    80005fe4:	840080e7          	jalr	-1984(ra) # 80007820 <_ZN15MemoryAllocator6mallocEm>
    80005fe8:	00050913          	mv	s2,a0
    _thread* t = new _thread(start_routine, arg, stack, DEFAULT_TIME_SLICE);
    80005fec:	00200713          	li	a4,2
    80005ff0:	00048693          	mv	a3,s1
    80005ff4:	000a0613          	mv	a2,s4
    80005ff8:	00098593          	mv	a1,s3
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	ed4080e7          	jalr	-300(ra) # 80005ed0 <_ZN7_threadC1EPFvPvES0_Pcm>
    80006004:	0280006f          	j	8000602c <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_+0x90>
        stack = (char *)MemoryAllocator::instance().malloc(DEFAULT_STACK_SIZE);
    80006008:	00001097          	auipc	ra,0x1
    8000600c:	6f8080e7          	jalr	1784(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006010:	000015b7          	lui	a1,0x1
    80006014:	00002097          	auipc	ra,0x2
    80006018:	80c080e7          	jalr	-2036(ra) # 80007820 <_ZN15MemoryAllocator6mallocEm>
    8000601c:	00050493          	mv	s1,a0
        if (!stack) return -1; /// cannot allocate stack
    80006020:	fa051ae3          	bnez	a0,80005fd4 <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_+0x38>
    80006024:	fff00513          	li	a0,-1
    80006028:	0180006f          	j	80006040 <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_+0xa4>
    bool isFinished() const { return finished; }
    8000602c:	03894783          	lbu	a5,56(s2)
    if (t->isFinished()){ delete t; t = nullptr; *handle = t; return -3;}
    80006030:	02079a63          	bnez	a5,80006064 <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_+0xc8>
    *handle = (tmp!= nullptr)?t: nullptr;
    80006034:	012ab023          	sd	s2,0(s5)
    return (tmp!= nullptr)?0:-1;
    80006038:	04090663          	beqz	s2,80006084 <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_+0xe8>
    8000603c:	00000513          	li	a0,0
}
    80006040:	03813083          	ld	ra,56(sp)
    80006044:	03013403          	ld	s0,48(sp)
    80006048:	02813483          	ld	s1,40(sp)
    8000604c:	02013903          	ld	s2,32(sp)
    80006050:	01813983          	ld	s3,24(sp)
    80006054:	01013a03          	ld	s4,16(sp)
    80006058:	00813a83          	ld	s5,8(sp)
    8000605c:	04010113          	addi	sp,sp,64
    80006060:	00008067          	ret
    if (t->isFinished()){ delete t; t = nullptr; *handle = t; return -3;}
    80006064:	00090a63          	beqz	s2,80006078 <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_+0xdc>
    80006068:	00093783          	ld	a5,0(s2)
    8000606c:	0087b783          	ld	a5,8(a5)
    80006070:	00090513          	mv	a0,s2
    80006074:	000780e7          	jalr	a5
    80006078:	000ab023          	sd	zero,0(s5)
    8000607c:	ffd00513          	li	a0,-3
    80006080:	fc1ff06f          	j	80006040 <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_+0xa4>
    return (tmp!= nullptr)?0:-1;
    80006084:	fff00513          	li	a0,-1
    80006088:	fb9ff06f          	j	80006040 <_ZN7_thread12threadCreateEPPS_PFvPvES2_S2_+0xa4>
    8000608c:	00050493          	mv	s1,a0
    void operator delete(void *p) noexcept{ MemoryAllocator::instance().free(p); }
    80006090:	00001097          	auipc	ra,0x1
    80006094:	670080e7          	jalr	1648(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006098:	00090593          	mv	a1,s2
    8000609c:	00002097          	auipc	ra,0x2
    800060a0:	914080e7          	jalr	-1772(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
    800060a4:	00048513          	mv	a0,s1
    800060a8:	00008097          	auipc	ra,0x8
    800060ac:	fa0080e7          	jalr	-96(ra) # 8000e048 <_Unwind_Resume>

00000000800060b0 <_GLOBAL__sub_I__ZN7_thread7runningE>:
}
    800060b0:	ff010113          	addi	sp,sp,-16
    800060b4:	00113423          	sd	ra,8(sp)
    800060b8:	00813023          	sd	s0,0(sp)
    800060bc:	01010413          	addi	s0,sp,16
    800060c0:	000105b7          	lui	a1,0x10
    800060c4:	fff58593          	addi	a1,a1,-1 # ffff <_entry-0x7fff0001>
    800060c8:	00100513          	li	a0,1
    800060cc:	00000097          	auipc	ra,0x0
    800060d0:	98c080e7          	jalr	-1652(ra) # 80005a58 <_Z41__static_initialization_and_destruction_0ii>
    800060d4:	00813083          	ld	ra,8(sp)
    800060d8:	00013403          	ld	s0,0(sp)
    800060dc:	01010113          	addi	sp,sp,16
    800060e0:	00008067          	ret

00000000800060e4 <_ZN7_threadD1Ev>:
    virtual ~_thread(){
    800060e4:	fd010113          	addi	sp,sp,-48
    800060e8:	02113423          	sd	ra,40(sp)
    800060ec:	02813023          	sd	s0,32(sp)
    800060f0:	00913c23          	sd	s1,24(sp)
    800060f4:	01213823          	sd	s2,16(sp)
    800060f8:	01313423          	sd	s3,8(sp)
    800060fc:	03010413          	addi	s0,sp,48
    80006100:	00050493          	mv	s1,a0
    80006104:	00007797          	auipc	a5,0x7
    80006108:	c3c78793          	addi	a5,a5,-964 # 8000cd40 <_ZTV7_thread+0x10>
    8000610c:	00f53023          	sd	a5,0(a0)
        if(this != running) {
    80006110:	00007797          	auipc	a5,0x7
    80006114:	df87b783          	ld	a5,-520(a5) # 8000cf08 <_ZN7_thread7runningE>
    80006118:	00a78863          	beq	a5,a0,80006128 <_ZN7_threadD1Ev+0x44>
            bool removed = Scheduler::remove(this); // just remove it from scheduler and delete it since it's not running
    8000611c:	00000097          	auipc	ra,0x0
    80006120:	3dc080e7          	jalr	988(ra) # 800064f8 <_ZN9Scheduler6removeEP7_thread>
            if(!removed)removed = sleeping.remove(this); // if not in scheduler, it can be sleeping
    80006124:	02050863          	beqz	a0,80006154 <_ZN7_threadD1Ev+0x70>
        delete stack;
    80006128:	0184b503          	ld	a0,24(s1)
    8000612c:	00050663          	beqz	a0,80006138 <_ZN7_threadD1Ev+0x54>
    80006130:	00001097          	auipc	ra,0x1
    80006134:	850080e7          	jalr	-1968(ra) # 80006980 <_ZdlPv>
    }
    80006138:	02813083          	ld	ra,40(sp)
    8000613c:	02013403          	ld	s0,32(sp)
    80006140:	01813483          	ld	s1,24(sp)
    80006144:	01013903          	ld	s2,16(sp)
    80006148:	00813983          	ld	s3,8(sp)
    8000614c:	03010113          	addi	sp,sp,48
    80006150:	00008067          	ret
        return data;

    }

    bool remove(T* data){
        Elem* h = this->head, *prev = nullptr;
    80006154:	00007917          	auipc	s2,0x7
    80006158:	dac93903          	ld	s2,-596(s2) # 8000cf00 <_ZN7_thread8sleepingE>
    8000615c:	00000713          	li	a4,0
        for (; h ; prev = h, h = h->next) {
    80006160:	00090c63          	beqz	s2,80006178 <_ZN7_threadD1Ev+0x94>
            if(h->data == data)break;
    80006164:	00093783          	ld	a5,0(s2)
    80006168:	00f48863          	beq	s1,a5,80006178 <_ZN7_threadD1Ev+0x94>
        for (; h ; prev = h, h = h->next) {
    8000616c:	00090713          	mv	a4,s2
    80006170:	01093903          	ld	s2,16(s2)
    80006174:	fedff06f          	j	80006160 <_ZN7_threadD1Ev+0x7c>
        }
        if(!h) return false;
    80006178:	fa0908e3          	beqz	s2,80006128 <_ZN7_threadD1Ev+0x44>
        if(!prev) // it's first el
    8000617c:	02070463          	beqz	a4,800061a4 <_ZN7_threadD1Ev+0xc0>
            return removeFirst()!= nullptr;
        if(!h->next) // it's last
    80006180:	01093983          	ld	s3,16(s2)
    80006184:	04098863          	beqz	s3,800061d4 <_ZN7_threadD1Ev+0xf0>
            return removeLast()!= nullptr;
        // it's in between

        prev->next = h->next;
    80006188:	01373823          	sd	s3,16(a4)
            MemoryAllocator::instance().free(chunk);
    8000618c:	00001097          	auipc	ra,0x1
    80006190:	574080e7          	jalr	1396(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006194:	00090593          	mv	a1,s2
    80006198:	00002097          	auipc	ra,0x2
    8000619c:	818080e7          	jalr	-2024(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
        //inc->next = nullptr;
        delete h;
        return true;
    800061a0:	f89ff06f          	j	80006128 <_ZN7_threadD1Ev+0x44>
        if (!head) { return 0; }
    800061a4:	00007917          	auipc	s2,0x7
    800061a8:	d5c93903          	ld	s2,-676(s2) # 8000cf00 <_ZN7_thread8sleepingE>
    800061ac:	f6090ee3          	beqz	s2,80006128 <_ZN7_threadD1Ev+0x44>
        head = head->next;
    800061b0:	01093783          	ld	a5,16(s2)
    800061b4:	00007717          	auipc	a4,0x7
    800061b8:	d4f73623          	sd	a5,-692(a4) # 8000cf00 <_ZN7_thread8sleepingE>
            MemoryAllocator::instance().free(chunk);
    800061bc:	00001097          	auipc	ra,0x1
    800061c0:	544080e7          	jalr	1348(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    800061c4:	00090593          	mv	a1,s2
    800061c8:	00001097          	auipc	ra,0x1
    800061cc:	7e8080e7          	jalr	2024(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
            return removeFirst()!= nullptr;
    800061d0:	f59ff06f          	j	80006128 <_ZN7_threadD1Ev+0x44>
        if (!head) { return 0; }
    800061d4:	00007717          	auipc	a4,0x7
    800061d8:	d2c73703          	ld	a4,-724(a4) # 8000cf00 <_ZN7_thread8sleepingE>
    800061dc:	f40706e3          	beqz	a4,80006128 <_ZN7_threadD1Ev+0x44>
        for (Elem *h = head;h ; prev = h, h = h->next);
    800061e0:	00070793          	mv	a5,a4
    800061e4:	00078863          	beqz	a5,800061f4 <_ZN7_threadD1Ev+0x110>
    800061e8:	00078993          	mv	s3,a5
    800061ec:	0107b783          	ld	a5,16(a5)
    800061f0:	ff5ff06f          	j	800061e4 <_ZN7_threadD1Ev+0x100>
        if(prev == head){ // it's first element
    800061f4:	03370063          	beq	a4,s3,80006214 <_ZN7_threadD1Ev+0x130>
        delete prev;
    800061f8:	f20988e3          	beqz	s3,80006128 <_ZN7_threadD1Ev+0x44>
            MemoryAllocator::instance().free(chunk);
    800061fc:	00001097          	auipc	ra,0x1
    80006200:	504080e7          	jalr	1284(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006204:	00098593          	mv	a1,s3
    80006208:	00001097          	auipc	ra,0x1
    8000620c:	7a8080e7          	jalr	1960(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
            return removeLast()!= nullptr;
    80006210:	f19ff06f          	j	80006128 <_ZN7_threadD1Ev+0x44>
            head = prev->next;
    80006214:	0109b783          	ld	a5,16(s3)
    80006218:	00007717          	auipc	a4,0x7
    8000621c:	cef73423          	sd	a5,-792(a4) # 8000cf00 <_ZN7_thread8sleepingE>
    80006220:	fd9ff06f          	j	800061f8 <_ZN7_threadD1Ev+0x114>

0000000080006224 <_ZN7_threadD0Ev>:
    virtual ~_thread(){
    80006224:	fd010113          	addi	sp,sp,-48
    80006228:	02113423          	sd	ra,40(sp)
    8000622c:	02813023          	sd	s0,32(sp)
    80006230:	00913c23          	sd	s1,24(sp)
    80006234:	01213823          	sd	s2,16(sp)
    80006238:	01313423          	sd	s3,8(sp)
    8000623c:	03010413          	addi	s0,sp,48
    80006240:	00050493          	mv	s1,a0
    80006244:	00007797          	auipc	a5,0x7
    80006248:	afc78793          	addi	a5,a5,-1284 # 8000cd40 <_ZTV7_thread+0x10>
    8000624c:	00f53023          	sd	a5,0(a0)
        if(this != running) {
    80006250:	00007797          	auipc	a5,0x7
    80006254:	cb87b783          	ld	a5,-840(a5) # 8000cf08 <_ZN7_thread7runningE>
    80006258:	00f50863          	beq	a0,a5,80006268 <_ZN7_threadD0Ev+0x44>
            bool removed = Scheduler::remove(this); // just remove it from scheduler and delete it since it's not running
    8000625c:	00000097          	auipc	ra,0x0
    80006260:	29c080e7          	jalr	668(ra) # 800064f8 <_ZN9Scheduler6removeEP7_thread>
            if(!removed)removed = sleeping.remove(this); // if not in scheduler, it can be sleeping
    80006264:	04050263          	beqz	a0,800062a8 <_ZN7_threadD0Ev+0x84>
        delete stack;
    80006268:	0184b503          	ld	a0,24(s1)
    8000626c:	00050663          	beqz	a0,80006278 <_ZN7_threadD0Ev+0x54>
    80006270:	00000097          	auipc	ra,0x0
    80006274:	710080e7          	jalr	1808(ra) # 80006980 <_ZdlPv>
    void operator delete(void *p) noexcept{ MemoryAllocator::instance().free(p); }
    80006278:	00001097          	auipc	ra,0x1
    8000627c:	488080e7          	jalr	1160(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006280:	00048593          	mv	a1,s1
    80006284:	00001097          	auipc	ra,0x1
    80006288:	72c080e7          	jalr	1836(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
    }
    8000628c:	02813083          	ld	ra,40(sp)
    80006290:	02013403          	ld	s0,32(sp)
    80006294:	01813483          	ld	s1,24(sp)
    80006298:	01013903          	ld	s2,16(sp)
    8000629c:	00813983          	ld	s3,8(sp)
    800062a0:	03010113          	addi	sp,sp,48
    800062a4:	00008067          	ret
        Elem* h = this->head, *prev = nullptr;
    800062a8:	00007917          	auipc	s2,0x7
    800062ac:	c5893903          	ld	s2,-936(s2) # 8000cf00 <_ZN7_thread8sleepingE>
    800062b0:	00000713          	li	a4,0
        for (; h ; prev = h, h = h->next) {
    800062b4:	00090c63          	beqz	s2,800062cc <_ZN7_threadD0Ev+0xa8>
            if(h->data == data)break;
    800062b8:	00093783          	ld	a5,0(s2)
    800062bc:	00f48863          	beq	s1,a5,800062cc <_ZN7_threadD0Ev+0xa8>
        for (; h ; prev = h, h = h->next) {
    800062c0:	00090713          	mv	a4,s2
    800062c4:	01093903          	ld	s2,16(s2)
    800062c8:	fedff06f          	j	800062b4 <_ZN7_threadD0Ev+0x90>
        if(!h) return false;
    800062cc:	f8090ee3          	beqz	s2,80006268 <_ZN7_threadD0Ev+0x44>
        if(!prev) // it's first el
    800062d0:	02070463          	beqz	a4,800062f8 <_ZN7_threadD0Ev+0xd4>
        if(!h->next) // it's last
    800062d4:	01093983          	ld	s3,16(s2)
    800062d8:	04098863          	beqz	s3,80006328 <_ZN7_threadD0Ev+0x104>
        prev->next = h->next;
    800062dc:	01373823          	sd	s3,16(a4)
            MemoryAllocator::instance().free(chunk);
    800062e0:	00001097          	auipc	ra,0x1
    800062e4:	420080e7          	jalr	1056(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    800062e8:	00090593          	mv	a1,s2
    800062ec:	00001097          	auipc	ra,0x1
    800062f0:	6c4080e7          	jalr	1732(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
        return true;
    800062f4:	f75ff06f          	j	80006268 <_ZN7_threadD0Ev+0x44>
        if (!head) { return 0; }
    800062f8:	00007917          	auipc	s2,0x7
    800062fc:	c0893903          	ld	s2,-1016(s2) # 8000cf00 <_ZN7_thread8sleepingE>
    80006300:	f60904e3          	beqz	s2,80006268 <_ZN7_threadD0Ev+0x44>
        head = head->next;
    80006304:	01093783          	ld	a5,16(s2)
    80006308:	00007717          	auipc	a4,0x7
    8000630c:	bef73c23          	sd	a5,-1032(a4) # 8000cf00 <_ZN7_thread8sleepingE>
            MemoryAllocator::instance().free(chunk);
    80006310:	00001097          	auipc	ra,0x1
    80006314:	3f0080e7          	jalr	1008(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006318:	00090593          	mv	a1,s2
    8000631c:	00001097          	auipc	ra,0x1
    80006320:	694080e7          	jalr	1684(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
            return removeFirst()!= nullptr;
    80006324:	f45ff06f          	j	80006268 <_ZN7_threadD0Ev+0x44>
        if (!head) { return 0; }
    80006328:	00007717          	auipc	a4,0x7
    8000632c:	bd873703          	ld	a4,-1064(a4) # 8000cf00 <_ZN7_thread8sleepingE>
    80006330:	f2070ce3          	beqz	a4,80006268 <_ZN7_threadD0Ev+0x44>
        for (Elem *h = head;h ; prev = h, h = h->next);
    80006334:	00070793          	mv	a5,a4
    80006338:	00078863          	beqz	a5,80006348 <_ZN7_threadD0Ev+0x124>
    8000633c:	00078993          	mv	s3,a5
    80006340:	0107b783          	ld	a5,16(a5)
    80006344:	ff5ff06f          	j	80006338 <_ZN7_threadD0Ev+0x114>
        if(prev == head){ // it's first element
    80006348:	03370063          	beq	a4,s3,80006368 <_ZN7_threadD0Ev+0x144>
        delete prev;
    8000634c:	f0098ee3          	beqz	s3,80006268 <_ZN7_threadD0Ev+0x44>
            MemoryAllocator::instance().free(chunk);
    80006350:	00001097          	auipc	ra,0x1
    80006354:	3b0080e7          	jalr	944(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006358:	00098593          	mv	a1,s3
    8000635c:	00001097          	auipc	ra,0x1
    80006360:	654080e7          	jalr	1620(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
            return removeLast()!= nullptr;
    80006364:	f05ff06f          	j	80006268 <_ZN7_threadD0Ev+0x44>
            head = prev->next;
    80006368:	0109b783          	ld	a5,16(s3)
    8000636c:	00007717          	auipc	a4,0x7
    80006370:	b8f73a23          	sd	a5,-1132(a4) # 8000cf00 <_ZN7_thread8sleepingE>
    80006374:	fd9ff06f          	j	8000634c <_ZN7_threadD0Ev+0x128>

0000000080006378 <_Z41__static_initialization_and_destruction_0ii>:
    return readyCoroutineQueue.peekLast();
}

bool Scheduler::remove(_thread *t) {
    return readyCoroutineQueue.remove(t);
}
    80006378:	ff010113          	addi	sp,sp,-16
    8000637c:	00813423          	sd	s0,8(sp)
    80006380:	01010413          	addi	s0,sp,16
    80006384:	00100793          	li	a5,1
    80006388:	00f50863          	beq	a0,a5,80006398 <_Z41__static_initialization_and_destruction_0ii+0x20>
    8000638c:	00813403          	ld	s0,8(sp)
    80006390:	01010113          	addi	sp,sp,16
    80006394:	00008067          	ret
    80006398:	000107b7          	lui	a5,0x10
    8000639c:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800063a0:	fef596e3          	bne	a1,a5,8000638c <_Z41__static_initialization_and_destruction_0ii+0x14>

    Elem *head, *tail;

public:

    List() : head(0), tail(0) {}
    800063a4:	00007797          	auipc	a5,0x7
    800063a8:	b8478793          	addi	a5,a5,-1148 # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
    800063ac:	0007b023          	sd	zero,0(a5)
    800063b0:	0007b423          	sd	zero,8(a5)
    800063b4:	fd9ff06f          	j	8000638c <_Z41__static_initialization_and_destruction_0ii+0x14>

00000000800063b8 <_ZN9Scheduler3getEv>:
{
    800063b8:	fe010113          	addi	sp,sp,-32
    800063bc:	00113c23          	sd	ra,24(sp)
    800063c0:	00813823          	sd	s0,16(sp)
    800063c4:	00913423          	sd	s1,8(sp)
    800063c8:	01213023          	sd	s2,0(sp)
    800063cc:	02010413          	addi	s0,sp,32
        }
    }

    T *removeFirst()
    {
        if (!head) { return 0; }
    800063d0:	00007497          	auipc	s1,0x7
    800063d4:	b584b483          	ld	s1,-1192(s1) # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
    800063d8:	04048a63          	beqz	s1,8000642c <_ZN9Scheduler3getEv+0x74>

        Elem *elem = head;
        head = head->next;
    800063dc:	0084b783          	ld	a5,8(s1)
    800063e0:	00007717          	auipc	a4,0x7
    800063e4:	b4f73423          	sd	a5,-1208(a4) # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
        if (!head) { tail = 0; }
    800063e8:	02078c63          	beqz	a5,80006420 <_ZN9Scheduler3getEv+0x68>

        T *ret = elem->data;
    800063ec:	0004b903          	ld	s2,0(s1)
            MemoryAllocator::instance().free(chunk);
    800063f0:	00001097          	auipc	ra,0x1
    800063f4:	310080e7          	jalr	784(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    800063f8:	00048593          	mv	a1,s1
    800063fc:	00001097          	auipc	ra,0x1
    80006400:	5b4080e7          	jalr	1460(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
}
    80006404:	00090513          	mv	a0,s2
    80006408:	01813083          	ld	ra,24(sp)
    8000640c:	01013403          	ld	s0,16(sp)
    80006410:	00813483          	ld	s1,8(sp)
    80006414:	00013903          	ld	s2,0(sp)
    80006418:	02010113          	addi	sp,sp,32
    8000641c:	00008067          	ret
        if (!head) { tail = 0; }
    80006420:	00007797          	auipc	a5,0x7
    80006424:	b007b823          	sd	zero,-1264(a5) # 8000cf30 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
    80006428:	fc5ff06f          	j	800063ec <_ZN9Scheduler3getEv+0x34>
        if (!head) { return 0; }
    8000642c:	00048913          	mv	s2,s1
    return readyCoroutineQueue.removeFirst();
    80006430:	fd5ff06f          	j	80006404 <_ZN9Scheduler3getEv+0x4c>

0000000080006434 <_ZN9Scheduler3putEP7_thread>:
{
    80006434:	fe010113          	addi	sp,sp,-32
    80006438:	00113c23          	sd	ra,24(sp)
    8000643c:	00813823          	sd	s0,16(sp)
    80006440:	00913423          	sd	s1,8(sp)
    80006444:	02010413          	addi	s0,sp,32
    80006448:	00050493          	mv	s1,a0
            return MemoryAllocator::instance().malloc(size);
    8000644c:	00001097          	auipc	ra,0x1
    80006450:	2b4080e7          	jalr	692(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006454:	01000593          	li	a1,16
    80006458:	00001097          	auipc	ra,0x1
    8000645c:	3c8080e7          	jalr	968(ra) # 80007820 <_ZN15MemoryAllocator6mallocEm>
        Elem(T *data, Elem *next) : data(data), next(next) {}
    80006460:	00953023          	sd	s1,0(a0)
    80006464:	00053423          	sd	zero,8(a0)
        if (tail)
    80006468:	00007797          	auipc	a5,0x7
    8000646c:	ac87b783          	ld	a5,-1336(a5) # 8000cf30 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
    80006470:	02078263          	beqz	a5,80006494 <_ZN9Scheduler3putEP7_thread+0x60>
            tail->next = elem;
    80006474:	00a7b423          	sd	a0,8(a5)
            tail = elem;
    80006478:	00007797          	auipc	a5,0x7
    8000647c:	aaa7bc23          	sd	a0,-1352(a5) # 8000cf30 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
}
    80006480:	01813083          	ld	ra,24(sp)
    80006484:	01013403          	ld	s0,16(sp)
    80006488:	00813483          	ld	s1,8(sp)
    8000648c:	02010113          	addi	sp,sp,32
    80006490:	00008067          	ret
            head = tail = elem;
    80006494:	00007797          	auipc	a5,0x7
    80006498:	a9478793          	addi	a5,a5,-1388 # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
    8000649c:	00a7b423          	sd	a0,8(a5)
    800064a0:	00a7b023          	sd	a0,0(a5)
    800064a4:	fddff06f          	j	80006480 <_ZN9Scheduler3putEP7_thread+0x4c>

00000000800064a8 <_ZN9Scheduler10peek_firstEv>:
_thread *Scheduler::peek_first() {
    800064a8:	ff010113          	addi	sp,sp,-16
    800064ac:	00813423          	sd	s0,8(sp)
    800064b0:	01010413          	addi	s0,sp,16
        return ret;
    }

    T *peekFirst()
    {
        if (!head) { return 0; }
    800064b4:	00007517          	auipc	a0,0x7
    800064b8:	a7453503          	ld	a0,-1420(a0) # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
    800064bc:	00050463          	beqz	a0,800064c4 <_ZN9Scheduler10peek_firstEv+0x1c>
        return head->data;
    800064c0:	00053503          	ld	a0,0(a0)
}
    800064c4:	00813403          	ld	s0,8(sp)
    800064c8:	01010113          	addi	sp,sp,16
    800064cc:	00008067          	ret

00000000800064d0 <_ZN9Scheduler9peek_lastEv>:
_thread *Scheduler::peek_last() {
    800064d0:	ff010113          	addi	sp,sp,-16
    800064d4:	00813423          	sd	s0,8(sp)
    800064d8:	01010413          	addi	s0,sp,16
        return ret;
    }

    T *peekLast()
    {
        if (!tail) { return 0; }
    800064dc:	00007517          	auipc	a0,0x7
    800064e0:	a5453503          	ld	a0,-1452(a0) # 8000cf30 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
    800064e4:	00050463          	beqz	a0,800064ec <_ZN9Scheduler9peek_lastEv+0x1c>
        return tail->data;
    800064e8:	00053503          	ld	a0,0(a0)
}
    800064ec:	00813403          	ld	s0,8(sp)
    800064f0:	01010113          	addi	sp,sp,16
    800064f4:	00008067          	ret

00000000800064f8 <_ZN9Scheduler6removeEP7_thread>:
bool Scheduler::remove(_thread *t) {
    800064f8:	fe010113          	addi	sp,sp,-32
    800064fc:	00113c23          	sd	ra,24(sp)
    80006500:	00813823          	sd	s0,16(sp)
    80006504:	00913423          	sd	s1,8(sp)
    80006508:	01213023          	sd	s2,0(sp)
    8000650c:	02010413          	addi	s0,sp,32
    }

    bool remove(T* data){
        Elem* h = this->head, *prev = nullptr;
    80006510:	00007497          	auipc	s1,0x7
    80006514:	a184b483          	ld	s1,-1512(s1) # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
    80006518:	00000713          	li	a4,0
        for (; h ; prev = h, h = h->next) {
    8000651c:	00048c63          	beqz	s1,80006534 <_ZN9Scheduler6removeEP7_thread+0x3c>
            if(h->data == data)break;
    80006520:	0004b783          	ld	a5,0(s1)
    80006524:	00f50863          	beq	a0,a5,80006534 <_ZN9Scheduler6removeEP7_thread+0x3c>
        for (; h ; prev = h, h = h->next) {
    80006528:	00048713          	mv	a4,s1
    8000652c:	0084b483          	ld	s1,8(s1)
    80006530:	fedff06f          	j	8000651c <_ZN9Scheduler6removeEP7_thread+0x24>
        }
        if(!h) return false;
    80006534:	10048263          	beqz	s1,80006638 <_ZN9Scheduler6removeEP7_thread+0x140>
        if(!prev) // it's first el
    80006538:	04070063          	beqz	a4,80006578 <_ZN9Scheduler6removeEP7_thread+0x80>
            return removeFirst()!= nullptr;
        if(!h->next) // it's last
    8000653c:	0084b783          	ld	a5,8(s1)
    80006540:	08078463          	beqz	a5,800065c8 <_ZN9Scheduler6removeEP7_thread+0xd0>
            return removeLast()!= nullptr;
        // it's in between

        prev->next = h->next;
    80006544:	00f73423          	sd	a5,8(a4)
            MemoryAllocator::instance().free(chunk);
    80006548:	00001097          	auipc	ra,0x1
    8000654c:	1b8080e7          	jalr	440(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006550:	00048593          	mv	a1,s1
    80006554:	00001097          	auipc	ra,0x1
    80006558:	45c080e7          	jalr	1116(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
        //inc->next = nullptr;
        delete h;
        return true;
    8000655c:	00100513          	li	a0,1
}
    80006560:	01813083          	ld	ra,24(sp)
    80006564:	01013403          	ld	s0,16(sp)
    80006568:	00813483          	ld	s1,8(sp)
    8000656c:	00013903          	ld	s2,0(sp)
    80006570:	02010113          	addi	sp,sp,32
    80006574:	00008067          	ret
        if (!head) { return 0; }
    80006578:	00007917          	auipc	s2,0x7
    8000657c:	9b093903          	ld	s2,-1616(s2) # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
    80006580:	04090063          	beqz	s2,800065c0 <_ZN9Scheduler6removeEP7_thread+0xc8>
        head = head->next;
    80006584:	00893783          	ld	a5,8(s2)
    80006588:	00007717          	auipc	a4,0x7
    8000658c:	9af73023          	sd	a5,-1632(a4) # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
        if (!head) { tail = 0; }
    80006590:	02078263          	beqz	a5,800065b4 <_ZN9Scheduler6removeEP7_thread+0xbc>
        T *ret = elem->data;
    80006594:	00093483          	ld	s1,0(s2)
            MemoryAllocator::instance().free(chunk);
    80006598:	00001097          	auipc	ra,0x1
    8000659c:	168080e7          	jalr	360(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    800065a0:	00090593          	mv	a1,s2
    800065a4:	00001097          	auipc	ra,0x1
    800065a8:	40c080e7          	jalr	1036(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
            return removeFirst()!= nullptr;
    800065ac:	00903533          	snez	a0,s1
    800065b0:	fb1ff06f          	j	80006560 <_ZN9Scheduler6removeEP7_thread+0x68>
        if (!head) { tail = 0; }
    800065b4:	00007797          	auipc	a5,0x7
    800065b8:	9607be23          	sd	zero,-1668(a5) # 8000cf30 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
    800065bc:	fd9ff06f          	j	80006594 <_ZN9Scheduler6removeEP7_thread+0x9c>
        if (!head) { return 0; }
    800065c0:	00090493          	mv	s1,s2
    800065c4:	fe9ff06f          	j	800065ac <_ZN9Scheduler6removeEP7_thread+0xb4>
        if (!head) { return 0; }
    800065c8:	00007497          	auipc	s1,0x7
    800065cc:	9604b483          	ld	s1,-1696(s1) # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
    800065d0:	04048a63          	beqz	s1,80006624 <_ZN9Scheduler6removeEP7_thread+0x12c>
        for (Elem *curr = head; curr && curr != tail; curr = curr->next)
    800065d4:	00048e63          	beqz	s1,800065f0 <_ZN9Scheduler6removeEP7_thread+0xf8>
    800065d8:	00007717          	auipc	a4,0x7
    800065dc:	95873703          	ld	a4,-1704(a4) # 8000cf30 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
    800065e0:	00e48863          	beq	s1,a4,800065f0 <_ZN9Scheduler6removeEP7_thread+0xf8>
            prev = curr;
    800065e4:	00048793          	mv	a5,s1
        for (Elem *curr = head; curr && curr != tail; curr = curr->next)
    800065e8:	0084b483          	ld	s1,8(s1)
    800065ec:	fe9ff06f          	j	800065d4 <_ZN9Scheduler6removeEP7_thread+0xdc>
        Elem *elem = tail;
    800065f0:	00007917          	auipc	s2,0x7
    800065f4:	94093903          	ld	s2,-1728(s2) # 8000cf30 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
        if (prev) { prev->next = 0; }
    800065f8:	02078a63          	beqz	a5,8000662c <_ZN9Scheduler6removeEP7_thread+0x134>
    800065fc:	0007b423          	sd	zero,8(a5)
        tail = prev;
    80006600:	00007717          	auipc	a4,0x7
    80006604:	92f73823          	sd	a5,-1744(a4) # 8000cf30 <_ZN9Scheduler19readyCoroutineQueueE+0x8>
        T *ret = elem->data;
    80006608:	00093483          	ld	s1,0(s2)
        delete elem;
    8000660c:	00090c63          	beqz	s2,80006624 <_ZN9Scheduler6removeEP7_thread+0x12c>
            MemoryAllocator::instance().free(chunk);
    80006610:	00001097          	auipc	ra,0x1
    80006614:	0f0080e7          	jalr	240(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006618:	00090593          	mv	a1,s2
    8000661c:	00001097          	auipc	ra,0x1
    80006620:	394080e7          	jalr	916(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
            return removeLast()!= nullptr;
    80006624:	00903533          	snez	a0,s1
    80006628:	f39ff06f          	j	80006560 <_ZN9Scheduler6removeEP7_thread+0x68>
        else { head = 0; }
    8000662c:	00007717          	auipc	a4,0x7
    80006630:	8e073e23          	sd	zero,-1796(a4) # 8000cf28 <_ZN9Scheduler19readyCoroutineQueueE>
    80006634:	fcdff06f          	j	80006600 <_ZN9Scheduler6removeEP7_thread+0x108>
        if(!h) return false;
    80006638:	00000513          	li	a0,0
    8000663c:	f25ff06f          	j	80006560 <_ZN9Scheduler6removeEP7_thread+0x68>

0000000080006640 <_GLOBAL__sub_I__ZN9Scheduler19readyCoroutineQueueE>:
    80006640:	ff010113          	addi	sp,sp,-16
    80006644:	00113423          	sd	ra,8(sp)
    80006648:	00813023          	sd	s0,0(sp)
    8000664c:	01010413          	addi	s0,sp,16
    80006650:	000105b7          	lui	a1,0x10
    80006654:	fff58593          	addi	a1,a1,-1 # ffff <_entry-0x7fff0001>
    80006658:	00100513          	li	a0,1
    8000665c:	00000097          	auipc	ra,0x0
    80006660:	d1c080e7          	jalr	-740(ra) # 80006378 <_Z41__static_initialization_and_destruction_0ii>
    80006664:	00813083          	ld	ra,8(sp)
    80006668:	00013403          	ld	s0,0(sp)
    8000666c:	01010113          	addi	sp,sp,16
    80006670:	00008067          	ret

0000000080006674 <_Z15userMainWrapperPv>:

extern void userMain();

static bool usrFinished = false;

void userMainWrapper(void* ){
    80006674:	ff010113          	addi	sp,sp,-16
    80006678:	00113423          	sd	ra,8(sp)
    8000667c:	00813023          	sd	s0,0(sp)
    80006680:	01010413          	addi	s0,sp,16
    userMain();
    80006684:	ffffd097          	auipc	ra,0xffffd
    80006688:	6cc080e7          	jalr	1740(ra) # 80003d50 <_Z8userMainv>


    usrFinished = true;
    8000668c:	00100793          	li	a5,1
    80006690:	00007717          	auipc	a4,0x7
    80006694:	8af70423          	sb	a5,-1880(a4) # 8000cf38 <_ZL11usrFinished>
}
    80006698:	00813083          	ld	ra,8(sp)
    8000669c:	00013403          	ld	s0,0(sp)
    800066a0:	01010113          	addi	sp,sp,16
    800066a4:	00008067          	ret

00000000800066a8 <main>:

int main(){
    800066a8:	fc010113          	addi	sp,sp,-64
    800066ac:	02113c23          	sd	ra,56(sp)
    800066b0:	02813823          	sd	s0,48(sp)
    800066b4:	02913423          	sd	s1,40(sp)
    800066b8:	03213023          	sd	s2,32(sp)
    800066bc:	04010413          	addi	s0,sp,64
    /// sstatus <= 0b10, intr enabled
    /// stvec <= adresa syscallHandler prekidne rutine iz .S fajla, |0b00 direktan rezim 00 na poslednja 2 bita
    Riscv::w_stvec( (uint64)&Handlers::trapHandler | 0b00);
    800066c0:	00006797          	auipc	a5,0x6
    800066c4:	7487b783          	ld	a5,1864(a5) # 8000ce08 <_GLOBAL_OFFSET_TABLE_+0x28>
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
    800066c8:	10579073          	csrw	stvec,a5

    thread_t t, usr, putcThread;
    thread_create(&t, nullptr, nullptr); /// mainThread (running)
    800066cc:	00000613          	li	a2,0
    800066d0:	00000593          	li	a1,0
    800066d4:	fd840513          	addi	a0,s0,-40
    800066d8:	ffffe097          	auipc	ra,0xffffe
    800066dc:	2b8080e7          	jalr	696(ra) # 80004990 <thread_create>

    ConsoleBuffer* putc_buffer = new ConsoleBuffer(); ConsoleBuffer* getc_buffer = new ConsoleBuffer();
    800066e0:	02800513          	li	a0,40
    800066e4:	00000097          	auipc	ra,0x0
    800066e8:	274080e7          	jalr	628(ra) # 80006958 <_Znwm>
    800066ec:	00050913          	mv	s2,a0
    800066f0:	10000593          	li	a1,256
    800066f4:	00001097          	auipc	ra,0x1
    800066f8:	c74080e7          	jalr	-908(ra) # 80007368 <_ZN13ConsoleBufferC1Ei>
    800066fc:	02800513          	li	a0,40
    80006700:	00000097          	auipc	ra,0x0
    80006704:	258080e7          	jalr	600(ra) # 80006958 <_Znwm>
    80006708:	00050493          	mv	s1,a0
    8000670c:	10000593          	li	a1,256
    80006710:	00001097          	auipc	ra,0x1
    80006714:	c58080e7          	jalr	-936(ra) # 80007368 <_ZN13ConsoleBufferC1Ei>
    _console::putcBuffer = putc_buffer; _console::getcBuffer = getc_buffer;
    80006718:	00006797          	auipc	a5,0x6
    8000671c:	7307b783          	ld	a5,1840(a5) # 8000ce48 <_GLOBAL_OFFSET_TABLE_+0x68>
    80006720:	0127b023          	sd	s2,0(a5)
    80006724:	00006797          	auipc	a5,0x6
    80006728:	6fc7b783          	ld	a5,1788(a5) # 8000ce20 <_GLOBAL_OFFSET_TABLE_+0x40>
    8000672c:	0097b023          	sd	s1,0(a5)

    thread_create(&putcThread, _console::putcHandle, (void*) 1);
    80006730:	00100613          	li	a2,1
    80006734:	00006597          	auipc	a1,0x6
    80006738:	70c5b583          	ld	a1,1804(a1) # 8000ce40 <_GLOBAL_OFFSET_TABLE_+0x60>
    8000673c:	fc840513          	addi	a0,s0,-56
    80006740:	ffffe097          	auipc	ra,0xffffe
    80006744:	250080e7          	jalr	592(ra) # 80004990 <thread_create>
    _thread::putcThr = putcThread;
    80006748:	00006797          	auipc	a5,0x6
    8000674c:	6e07b783          	ld	a5,1760(a5) # 8000ce28 <_GLOBAL_OFFSET_TABLE_+0x48>
    80006750:	fc843703          	ld	a4,-56(s0)
    80006754:	00e7b023          	sd	a4,0(a5)
    /// IMPORTANT! do not delete this dispatch. This is here so putcThread gets its SUPERVISOR privileges in csr regiser
    /// also, it blocks putcThread on a buffer semaphore until putc is called.
    thread_dispatch();
    80006758:	ffffe097          	auipc	ra,0xffffe
    8000675c:	2f4080e7          	jalr	756(ra) # 80004a4c <thread_dispatch>
    __asm__ volatile ("mv a0, %[a0]" : : [a0] "r"(a0));
    80006760:	09900793          	li	a5,153
    80006764:	00078513          	mv	a0,a5
    __asm__ volatile ("mv a1, %[a1]" : : [a1] "r"(a1));
    80006768:	00000793          	li	a5,0
    8000676c:	00078593          	mv	a1,a5
    __asm__ volatile ("ecall");
    80006770:	00000073          	ecall

    Riscv::changeMode(Riscv::Mode::USER);
    /// entered user mode


    thread_create(&usr, userMainWrapper, nullptr);
    80006774:	00000613          	li	a2,0
    80006778:	00000597          	auipc	a1,0x0
    8000677c:	efc58593          	addi	a1,a1,-260 # 80006674 <_Z15userMainWrapperPv>
    80006780:	fd040513          	addi	a0,s0,-48
    80006784:	ffffe097          	auipc	ra,0xffffe
    80006788:	20c080e7          	jalr	524(ra) # 80004990 <thread_create>
    8000678c:	00c0006f          	j	80006798 <main+0xf0>


    while (!_thread::schedulerEmpty() || !usrFinished //|| _thread::hasSleepingThreads()
){ // wait for userMain and all the threads to finish
        thread_dispatch();
    80006790:	ffffe097          	auipc	ra,0xffffe
    80006794:	2bc080e7          	jalr	700(ra) # 80004a4c <thread_dispatch>
    while (!_thread::schedulerEmpty() || !usrFinished //|| _thread::hasSleepingThreads()
    80006798:	fffff097          	auipc	ra,0xfffff
    8000679c:	5bc080e7          	jalr	1468(ra) # 80005d54 <_ZN7_thread14schedulerEmptyEv>
    800067a0:	fe0508e3          	beqz	a0,80006790 <main+0xe8>
    800067a4:	00006797          	auipc	a5,0x6
    800067a8:	7947c783          	lbu	a5,1940(a5) # 8000cf38 <_ZL11usrFinished>
    800067ac:	fe0782e3          	beqz	a5,80006790 <main+0xe8>
    __asm__ volatile ("mv a0, %[a0]" : : [a0] "r"(a0));
    800067b0:	09900793          	li	a5,153
    800067b4:	00078513          	mv	a0,a5
    __asm__ volatile ("mv a1, %[a1]" : : [a1] "r"(a1));
    800067b8:	00100793          	li	a5,1
    800067bc:	00078593          	mv	a1,a5
    __asm__ volatile ("ecall");
    800067c0:	00000073          	ecall
    }

    /// exit user mode
    Riscv::changeMode(Riscv::Mode::SUPERVISOR);

    printStringS("FREEING-MAIN\n");
    800067c4:	00004517          	auipc	a0,0x4
    800067c8:	f0c50513          	addi	a0,a0,-244 # 8000a6d0 <CONSOLE_STATUS+0x6c0>
    800067cc:	00001097          	auipc	ra,0x1
    800067d0:	30c080e7          	jalr	780(ra) # 80007ad8 <_Z12printStringSPKc>

    delete t;
    800067d4:	fd843503          	ld	a0,-40(s0)
    800067d8:	00050863          	beqz	a0,800067e8 <main+0x140>
    800067dc:	00053783          	ld	a5,0(a0)
    800067e0:	0087b783          	ld	a5,8(a5)
    800067e4:	000780e7          	jalr	a5
    delete usr;
    800067e8:	fd043503          	ld	a0,-48(s0)
    800067ec:	00050863          	beqz	a0,800067fc <main+0x154>
    800067f0:	00053783          	ld	a5,0(a0)
    800067f4:	0087b783          	ld	a5,8(a5)
    800067f8:	000780e7          	jalr	a5
    delete putc_buffer;
    800067fc:	00090e63          	beqz	s2,80006818 <main+0x170>
    80006800:	00090513          	mv	a0,s2
    80006804:	00001097          	auipc	ra,0x1
    80006808:	d08080e7          	jalr	-760(ra) # 8000750c <_ZN13ConsoleBufferD1Ev>
    8000680c:	00090513          	mv	a0,s2
    80006810:	00000097          	auipc	ra,0x0
    80006814:	170080e7          	jalr	368(ra) # 80006980 <_ZdlPv>
    delete getc_buffer;
    80006818:	00048e63          	beqz	s1,80006834 <main+0x18c>
    8000681c:	00048513          	mv	a0,s1
    80006820:	00001097          	auipc	ra,0x1
    80006824:	cec080e7          	jalr	-788(ra) # 8000750c <_ZN13ConsoleBufferD1Ev>
    80006828:	00048513          	mv	a0,s1
    8000682c:	00000097          	auipc	ra,0x0
    80006830:	154080e7          	jalr	340(ra) # 80006980 <_ZdlPv>
    delete putcThread;
    80006834:	fc843503          	ld	a0,-56(s0)
    80006838:	00050863          	beqz	a0,80006848 <main+0x1a0>
    8000683c:	00053783          	ld	a5,0(a0)
    80006840:	0087b783          	ld	a5,8(a5)
    80006844:	000780e7          	jalr	a5

    printStringS(MemoryAllocator::instance().deallocatedAllMemory()?"\nDeallocated: YES.\n":"\nNot deallocated.\n");
    80006848:	00001097          	auipc	ra,0x1
    8000684c:	eb8080e7          	jalr	-328(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006850:	00001097          	auipc	ra,0x1
    80006854:	0b4080e7          	jalr	180(ra) # 80007904 <_ZNK15MemoryAllocator20deallocatedAllMemoryEv>
    80006858:	04050063          	beqz	a0,80006898 <main+0x1f0>
    8000685c:	00004517          	auipc	a0,0x4
    80006860:	e5c50513          	addi	a0,a0,-420 # 8000a6b8 <CONSOLE_STATUS+0x6a8>
    80006864:	00001097          	auipc	ra,0x1
    80006868:	274080e7          	jalr	628(ra) # 80007ad8 <_Z12printStringSPKc>
    __asm__ volatile("li t0, 0x5555");
    8000686c:	000052b7          	lui	t0,0x5
    80006870:	5552829b          	addiw	t0,t0,1365
    __asm__ volatile("li t1, 0x100000");
    80006874:	00100337          	lui	t1,0x100
    __asm__ volatile("sw t0, 0(t1) ");
    80006878:	00532023          	sw	t0,0(t1) # 100000 <_entry-0x7ff00000>
    Riscv::halt();
    return 0;
}
    8000687c:	00000513          	li	a0,0
    80006880:	03813083          	ld	ra,56(sp)
    80006884:	03013403          	ld	s0,48(sp)
    80006888:	02813483          	ld	s1,40(sp)
    8000688c:	02013903          	ld	s2,32(sp)
    80006890:	04010113          	addi	sp,sp,64
    80006894:	00008067          	ret
    printStringS(MemoryAllocator::instance().deallocatedAllMemory()?"\nDeallocated: YES.\n":"\nNot deallocated.\n");
    80006898:	00004517          	auipc	a0,0x4
    8000689c:	e0850513          	addi	a0,a0,-504 # 8000a6a0 <CONSOLE_STATUS+0x690>
    800068a0:	fc5ff06f          	j	80006864 <main+0x1bc>
    800068a4:	00050493          	mv	s1,a0
    ConsoleBuffer* putc_buffer = new ConsoleBuffer(); ConsoleBuffer* getc_buffer = new ConsoleBuffer();
    800068a8:	00090513          	mv	a0,s2
    800068ac:	00000097          	auipc	ra,0x0
    800068b0:	0d4080e7          	jalr	212(ra) # 80006980 <_ZdlPv>
    800068b4:	00048513          	mv	a0,s1
    800068b8:	00007097          	auipc	ra,0x7
    800068bc:	790080e7          	jalr	1936(ra) # 8000e048 <_Unwind_Resume>
    800068c0:	00050913          	mv	s2,a0
    800068c4:	00048513          	mv	a0,s1
    800068c8:	00000097          	auipc	ra,0x0
    800068cc:	0b8080e7          	jalr	184(ra) # 80006980 <_ZdlPv>
    800068d0:	00090513          	mv	a0,s2
    800068d4:	00007097          	auipc	ra,0x7
    800068d8:	774080e7          	jalr	1908(ra) # 8000e048 <_Unwind_Resume>

00000000800068dc <_ZN6ThreadD1Ev>:
void operator delete(void* ptr){ mem_free(ptr); }

Thread::Thread(void (*body)(void *), void *arg) : myHandle(nullptr), body(body), arg(arg){
}

Thread::~Thread() {
    800068dc:	ff010113          	addi	sp,sp,-16
    800068e0:	00813423          	sd	s0,8(sp)
    800068e4:	01010413          	addi	s0,sp,16
    //delete myHandle; // it will deallocate itself
}
    800068e8:	00813403          	ld	s0,8(sp)
    800068ec:	01010113          	addi	sp,sp,16
    800068f0:	00008067          	ret

00000000800068f4 <_ZN6Thread10runWrapperEPv>:

void Thread::runWrapper(void* self){ ((Thread*)self)->run(); }
    800068f4:	ff010113          	addi	sp,sp,-16
    800068f8:	00113423          	sd	ra,8(sp)
    800068fc:	00813023          	sd	s0,0(sp)
    80006900:	01010413          	addi	s0,sp,16
    80006904:	00053783          	ld	a5,0(a0)
    80006908:	0107b783          	ld	a5,16(a5)
    8000690c:	000780e7          	jalr	a5
    80006910:	00813083          	ld	ra,8(sp)
    80006914:	00013403          	ld	s0,0(sp)
    80006918:	01010113          	addi	sp,sp,16
    8000691c:	00008067          	ret

0000000080006920 <_ZN9SemaphoreD1Ev>:

Semaphore::Semaphore(unsigned int init) : myHandle(nullptr) {
    sem_open(&myHandle, init);
}

Semaphore::~Semaphore() {
    80006920:	ff010113          	addi	sp,sp,-16
    80006924:	00113423          	sd	ra,8(sp)
    80006928:	00813023          	sd	s0,0(sp)
    8000692c:	01010413          	addi	s0,sp,16
    80006930:	00006797          	auipc	a5,0x6
    80006934:	48878793          	addi	a5,a5,1160 # 8000cdb8 <_ZTV9Semaphore+0x10>
    80006938:	00f53023          	sd	a5,0(a0)
    sem_close(myHandle); // removes handle from the list and frees space
    8000693c:	00853503          	ld	a0,8(a0)
    80006940:	ffffe097          	auipc	ra,0xffffe
    80006944:	18c080e7          	jalr	396(ra) # 80004acc <sem_close>
}
    80006948:	00813083          	ld	ra,8(sp)
    8000694c:	00013403          	ld	s0,0(sp)
    80006950:	01010113          	addi	sp,sp,16
    80006954:	00008067          	ret

0000000080006958 <_Znwm>:
void* operator new(size_t chunk){ return mem_alloc(chunk); }
    80006958:	ff010113          	addi	sp,sp,-16
    8000695c:	00113423          	sd	ra,8(sp)
    80006960:	00813023          	sd	s0,0(sp)
    80006964:	01010413          	addi	s0,sp,16
    80006968:	ffffe097          	auipc	ra,0xffffe
    8000696c:	fa0080e7          	jalr	-96(ra) # 80004908 <mem_alloc>
    80006970:	00813083          	ld	ra,8(sp)
    80006974:	00013403          	ld	s0,0(sp)
    80006978:	01010113          	addi	sp,sp,16
    8000697c:	00008067          	ret

0000000080006980 <_ZdlPv>:
void operator delete(void* ptr){ mem_free(ptr); }
    80006980:	ff010113          	addi	sp,sp,-16
    80006984:	00113423          	sd	ra,8(sp)
    80006988:	00813023          	sd	s0,0(sp)
    8000698c:	01010413          	addi	s0,sp,16
    80006990:	ffffe097          	auipc	ra,0xffffe
    80006994:	fc0080e7          	jalr	-64(ra) # 80004950 <mem_free>
    80006998:	00813083          	ld	ra,8(sp)
    8000699c:	00013403          	ld	s0,0(sp)
    800069a0:	01010113          	addi	sp,sp,16
    800069a4:	00008067          	ret

00000000800069a8 <_ZN6ThreadD0Ev>:
Thread::~Thread() {
    800069a8:	ff010113          	addi	sp,sp,-16
    800069ac:	00113423          	sd	ra,8(sp)
    800069b0:	00813023          	sd	s0,0(sp)
    800069b4:	01010413          	addi	s0,sp,16
}
    800069b8:	00000097          	auipc	ra,0x0
    800069bc:	fc8080e7          	jalr	-56(ra) # 80006980 <_ZdlPv>
    800069c0:	00813083          	ld	ra,8(sp)
    800069c4:	00013403          	ld	s0,0(sp)
    800069c8:	01010113          	addi	sp,sp,16
    800069cc:	00008067          	ret

00000000800069d0 <_ZN9SemaphoreD0Ev>:
Semaphore::~Semaphore() {
    800069d0:	fe010113          	addi	sp,sp,-32
    800069d4:	00113c23          	sd	ra,24(sp)
    800069d8:	00813823          	sd	s0,16(sp)
    800069dc:	00913423          	sd	s1,8(sp)
    800069e0:	02010413          	addi	s0,sp,32
    800069e4:	00050493          	mv	s1,a0
}
    800069e8:	00000097          	auipc	ra,0x0
    800069ec:	f38080e7          	jalr	-200(ra) # 80006920 <_ZN9SemaphoreD1Ev>
    800069f0:	00048513          	mv	a0,s1
    800069f4:	00000097          	auipc	ra,0x0
    800069f8:	f8c080e7          	jalr	-116(ra) # 80006980 <_ZdlPv>
    800069fc:	01813083          	ld	ra,24(sp)
    80006a00:	01013403          	ld	s0,16(sp)
    80006a04:	00813483          	ld	s1,8(sp)
    80006a08:	02010113          	addi	sp,sp,32
    80006a0c:	00008067          	ret

0000000080006a10 <_ZN6ThreadC1EPFvPvES0_>:
Thread::Thread(void (*body)(void *), void *arg) : myHandle(nullptr), body(body), arg(arg){
    80006a10:	ff010113          	addi	sp,sp,-16
    80006a14:	00813423          	sd	s0,8(sp)
    80006a18:	01010413          	addi	s0,sp,16
    80006a1c:	00006797          	auipc	a5,0x6
    80006a20:	37478793          	addi	a5,a5,884 # 8000cd90 <_ZTV6Thread+0x10>
    80006a24:	00f53023          	sd	a5,0(a0)
    80006a28:	00053423          	sd	zero,8(a0)
    80006a2c:	00b53823          	sd	a1,16(a0)
    80006a30:	00c53c23          	sd	a2,24(a0)
}
    80006a34:	00813403          	ld	s0,8(sp)
    80006a38:	01010113          	addi	sp,sp,16
    80006a3c:	00008067          	ret

0000000080006a40 <_ZN6Thread5startEv>:
int Thread::start() {
    80006a40:	ff010113          	addi	sp,sp,-16
    80006a44:	00113423          	sd	ra,8(sp)
    80006a48:	00813023          	sd	s0,0(sp)
    80006a4c:	01010413          	addi	s0,sp,16
    auto b = this->body!= nullptr?body: runWrapper;
    80006a50:	01053783          	ld	a5,16(a0)
    80006a54:	02078663          	beqz	a5,80006a80 <_ZN6Thread5startEv+0x40>
    80006a58:	00078593          	mv	a1,a5
    void* a = this->body!= nullptr?arg: this;
    80006a5c:	02078863          	beqz	a5,80006a8c <_ZN6Thread5startEv+0x4c>
    80006a60:	01853603          	ld	a2,24(a0)
    return thread_create(&myHandle, b, a);
    80006a64:	00850513          	addi	a0,a0,8
    80006a68:	ffffe097          	auipc	ra,0xffffe
    80006a6c:	f28080e7          	jalr	-216(ra) # 80004990 <thread_create>
}
    80006a70:	00813083          	ld	ra,8(sp)
    80006a74:	00013403          	ld	s0,0(sp)
    80006a78:	01010113          	addi	sp,sp,16
    80006a7c:	00008067          	ret
    auto b = this->body!= nullptr?body: runWrapper;
    80006a80:	00000597          	auipc	a1,0x0
    80006a84:	e7458593          	addi	a1,a1,-396 # 800068f4 <_ZN6Thread10runWrapperEPv>
    80006a88:	fd5ff06f          	j	80006a5c <_ZN6Thread5startEv+0x1c>
    void* a = this->body!= nullptr?arg: this;
    80006a8c:	00050613          	mv	a2,a0
    80006a90:	fd5ff06f          	j	80006a64 <_ZN6Thread5startEv+0x24>

0000000080006a94 <_ZN6Thread8dispatchEv>:
void Thread::dispatch() { thread_dispatch(); }
    80006a94:	ff010113          	addi	sp,sp,-16
    80006a98:	00113423          	sd	ra,8(sp)
    80006a9c:	00813023          	sd	s0,0(sp)
    80006aa0:	01010413          	addi	s0,sp,16
    80006aa4:	ffffe097          	auipc	ra,0xffffe
    80006aa8:	fa8080e7          	jalr	-88(ra) # 80004a4c <thread_dispatch>
    80006aac:	00813083          	ld	ra,8(sp)
    80006ab0:	00013403          	ld	s0,0(sp)
    80006ab4:	01010113          	addi	sp,sp,16
    80006ab8:	00008067          	ret

0000000080006abc <_ZN6Thread5sleepEm>:
int Thread::sleep(time_t time) { return time_sleep(time); }
    80006abc:	ff010113          	addi	sp,sp,-16
    80006ac0:	00113423          	sd	ra,8(sp)
    80006ac4:	00813023          	sd	s0,0(sp)
    80006ac8:	01010413          	addi	s0,sp,16
    80006acc:	ffffe097          	auipc	ra,0xffffe
    80006ad0:	14c080e7          	jalr	332(ra) # 80004c18 <time_sleep>
    80006ad4:	00813083          	ld	ra,8(sp)
    80006ad8:	00013403          	ld	s0,0(sp)
    80006adc:	01010113          	addi	sp,sp,16
    80006ae0:	00008067          	ret

0000000080006ae4 <_ZN6ThreadC1Ev>:
Thread::Thread(): myHandle(nullptr), body(nullptr), arg(nullptr) { }
    80006ae4:	ff010113          	addi	sp,sp,-16
    80006ae8:	00813423          	sd	s0,8(sp)
    80006aec:	01010413          	addi	s0,sp,16
    80006af0:	00006797          	auipc	a5,0x6
    80006af4:	2a078793          	addi	a5,a5,672 # 8000cd90 <_ZTV6Thread+0x10>
    80006af8:	00f53023          	sd	a5,0(a0)
    80006afc:	00053423          	sd	zero,8(a0)
    80006b00:	00053823          	sd	zero,16(a0)
    80006b04:	00053c23          	sd	zero,24(a0)
    80006b08:	00813403          	ld	s0,8(sp)
    80006b0c:	01010113          	addi	sp,sp,16
    80006b10:	00008067          	ret

0000000080006b14 <_ZN9SemaphoreC1Ej>:
Semaphore::Semaphore(unsigned int init) : myHandle(nullptr) {
    80006b14:	ff010113          	addi	sp,sp,-16
    80006b18:	00113423          	sd	ra,8(sp)
    80006b1c:	00813023          	sd	s0,0(sp)
    80006b20:	01010413          	addi	s0,sp,16
    80006b24:	00006797          	auipc	a5,0x6
    80006b28:	29478793          	addi	a5,a5,660 # 8000cdb8 <_ZTV9Semaphore+0x10>
    80006b2c:	00f53023          	sd	a5,0(a0)
    80006b30:	00053423          	sd	zero,8(a0)
    sem_open(&myHandle, init);
    80006b34:	00850513          	addi	a0,a0,8
    80006b38:	ffffe097          	auipc	ra,0xffffe
    80006b3c:	f50080e7          	jalr	-176(ra) # 80004a88 <sem_open>
}
    80006b40:	00813083          	ld	ra,8(sp)
    80006b44:	00013403          	ld	s0,0(sp)
    80006b48:	01010113          	addi	sp,sp,16
    80006b4c:	00008067          	ret

0000000080006b50 <_ZN9Semaphore4waitEv>:

int Semaphore::wait() {
    80006b50:	ff010113          	addi	sp,sp,-16
    80006b54:	00113423          	sd	ra,8(sp)
    80006b58:	00813023          	sd	s0,0(sp)
    80006b5c:	01010413          	addi	s0,sp,16
    return sem_wait(myHandle);
    80006b60:	00853503          	ld	a0,8(a0)
    80006b64:	ffffe097          	auipc	ra,0xffffe
    80006b68:	fa8080e7          	jalr	-88(ra) # 80004b0c <sem_wait>
}
    80006b6c:	00813083          	ld	ra,8(sp)
    80006b70:	00013403          	ld	s0,0(sp)
    80006b74:	01010113          	addi	sp,sp,16
    80006b78:	00008067          	ret

0000000080006b7c <_ZN9Semaphore6signalEv>:

int Semaphore::signal() {
    80006b7c:	ff010113          	addi	sp,sp,-16
    80006b80:	00113423          	sd	ra,8(sp)
    80006b84:	00813023          	sd	s0,0(sp)
    80006b88:	01010413          	addi	s0,sp,16
    return sem_signal(myHandle);
    80006b8c:	00853503          	ld	a0,8(a0)
    80006b90:	ffffe097          	auipc	ra,0xffffe
    80006b94:	fbc080e7          	jalr	-68(ra) # 80004b4c <sem_signal>
}
    80006b98:	00813083          	ld	ra,8(sp)
    80006b9c:	00013403          	ld	s0,0(sp)
    80006ba0:	01010113          	addi	sp,sp,16
    80006ba4:	00008067          	ret

0000000080006ba8 <_ZN9Semaphore9timedWaitEm>:

int Semaphore::timedWait(time_t timeout) {
    80006ba8:	ff010113          	addi	sp,sp,-16
    80006bac:	00113423          	sd	ra,8(sp)
    80006bb0:	00813023          	sd	s0,0(sp)
    80006bb4:	01010413          	addi	s0,sp,16
    return sem_timedwait(myHandle, timeout);
    80006bb8:	00853503          	ld	a0,8(a0)
    80006bbc:	ffffe097          	auipc	ra,0xffffe
    80006bc0:	fd0080e7          	jalr	-48(ra) # 80004b8c <sem_timedwait>
}
    80006bc4:	00813083          	ld	ra,8(sp)
    80006bc8:	00013403          	ld	s0,0(sp)
    80006bcc:	01010113          	addi	sp,sp,16
    80006bd0:	00008067          	ret

0000000080006bd4 <_ZN9Semaphore7tryWaitEv>:

int Semaphore::tryWait() {
    80006bd4:	ff010113          	addi	sp,sp,-16
    80006bd8:	00113423          	sd	ra,8(sp)
    80006bdc:	00813023          	sd	s0,0(sp)
    80006be0:	01010413          	addi	s0,sp,16
    return sem_trywait(myHandle);
    80006be4:	00853503          	ld	a0,8(a0)
    80006be8:	ffffe097          	auipc	ra,0xffffe
    80006bec:	ff0080e7          	jalr	-16(ra) # 80004bd8 <sem_trywait>
}
    80006bf0:	00813083          	ld	ra,8(sp)
    80006bf4:	00013403          	ld	s0,0(sp)
    80006bf8:	01010113          	addi	sp,sp,16
    80006bfc:	00008067          	ret

0000000080006c00 <_ZN14PeriodicThreadC1Em>:

PeriodicThread::PeriodicThread(time_t period) : Thread(){
    80006c00:	fe010113          	addi	sp,sp,-32
    80006c04:	00113c23          	sd	ra,24(sp)
    80006c08:	00813823          	sd	s0,16(sp)
    80006c0c:	00913423          	sd	s1,8(sp)
    80006c10:	01213023          	sd	s2,0(sp)
    80006c14:	02010413          	addi	s0,sp,32
    80006c18:	00050493          	mv	s1,a0
    80006c1c:	00058913          	mv	s2,a1
    80006c20:	00000097          	auipc	ra,0x0
    80006c24:	ec4080e7          	jalr	-316(ra) # 80006ae4 <_ZN6ThreadC1Ev>
    80006c28:	00006797          	auipc	a5,0x6
    80006c2c:	13878793          	addi	a5,a5,312 # 8000cd60 <_ZTV14PeriodicThread+0x10>
    80006c30:	00f4b023          	sd	a5,0(s1)
    this->period = period;
    80006c34:	0324b023          	sd	s2,32(s1)

}
    80006c38:	01813083          	ld	ra,24(sp)
    80006c3c:	01013403          	ld	s0,16(sp)
    80006c40:	00813483          	ld	s1,8(sp)
    80006c44:	00013903          	ld	s2,0(sp)
    80006c48:	02010113          	addi	sp,sp,32
    80006c4c:	00008067          	ret

0000000080006c50 <_ZN7Console4getcEv>:

char Console::getc() {
    80006c50:	ff010113          	addi	sp,sp,-16
    80006c54:	00113423          	sd	ra,8(sp)
    80006c58:	00813023          	sd	s0,0(sp)
    80006c5c:	01010413          	addi	s0,sp,16
    return ::getc();
    80006c60:	ffffe097          	auipc	ra,0xffffe
    80006c64:	004080e7          	jalr	4(ra) # 80004c64 <getc>
}
    80006c68:	00813083          	ld	ra,8(sp)
    80006c6c:	00013403          	ld	s0,0(sp)
    80006c70:	01010113          	addi	sp,sp,16
    80006c74:	00008067          	ret

0000000080006c78 <_ZN7Console4putcEc>:

void Console::putc(char c) {
    80006c78:	ff010113          	addi	sp,sp,-16
    80006c7c:	00113423          	sd	ra,8(sp)
    80006c80:	00813023          	sd	s0,0(sp)
    80006c84:	01010413          	addi	s0,sp,16
    ::putc(c);
    80006c88:	ffffe097          	auipc	ra,0xffffe
    80006c8c:	01c080e7          	jalr	28(ra) # 80004ca4 <putc>
}
    80006c90:	00813083          	ld	ra,8(sp)
    80006c94:	00013403          	ld	s0,0(sp)
    80006c98:	01010113          	addi	sp,sp,16
    80006c9c:	00008067          	ret

0000000080006ca0 <_ZN6Thread3runEv>:
    int start ();
    static void dispatch ();
    static int sleep (time_t);
protected:
    Thread ();
    virtual void run () {}
    80006ca0:	ff010113          	addi	sp,sp,-16
    80006ca4:	00813423          	sd	s0,8(sp)
    80006ca8:	01010413          	addi	s0,sp,16
    80006cac:	00813403          	ld	s0,8(sp)
    80006cb0:	01010113          	addi	sp,sp,16
    80006cb4:	00008067          	ret

0000000080006cb8 <_ZN14PeriodicThread18periodicActivationEv>:
};
class PeriodicThread : public Thread {
public:
    void terminate (){ period = 0; } // thread shouldn't terminate itself
protected:
    PeriodicThread (time_t period);
    80006cb8:	ff010113          	addi	sp,sp,-16
    80006cbc:	00813423          	sd	s0,8(sp)
    80006cc0:	01010413          	addi	s0,sp,16
    80006cc4:	00813403          	ld	s0,8(sp)
    80006cc8:	01010113          	addi	sp,sp,16
    80006ccc:	00008067          	ret

0000000080006cd0 <_ZN14PeriodicThreadD1Ev>:
};
    80006cd0:	ff010113          	addi	sp,sp,-16
    80006cd4:	00813423          	sd	s0,8(sp)
    80006cd8:	01010413          	addi	s0,sp,16
    80006cdc:	00006797          	auipc	a5,0x6
    80006ce0:	08478793          	addi	a5,a5,132 # 8000cd60 <_ZTV14PeriodicThread+0x10>
    80006ce4:	00f53023          	sd	a5,0(a0)
    80006ce8:	00813403          	ld	s0,8(sp)
    80006cec:	01010113          	addi	sp,sp,16
    80006cf0:	00008067          	ret

0000000080006cf4 <_ZN14PeriodicThreadD0Ev>:
    80006cf4:	ff010113          	addi	sp,sp,-16
    80006cf8:	00113423          	sd	ra,8(sp)
    80006cfc:	00813023          	sd	s0,0(sp)
    80006d00:	01010413          	addi	s0,sp,16
    80006d04:	00006797          	auipc	a5,0x6
    80006d08:	05c78793          	addi	a5,a5,92 # 8000cd60 <_ZTV14PeriodicThread+0x10>
    80006d0c:	00f53023          	sd	a5,0(a0)
    80006d10:	00000097          	auipc	ra,0x0
    80006d14:	c70080e7          	jalr	-912(ra) # 80006980 <_ZdlPv>
    80006d18:	00813083          	ld	ra,8(sp)
    80006d1c:	00013403          	ld	s0,0(sp)
    80006d20:	01010113          	addi	sp,sp,16
    80006d24:	00008067          	ret

0000000080006d28 <_ZN14PeriodicThread3runEv>:
    virtual void periodicActivation () {}
    80006d28:	fe010113          	addi	sp,sp,-32
    80006d2c:	00113c23          	sd	ra,24(sp)
    80006d30:	00813823          	sd	s0,16(sp)
    80006d34:	00913423          	sd	s1,8(sp)
    80006d38:	02010413          	addi	s0,sp,32
    80006d3c:	00050493          	mv	s1,a0
    void run() override{
    80006d40:	0204b783          	ld	a5,32(s1)
    80006d44:	02078263          	beqz	a5,80006d68 <_ZN14PeriodicThread3runEv+0x40>
        while (period != 0){
    80006d48:	0004b783          	ld	a5,0(s1)
    80006d4c:	0187b783          	ld	a5,24(a5)
    80006d50:	00048513          	mv	a0,s1
    80006d54:	000780e7          	jalr	a5
            periodicActivation(); // other way around?
    80006d58:	0204b503          	ld	a0,32(s1)
    80006d5c:	00000097          	auipc	ra,0x0
    80006d60:	d60080e7          	jalr	-672(ra) # 80006abc <_ZN6Thread5sleepEm>
    80006d64:	fc055ee3          	bgez	a0,80006d40 <_ZN14PeriodicThread3runEv+0x18>
            if(Thread::sleep(period) < 0)
                break;
        }
    80006d68:	01813083          	ld	ra,24(sp)
    80006d6c:	01013403          	ld	s0,16(sp)
    80006d70:	00813483          	ld	s1,8(sp)
    80006d74:	02010113          	addi	sp,sp,32
    80006d78:	00008067          	ret

0000000080006d7c <_ZN5Riscv20popSstatusSPPandSPIEEb>:
//
// Created by os on 5/7/24.
//
#include "../inc/riscv.hpp"
#include "../inc/_thread.hpp"
void Riscv::popSstatusSPPandSPIE(bool swToUsr) {
    80006d7c:	ff010113          	addi	sp,sp,-16
    80006d80:	00813423          	sd	s0,8(sp)
    80006d84:	01010413          	addi	s0,sp,16
    if(swToUsr)// change previous privileges
    80006d88:	00050663          	beqz	a0,80006d94 <_ZN5Riscv20popSstatusSPPandSPIEEb+0x18>
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    80006d8c:	10000793          	li	a5,256
    80006d90:	1007b073          	csrc	sstatus,a5
        Riscv::swMode(Mode::USER); // it will be switched when sret is called

    __asm__ volatile("csrw sepc, ra"); // sepc <= ra (it's line after this call)
    80006d94:	14109073          	csrw	sepc,ra
    __asm__ volatile("sret"); // pc <= sepc (ra) and previous privileges set to current
    80006d98:	10200073          	sret
}
    80006d9c:	00813403          	ld	s0,8(sp)
    80006da0:	01010113          	addi	sp,sp,16
    80006da4:	00008067          	ret

0000000080006da8 <_ZN4_sem10semTryWaitEv>:
    if(++val <= 0)
        unblock();
    return 0;
}

int _sem::semTryWait() {
    80006da8:	ff010113          	addi	sp,sp,-16
    80006dac:	00813423          	sd	s0,8(sp)
    80006db0:	01010413          	addi	s0,sp,16

   // if(val < 0) return waitCode::ALREADYLOCKED; // error
    if(--val < 0)
    80006db4:	00052783          	lw	a5,0(a0)
    80006db8:	fff7879b          	addiw	a5,a5,-1
    80006dbc:	00f52023          	sw	a5,0(a0)
    80006dc0:	02079713          	slli	a4,a5,0x20
    80006dc4:	00074a63          	bltz	a4,80006dd8 <_ZN4_sem10semTryWaitEv+0x30>
        return waitCode::SEMLOCKED;
    return waitCode::SEMFREE;
    80006dc8:	00100513          	li	a0,1
}
    80006dcc:	00813403          	ld	s0,8(sp)
    80006dd0:	01010113          	addi	sp,sp,16
    80006dd4:	00008067          	ret
        return waitCode::SEMLOCKED;
    80006dd8:	00000513          	li	a0,0
    80006ddc:	ff1ff06f          	j	80006dcc <_ZN4_sem10semTryWaitEv+0x24>

0000000080006de0 <_ZN4_sem5blockEP7_thread>:
void _sem::block(_thread* t) {
    80006de0:	fd010113          	addi	sp,sp,-48
    80006de4:	02113423          	sd	ra,40(sp)
    80006de8:	02813023          	sd	s0,32(sp)
    80006dec:	00913c23          	sd	s1,24(sp)
    80006df0:	01213823          	sd	s2,16(sp)
    80006df4:	01313423          	sd	s3,8(sp)
    80006df8:	03010413          	addi	s0,sp,48
    80006dfc:	00050913          	mv	s2,a0
    80006e00:	00058493          	mv	s1,a1
    blocked.addLast(t);
    80006e04:	00850993          	addi	s3,a0,8
        Elem *next;

        Elem(T *data, Elem *next) : data(data), next(next) {}

        void* operator new(size_t size){
            return MemoryAllocator::instance().malloc(size);
    80006e08:	00001097          	auipc	ra,0x1
    80006e0c:	8f8080e7          	jalr	-1800(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006e10:	01000593          	li	a1,16
    80006e14:	00001097          	auipc	ra,0x1
    80006e18:	a0c080e7          	jalr	-1524(ra) # 80007820 <_ZN15MemoryAllocator6mallocEm>
        Elem(T *data, Elem *next) : data(data), next(next) {}
    80006e1c:	00953023          	sd	s1,0(a0)
    80006e20:	00053423          	sd	zero,8(a0)
    }

    void addLast(T *data)
    {
        Elem *elem = new Elem(data, 0);
        if (tail)
    80006e24:	0089b783          	ld	a5,8(s3)
    80006e28:	02078c63          	beqz	a5,80006e60 <_ZN4_sem5blockEP7_thread+0x80>
        {
            tail->next = elem;
    80006e2c:	00a7b423          	sd	a0,8(a5)
            tail = elem;
    80006e30:	00a9b423          	sd	a0,8(s3)
    static int threadExit();
    static int timeSleep(time_t time);

    /// some setters
    void setFinished(bool val) { _thread::finished = val; }
    void setState(State val) { _thread::state = val; }
    80006e34:	00400793          	li	a5,4
    80006e38:	02f4ae23          	sw	a5,60(s1)
    t->setState(_thread::State::BLOCKED);
    thread_dispatch();
    80006e3c:	ffffe097          	auipc	ra,0xffffe
    80006e40:	c10080e7          	jalr	-1008(ra) # 80004a4c <thread_dispatch>
}
    80006e44:	02813083          	ld	ra,40(sp)
    80006e48:	02013403          	ld	s0,32(sp)
    80006e4c:	01813483          	ld	s1,24(sp)
    80006e50:	01013903          	ld	s2,16(sp)
    80006e54:	00813983          	ld	s3,8(sp)
    80006e58:	03010113          	addi	sp,sp,48
    80006e5c:	00008067          	ret
        } else
        {
            head = tail = elem;
    80006e60:	00a9b423          	sd	a0,8(s3)
    80006e64:	00a93423          	sd	a0,8(s2)
    80006e68:	fcdff06f          	j	80006e34 <_ZN4_sem5blockEP7_thread+0x54>

0000000080006e6c <_ZN4_sem7semWaitEmb>:
    if(timed_wait){ // timedWait
    80006e6c:	00060e63          	beqz	a2,80006e88 <_ZN4_sem7semWaitEmb+0x1c>
        if(timeout == 0)
    80006e70:	08058263          	beqz	a1,80006ef4 <_ZN4_sem7semWaitEmb+0x88>
        _thread::running->setTimedSem(this);
    80006e74:	00006797          	auipc	a5,0x6
    80006e78:	f8c7b783          	ld	a5,-116(a5) # 8000ce00 <_GLOBAL_OFFSET_TABLE_+0x20>
    80006e7c:	0007b783          	ld	a5,0(a5)
    bool shouldWakeUp() const { return time_sleeping <= 0; }

    /// for timed waiting
    static void timedWaitingHandler();

    void setTimedSem(_sem* s) { timed_sem = s; }
    80006e80:	04a7b423          	sd	a0,72(a5)
    _sem* getTimedSem() const { return timed_sem; }

    bool isTimedWaiting() const { return timed_sem != nullptr; }

    void setTimeout(time_t to) { timeout = to; }
    80006e84:	04b7b823          	sd	a1,80(a5)
    if(--val < 0)
    80006e88:	00052783          	lw	a5,0(a0)
    80006e8c:	fff7879b          	addiw	a5,a5,-1
    80006e90:	00f52023          	sw	a5,0(a0)
    80006e94:	02079713          	slli	a4,a5,0x20
    80006e98:	00074c63          	bltz	a4,80006eb0 <_ZN4_sem7semWaitEmb+0x44>
    return _thread::running->wait_ret_val; // 0 by default
    80006e9c:	00006797          	auipc	a5,0x6
    80006ea0:	f647b783          	ld	a5,-156(a5) # 8000ce00 <_GLOBAL_OFFSET_TABLE_+0x20>
    80006ea4:	0007b783          	ld	a5,0(a5)
    80006ea8:	0407a503          	lw	a0,64(a5)
}
    80006eac:	00008067          	ret
int _sem::semWait(time_t timeout, bool timed_wait) {
    80006eb0:	ff010113          	addi	sp,sp,-16
    80006eb4:	00113423          	sd	ra,8(sp)
    80006eb8:	00813023          	sd	s0,0(sp)
    80006ebc:	01010413          	addi	s0,sp,16
        block(_thread::running);
    80006ec0:	00006797          	auipc	a5,0x6
    80006ec4:	f407b783          	ld	a5,-192(a5) # 8000ce00 <_GLOBAL_OFFSET_TABLE_+0x20>
    80006ec8:	0007b583          	ld	a1,0(a5)
    80006ecc:	00000097          	auipc	ra,0x0
    80006ed0:	f14080e7          	jalr	-236(ra) # 80006de0 <_ZN4_sem5blockEP7_thread>
    return _thread::running->wait_ret_val; // 0 by default
    80006ed4:	00006797          	auipc	a5,0x6
    80006ed8:	f2c7b783          	ld	a5,-212(a5) # 8000ce00 <_GLOBAL_OFFSET_TABLE_+0x20>
    80006edc:	0007b783          	ld	a5,0(a5)
    80006ee0:	0407a503          	lw	a0,64(a5)
}
    80006ee4:	00813083          	ld	ra,8(sp)
    80006ee8:	00013403          	ld	s0,0(sp)
    80006eec:	01010113          	addi	sp,sp,16
    80006ef0:	00008067          	ret
            return waitCode::TIMEOUT;
    80006ef4:	ffe00513          	li	a0,-2
    80006ef8:	00008067          	ret

0000000080006efc <_ZN4_sem7unblockEv>:

void _sem::unblock() {
    80006efc:	fe010113          	addi	sp,sp,-32
    80006f00:	00113c23          	sd	ra,24(sp)
    80006f04:	00813823          	sd	s0,16(sp)
    80006f08:	00913423          	sd	s1,8(sp)
    80006f0c:	01213023          	sd	s2,0(sp)
    80006f10:	02010413          	addi	s0,sp,32
        }
    }

    T *removeFirst()
    {
        if (!head) { return 0; }
    80006f14:	00853903          	ld	s2,8(a0)
    80006f18:	06090863          	beqz	s2,80006f88 <_ZN4_sem7unblockEv+0x8c>

        Elem *elem = head;
        head = head->next;
    80006f1c:	00893783          	ld	a5,8(s2)
    80006f20:	00f53423          	sd	a5,8(a0)
        if (!head) { tail = 0; }
    80006f24:	04078e63          	beqz	a5,80006f80 <_ZN4_sem7unblockEv+0x84>

        T *ret = elem->data;
    80006f28:	00093483          	ld	s1,0(s2)
            MemoryAllocator::instance().free(chunk);
    80006f2c:	00000097          	auipc	ra,0x0
    80006f30:	7d4080e7          	jalr	2004(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80006f34:	00090593          	mv	a1,s2
    80006f38:	00001097          	auipc	ra,0x1
    80006f3c:	a78080e7          	jalr	-1416(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
    _thread* t = blocked.removeFirst();

    if(t){
    80006f40:	02048463          	beqz	s1,80006f68 <_ZN4_sem7unblockEv+0x6c>
    bool isTimedWaiting() const { return timed_sem != nullptr; }
    80006f44:	0484b783          	ld	a5,72(s1)
        if(t->isTimedWaiting()){
    80006f48:	00078663          	beqz	a5,80006f54 <_ZN4_sem7unblockEv+0x58>
    void setTimedSem(_sem* s) { timed_sem = s; }
    80006f4c:	0404b423          	sd	zero,72(s1)
    void setTimeout(time_t to) { timeout = to; }
    80006f50:	0404b823          	sd	zero,80(s1)
    void setState(State val) { _thread::state = val; }
    80006f54:	00100793          	li	a5,1
    80006f58:	02f4ae23          	sw	a5,60(s1)
            t->setTimedSem(nullptr); // not timed waiting anymore
            t->setTimeout(0);
        }
        t->setState(_thread::State::READY);
        Scheduler::put(t);
    80006f5c:	00048513          	mv	a0,s1
    80006f60:	fffff097          	auipc	ra,0xfffff
    80006f64:	4d4080e7          	jalr	1236(ra) # 80006434 <_ZN9Scheduler3putEP7_thread>
    }
}
    80006f68:	01813083          	ld	ra,24(sp)
    80006f6c:	01013403          	ld	s0,16(sp)
    80006f70:	00813483          	ld	s1,8(sp)
    80006f74:	00013903          	ld	s2,0(sp)
    80006f78:	02010113          	addi	sp,sp,32
    80006f7c:	00008067          	ret
        if (!head) { tail = 0; }
    80006f80:	00053823          	sd	zero,16(a0)
    80006f84:	fa5ff06f          	j	80006f28 <_ZN4_sem7unblockEv+0x2c>
        if (!head) { return 0; }
    80006f88:	00090493          	mv	s1,s2
    80006f8c:	fb5ff06f          	j	80006f40 <_ZN4_sem7unblockEv+0x44>

0000000080006f90 <_ZN4_sem9semSignalEv>:
    if(++val <= 0)
    80006f90:	00052783          	lw	a5,0(a0)
    80006f94:	0017879b          	addiw	a5,a5,1
    80006f98:	0007871b          	sext.w	a4,a5
    80006f9c:	00f52023          	sw	a5,0(a0)
    80006fa0:	00e05663          	blez	a4,80006fac <_ZN4_sem9semSignalEv+0x1c>
}
    80006fa4:	00000513          	li	a0,0
    80006fa8:	00008067          	ret
int _sem::semSignal() {
    80006fac:	ff010113          	addi	sp,sp,-16
    80006fb0:	00113423          	sd	ra,8(sp)
    80006fb4:	00813023          	sd	s0,0(sp)
    80006fb8:	01010413          	addi	s0,sp,16
        unblock();
    80006fbc:	00000097          	auipc	ra,0x0
    80006fc0:	f40080e7          	jalr	-192(ra) # 80006efc <_ZN4_sem7unblockEv>
}
    80006fc4:	00000513          	li	a0,0
    80006fc8:	00813083          	ld	ra,8(sp)
    80006fcc:	00013403          	ld	s0,0(sp)
    80006fd0:	01010113          	addi	sp,sp,16
    80006fd4:	00008067          	ret

0000000080006fd8 <_ZN4_sem9addToListEPS_>:
    }

    return 0;
}

void _sem::addToList(_sem* s) {
    80006fd8:	ff010113          	addi	sp,sp,-16
    80006fdc:	00813423          	sd	s0,8(sp)
    80006fe0:	01010413          	addi	s0,sp,16
    if (tail){
    80006fe4:	00006797          	auipc	a5,0x6
    80006fe8:	f5c7b783          	ld	a5,-164(a5) # 8000cf40 <_ZN4_sem4tailE>
    80006fec:	00078e63          	beqz	a5,80007008 <_ZN4_sem9addToListEPS_+0x30>
        tail->next = s;
    80006ff0:	00a7bc23          	sd	a0,24(a5)
        tail = s;
    80006ff4:	00006797          	auipc	a5,0x6
    80006ff8:	f4a7b623          	sd	a0,-180(a5) # 8000cf40 <_ZN4_sem4tailE>
    }else
        head = tail = s;
}
    80006ffc:	00813403          	ld	s0,8(sp)
    80007000:	01010113          	addi	sp,sp,16
    80007004:	00008067          	ret
        head = tail = s;
    80007008:	00006797          	auipc	a5,0x6
    8000700c:	f3878793          	addi	a5,a5,-200 # 8000cf40 <_ZN4_sem4tailE>
    80007010:	00a7b023          	sd	a0,0(a5)
    80007014:	00a7b423          	sd	a0,8(a5)
}
    80007018:	fe5ff06f          	j	80006ffc <_ZN4_sem9addToListEPS_+0x24>

000000008000701c <_ZN4_sem7semOpenEPPS_i>:
int _sem::semOpen(sem_t *handle, int init) {
    8000701c:	fe010113          	addi	sp,sp,-32
    80007020:	00113c23          	sd	ra,24(sp)
    80007024:	00813823          	sd	s0,16(sp)
    80007028:	00913423          	sd	s1,8(sp)
    8000702c:	01213023          	sd	s2,0(sp)
    80007030:	02010413          	addi	s0,sp,32
    80007034:	00050913          	mv	s2,a0
    80007038:	00058493          	mv	s1,a1
#include "../inc/List.hpp"

class _sem {
public:
    /// operators for making objects
    void *operator new(size_t n){ return MemoryAllocator::instance().malloc(n); }
    8000703c:	00000097          	auipc	ra,0x0
    80007040:	6c4080e7          	jalr	1732(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80007044:	02000593          	li	a1,32
    80007048:	00000097          	auipc	ra,0x0
    8000704c:	7d8080e7          	jalr	2008(ra) # 80007820 <_ZN15MemoryAllocator6mallocEm>
    enum waitCode{ ALREADYLOCKED = -3, TIMEOUT = -2, SEMDEAD = -1,  SEMLOCKED = 0, SEMFREE = 1 };

    static void addToList(_sem* s);
    static int removeFromList(_sem* s);

   explicit _sem(int val) : val(val),  next(nullptr)
    80007050:	00952023          	sw	s1,0(a0)
    List() : head(0), tail(0) {}
    80007054:	00053423          	sd	zero,8(a0)
    80007058:	00053823          	sd	zero,16(a0)
    8000705c:	00053c23          	sd	zero,24(a0)
    if(tmp) *handle = s;
    80007060:	02050663          	beqz	a0,8000708c <_ZN4_sem7semOpenEPPS_i+0x70>
    80007064:	00a93023          	sd	a0,0(s2)
    addToList(s);
    80007068:	00000097          	auipc	ra,0x0
    8000706c:	f70080e7          	jalr	-144(ra) # 80006fd8 <_ZN4_sem9addToListEPS_>
    return 0;
    80007070:	00000513          	li	a0,0
}
    80007074:	01813083          	ld	ra,24(sp)
    80007078:	01013403          	ld	s0,16(sp)
    8000707c:	00813483          	ld	s1,8(sp)
    80007080:	00013903          	ld	s2,0(sp)
    80007084:	02010113          	addi	sp,sp,32
    80007088:	00008067          	ret
    else return -1; // cannot allocate
    8000708c:	fff00513          	li	a0,-1
    80007090:	fe5ff06f          	j	80007074 <_ZN4_sem7semOpenEPPS_i+0x58>

0000000080007094 <_ZN4_sem14removeFromListEPS_>:

int _sem::removeFromList(_sem* s) {
    80007094:	ff010113          	addi	sp,sp,-16
    80007098:	00813423          	sd	s0,8(sp)
    8000709c:	01010413          	addi	s0,sp,16
    if(!head)
    800070a0:	00006697          	auipc	a3,0x6
    800070a4:	ea86b683          	ld	a3,-344(a3) # 8000cf48 <_ZN4_sem4headE>
    800070a8:	08068263          	beqz	a3,8000712c <_ZN4_sem14removeFromListEPS_+0x98>
        return -1;

    _sem* h = head, *prev = nullptr;
    800070ac:	00068793          	mv	a5,a3
    800070b0:	00000713          	li	a4,0
    for (; h ; prev = h, h = h->next) {
    800070b4:	00078a63          	beqz	a5,800070c8 <_ZN4_sem14removeFromListEPS_+0x34>
        if(h == s)break;
    800070b8:	00a78863          	beq	a5,a0,800070c8 <_ZN4_sem14removeFromListEPS_+0x34>
    for (; h ; prev = h, h = h->next) {
    800070bc:	00078713          	mv	a4,a5
    800070c0:	0187b783          	ld	a5,24(a5)
    800070c4:	ff1ff06f          	j	800070b4 <_ZN4_sem14removeFromListEPS_+0x20>
    }

    if(!h) return -1;
    800070c8:	06078663          	beqz	a5,80007134 <_ZN4_sem14removeFromListEPS_+0xa0>
    if(!prev){ // first
    800070cc:	02070663          	beqz	a4,800070f8 <_ZN4_sem14removeFromListEPS_+0x64>
        head = head->next;
        if(!head) tail = nullptr;
        return 0;
    }
    prev->next = s->next;
    800070d0:	01853783          	ld	a5,24(a0)
    800070d4:	00f73c23          	sd	a5,24(a4)
    s->next = nullptr;
    800070d8:	00053c23          	sd	zero,24(a0)

    if(tail == s) // if last
    800070dc:	00006797          	auipc	a5,0x6
    800070e0:	e647b783          	ld	a5,-412(a5) # 8000cf40 <_ZN4_sem4tailE>
    800070e4:	02a78c63          	beq	a5,a0,8000711c <_ZN4_sem14removeFromListEPS_+0x88>
        tail = prev;
    return 0;
    800070e8:	00000513          	li	a0,0
}
    800070ec:	00813403          	ld	s0,8(sp)
    800070f0:	01010113          	addi	sp,sp,16
    800070f4:	00008067          	ret
        head = head->next;
    800070f8:	0186b783          	ld	a5,24(a3)
    800070fc:	00006717          	auipc	a4,0x6
    80007100:	e4f73623          	sd	a5,-436(a4) # 8000cf48 <_ZN4_sem4headE>
        if(!head) tail = nullptr;
    80007104:	00078663          	beqz	a5,80007110 <_ZN4_sem14removeFromListEPS_+0x7c>
        return 0;
    80007108:	00000513          	li	a0,0
    8000710c:	fe1ff06f          	j	800070ec <_ZN4_sem14removeFromListEPS_+0x58>
        if(!head) tail = nullptr;
    80007110:	00006797          	auipc	a5,0x6
    80007114:	e207b823          	sd	zero,-464(a5) # 8000cf40 <_ZN4_sem4tailE>
    80007118:	ff1ff06f          	j	80007108 <_ZN4_sem14removeFromListEPS_+0x74>
        tail = prev;
    8000711c:	00006797          	auipc	a5,0x6
    80007120:	e2e7b223          	sd	a4,-476(a5) # 8000cf40 <_ZN4_sem4tailE>
    return 0;
    80007124:	00000513          	li	a0,0
    80007128:	fc5ff06f          	j	800070ec <_ZN4_sem14removeFromListEPS_+0x58>
        return -1;
    8000712c:	fff00513          	li	a0,-1
    80007130:	fbdff06f          	j	800070ec <_ZN4_sem14removeFromListEPS_+0x58>
    if(!h) return -1;
    80007134:	fff00513          	li	a0,-1
    80007138:	fb5ff06f          	j	800070ec <_ZN4_sem14removeFromListEPS_+0x58>

000000008000713c <_ZN4_sem8semCloseEv>:
int _sem::semClose() {
    8000713c:	fd010113          	addi	sp,sp,-48
    80007140:	02113423          	sd	ra,40(sp)
    80007144:	02813023          	sd	s0,32(sp)
    80007148:	00913c23          	sd	s1,24(sp)
    8000714c:	01213823          	sd	s2,16(sp)
    80007150:	01313423          	sd	s3,8(sp)
    80007154:	03010413          	addi	s0,sp,48
    80007158:	00050913          	mv	s2,a0
    removeFromList(this);
    8000715c:	00000097          	auipc	ra,0x0
    80007160:	f38080e7          	jalr	-200(ra) # 80007094 <_ZN4_sem14removeFromListEPS_>
    80007164:	03c0006f          	j	800071a0 <_ZN4_sem8semCloseEv+0x64>
        if (!head) { tail = 0; }
    80007168:	00093823          	sd	zero,16(s2)
        T *ret = elem->data;
    8000716c:	0004b983          	ld	s3,0(s1)
            MemoryAllocator::instance().free(chunk);
    80007170:	00000097          	auipc	ra,0x0
    80007174:	590080e7          	jalr	1424(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80007178:	00048593          	mv	a1,s1
    8000717c:	00001097          	auipc	ra,0x1
    80007180:	834080e7          	jalr	-1996(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
    80007184:	00100793          	li	a5,1
    80007188:	02f9ae23          	sw	a5,60(s3)
        t->wait_ret_val = waitCode::SEMDEAD;
    8000718c:	fff00793          	li	a5,-1
    80007190:	04f9a023          	sw	a5,64(s3)
        Scheduler::put(t);
    80007194:	00098513          	mv	a0,s3
    80007198:	fffff097          	auipc	ra,0xfffff
    8000719c:	29c080e7          	jalr	668(ra) # 80006434 <_ZN9Scheduler3putEP7_thread>
        return ret;
    }

    T *peekFirst()
    {
        if (!head) { return 0; }
    800071a0:	00893783          	ld	a5,8(s2)
    800071a4:	02078663          	beqz	a5,800071d0 <_ZN4_sem8semCloseEv+0x94>
        return head->data;
    800071a8:	0007b783          	ld	a5,0(a5)
    while (blocked.peekFirst() != nullptr){
    800071ac:	02078263          	beqz	a5,800071d0 <_ZN4_sem8semCloseEv+0x94>
        if (!head) { return 0; }
    800071b0:	00893483          	ld	s1,8(s2)
    800071b4:	00048a63          	beqz	s1,800071c8 <_ZN4_sem8semCloseEv+0x8c>
        head = head->next;
    800071b8:	0084b783          	ld	a5,8(s1)
    800071bc:	00f93423          	sd	a5,8(s2)
        if (!head) { tail = 0; }
    800071c0:	fa0796e3          	bnez	a5,8000716c <_ZN4_sem8semCloseEv+0x30>
    800071c4:	fa5ff06f          	j	80007168 <_ZN4_sem8semCloseEv+0x2c>
        if (!head) { return 0; }
    800071c8:	00048993          	mv	s3,s1
    800071cc:	fb9ff06f          	j	80007184 <_ZN4_sem8semCloseEv+0x48>
}
    800071d0:	00000513          	li	a0,0
    800071d4:	02813083          	ld	ra,40(sp)
    800071d8:	02013403          	ld	s0,32(sp)
    800071dc:	01813483          	ld	s1,24(sp)
    800071e0:	01013903          	ld	s2,16(sp)
    800071e4:	00813983          	ld	s3,8(sp)
    800071e8:	03010113          	addi	sp,sp,48
    800071ec:	00008067          	ret

00000000800071f0 <_ZN4_sem16unblock_timedoutEP7_thread>:

void _sem::unblock_timedout(_thread *t) {
    800071f0:	fd010113          	addi	sp,sp,-48
    800071f4:	02113423          	sd	ra,40(sp)
    800071f8:	02813023          	sd	s0,32(sp)
    800071fc:	00913c23          	sd	s1,24(sp)
    80007200:	01213823          	sd	s2,16(sp)
    80007204:	01313423          	sd	s3,8(sp)
    80007208:	03010413          	addi	s0,sp,48
    8000720c:	00050993          	mv	s3,a0
    80007210:	00058913          	mv	s2,a1

    blocked.remove(t);
    80007214:	00850693          	addi	a3,a0,8
        if (!tail) { return 0; }
        return tail->data;
    }

    bool remove(T* data){
        Elem* h = this->head, *prev = nullptr;
    80007218:	00853483          	ld	s1,8(a0)
    8000721c:	00000793          	li	a5,0
        for (; h ; prev = h, h = h->next) {
    80007220:	00048c63          	beqz	s1,80007238 <_ZN4_sem16unblock_timedoutEP7_thread+0x48>
            if(h->data == data)break;
    80007224:	0004b703          	ld	a4,0(s1)
    80007228:	00e90863          	beq	s2,a4,80007238 <_ZN4_sem16unblock_timedoutEP7_thread+0x48>
        for (; h ; prev = h, h = h->next) {
    8000722c:	00048793          	mv	a5,s1
    80007230:	0084b483          	ld	s1,8(s1)
    80007234:	fedff06f          	j	80007220 <_ZN4_sem16unblock_timedoutEP7_thread+0x30>
        }
        if(!h) return false;
    80007238:	02048463          	beqz	s1,80007260 <_ZN4_sem16unblock_timedoutEP7_thread+0x70>
        if(!prev) // it's first el
    8000723c:	06078463          	beqz	a5,800072a4 <_ZN4_sem16unblock_timedoutEP7_thread+0xb4>
            return removeFirst()!= nullptr;
        if(!h->next) // it's last
    80007240:	0084b703          	ld	a4,8(s1)
    80007244:	08070a63          	beqz	a4,800072d8 <_ZN4_sem16unblock_timedoutEP7_thread+0xe8>
            return removeLast()!= nullptr;
        // it's in between

        prev->next = h->next;
    80007248:	00e7b423          	sd	a4,8(a5)
            MemoryAllocator::instance().free(chunk);
    8000724c:	00000097          	auipc	ra,0x0
    80007250:	4b4080e7          	jalr	1204(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80007254:	00048593          	mv	a1,s1
    80007258:	00000097          	auipc	ra,0x0
    8000725c:	758080e7          	jalr	1880(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
    80007260:	00100793          	li	a5,1
    80007264:	02f92e23          	sw	a5,60(s2)
    t->setState(_thread::State::READY);
    t->wait_ret_val = waitCode::TIMEOUT;
    80007268:	ffe00793          	li	a5,-2
    8000726c:	04f92023          	sw	a5,64(s2)
    semSignal(); // val++
    80007270:	00098513          	mv	a0,s3
    80007274:	00000097          	auipc	ra,0x0
    80007278:	d1c080e7          	jalr	-740(ra) # 80006f90 <_ZN4_sem9semSignalEv>
    Scheduler::put(t);
    8000727c:	00090513          	mv	a0,s2
    80007280:	fffff097          	auipc	ra,0xfffff
    80007284:	1b4080e7          	jalr	436(ra) # 80006434 <_ZN9Scheduler3putEP7_thread>
}
    80007288:	02813083          	ld	ra,40(sp)
    8000728c:	02013403          	ld	s0,32(sp)
    80007290:	01813483          	ld	s1,24(sp)
    80007294:	01013903          	ld	s2,16(sp)
    80007298:	00813983          	ld	s3,8(sp)
    8000729c:	03010113          	addi	sp,sp,48
    800072a0:	00008067          	ret
        if (!head) { return 0; }
    800072a4:	0089b483          	ld	s1,8(s3)
    800072a8:	fa048ce3          	beqz	s1,80007260 <_ZN4_sem16unblock_timedoutEP7_thread+0x70>
        head = head->next;
    800072ac:	0084b783          	ld	a5,8(s1)
    800072b0:	00f9b423          	sd	a5,8(s3)
        if (!head) { tail = 0; }
    800072b4:	00078e63          	beqz	a5,800072d0 <_ZN4_sem16unblock_timedoutEP7_thread+0xe0>
            MemoryAllocator::instance().free(chunk);
    800072b8:	00000097          	auipc	ra,0x0
    800072bc:	448080e7          	jalr	1096(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    800072c0:	00048593          	mv	a1,s1
    800072c4:	00000097          	auipc	ra,0x0
    800072c8:	6ec080e7          	jalr	1772(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
            return removeFirst()!= nullptr;
    800072cc:	f95ff06f          	j	80007260 <_ZN4_sem16unblock_timedoutEP7_thread+0x70>
        if (!head) { tail = 0; }
    800072d0:	0006b423          	sd	zero,8(a3)
    800072d4:	fe5ff06f          	j	800072b8 <_ZN4_sem16unblock_timedoutEP7_thread+0xc8>
        if (!head) { return 0; }
    800072d8:	0089b783          	ld	a5,8(s3)
    800072dc:	f80782e3          	beqz	a5,80007260 <_ZN4_sem16unblock_timedoutEP7_thread+0x70>
        for (Elem *curr = head; curr && curr != tail; curr = curr->next)
    800072e0:	00078c63          	beqz	a5,800072f8 <_ZN4_sem16unblock_timedoutEP7_thread+0x108>
    800072e4:	0086b603          	ld	a2,8(a3)
    800072e8:	00c78863          	beq	a5,a2,800072f8 <_ZN4_sem16unblock_timedoutEP7_thread+0x108>
            prev = curr;
    800072ec:	00078713          	mv	a4,a5
        for (Elem *curr = head; curr && curr != tail; curr = curr->next)
    800072f0:	0087b783          	ld	a5,8(a5)
    800072f4:	fedff06f          	j	800072e0 <_ZN4_sem16unblock_timedoutEP7_thread+0xf0>
        Elem *elem = tail;
    800072f8:	0086b483          	ld	s1,8(a3)
        if (prev) { prev->next = 0; }
    800072fc:	02070463          	beqz	a4,80007324 <_ZN4_sem16unblock_timedoutEP7_thread+0x134>
    80007300:	00073423          	sd	zero,8(a4)
        tail = prev;
    80007304:	00e6b423          	sd	a4,8(a3)
        delete elem;
    80007308:	f4048ce3          	beqz	s1,80007260 <_ZN4_sem16unblock_timedoutEP7_thread+0x70>
            MemoryAllocator::instance().free(chunk);
    8000730c:	00000097          	auipc	ra,0x0
    80007310:	3f4080e7          	jalr	1012(ra) # 80007700 <_ZN15MemoryAllocator8instanceEv>
    80007314:	00048593          	mv	a1,s1
    80007318:	00000097          	auipc	ra,0x0
    8000731c:	698080e7          	jalr	1688(ra) # 800079b0 <_ZN15MemoryAllocator4freeEPv>
            return removeLast()!= nullptr;
    80007320:	f41ff06f          	j	80007260 <_ZN4_sem16unblock_timedoutEP7_thread+0x70>
        else { head = 0; }
    80007324:	0009b423          	sd	zero,8(s3)
    80007328:	fddff06f          	j	80007304 <_ZN4_sem16unblock_timedoutEP7_thread+0x114>

000000008000732c <_ZN4_sem14validSemaphoreEPS_>:

bool _sem::validSemaphore(sem_t s) { /// if in list then it's valid
    8000732c:	ff010113          	addi	sp,sp,-16
    80007330:	00813423          	sd	s0,8(sp)
    80007334:	01010413          	addi	s0,sp,16
    for (_sem* h = head; h ; h = h->next) {
    80007338:	00006797          	auipc	a5,0x6
    8000733c:	c107b783          	ld	a5,-1008(a5) # 8000cf48 <_ZN4_sem4headE>
    80007340:	00078863          	beqz	a5,80007350 <_ZN4_sem14validSemaphoreEPS_+0x24>
        if(s == h)
    80007344:	00a78e63          	beq	a5,a0,80007360 <_ZN4_sem14validSemaphoreEPS_+0x34>
    for (_sem* h = head; h ; h = h->next) {
    80007348:	0187b783          	ld	a5,24(a5)
    8000734c:	ff5ff06f          	j	80007340 <_ZN4_sem14validSemaphoreEPS_+0x14>
            return true;
    }
    return false;
    80007350:	00000513          	li	a0,0
}
    80007354:	00813403          	ld	s0,8(sp)
    80007358:	01010113          	addi	sp,sp,16
    8000735c:	00008067          	ret
            return true;
    80007360:	00100513          	li	a0,1
    80007364:	ff1ff06f          	j	80007354 <_ZN4_sem14validSemaphoreEPS_+0x28>

0000000080007368 <_ZN13ConsoleBufferC1Ei>:
//

#include "../inc/ConsoleBuffer.hpp"
#include "../inc/_sem.hpp"

ConsoleBuffer::ConsoleBuffer(int _cap) : cap(_cap + 1), head(0), tail(0) {
    80007368:	fe010113          	addi	sp,sp,-32
    8000736c:	00113c23          	sd	ra,24(sp)
    80007370:	00813823          	sd	s0,16(sp)
    80007374:	00913423          	sd	s1,8(sp)
    80007378:	01213023          	sd	s2,0(sp)
    8000737c:	02010413          	addi	s0,sp,32
    80007380:	00050493          	mv	s1,a0
    80007384:	00058913          	mv	s2,a1
    80007388:	0015851b          	addiw	a0,a1,1
    8000738c:	00a4a023          	sw	a0,0(s1)
    80007390:	0004a823          	sw	zero,16(s1)
    80007394:	0004aa23          	sw	zero,20(s1)
    buffer = (char *)mem_alloc(sizeof(char) * cap);
    80007398:	0005051b          	sext.w	a0,a0
    8000739c:	ffffd097          	auipc	ra,0xffffd
    800073a0:	56c080e7          	jalr	1388(ra) # 80004908 <mem_alloc>
    800073a4:	00a4b423          	sd	a0,8(s1)

    sem_open(&itemAvailable, 0);
    800073a8:	00000593          	li	a1,0
    800073ac:	02048513          	addi	a0,s1,32
    800073b0:	ffffd097          	auipc	ra,0xffffd
    800073b4:	6d8080e7          	jalr	1752(ra) # 80004a88 <sem_open>
    sem_open(&spaceAvailable, _cap);
    800073b8:	00090593          	mv	a1,s2
    800073bc:	01848513          	addi	a0,s1,24
    800073c0:	ffffd097          	auipc	ra,0xffffd
    800073c4:	6c8080e7          	jalr	1736(ra) # 80004a88 <sem_open>

}
    800073c8:	01813083          	ld	ra,24(sp)
    800073cc:	01013403          	ld	s0,16(sp)
    800073d0:	00813483          	ld	s1,8(sp)
    800073d4:	00013903          	ld	s2,0(sp)
    800073d8:	02010113          	addi	sp,sp,32
    800073dc:	00008067          	ret

00000000800073e0 <_ZN13ConsoleBuffer3putEc>:
    sem_close(itemAvailable);
    sem_close(spaceAvailable);

}

void ConsoleBuffer::put(char val) {
    800073e0:	fe010113          	addi	sp,sp,-32
    800073e4:	00113c23          	sd	ra,24(sp)
    800073e8:	00813823          	sd	s0,16(sp)
    800073ec:	00913423          	sd	s1,8(sp)
    800073f0:	01213023          	sd	s2,0(sp)
    800073f4:	02010413          	addi	s0,sp,32
    800073f8:	00050493          	mv	s1,a0
    800073fc:	00058913          	mv	s2,a1

    spaceAvailable->semWait();
    80007400:	00000613          	li	a2,0
    80007404:	00000593          	li	a1,0
    80007408:	01853503          	ld	a0,24(a0)
    8000740c:	00000097          	auipc	ra,0x0
    80007410:	a60080e7          	jalr	-1440(ra) # 80006e6c <_ZN4_sem7semWaitEmb>


    buffer[tail] = val;
    80007414:	0084b783          	ld	a5,8(s1)
    80007418:	0144a703          	lw	a4,20(s1)
    8000741c:	00e787b3          	add	a5,a5,a4
    80007420:	01278023          	sb	s2,0(a5)
    tail = (tail + 1) % cap;
    80007424:	0144a783          	lw	a5,20(s1)
    80007428:	0017879b          	addiw	a5,a5,1
    8000742c:	0004a703          	lw	a4,0(s1)
    80007430:	02e7e7bb          	remw	a5,a5,a4
    80007434:	00f4aa23          	sw	a5,20(s1)


    itemAvailable->semSignal();
    80007438:	0204b503          	ld	a0,32(s1)
    8000743c:	00000097          	auipc	ra,0x0
    80007440:	b54080e7          	jalr	-1196(ra) # 80006f90 <_ZN4_sem9semSignalEv>

}
    80007444:	01813083          	ld	ra,24(sp)
    80007448:	01013403          	ld	s0,16(sp)
    8000744c:	00813483          	ld	s1,8(sp)
    80007450:	00013903          	ld	s2,0(sp)
    80007454:	02010113          	addi	sp,sp,32
    80007458:	00008067          	ret

000000008000745c <_ZN13ConsoleBuffer3getEv>:

char ConsoleBuffer::get() {
    8000745c:	fe010113          	addi	sp,sp,-32
    80007460:	00113c23          	sd	ra,24(sp)
    80007464:	00813823          	sd	s0,16(sp)
    80007468:	00913423          	sd	s1,8(sp)
    8000746c:	01213023          	sd	s2,0(sp)
    80007470:	02010413          	addi	s0,sp,32
    80007474:	00050493          	mv	s1,a0

    itemAvailable->semWait();
    80007478:	00000613          	li	a2,0
    8000747c:	00000593          	li	a1,0
    80007480:	02053503          	ld	a0,32(a0)
    80007484:	00000097          	auipc	ra,0x0
    80007488:	9e8080e7          	jalr	-1560(ra) # 80006e6c <_ZN4_sem7semWaitEmb>



    char ret = buffer[head];
    8000748c:	0084b703          	ld	a4,8(s1)
    80007490:	0104a783          	lw	a5,16(s1)
    80007494:	00f70733          	add	a4,a4,a5
    80007498:	00074903          	lbu	s2,0(a4)
    head = (head + 1) % cap;
    8000749c:	0017879b          	addiw	a5,a5,1
    800074a0:	0004a703          	lw	a4,0(s1)
    800074a4:	02e7e7bb          	remw	a5,a5,a4
    800074a8:	00f4a823          	sw	a5,16(s1)


    spaceAvailable->semSignal();
    800074ac:	0184b503          	ld	a0,24(s1)
    800074b0:	00000097          	auipc	ra,0x0
    800074b4:	ae0080e7          	jalr	-1312(ra) # 80006f90 <_ZN4_sem9semSignalEv>

    return ret;
}
    800074b8:	00090513          	mv	a0,s2
    800074bc:	01813083          	ld	ra,24(sp)
    800074c0:	01013403          	ld	s0,16(sp)
    800074c4:	00813483          	ld	s1,8(sp)
    800074c8:	00013903          	ld	s2,0(sp)
    800074cc:	02010113          	addi	sp,sp,32
    800074d0:	00008067          	ret

00000000800074d4 <_ZN13ConsoleBuffer6getCntEv>:

int ConsoleBuffer::getCnt() {
    800074d4:	ff010113          	addi	sp,sp,-16
    800074d8:	00813423          	sd	s0,8(sp)
    800074dc:	01010413          	addi	s0,sp,16
    int ret;

    if (tail >= head) {
    800074e0:	01452783          	lw	a5,20(a0)
    800074e4:	01052703          	lw	a4,16(a0)
    800074e8:	00e7ca63          	blt	a5,a4,800074fc <_ZN13ConsoleBuffer6getCntEv+0x28>
        ret = tail - head;
    800074ec:	40e7853b          	subw	a0,a5,a4
    }



    return ret;
}
    800074f0:	00813403          	ld	s0,8(sp)
    800074f4:	01010113          	addi	sp,sp,16
    800074f8:	00008067          	ret
        ret = cap - head + tail;
    800074fc:	00052503          	lw	a0,0(a0)
    80007500:	40e5053b          	subw	a0,a0,a4
    80007504:	00f5053b          	addw	a0,a0,a5
    80007508:	fe9ff06f          	j	800074f0 <_ZN13ConsoleBuffer6getCntEv+0x1c>

000000008000750c <_ZN13ConsoleBufferD1Ev>:
ConsoleBuffer::~ConsoleBuffer() {
    8000750c:	fe010113          	addi	sp,sp,-32
    80007510:	00113c23          	sd	ra,24(sp)
    80007514:	00813823          	sd	s0,16(sp)
    80007518:	00913423          	sd	s1,8(sp)
    8000751c:	02010413          	addi	s0,sp,32
    80007520:	00050493          	mv	s1,a0
    while (getCnt()) {
    80007524:	00048513          	mv	a0,s1
    80007528:	00000097          	auipc	ra,0x0
    8000752c:	fac080e7          	jalr	-84(ra) # 800074d4 <_ZN13ConsoleBuffer6getCntEv>
    80007530:	00050e63          	beqz	a0,8000754c <_ZN13ConsoleBufferD1Ev+0x40>
        head = (head + 1) % cap;
    80007534:	0104a783          	lw	a5,16(s1)
    80007538:	0017879b          	addiw	a5,a5,1
    8000753c:	0004a703          	lw	a4,0(s1)
    80007540:	02e7e7bb          	remw	a5,a5,a4
    80007544:	00f4a823          	sw	a5,16(s1)
    while (getCnt()) {
    80007548:	fddff06f          	j	80007524 <_ZN13ConsoleBufferD1Ev+0x18>
    mem_free(buffer);
    8000754c:	0084b503          	ld	a0,8(s1)
    80007550:	ffffd097          	auipc	ra,0xffffd
    80007554:	400080e7          	jalr	1024(ra) # 80004950 <mem_free>
    sem_close(itemAvailable);
    80007558:	0204b503          	ld	a0,32(s1)
    8000755c:	ffffd097          	auipc	ra,0xffffd
    80007560:	570080e7          	jalr	1392(ra) # 80004acc <sem_close>
    sem_close(spaceAvailable);
    80007564:	0184b503          	ld	a0,24(s1)
    80007568:	ffffd097          	auipc	ra,0xffffd
    8000756c:	564080e7          	jalr	1380(ra) # 80004acc <sem_close>
}
    80007570:	01813083          	ld	ra,24(sp)
    80007574:	01013403          	ld	s0,16(sp)
    80007578:	00813483          	ld	s1,8(sp)
    8000757c:	02010113          	addi	sp,sp,32
    80007580:	00008067          	ret

0000000080007584 <_ZN8_console10putcHandleEPv>:
ConsoleBuffer* _console::getcBuffer;

void _console::putcHandle(void* arg) {
    while(true) {

        while (*((char *) CONSOLE_STATUS) & CONSOLE_TX_STATUS_BIT) {
    80007584:	00006797          	auipc	a5,0x6
    80007588:	86c7b783          	ld	a5,-1940(a5) # 8000cdf0 <_GLOBAL_OFFSET_TABLE_+0x10>
    8000758c:	0007b783          	ld	a5,0(a5)
    80007590:	0007c783          	lbu	a5,0(a5)
    80007594:	0207f793          	andi	a5,a5,32
    80007598:	fe0786e3          	beqz	a5,80007584 <_ZN8_console10putcHandleEPv>
void _console::putcHandle(void* arg) {
    8000759c:	ff010113          	addi	sp,sp,-16
    800075a0:	00113423          	sd	ra,8(sp)
    800075a4:	00813023          	sd	s0,0(sp)
    800075a8:	01010413          	addi	s0,sp,16
            char c = (char) putcBuffer->get();
    800075ac:	00006517          	auipc	a0,0x6
    800075b0:	9a453503          	ld	a0,-1628(a0) # 8000cf50 <_ZN8_console10putcBufferE>
    800075b4:	00000097          	auipc	ra,0x0
    800075b8:	ea8080e7          	jalr	-344(ra) # 8000745c <_ZN13ConsoleBuffer3getEv>

            *((char *) CONSOLE_TX_DATA) = c;
    800075bc:	00006797          	auipc	a5,0x6
    800075c0:	8547b783          	ld	a5,-1964(a5) # 8000ce10 <_GLOBAL_OFFSET_TABLE_+0x30>
    800075c4:	0007b783          	ld	a5,0(a5)
    800075c8:	00a78023          	sb	a0,0(a5)
        while (*((char *) CONSOLE_STATUS) & CONSOLE_TX_STATUS_BIT) {
    800075cc:	00006797          	auipc	a5,0x6
    800075d0:	8247b783          	ld	a5,-2012(a5) # 8000cdf0 <_GLOBAL_OFFSET_TABLE_+0x10>
    800075d4:	0007b783          	ld	a5,0(a5)
    800075d8:	0007c783          	lbu	a5,0(a5)
    800075dc:	0207f793          	andi	a5,a5,32
    800075e0:	fe0786e3          	beqz	a5,800075cc <_ZN8_console10putcHandleEPv+0x48>
    800075e4:	fc9ff06f          	j	800075ac <_ZN8_console10putcHandleEPv+0x28>

00000000800075e8 <_ZN8_console10getcHandleEv>:
    }


}

void _console::getcHandle() {
    800075e8:	ff010113          	addi	sp,sp,-16
    800075ec:	00113423          	sd	ra,8(sp)
    800075f0:	00813023          	sd	s0,0(sp)
    800075f4:	01010413          	addi	s0,sp,16
    if(plic_claim() != CONSOLE_IRQ)return; // not console interrupt?
    800075f8:	00001097          	auipc	ra,0x1
    800075fc:	e8c080e7          	jalr	-372(ra) # 80008484 <plic_claim>
    80007600:	00a00793          	li	a5,10
    80007604:	04f51e63          	bne	a0,a5,80007660 <_ZN8_console10getcHandleEv+0x78>
    80007608:	0140006f          	j	8000761c <_ZN8_console10getcHandleEv+0x34>

        char c = *((char *) CONSOLE_RX_DATA);
        if((int)c == 13) // INTERPRET ENTER AS \n (ASCII 13 <=> Carriage Return)
            c = '\n';

        getcBuffer->put(c);
    8000760c:	00006517          	auipc	a0,0x6
    80007610:	94c53503          	ld	a0,-1716(a0) # 8000cf58 <_ZN8_console10getcBufferE>
    80007614:	00000097          	auipc	ra,0x0
    80007618:	dcc080e7          	jalr	-564(ra) # 800073e0 <_ZN13ConsoleBuffer3putEc>
    while (*((char *) CONSOLE_STATUS) & CONSOLE_RX_STATUS_BIT) {
    8000761c:	00005797          	auipc	a5,0x5
    80007620:	7d47b783          	ld	a5,2004(a5) # 8000cdf0 <_GLOBAL_OFFSET_TABLE_+0x10>
    80007624:	0007b783          	ld	a5,0(a5)
    80007628:	0007c783          	lbu	a5,0(a5)
    8000762c:	0017f793          	andi	a5,a5,1
    80007630:	02078263          	beqz	a5,80007654 <_ZN8_console10getcHandleEv+0x6c>
        char c = *((char *) CONSOLE_RX_DATA);
    80007634:	00005797          	auipc	a5,0x5
    80007638:	7b47b783          	ld	a5,1972(a5) # 8000cde8 <_GLOBAL_OFFSET_TABLE_+0x8>
    8000763c:	0007b783          	ld	a5,0(a5)
    80007640:	0007c583          	lbu	a1,0(a5)
        if((int)c == 13) // INTERPRET ENTER AS \n (ASCII 13 <=> Carriage Return)
    80007644:	00d00793          	li	a5,13
    80007648:	fcf592e3          	bne	a1,a5,8000760c <_ZN8_console10getcHandleEv+0x24>
            c = '\n';
    8000764c:	00a00593          	li	a1,10
    80007650:	fbdff06f          	j	8000760c <_ZN8_console10getcHandleEv+0x24>

    }

    plic_complete(CONSOLE_IRQ);
    80007654:	00a00513          	li	a0,10
    80007658:	00001097          	auipc	ra,0x1
    8000765c:	e64080e7          	jalr	-412(ra) # 800084bc <plic_complete>

}
    80007660:	00813083          	ld	ra,8(sp)
    80007664:	00013403          	ld	s0,0(sp)
    80007668:	01010113          	addi	sp,sp,16
    8000766c:	00008067          	ret

0000000080007670 <_ZN8_console5putcSEm>:



void _console::putcS(uint64 c) {
    80007670:	ff010113          	addi	sp,sp,-16
    80007674:	00813423          	sd	s0,8(sp)
    80007678:	01010413          	addi	s0,sp,16

   while(!(*(char *) CONSOLE_STATUS & CONSOLE_TX_STATUS_BIT)) {
    8000767c:	00005797          	auipc	a5,0x5
    80007680:	7747b783          	ld	a5,1908(a5) # 8000cdf0 <_GLOBAL_OFFSET_TABLE_+0x10>
    80007684:	0007b783          	ld	a5,0(a5)
    80007688:	0007c783          	lbu	a5,0(a5)
    8000768c:	0207f793          	andi	a5,a5,32
    80007690:	fe0786e3          	beqz	a5,8000767c <_ZN8_console5putcSEm+0xc>
        /* busy wait */
    }
    *((char *) CONSOLE_TX_DATA) = (char) c;
    80007694:	00005797          	auipc	a5,0x5
    80007698:	77c7b783          	ld	a5,1916(a5) # 8000ce10 <_GLOBAL_OFFSET_TABLE_+0x30>
    8000769c:	0007b783          	ld	a5,0(a5)
    800076a0:	00a78023          	sb	a0,0(a5)
}
    800076a4:	00813403          	ld	s0,8(sp)
    800076a8:	01010113          	addi	sp,sp,16
    800076ac:	00008067          	ret

00000000800076b0 <_ZN15MemoryAllocatorC1Ev>:
MemoryAllocator& MemoryAllocator::instance() { /// singleton class
    static MemoryAllocator ma;
    return ma;
}

MemoryAllocator::MemoryAllocator() {
    800076b0:	ff010113          	addi	sp,sp,-16
    800076b4:	00813423          	sd	s0,8(sp)
    800076b8:	01010413          	addi	s0,sp,16
    /// HEAP space AROUND [800056e0, 88000000)
    this->start = (size_t)HEAP_START_ADDR; // 800056e0
    800076bc:	00005797          	auipc	a5,0x5
    800076c0:	73c7b783          	ld	a5,1852(a5) # 8000cdf8 <_GLOBAL_OFFSET_TABLE_+0x18>
    800076c4:	0007b703          	ld	a4,0(a5)
    800076c8:	00e53023          	sd	a4,0(a0)
    this->end = (size_t)HEAP_END_ADDR; // 88000000
    800076cc:	00005797          	auipc	a5,0x5
    800076d0:	76c7b783          	ld	a5,1900(a5) # 8000ce38 <_GLOBAL_OFFSET_TABLE_+0x58>
    800076d4:	0007b783          	ld	a5,0(a5)
    800076d8:	00f53423          	sd	a5,8(a0)

    this->head = (FreeMemBlock*)start;
    800076dc:	00e53823          	sd	a4,16(a0)
    this->head->size = this->end - this->start - sizeof(FreeMemBlock); // whole HEAP - size of struct
    800076e0:	40e787b3          	sub	a5,a5,a4
    800076e4:	ff078793          	addi	a5,a5,-16
    800076e8:	00f73023          	sd	a5,0(a4)
    this->head->next= nullptr;
    800076ec:	01053783          	ld	a5,16(a0)
    800076f0:	0007b423          	sd	zero,8(a5)

}
    800076f4:	00813403          	ld	s0,8(sp)
    800076f8:	01010113          	addi	sp,sp,16
    800076fc:	00008067          	ret

0000000080007700 <_ZN15MemoryAllocator8instanceEv>:
    static MemoryAllocator ma;
    80007700:	00006797          	auipc	a5,0x6
    80007704:	8607c783          	lbu	a5,-1952(a5) # 8000cf60 <_ZGVZN15MemoryAllocator8instanceEvE2ma>
    80007708:	00078863          	beqz	a5,80007718 <_ZN15MemoryAllocator8instanceEv+0x18>
}
    8000770c:	00006517          	auipc	a0,0x6
    80007710:	85c50513          	addi	a0,a0,-1956 # 8000cf68 <_ZZN15MemoryAllocator8instanceEvE2ma>
    80007714:	00008067          	ret
MemoryAllocator& MemoryAllocator::instance() { /// singleton class
    80007718:	ff010113          	addi	sp,sp,-16
    8000771c:	00113423          	sd	ra,8(sp)
    80007720:	00813023          	sd	s0,0(sp)
    80007724:	01010413          	addi	s0,sp,16
    static MemoryAllocator ma;
    80007728:	00006517          	auipc	a0,0x6
    8000772c:	84050513          	addi	a0,a0,-1984 # 8000cf68 <_ZZN15MemoryAllocator8instanceEvE2ma>
    80007730:	00000097          	auipc	ra,0x0
    80007734:	f80080e7          	jalr	-128(ra) # 800076b0 <_ZN15MemoryAllocatorC1Ev>
    80007738:	00100793          	li	a5,1
    8000773c:	00006717          	auipc	a4,0x6
    80007740:	82f70223          	sb	a5,-2012(a4) # 8000cf60 <_ZGVZN15MemoryAllocator8instanceEvE2ma>
}
    80007744:	00006517          	auipc	a0,0x6
    80007748:	82450513          	addi	a0,a0,-2012 # 8000cf68 <_ZZN15MemoryAllocator8instanceEvE2ma>
    8000774c:	00813083          	ld	ra,8(sp)
    80007750:	00013403          	ld	s0,0(sp)
    80007754:	01010113          	addi	sp,sp,16
    80007758:	00008067          	ret

000000008000775c <_ZN15MemoryAllocator7_mallocEm>:
    mem_in_blocks = Riscv::r_a1();
    /// call malloc
    return _malloc(mem_in_blocks);
}

void *MemoryAllocator::_malloc(size_t size_blcks) { // idea from 1. zad. avgust 2021.
    8000775c:	ff010113          	addi	sp,sp,-16
    80007760:	00813423          	sd	s0,8(sp)
    80007764:	01010413          	addi	s0,sp,16
    80007768:	00050693          	mv	a3,a0
    if(!this->head) return nullptr; /// no memory
    8000776c:	01053503          	ld	a0,16(a0)
    80007770:	06050c63          	beqz	a0,800077e8 <_ZN15MemoryAllocator7_mallocEm+0x8c>
    size_t needed_size = size_blcks * MEM_BLOCK_SIZE;
    80007774:	00659593          	slli	a1,a1,0x6
    size_t max_free_size = end - (start + sizeof(FreeMemBlock));
    80007778:	0086b783          	ld	a5,8(a3)
    8000777c:	0006b703          	ld	a4,0(a3)
    80007780:	40e787b3          	sub	a5,a5,a4
    80007784:	ff078793          	addi	a5,a5,-16
    if(needed_size > max_free_size) return nullptr; /// too large size
    80007788:	08b7e863          	bltu	a5,a1,80007818 <_ZN15MemoryAllocator7_mallocEm+0xbc>
    /// first fit algorithm
    FreeMemBlock* curr = this->head, *prev = nullptr;
    8000778c:	00000713          	li	a4,0
    80007790:	00c0006f          	j	8000779c <_ZN15MemoryAllocator7_mallocEm+0x40>
    for(; curr != nullptr; prev = curr, curr = curr->next)
    80007794:	00050713          	mv	a4,a0
    80007798:	00853503          	ld	a0,8(a0)
    8000779c:	00050663          	beqz	a0,800077a8 <_ZN15MemoryAllocator7_mallocEm+0x4c>
        if(curr->size >= needed_size)break;
    800077a0:	00053783          	ld	a5,0(a0)
    800077a4:	feb7e8e3          	bltu	a5,a1,80007794 <_ZN15MemoryAllocator7_mallocEm+0x38>
    if(!curr)return nullptr; // can't find block of needed_size size
    800077a8:	04050063          	beqz	a0,800077e8 <_ZN15MemoryAllocator7_mallocEm+0x8c>

    size_t remainder = curr->size - needed_size;
    800077ac:	00053783          	ld	a5,0(a0)
    800077b0:	40b787b3          	sub	a5,a5,a1
    if(remainder >= sizeof(FreeMemBlock) + MEM_BLOCK_SIZE) {
    800077b4:	04f00613          	li	a2,79
    800077b8:	04f67263          	bgeu	a2,a5,800077fc <_ZN15MemoryAllocator7_mallocEm+0xa0>
        /// calculate address of remaining block <=> sliced from the beginning and the rest is free memory
        FreeMemBlock *remaining_blk = (FreeMemBlock *) ((size_t) curr + sizeof(FreeMemBlock) + needed_size);
    800077bc:	00b50633          	add	a2,a0,a1
    800077c0:	01060813          	addi	a6,a2,16
        remaining_blk->next = curr->next;
    800077c4:	00853883          	ld	a7,8(a0)
    800077c8:	01183423          	sd	a7,8(a6)
        /// size <= from remaining free space subtract struct header size
        remaining_blk->size = remainder-sizeof(FreeMemBlock);
    800077cc:	ff078793          	addi	a5,a5,-16
    800077d0:	00f63823          	sd	a5,16(a2)
        /// put it in the list
        if(prev) prev->next = remaining_blk;
    800077d4:	02070063          	beqz	a4,800077f4 <_ZN15MemoryAllocator7_mallocEm+0x98>
    800077d8:	01073423          	sd	a6,8(a4)
        else this->head = remaining_blk; // it's first block

        curr->size = needed_size; // curr will be new allocated block
    800077dc:	00b53023          	sd	a1,0(a0)
        /// put it in the list
        if(prev) prev->next = curr->next;
        else this->head = curr->next; // it's first block
    }

    curr->next = nullptr;
    800077e0:	00053423          	sd	zero,8(a0)
    return (void *)((size_t)curr + sizeof(FreeMemBlock));
    800077e4:	01050513          	addi	a0,a0,16
}
    800077e8:	00813403          	ld	s0,8(sp)
    800077ec:	01010113          	addi	sp,sp,16
    800077f0:	00008067          	ret
        else this->head = remaining_blk; // it's first block
    800077f4:	0106b823          	sd	a6,16(a3)
    800077f8:	fe5ff06f          	j	800077dc <_ZN15MemoryAllocator7_mallocEm+0x80>
        if(prev) prev->next = curr->next;
    800077fc:	00070863          	beqz	a4,8000780c <_ZN15MemoryAllocator7_mallocEm+0xb0>
    80007800:	00853783          	ld	a5,8(a0)
    80007804:	00f73423          	sd	a5,8(a4)
    80007808:	fd9ff06f          	j	800077e0 <_ZN15MemoryAllocator7_mallocEm+0x84>
        else this->head = curr->next; // it's first block
    8000780c:	00853783          	ld	a5,8(a0)
    80007810:	00f6b823          	sd	a5,16(a3)
    80007814:	fcdff06f          	j	800077e0 <_ZN15MemoryAllocator7_mallocEm+0x84>
    if(needed_size > max_free_size) return nullptr; /// too large size
    80007818:	00000513          	li	a0,0
    8000781c:	fcdff06f          	j	800077e8 <_ZN15MemoryAllocator7_mallocEm+0x8c>

0000000080007820 <_ZN15MemoryAllocator6mallocEm>:
void *MemoryAllocator::malloc(size_t size) {
    80007820:	fe010113          	addi	sp,sp,-32
    80007824:	00113c23          	sd	ra,24(sp)
    80007828:	00813823          	sd	s0,16(sp)
    8000782c:	02010413          	addi	s0,sp,32
    mem_in_blocks = (size + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
    80007830:	03f58593          	addi	a1,a1,63
    80007834:	0065d593          	srli	a1,a1,0x6
    80007838:	feb43423          	sd	a1,-24(s0)
    return _malloc(mem_in_blocks);
    8000783c:	fe843583          	ld	a1,-24(s0)
    80007840:	00000097          	auipc	ra,0x0
    80007844:	f1c080e7          	jalr	-228(ra) # 8000775c <_ZN15MemoryAllocator7_mallocEm>
}
    80007848:	01813083          	ld	ra,24(sp)
    8000784c:	01013403          	ld	s0,16(sp)
    80007850:	02010113          	addi	sp,sp,32
    80007854:	00008067          	ret

0000000080007858 <_ZN15MemoryAllocator13malloc_blocksEm>:
void *MemoryAllocator::malloc_blocks(size_t size) { /// only from C api
    80007858:	fe010113          	addi	sp,sp,-32
    8000785c:	00113c23          	sd	ra,24(sp)
    80007860:	00813823          	sd	s0,16(sp)
    80007864:	02010413          	addi	s0,sp,32
    __asm__ volatile ("mv %[a1], a1" : [a1] "=r"(a1));
    80007868:	00058793          	mv	a5,a1
    8000786c:	fef43023          	sd	a5,-32(s0)
    return a1;
    80007870:	fe043783          	ld	a5,-32(s0)
    mem_in_blocks = Riscv::r_a1();
    80007874:	fef43423          	sd	a5,-24(s0)
    return _malloc(mem_in_blocks);
    80007878:	fe843583          	ld	a1,-24(s0)
    8000787c:	00000097          	auipc	ra,0x0
    80007880:	ee0080e7          	jalr	-288(ra) # 8000775c <_ZN15MemoryAllocator7_mallocEm>
}
    80007884:	01813083          	ld	ra,24(sp)
    80007888:	01013403          	ld	s0,16(sp)
    8000788c:	02010113          	addi	sp,sp,32
    80007890:	00008067          	ret

0000000080007894 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_>:
    else head = blk; // first in the list
    tryToJoin(blk, blk->next); /// try to join with next
    return 0;
}

bool MemoryAllocator::tryToJoin(FreeMemBlock* first, FreeMemBlock* second) {
    80007894:	ff010113          	addi	sp,sp,-16
    80007898:	00813423          	sd	s0,8(sp)
    8000789c:	01010413          	addi	s0,sp,16
    if(!first || !second) return false;
    800078a0:	04058a63          	beqz	a1,800078f4 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x60>
    800078a4:	04060c63          	beqz	a2,800078fc <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x68>
    if((size_t)first + sizeof(FreeMemBlock) + first->size == (size_t) second){
    800078a8:	0005b703          	ld	a4,0(a1)
    800078ac:	00e587b3          	add	a5,a1,a4
    800078b0:	01078793          	addi	a5,a5,16
    800078b4:	00c78a63          	beq	a5,a2,800078c8 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x34>

        second->next = nullptr;
        second->size = 0xFF; // for record where freed header was
        return true;
    }
    return false;
    800078b8:	00000513          	li	a0,0
}
    800078bc:	00813403          	ld	s0,8(sp)
    800078c0:	01010113          	addi	sp,sp,16
    800078c4:	00008067          	ret
        first->size += sizeof(FreeMemBlock) + second->size;
    800078c8:	00063783          	ld	a5,0(a2)
    800078cc:	00f70733          	add	a4,a4,a5
    800078d0:	01070713          	addi	a4,a4,16
    800078d4:	00e5b023          	sd	a4,0(a1)
        first->next = second->next;
    800078d8:	00863783          	ld	a5,8(a2)
    800078dc:	00f5b423          	sd	a5,8(a1)
        second->next = nullptr;
    800078e0:	00063423          	sd	zero,8(a2)
        second->size = 0xFF; // for record where freed header was
    800078e4:	0ff00793          	li	a5,255
    800078e8:	00f63023          	sd	a5,0(a2)
        return true;
    800078ec:	00100513          	li	a0,1
    800078f0:	fcdff06f          	j	800078bc <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x28>
    if(!first || !second) return false;
    800078f4:	00000513          	li	a0,0
    800078f8:	fc5ff06f          	j	800078bc <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x28>
    800078fc:	00000513          	li	a0,0
    80007900:	fbdff06f          	j	800078bc <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_+0x28>

0000000080007904 <_ZNK15MemoryAllocator20deallocatedAllMemoryEv>:


bool MemoryAllocator::deallocatedAllMemory() const {
    80007904:	ff010113          	addi	sp,sp,-16
    80007908:	00813423          	sd	s0,8(sp)
    8000790c:	01010413          	addi	s0,sp,16
    return ((size_t)head == start)&&  // same start address
    80007910:	01053783          	ld	a5,16(a0)
    80007914:	00053703          	ld	a4,0(a0)
    (head->size >= (this->end - this->start - sizeof(FreeMemBlock)))&& // same free size
    80007918:	00e78a63          	beq	a5,a4,8000792c <_ZNK15MemoryAllocator20deallocatedAllMemoryEv+0x28>
    8000791c:	00000513          	li	a0,0
    head->next == nullptr; // no more free memory
}
    80007920:	00813403          	ld	s0,8(sp)
    80007924:	01010113          	addi	sp,sp,16
    80007928:	00008067          	ret
    (head->size >= (this->end - this->start - sizeof(FreeMemBlock)))&& // same free size
    8000792c:	0007b603          	ld	a2,0(a5)
    80007930:	00853683          	ld	a3,8(a0)
    80007934:	40e68733          	sub	a4,a3,a4
    80007938:	ff070713          	addi	a4,a4,-16
    return ((size_t)head == start)&&  // same start address
    8000793c:	00e66a63          	bltu	a2,a4,80007950 <_ZNK15MemoryAllocator20deallocatedAllMemoryEv+0x4c>
    head->next == nullptr; // no more free memory
    80007940:	0087b783          	ld	a5,8(a5)
    (head->size >= (this->end - this->start - sizeof(FreeMemBlock)))&& // same free size
    80007944:	00078a63          	beqz	a5,80007958 <_ZNK15MemoryAllocator20deallocatedAllMemoryEv+0x54>
    80007948:	00000513          	li	a0,0
    8000794c:	fd5ff06f          	j	80007920 <_ZNK15MemoryAllocator20deallocatedAllMemoryEv+0x1c>
    80007950:	00000513          	li	a0,0
    80007954:	fcdff06f          	j	80007920 <_ZNK15MemoryAllocator20deallocatedAllMemoryEv+0x1c>
    80007958:	00100513          	li	a0,1
    8000795c:	fc5ff06f          	j	80007920 <_ZNK15MemoryAllocator20deallocatedAllMemoryEv+0x1c>

0000000080007960 <_ZN15MemoryAllocator18alreadyDeallocatedEm>:

bool MemoryAllocator::alreadyDeallocated(size_t addr) {
    80007960:	ff010113          	addi	sp,sp,-16
    80007964:	00813423          	sd	s0,8(sp)
    80007968:	01010413          	addi	s0,sp,16
    for (FreeMemBlock* h = this->head;  h ;h = h->next) {
    8000796c:	01053783          	ld	a5,16(a0)
    80007970:	0080006f          	j	80007978 <_ZN15MemoryAllocator18alreadyDeallocatedEm+0x18>
    80007974:	0087b783          	ld	a5,8(a5)
    80007978:	02078063          	beqz	a5,80007998 <_ZN15MemoryAllocator18alreadyDeallocatedEm+0x38>

        if(addr < (size_t)h) break; // no need to check other blocks
    8000797c:	02f5e663          	bltu	a1,a5,800079a8 <_ZN15MemoryAllocator18alreadyDeallocatedEm+0x48>

        if(addr > (size_t)(h) && addr <= (size_t)(h)+h->size)
    80007980:	feb7fae3          	bgeu	a5,a1,80007974 <_ZN15MemoryAllocator18alreadyDeallocatedEm+0x14>
    80007984:	0007b683          	ld	a3,0(a5)
    80007988:	00d78733          	add	a4,a5,a3
    8000798c:	feb764e3          	bltu	a4,a1,80007974 <_ZN15MemoryAllocator18alreadyDeallocatedEm+0x14>
            return true; // already deallocated
    80007990:	00100513          	li	a0,1
    80007994:	0080006f          	j	8000799c <_ZN15MemoryAllocator18alreadyDeallocatedEm+0x3c>

    }
    return false;
    80007998:	00000513          	li	a0,0
}
    8000799c:	00813403          	ld	s0,8(sp)
    800079a0:	01010113          	addi	sp,sp,16
    800079a4:	00008067          	ret
    return false;
    800079a8:	00000513          	li	a0,0
    800079ac:	ff1ff06f          	j	8000799c <_ZN15MemoryAllocator18alreadyDeallocatedEm+0x3c>

00000000800079b0 <_ZN15MemoryAllocator4freeEPv>:
    if(ptr == nullptr) return -1; // invalid address
    800079b0:	0e058c63          	beqz	a1,80007aa8 <_ZN15MemoryAllocator4freeEPv+0xf8>
int MemoryAllocator::free(void * ptr) {
    800079b4:	fc010113          	addi	sp,sp,-64
    800079b8:	02113c23          	sd	ra,56(sp)
    800079bc:	02813823          	sd	s0,48(sp)
    800079c0:	02913423          	sd	s1,40(sp)
    800079c4:	03213023          	sd	s2,32(sp)
    800079c8:	01313c23          	sd	s3,24(sp)
    800079cc:	01413823          	sd	s4,16(sp)
    800079d0:	01513423          	sd	s5,8(sp)
    800079d4:	04010413          	addi	s0,sp,64
    800079d8:	00050493          	mv	s1,a0
    800079dc:	00058993          	mv	s3,a1
    size_t addr = (size_t)ptr;
    800079e0:	00058913          	mv	s2,a1
    if(addr < this->start || addr >= this->end) return -2; // out of heap bounds
    800079e4:	00053783          	ld	a5,0(a0)
    800079e8:	0cf5e463          	bltu	a1,a5,80007ab0 <_ZN15MemoryAllocator4freeEPv+0x100>
    800079ec:	00853783          	ld	a5,8(a0)
    800079f0:	0cf5f463          	bgeu	a1,a5,80007ab8 <_ZN15MemoryAllocator4freeEPv+0x108>
    if(alreadyDeallocated(addr))return 0;
    800079f4:	00000097          	auipc	ra,0x0
    800079f8:	f6c080e7          	jalr	-148(ra) # 80007960 <_ZN15MemoryAllocator18alreadyDeallocatedEm>
    800079fc:	0c051263          	bnez	a0,80007ac0 <_ZN15MemoryAllocator4freeEPv+0x110>
    FreeMemBlock* blk = (FreeMemBlock*)(addr - sizeof(FreeMemBlock)); // not safe
    80007a00:	ff098a93          	addi	s5,s3,-16
    if(blk->next != nullptr || blk->size<=0) return -3; // basic checks
    80007a04:	008aba03          	ld	s4,8(s5)
    80007a08:	0c0a1063          	bnez	s4,80007ac8 <_ZN15MemoryAllocator4freeEPv+0x118>
    80007a0c:	ff09b683          	ld	a3,-16(s3)
    80007a10:	0c068063          	beqz	a3,80007ad0 <_ZN15MemoryAllocator4freeEPv+0x120>
    if(!this->head){
    80007a14:	0104b783          	ld	a5,16(s1)
    80007a18:	00078e63          	beqz	a5,80007a34 <_ZN15MemoryAllocator4freeEPv+0x84>
    for(; curr != nullptr; prev = curr, curr = curr->next)//[0-2]{3-4}[6-7][8-22]
    80007a1c:	02078063          	beqz	a5,80007a3c <_ZN15MemoryAllocator4freeEPv+0x8c>
        if(addr + blk->size <= (size_t)curr )break;
    80007a20:	01268733          	add	a4,a3,s2
    80007a24:	00e7fc63          	bgeu	a5,a4,80007a3c <_ZN15MemoryAllocator4freeEPv+0x8c>
    for(; curr != nullptr; prev = curr, curr = curr->next)//[0-2]{3-4}[6-7][8-22]
    80007a28:	00078a13          	mv	s4,a5
    80007a2c:	0087b783          	ld	a5,8(a5)
    80007a30:	fedff06f          	j	80007a1c <_ZN15MemoryAllocator4freeEPv+0x6c>
        this->head = blk;
    80007a34:	0154b823          	sd	s5,16(s1)
        return 0;
    80007a38:	04c0006f          	j	80007a84 <_ZN15MemoryAllocator4freeEPv+0xd4>
    blk->next = curr;
    80007a3c:	00fab423          	sd	a5,8(s5)
    if(prev){
    80007a40:	020a0463          	beqz	s4,80007a68 <_ZN15MemoryAllocator4freeEPv+0xb8>
        prev->next = blk;
    80007a44:	015a3423          	sd	s5,8(s4)
        if(tryToJoin(prev, blk)) /// if joined, change blk header
    80007a48:	000a8613          	mv	a2,s5
    80007a4c:	000a0593          	mv	a1,s4
    80007a50:	00048513          	mv	a0,s1
    80007a54:	00000097          	auipc	ra,0x0
    80007a58:	e40080e7          	jalr	-448(ra) # 80007894 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_>
    80007a5c:	00050863          	beqz	a0,80007a6c <_ZN15MemoryAllocator4freeEPv+0xbc>
            blk = prev;
    80007a60:	000a0a93          	mv	s5,s4
    80007a64:	0080006f          	j	80007a6c <_ZN15MemoryAllocator4freeEPv+0xbc>
    else head = blk; // first in the list
    80007a68:	0154b823          	sd	s5,16(s1)
    tryToJoin(blk, blk->next); /// try to join with next
    80007a6c:	008ab603          	ld	a2,8(s5)
    80007a70:	000a8593          	mv	a1,s5
    80007a74:	00048513          	mv	a0,s1
    80007a78:	00000097          	auipc	ra,0x0
    80007a7c:	e1c080e7          	jalr	-484(ra) # 80007894 <_ZN15MemoryAllocator9tryToJoinEPNS_12FreeMemBlockES1_>
    return 0;
    80007a80:	00000513          	li	a0,0
}
    80007a84:	03813083          	ld	ra,56(sp)
    80007a88:	03013403          	ld	s0,48(sp)
    80007a8c:	02813483          	ld	s1,40(sp)
    80007a90:	02013903          	ld	s2,32(sp)
    80007a94:	01813983          	ld	s3,24(sp)
    80007a98:	01013a03          	ld	s4,16(sp)
    80007a9c:	00813a83          	ld	s5,8(sp)
    80007aa0:	04010113          	addi	sp,sp,64
    80007aa4:	00008067          	ret
    if(ptr == nullptr) return -1; // invalid address
    80007aa8:	fff00513          	li	a0,-1
}
    80007aac:	00008067          	ret
    if(addr < this->start || addr >= this->end) return -2; // out of heap bounds
    80007ab0:	ffe00513          	li	a0,-2
    80007ab4:	fd1ff06f          	j	80007a84 <_ZN15MemoryAllocator4freeEPv+0xd4>
    80007ab8:	ffe00513          	li	a0,-2
    80007abc:	fc9ff06f          	j	80007a84 <_ZN15MemoryAllocator4freeEPv+0xd4>
    if(alreadyDeallocated(addr))return 0;
    80007ac0:	00000513          	li	a0,0
    80007ac4:	fc1ff06f          	j	80007a84 <_ZN15MemoryAllocator4freeEPv+0xd4>
    if(blk->next != nullptr || blk->size<=0) return -3; // basic checks
    80007ac8:	ffd00513          	li	a0,-3
    80007acc:	fb9ff06f          	j	80007a84 <_ZN15MemoryAllocator4freeEPv+0xd4>
    80007ad0:	ffd00513          	li	a0,-3
    80007ad4:	fb1ff06f          	j	80007a84 <_ZN15MemoryAllocator4freeEPv+0xd4>

0000000080007ad8 <_Z12printStringSPKc>:
// Created by os on 5/12/24.
//
#include "../inc/printingSupervisor.hpp"
#include "../inc/_console.hpp"

void printStringS(const char *string) {
    80007ad8:	fe010113          	addi	sp,sp,-32
    80007adc:	00113c23          	sd	ra,24(sp)
    80007ae0:	00813823          	sd	s0,16(sp)
    80007ae4:	00913423          	sd	s1,8(sp)
    80007ae8:	02010413          	addi	s0,sp,32
    80007aec:	00050493          	mv	s1,a0
    while (*string != '\0')
    80007af0:	0004c503          	lbu	a0,0(s1)
    80007af4:	00050a63          	beqz	a0,80007b08 <_Z12printStringSPKc+0x30>
    {
        _console::putcS(*string);
    80007af8:	00000097          	auipc	ra,0x0
    80007afc:	b78080e7          	jalr	-1160(ra) # 80007670 <_ZN8_console5putcSEm>
        string++;
    80007b00:	00148493          	addi	s1,s1,1
    while (*string != '\0')
    80007b04:	fedff06f          	j	80007af0 <_Z12printStringSPKc+0x18>
    }

}
    80007b08:	01813083          	ld	ra,24(sp)
    80007b0c:	01013403          	ld	s0,16(sp)
    80007b10:	00813483          	ld	s1,8(sp)
    80007b14:	02010113          	addi	sp,sp,32
    80007b18:	00008067          	ret

0000000080007b1c <_Z12stringToIntSPKc>:
//    }
//    buf[i] = '\0';
//    return buf;
//}

int stringToIntS(const char *s) {
    80007b1c:	ff010113          	addi	sp,sp,-16
    80007b20:	00813423          	sd	s0,8(sp)
    80007b24:	01010413          	addi	s0,sp,16
    80007b28:	00050693          	mv	a3,a0
    int n;

    n = 0;
    80007b2c:	00000513          	li	a0,0
    while ('0' <= *s && *s <= '9')
    80007b30:	0006c603          	lbu	a2,0(a3)
    80007b34:	fd06071b          	addiw	a4,a2,-48
    80007b38:	0ff77713          	andi	a4,a4,255
    80007b3c:	00900793          	li	a5,9
    80007b40:	02e7e063          	bltu	a5,a4,80007b60 <_Z12stringToIntSPKc+0x44>
        n = n * 10 + *s++ - '0';
    80007b44:	0025179b          	slliw	a5,a0,0x2
    80007b48:	00a787bb          	addw	a5,a5,a0
    80007b4c:	0017979b          	slliw	a5,a5,0x1
    80007b50:	00168693          	addi	a3,a3,1
    80007b54:	00c787bb          	addw	a5,a5,a2
    80007b58:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    80007b5c:	fd5ff06f          	j	80007b30 <_Z12stringToIntSPKc+0x14>
    return n;
}
    80007b60:	00813403          	ld	s0,8(sp)
    80007b64:	01010113          	addi	sp,sp,16
    80007b68:	00008067          	ret

0000000080007b6c <_Z9printIntSiii>:
char digitsS[] = "0123456789ABCDEF";

void printIntS(int xx, int base, int sgn) {
    80007b6c:	fd010113          	addi	sp,sp,-48
    80007b70:	02113423          	sd	ra,40(sp)
    80007b74:	02813023          	sd	s0,32(sp)
    80007b78:	00913c23          	sd	s1,24(sp)
    80007b7c:	03010413          	addi	s0,sp,48
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if(sgn && xx < 0){
    80007b80:	00060463          	beqz	a2,80007b88 <_Z9printIntSiii+0x1c>
    80007b84:	08054463          	bltz	a0,80007c0c <_Z9printIntSiii+0xa0>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    80007b88:	0005051b          	sext.w	a0,a0
    neg = 0;
    80007b8c:	00000813          	li	a6,0
    }

    i = 0;
    80007b90:	00000493          	li	s1,0
    do{
        buf[i++] = digitsS[x % base];
    80007b94:	0005879b          	sext.w	a5,a1
    80007b98:	02b5773b          	remuw	a4,a0,a1
    80007b9c:	00048613          	mv	a2,s1
    80007ba0:	0014849b          	addiw	s1,s1,1
    80007ba4:	02071693          	slli	a3,a4,0x20
    80007ba8:	0206d693          	srli	a3,a3,0x20
    80007bac:	00005717          	auipc	a4,0x5
    80007bb0:	21c70713          	addi	a4,a4,540 # 8000cdc8 <digitsS>
    80007bb4:	00d70733          	add	a4,a4,a3
    80007bb8:	00074683          	lbu	a3,0(a4)
    80007bbc:	fe040713          	addi	a4,s0,-32
    80007bc0:	00c70733          	add	a4,a4,a2
    80007bc4:	fed70823          	sb	a3,-16(a4)
    }while((x /= base) != 0);
    80007bc8:	0005071b          	sext.w	a4,a0
    80007bcc:	02b5553b          	divuw	a0,a0,a1
    80007bd0:	fcf772e3          	bgeu	a4,a5,80007b94 <_Z9printIntSiii+0x28>
    if(neg)
    80007bd4:	00080c63          	beqz	a6,80007bec <_Z9printIntSiii+0x80>
        buf[i++] = '-';
    80007bd8:	fe040793          	addi	a5,s0,-32
    80007bdc:	009784b3          	add	s1,a5,s1
    80007be0:	02d00793          	li	a5,45
    80007be4:	fef48823          	sb	a5,-16(s1)
    80007be8:	0026049b          	addiw	s1,a2,2

    while(--i >= 0)
    80007bec:	fff4849b          	addiw	s1,s1,-1
    80007bf0:	0204c463          	bltz	s1,80007c18 <_Z9printIntSiii+0xac>
        _console::putcS(buf[i]);
    80007bf4:	fe040793          	addi	a5,s0,-32
    80007bf8:	009787b3          	add	a5,a5,s1
    80007bfc:	ff07c503          	lbu	a0,-16(a5)
    80007c00:	00000097          	auipc	ra,0x0
    80007c04:	a70080e7          	jalr	-1424(ra) # 80007670 <_ZN8_console5putcSEm>
    80007c08:	fe5ff06f          	j	80007bec <_Z9printIntSiii+0x80>
        x = -xx;
    80007c0c:	40a0053b          	negw	a0,a0
        neg = 1;
    80007c10:	00100813          	li	a6,1
        x = -xx;
    80007c14:	f7dff06f          	j	80007b90 <_Z9printIntSiii+0x24>

}
    80007c18:	02813083          	ld	ra,40(sp)
    80007c1c:	02013403          	ld	s0,32(sp)
    80007c20:	01813483          	ld	s1,24(sp)
    80007c24:	03010113          	addi	sp,sp,48
    80007c28:	00008067          	ret

0000000080007c2c <start>:
    80007c2c:	ff010113          	addi	sp,sp,-16
    80007c30:	00813423          	sd	s0,8(sp)
    80007c34:	01010413          	addi	s0,sp,16
    80007c38:	300027f3          	csrr	a5,mstatus
    80007c3c:	ffffe737          	lui	a4,0xffffe
    80007c40:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff061f>
    80007c44:	00e7f7b3          	and	a5,a5,a4
    80007c48:	00001737          	lui	a4,0x1
    80007c4c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80007c50:	00e7e7b3          	or	a5,a5,a4
    80007c54:	30079073          	csrw	mstatus,a5
    80007c58:	00000797          	auipc	a5,0x0
    80007c5c:	16078793          	addi	a5,a5,352 # 80007db8 <system_main>
    80007c60:	34179073          	csrw	mepc,a5
    80007c64:	00000793          	li	a5,0
    80007c68:	18079073          	csrw	satp,a5
    80007c6c:	000107b7          	lui	a5,0x10
    80007c70:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80007c74:	30279073          	csrw	medeleg,a5
    80007c78:	30379073          	csrw	mideleg,a5
    80007c7c:	104027f3          	csrr	a5,sie
    80007c80:	2227e793          	ori	a5,a5,546
    80007c84:	10479073          	csrw	sie,a5
    80007c88:	fff00793          	li	a5,-1
    80007c8c:	00a7d793          	srli	a5,a5,0xa
    80007c90:	3b079073          	csrw	pmpaddr0,a5
    80007c94:	00f00793          	li	a5,15
    80007c98:	3a079073          	csrw	pmpcfg0,a5
    80007c9c:	f14027f3          	csrr	a5,mhartid
    80007ca0:	0200c737          	lui	a4,0x200c
    80007ca4:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80007ca8:	0007869b          	sext.w	a3,a5
    80007cac:	00269713          	slli	a4,a3,0x2
    80007cb0:	000f4637          	lui	a2,0xf4
    80007cb4:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80007cb8:	00d70733          	add	a4,a4,a3
    80007cbc:	0037979b          	slliw	a5,a5,0x3
    80007cc0:	020046b7          	lui	a3,0x2004
    80007cc4:	00d787b3          	add	a5,a5,a3
    80007cc8:	00c585b3          	add	a1,a1,a2
    80007ccc:	00371693          	slli	a3,a4,0x3
    80007cd0:	00005717          	auipc	a4,0x5
    80007cd4:	2b070713          	addi	a4,a4,688 # 8000cf80 <timer_scratch>
    80007cd8:	00b7b023          	sd	a1,0(a5)
    80007cdc:	00d70733          	add	a4,a4,a3
    80007ce0:	00f73c23          	sd	a5,24(a4)
    80007ce4:	02c73023          	sd	a2,32(a4)
    80007ce8:	34071073          	csrw	mscratch,a4
    80007cec:	00000797          	auipc	a5,0x0
    80007cf0:	6e478793          	addi	a5,a5,1764 # 800083d0 <timervec>
    80007cf4:	30579073          	csrw	mtvec,a5
    80007cf8:	300027f3          	csrr	a5,mstatus
    80007cfc:	0087e793          	ori	a5,a5,8
    80007d00:	30079073          	csrw	mstatus,a5
    80007d04:	304027f3          	csrr	a5,mie
    80007d08:	0807e793          	ori	a5,a5,128
    80007d0c:	30479073          	csrw	mie,a5
    80007d10:	f14027f3          	csrr	a5,mhartid
    80007d14:	0007879b          	sext.w	a5,a5
    80007d18:	00078213          	mv	tp,a5
    80007d1c:	30200073          	mret
    80007d20:	00813403          	ld	s0,8(sp)
    80007d24:	01010113          	addi	sp,sp,16
    80007d28:	00008067          	ret

0000000080007d2c <timerinit>:
    80007d2c:	ff010113          	addi	sp,sp,-16
    80007d30:	00813423          	sd	s0,8(sp)
    80007d34:	01010413          	addi	s0,sp,16
    80007d38:	f14027f3          	csrr	a5,mhartid
    80007d3c:	0200c737          	lui	a4,0x200c
    80007d40:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80007d44:	0007869b          	sext.w	a3,a5
    80007d48:	00269713          	slli	a4,a3,0x2
    80007d4c:	000f4637          	lui	a2,0xf4
    80007d50:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80007d54:	00d70733          	add	a4,a4,a3
    80007d58:	0037979b          	slliw	a5,a5,0x3
    80007d5c:	020046b7          	lui	a3,0x2004
    80007d60:	00d787b3          	add	a5,a5,a3
    80007d64:	00c585b3          	add	a1,a1,a2
    80007d68:	00371693          	slli	a3,a4,0x3
    80007d6c:	00005717          	auipc	a4,0x5
    80007d70:	21470713          	addi	a4,a4,532 # 8000cf80 <timer_scratch>
    80007d74:	00b7b023          	sd	a1,0(a5)
    80007d78:	00d70733          	add	a4,a4,a3
    80007d7c:	00f73c23          	sd	a5,24(a4)
    80007d80:	02c73023          	sd	a2,32(a4)
    80007d84:	34071073          	csrw	mscratch,a4
    80007d88:	00000797          	auipc	a5,0x0
    80007d8c:	64878793          	addi	a5,a5,1608 # 800083d0 <timervec>
    80007d90:	30579073          	csrw	mtvec,a5
    80007d94:	300027f3          	csrr	a5,mstatus
    80007d98:	0087e793          	ori	a5,a5,8
    80007d9c:	30079073          	csrw	mstatus,a5
    80007da0:	304027f3          	csrr	a5,mie
    80007da4:	0807e793          	ori	a5,a5,128
    80007da8:	30479073          	csrw	mie,a5
    80007dac:	00813403          	ld	s0,8(sp)
    80007db0:	01010113          	addi	sp,sp,16
    80007db4:	00008067          	ret

0000000080007db8 <system_main>:
    80007db8:	fe010113          	addi	sp,sp,-32
    80007dbc:	00813823          	sd	s0,16(sp)
    80007dc0:	00913423          	sd	s1,8(sp)
    80007dc4:	00113c23          	sd	ra,24(sp)
    80007dc8:	02010413          	addi	s0,sp,32
    80007dcc:	00000097          	auipc	ra,0x0
    80007dd0:	0c4080e7          	jalr	196(ra) # 80007e90 <cpuid>
    80007dd4:	00005497          	auipc	s1,0x5
    80007dd8:	0ac48493          	addi	s1,s1,172 # 8000ce80 <started>
    80007ddc:	02050263          	beqz	a0,80007e00 <system_main+0x48>
    80007de0:	0004a783          	lw	a5,0(s1)
    80007de4:	0007879b          	sext.w	a5,a5
    80007de8:	fe078ce3          	beqz	a5,80007de0 <system_main+0x28>
    80007dec:	0ff0000f          	fence
    80007df0:	00003517          	auipc	a0,0x3
    80007df4:	92050513          	addi	a0,a0,-1760 # 8000a710 <CONSOLE_STATUS+0x700>
    80007df8:	00001097          	auipc	ra,0x1
    80007dfc:	a74080e7          	jalr	-1420(ra) # 8000886c <panic>
    80007e00:	00001097          	auipc	ra,0x1
    80007e04:	9c8080e7          	jalr	-1592(ra) # 800087c8 <consoleinit>
    80007e08:	00001097          	auipc	ra,0x1
    80007e0c:	154080e7          	jalr	340(ra) # 80008f5c <printfinit>
    80007e10:	00002517          	auipc	a0,0x2
    80007e14:	54050513          	addi	a0,a0,1344 # 8000a350 <CONSOLE_STATUS+0x340>
    80007e18:	00001097          	auipc	ra,0x1
    80007e1c:	ab0080e7          	jalr	-1360(ra) # 800088c8 <__printf>
    80007e20:	00003517          	auipc	a0,0x3
    80007e24:	8c050513          	addi	a0,a0,-1856 # 8000a6e0 <CONSOLE_STATUS+0x6d0>
    80007e28:	00001097          	auipc	ra,0x1
    80007e2c:	aa0080e7          	jalr	-1376(ra) # 800088c8 <__printf>
    80007e30:	00002517          	auipc	a0,0x2
    80007e34:	52050513          	addi	a0,a0,1312 # 8000a350 <CONSOLE_STATUS+0x340>
    80007e38:	00001097          	auipc	ra,0x1
    80007e3c:	a90080e7          	jalr	-1392(ra) # 800088c8 <__printf>
    80007e40:	00001097          	auipc	ra,0x1
    80007e44:	4a8080e7          	jalr	1192(ra) # 800092e8 <kinit>
    80007e48:	00000097          	auipc	ra,0x0
    80007e4c:	148080e7          	jalr	328(ra) # 80007f90 <trapinit>
    80007e50:	00000097          	auipc	ra,0x0
    80007e54:	16c080e7          	jalr	364(ra) # 80007fbc <trapinithart>
    80007e58:	00000097          	auipc	ra,0x0
    80007e5c:	5b8080e7          	jalr	1464(ra) # 80008410 <plicinit>
    80007e60:	00000097          	auipc	ra,0x0
    80007e64:	5d8080e7          	jalr	1496(ra) # 80008438 <plicinithart>
    80007e68:	00000097          	auipc	ra,0x0
    80007e6c:	078080e7          	jalr	120(ra) # 80007ee0 <userinit>
    80007e70:	0ff0000f          	fence
    80007e74:	00100793          	li	a5,1
    80007e78:	00003517          	auipc	a0,0x3
    80007e7c:	88050513          	addi	a0,a0,-1920 # 8000a6f8 <CONSOLE_STATUS+0x6e8>
    80007e80:	00f4a023          	sw	a5,0(s1)
    80007e84:	00001097          	auipc	ra,0x1
    80007e88:	a44080e7          	jalr	-1468(ra) # 800088c8 <__printf>
    80007e8c:	0000006f          	j	80007e8c <system_main+0xd4>

0000000080007e90 <cpuid>:
    80007e90:	ff010113          	addi	sp,sp,-16
    80007e94:	00813423          	sd	s0,8(sp)
    80007e98:	01010413          	addi	s0,sp,16
    80007e9c:	00020513          	mv	a0,tp
    80007ea0:	00813403          	ld	s0,8(sp)
    80007ea4:	0005051b          	sext.w	a0,a0
    80007ea8:	01010113          	addi	sp,sp,16
    80007eac:	00008067          	ret

0000000080007eb0 <mycpu>:
    80007eb0:	ff010113          	addi	sp,sp,-16
    80007eb4:	00813423          	sd	s0,8(sp)
    80007eb8:	01010413          	addi	s0,sp,16
    80007ebc:	00020793          	mv	a5,tp
    80007ec0:	00813403          	ld	s0,8(sp)
    80007ec4:	0007879b          	sext.w	a5,a5
    80007ec8:	00779793          	slli	a5,a5,0x7
    80007ecc:	00006517          	auipc	a0,0x6
    80007ed0:	0e450513          	addi	a0,a0,228 # 8000dfb0 <cpus>
    80007ed4:	00f50533          	add	a0,a0,a5
    80007ed8:	01010113          	addi	sp,sp,16
    80007edc:	00008067          	ret

0000000080007ee0 <userinit>:
    80007ee0:	ff010113          	addi	sp,sp,-16
    80007ee4:	00813423          	sd	s0,8(sp)
    80007ee8:	01010413          	addi	s0,sp,16
    80007eec:	00813403          	ld	s0,8(sp)
    80007ef0:	01010113          	addi	sp,sp,16
    80007ef4:	ffffe317          	auipc	t1,0xffffe
    80007ef8:	7b430067          	jr	1972(t1) # 800066a8 <main>

0000000080007efc <either_copyout>:
    80007efc:	ff010113          	addi	sp,sp,-16
    80007f00:	00813023          	sd	s0,0(sp)
    80007f04:	00113423          	sd	ra,8(sp)
    80007f08:	01010413          	addi	s0,sp,16
    80007f0c:	02051663          	bnez	a0,80007f38 <either_copyout+0x3c>
    80007f10:	00058513          	mv	a0,a1
    80007f14:	00060593          	mv	a1,a2
    80007f18:	0006861b          	sext.w	a2,a3
    80007f1c:	00002097          	auipc	ra,0x2
    80007f20:	c58080e7          	jalr	-936(ra) # 80009b74 <__memmove>
    80007f24:	00813083          	ld	ra,8(sp)
    80007f28:	00013403          	ld	s0,0(sp)
    80007f2c:	00000513          	li	a0,0
    80007f30:	01010113          	addi	sp,sp,16
    80007f34:	00008067          	ret
    80007f38:	00003517          	auipc	a0,0x3
    80007f3c:	80050513          	addi	a0,a0,-2048 # 8000a738 <CONSOLE_STATUS+0x728>
    80007f40:	00001097          	auipc	ra,0x1
    80007f44:	92c080e7          	jalr	-1748(ra) # 8000886c <panic>

0000000080007f48 <either_copyin>:
    80007f48:	ff010113          	addi	sp,sp,-16
    80007f4c:	00813023          	sd	s0,0(sp)
    80007f50:	00113423          	sd	ra,8(sp)
    80007f54:	01010413          	addi	s0,sp,16
    80007f58:	02059463          	bnez	a1,80007f80 <either_copyin+0x38>
    80007f5c:	00060593          	mv	a1,a2
    80007f60:	0006861b          	sext.w	a2,a3
    80007f64:	00002097          	auipc	ra,0x2
    80007f68:	c10080e7          	jalr	-1008(ra) # 80009b74 <__memmove>
    80007f6c:	00813083          	ld	ra,8(sp)
    80007f70:	00013403          	ld	s0,0(sp)
    80007f74:	00000513          	li	a0,0
    80007f78:	01010113          	addi	sp,sp,16
    80007f7c:	00008067          	ret
    80007f80:	00002517          	auipc	a0,0x2
    80007f84:	7e050513          	addi	a0,a0,2016 # 8000a760 <CONSOLE_STATUS+0x750>
    80007f88:	00001097          	auipc	ra,0x1
    80007f8c:	8e4080e7          	jalr	-1820(ra) # 8000886c <panic>

0000000080007f90 <trapinit>:
    80007f90:	ff010113          	addi	sp,sp,-16
    80007f94:	00813423          	sd	s0,8(sp)
    80007f98:	01010413          	addi	s0,sp,16
    80007f9c:	00813403          	ld	s0,8(sp)
    80007fa0:	00002597          	auipc	a1,0x2
    80007fa4:	7e858593          	addi	a1,a1,2024 # 8000a788 <CONSOLE_STATUS+0x778>
    80007fa8:	00006517          	auipc	a0,0x6
    80007fac:	08850513          	addi	a0,a0,136 # 8000e030 <tickslock>
    80007fb0:	01010113          	addi	sp,sp,16
    80007fb4:	00001317          	auipc	t1,0x1
    80007fb8:	5c430067          	jr	1476(t1) # 80009578 <initlock>

0000000080007fbc <trapinithart>:
    80007fbc:	ff010113          	addi	sp,sp,-16
    80007fc0:	00813423          	sd	s0,8(sp)
    80007fc4:	01010413          	addi	s0,sp,16
    80007fc8:	00000797          	auipc	a5,0x0
    80007fcc:	2f878793          	addi	a5,a5,760 # 800082c0 <kernelvec>
    80007fd0:	10579073          	csrw	stvec,a5
    80007fd4:	00813403          	ld	s0,8(sp)
    80007fd8:	01010113          	addi	sp,sp,16
    80007fdc:	00008067          	ret

0000000080007fe0 <usertrap>:
    80007fe0:	ff010113          	addi	sp,sp,-16
    80007fe4:	00813423          	sd	s0,8(sp)
    80007fe8:	01010413          	addi	s0,sp,16
    80007fec:	00813403          	ld	s0,8(sp)
    80007ff0:	01010113          	addi	sp,sp,16
    80007ff4:	00008067          	ret

0000000080007ff8 <usertrapret>:
    80007ff8:	ff010113          	addi	sp,sp,-16
    80007ffc:	00813423          	sd	s0,8(sp)
    80008000:	01010413          	addi	s0,sp,16
    80008004:	00813403          	ld	s0,8(sp)
    80008008:	01010113          	addi	sp,sp,16
    8000800c:	00008067          	ret

0000000080008010 <kerneltrap>:
    80008010:	fe010113          	addi	sp,sp,-32
    80008014:	00813823          	sd	s0,16(sp)
    80008018:	00113c23          	sd	ra,24(sp)
    8000801c:	00913423          	sd	s1,8(sp)
    80008020:	02010413          	addi	s0,sp,32
    80008024:	142025f3          	csrr	a1,scause
    80008028:	100027f3          	csrr	a5,sstatus
    8000802c:	0027f793          	andi	a5,a5,2
    80008030:	10079c63          	bnez	a5,80008148 <kerneltrap+0x138>
    80008034:	142027f3          	csrr	a5,scause
    80008038:	0207ce63          	bltz	a5,80008074 <kerneltrap+0x64>
    8000803c:	00002517          	auipc	a0,0x2
    80008040:	79450513          	addi	a0,a0,1940 # 8000a7d0 <CONSOLE_STATUS+0x7c0>
    80008044:	00001097          	auipc	ra,0x1
    80008048:	884080e7          	jalr	-1916(ra) # 800088c8 <__printf>
    8000804c:	141025f3          	csrr	a1,sepc
    80008050:	14302673          	csrr	a2,stval
    80008054:	00002517          	auipc	a0,0x2
    80008058:	78c50513          	addi	a0,a0,1932 # 8000a7e0 <CONSOLE_STATUS+0x7d0>
    8000805c:	00001097          	auipc	ra,0x1
    80008060:	86c080e7          	jalr	-1940(ra) # 800088c8 <__printf>
    80008064:	00002517          	auipc	a0,0x2
    80008068:	79450513          	addi	a0,a0,1940 # 8000a7f8 <CONSOLE_STATUS+0x7e8>
    8000806c:	00001097          	auipc	ra,0x1
    80008070:	800080e7          	jalr	-2048(ra) # 8000886c <panic>
    80008074:	0ff7f713          	andi	a4,a5,255
    80008078:	00900693          	li	a3,9
    8000807c:	04d70063          	beq	a4,a3,800080bc <kerneltrap+0xac>
    80008080:	fff00713          	li	a4,-1
    80008084:	03f71713          	slli	a4,a4,0x3f
    80008088:	00170713          	addi	a4,a4,1
    8000808c:	fae798e3          	bne	a5,a4,8000803c <kerneltrap+0x2c>
    80008090:	00000097          	auipc	ra,0x0
    80008094:	e00080e7          	jalr	-512(ra) # 80007e90 <cpuid>
    80008098:	06050663          	beqz	a0,80008104 <kerneltrap+0xf4>
    8000809c:	144027f3          	csrr	a5,sip
    800080a0:	ffd7f793          	andi	a5,a5,-3
    800080a4:	14479073          	csrw	sip,a5
    800080a8:	01813083          	ld	ra,24(sp)
    800080ac:	01013403          	ld	s0,16(sp)
    800080b0:	00813483          	ld	s1,8(sp)
    800080b4:	02010113          	addi	sp,sp,32
    800080b8:	00008067          	ret
    800080bc:	00000097          	auipc	ra,0x0
    800080c0:	3c8080e7          	jalr	968(ra) # 80008484 <plic_claim>
    800080c4:	00a00793          	li	a5,10
    800080c8:	00050493          	mv	s1,a0
    800080cc:	06f50863          	beq	a0,a5,8000813c <kerneltrap+0x12c>
    800080d0:	fc050ce3          	beqz	a0,800080a8 <kerneltrap+0x98>
    800080d4:	00050593          	mv	a1,a0
    800080d8:	00002517          	auipc	a0,0x2
    800080dc:	6d850513          	addi	a0,a0,1752 # 8000a7b0 <CONSOLE_STATUS+0x7a0>
    800080e0:	00000097          	auipc	ra,0x0
    800080e4:	7e8080e7          	jalr	2024(ra) # 800088c8 <__printf>
    800080e8:	01013403          	ld	s0,16(sp)
    800080ec:	01813083          	ld	ra,24(sp)
    800080f0:	00048513          	mv	a0,s1
    800080f4:	00813483          	ld	s1,8(sp)
    800080f8:	02010113          	addi	sp,sp,32
    800080fc:	00000317          	auipc	t1,0x0
    80008100:	3c030067          	jr	960(t1) # 800084bc <plic_complete>
    80008104:	00006517          	auipc	a0,0x6
    80008108:	f2c50513          	addi	a0,a0,-212 # 8000e030 <tickslock>
    8000810c:	00001097          	auipc	ra,0x1
    80008110:	490080e7          	jalr	1168(ra) # 8000959c <acquire>
    80008114:	00005717          	auipc	a4,0x5
    80008118:	d7070713          	addi	a4,a4,-656 # 8000ce84 <ticks>
    8000811c:	00072783          	lw	a5,0(a4)
    80008120:	00006517          	auipc	a0,0x6
    80008124:	f1050513          	addi	a0,a0,-240 # 8000e030 <tickslock>
    80008128:	0017879b          	addiw	a5,a5,1
    8000812c:	00f72023          	sw	a5,0(a4)
    80008130:	00001097          	auipc	ra,0x1
    80008134:	538080e7          	jalr	1336(ra) # 80009668 <release>
    80008138:	f65ff06f          	j	8000809c <kerneltrap+0x8c>
    8000813c:	00001097          	auipc	ra,0x1
    80008140:	094080e7          	jalr	148(ra) # 800091d0 <uartintr>
    80008144:	fa5ff06f          	j	800080e8 <kerneltrap+0xd8>
    80008148:	00002517          	auipc	a0,0x2
    8000814c:	64850513          	addi	a0,a0,1608 # 8000a790 <CONSOLE_STATUS+0x780>
    80008150:	00000097          	auipc	ra,0x0
    80008154:	71c080e7          	jalr	1820(ra) # 8000886c <panic>

0000000080008158 <clockintr>:
    80008158:	fe010113          	addi	sp,sp,-32
    8000815c:	00813823          	sd	s0,16(sp)
    80008160:	00913423          	sd	s1,8(sp)
    80008164:	00113c23          	sd	ra,24(sp)
    80008168:	02010413          	addi	s0,sp,32
    8000816c:	00006497          	auipc	s1,0x6
    80008170:	ec448493          	addi	s1,s1,-316 # 8000e030 <tickslock>
    80008174:	00048513          	mv	a0,s1
    80008178:	00001097          	auipc	ra,0x1
    8000817c:	424080e7          	jalr	1060(ra) # 8000959c <acquire>
    80008180:	00005717          	auipc	a4,0x5
    80008184:	d0470713          	addi	a4,a4,-764 # 8000ce84 <ticks>
    80008188:	00072783          	lw	a5,0(a4)
    8000818c:	01013403          	ld	s0,16(sp)
    80008190:	01813083          	ld	ra,24(sp)
    80008194:	00048513          	mv	a0,s1
    80008198:	0017879b          	addiw	a5,a5,1
    8000819c:	00813483          	ld	s1,8(sp)
    800081a0:	00f72023          	sw	a5,0(a4)
    800081a4:	02010113          	addi	sp,sp,32
    800081a8:	00001317          	auipc	t1,0x1
    800081ac:	4c030067          	jr	1216(t1) # 80009668 <release>

00000000800081b0 <devintr>:
    800081b0:	142027f3          	csrr	a5,scause
    800081b4:	00000513          	li	a0,0
    800081b8:	0007c463          	bltz	a5,800081c0 <devintr+0x10>
    800081bc:	00008067          	ret
    800081c0:	fe010113          	addi	sp,sp,-32
    800081c4:	00813823          	sd	s0,16(sp)
    800081c8:	00113c23          	sd	ra,24(sp)
    800081cc:	00913423          	sd	s1,8(sp)
    800081d0:	02010413          	addi	s0,sp,32
    800081d4:	0ff7f713          	andi	a4,a5,255
    800081d8:	00900693          	li	a3,9
    800081dc:	04d70c63          	beq	a4,a3,80008234 <devintr+0x84>
    800081e0:	fff00713          	li	a4,-1
    800081e4:	03f71713          	slli	a4,a4,0x3f
    800081e8:	00170713          	addi	a4,a4,1
    800081ec:	00e78c63          	beq	a5,a4,80008204 <devintr+0x54>
    800081f0:	01813083          	ld	ra,24(sp)
    800081f4:	01013403          	ld	s0,16(sp)
    800081f8:	00813483          	ld	s1,8(sp)
    800081fc:	02010113          	addi	sp,sp,32
    80008200:	00008067          	ret
    80008204:	00000097          	auipc	ra,0x0
    80008208:	c8c080e7          	jalr	-884(ra) # 80007e90 <cpuid>
    8000820c:	06050663          	beqz	a0,80008278 <devintr+0xc8>
    80008210:	144027f3          	csrr	a5,sip
    80008214:	ffd7f793          	andi	a5,a5,-3
    80008218:	14479073          	csrw	sip,a5
    8000821c:	01813083          	ld	ra,24(sp)
    80008220:	01013403          	ld	s0,16(sp)
    80008224:	00813483          	ld	s1,8(sp)
    80008228:	00200513          	li	a0,2
    8000822c:	02010113          	addi	sp,sp,32
    80008230:	00008067          	ret
    80008234:	00000097          	auipc	ra,0x0
    80008238:	250080e7          	jalr	592(ra) # 80008484 <plic_claim>
    8000823c:	00a00793          	li	a5,10
    80008240:	00050493          	mv	s1,a0
    80008244:	06f50663          	beq	a0,a5,800082b0 <devintr+0x100>
    80008248:	00100513          	li	a0,1
    8000824c:	fa0482e3          	beqz	s1,800081f0 <devintr+0x40>
    80008250:	00048593          	mv	a1,s1
    80008254:	00002517          	auipc	a0,0x2
    80008258:	55c50513          	addi	a0,a0,1372 # 8000a7b0 <CONSOLE_STATUS+0x7a0>
    8000825c:	00000097          	auipc	ra,0x0
    80008260:	66c080e7          	jalr	1644(ra) # 800088c8 <__printf>
    80008264:	00048513          	mv	a0,s1
    80008268:	00000097          	auipc	ra,0x0
    8000826c:	254080e7          	jalr	596(ra) # 800084bc <plic_complete>
    80008270:	00100513          	li	a0,1
    80008274:	f7dff06f          	j	800081f0 <devintr+0x40>
    80008278:	00006517          	auipc	a0,0x6
    8000827c:	db850513          	addi	a0,a0,-584 # 8000e030 <tickslock>
    80008280:	00001097          	auipc	ra,0x1
    80008284:	31c080e7          	jalr	796(ra) # 8000959c <acquire>
    80008288:	00005717          	auipc	a4,0x5
    8000828c:	bfc70713          	addi	a4,a4,-1028 # 8000ce84 <ticks>
    80008290:	00072783          	lw	a5,0(a4)
    80008294:	00006517          	auipc	a0,0x6
    80008298:	d9c50513          	addi	a0,a0,-612 # 8000e030 <tickslock>
    8000829c:	0017879b          	addiw	a5,a5,1
    800082a0:	00f72023          	sw	a5,0(a4)
    800082a4:	00001097          	auipc	ra,0x1
    800082a8:	3c4080e7          	jalr	964(ra) # 80009668 <release>
    800082ac:	f65ff06f          	j	80008210 <devintr+0x60>
    800082b0:	00001097          	auipc	ra,0x1
    800082b4:	f20080e7          	jalr	-224(ra) # 800091d0 <uartintr>
    800082b8:	fadff06f          	j	80008264 <devintr+0xb4>
    800082bc:	0000                	unimp
	...

00000000800082c0 <kernelvec>:
    800082c0:	f0010113          	addi	sp,sp,-256
    800082c4:	00113023          	sd	ra,0(sp)
    800082c8:	00213423          	sd	sp,8(sp)
    800082cc:	00313823          	sd	gp,16(sp)
    800082d0:	00413c23          	sd	tp,24(sp)
    800082d4:	02513023          	sd	t0,32(sp)
    800082d8:	02613423          	sd	t1,40(sp)
    800082dc:	02713823          	sd	t2,48(sp)
    800082e0:	02813c23          	sd	s0,56(sp)
    800082e4:	04913023          	sd	s1,64(sp)
    800082e8:	04a13423          	sd	a0,72(sp)
    800082ec:	04b13823          	sd	a1,80(sp)
    800082f0:	04c13c23          	sd	a2,88(sp)
    800082f4:	06d13023          	sd	a3,96(sp)
    800082f8:	06e13423          	sd	a4,104(sp)
    800082fc:	06f13823          	sd	a5,112(sp)
    80008300:	07013c23          	sd	a6,120(sp)
    80008304:	09113023          	sd	a7,128(sp)
    80008308:	09213423          	sd	s2,136(sp)
    8000830c:	09313823          	sd	s3,144(sp)
    80008310:	09413c23          	sd	s4,152(sp)
    80008314:	0b513023          	sd	s5,160(sp)
    80008318:	0b613423          	sd	s6,168(sp)
    8000831c:	0b713823          	sd	s7,176(sp)
    80008320:	0b813c23          	sd	s8,184(sp)
    80008324:	0d913023          	sd	s9,192(sp)
    80008328:	0da13423          	sd	s10,200(sp)
    8000832c:	0db13823          	sd	s11,208(sp)
    80008330:	0dc13c23          	sd	t3,216(sp)
    80008334:	0fd13023          	sd	t4,224(sp)
    80008338:	0fe13423          	sd	t5,232(sp)
    8000833c:	0ff13823          	sd	t6,240(sp)
    80008340:	cd1ff0ef          	jal	ra,80008010 <kerneltrap>
    80008344:	00013083          	ld	ra,0(sp)
    80008348:	00813103          	ld	sp,8(sp)
    8000834c:	01013183          	ld	gp,16(sp)
    80008350:	02013283          	ld	t0,32(sp)
    80008354:	02813303          	ld	t1,40(sp)
    80008358:	03013383          	ld	t2,48(sp)
    8000835c:	03813403          	ld	s0,56(sp)
    80008360:	04013483          	ld	s1,64(sp)
    80008364:	04813503          	ld	a0,72(sp)
    80008368:	05013583          	ld	a1,80(sp)
    8000836c:	05813603          	ld	a2,88(sp)
    80008370:	06013683          	ld	a3,96(sp)
    80008374:	06813703          	ld	a4,104(sp)
    80008378:	07013783          	ld	a5,112(sp)
    8000837c:	07813803          	ld	a6,120(sp)
    80008380:	08013883          	ld	a7,128(sp)
    80008384:	08813903          	ld	s2,136(sp)
    80008388:	09013983          	ld	s3,144(sp)
    8000838c:	09813a03          	ld	s4,152(sp)
    80008390:	0a013a83          	ld	s5,160(sp)
    80008394:	0a813b03          	ld	s6,168(sp)
    80008398:	0b013b83          	ld	s7,176(sp)
    8000839c:	0b813c03          	ld	s8,184(sp)
    800083a0:	0c013c83          	ld	s9,192(sp)
    800083a4:	0c813d03          	ld	s10,200(sp)
    800083a8:	0d013d83          	ld	s11,208(sp)
    800083ac:	0d813e03          	ld	t3,216(sp)
    800083b0:	0e013e83          	ld	t4,224(sp)
    800083b4:	0e813f03          	ld	t5,232(sp)
    800083b8:	0f013f83          	ld	t6,240(sp)
    800083bc:	10010113          	addi	sp,sp,256
    800083c0:	10200073          	sret
    800083c4:	00000013          	nop
    800083c8:	00000013          	nop
    800083cc:	00000013          	nop

00000000800083d0 <timervec>:
    800083d0:	34051573          	csrrw	a0,mscratch,a0
    800083d4:	00b53023          	sd	a1,0(a0)
    800083d8:	00c53423          	sd	a2,8(a0)
    800083dc:	00d53823          	sd	a3,16(a0)
    800083e0:	01853583          	ld	a1,24(a0)
    800083e4:	02053603          	ld	a2,32(a0)
    800083e8:	0005b683          	ld	a3,0(a1)
    800083ec:	00c686b3          	add	a3,a3,a2
    800083f0:	00d5b023          	sd	a3,0(a1)
    800083f4:	00200593          	li	a1,2
    800083f8:	14459073          	csrw	sip,a1
    800083fc:	01053683          	ld	a3,16(a0)
    80008400:	00853603          	ld	a2,8(a0)
    80008404:	00053583          	ld	a1,0(a0)
    80008408:	34051573          	csrrw	a0,mscratch,a0
    8000840c:	30200073          	mret

0000000080008410 <plicinit>:
    80008410:	ff010113          	addi	sp,sp,-16
    80008414:	00813423          	sd	s0,8(sp)
    80008418:	01010413          	addi	s0,sp,16
    8000841c:	00813403          	ld	s0,8(sp)
    80008420:	0c0007b7          	lui	a5,0xc000
    80008424:	00100713          	li	a4,1
    80008428:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
    8000842c:	00e7a223          	sw	a4,4(a5)
    80008430:	01010113          	addi	sp,sp,16
    80008434:	00008067          	ret

0000000080008438 <plicinithart>:
    80008438:	ff010113          	addi	sp,sp,-16
    8000843c:	00813023          	sd	s0,0(sp)
    80008440:	00113423          	sd	ra,8(sp)
    80008444:	01010413          	addi	s0,sp,16
    80008448:	00000097          	auipc	ra,0x0
    8000844c:	a48080e7          	jalr	-1464(ra) # 80007e90 <cpuid>
    80008450:	0085171b          	slliw	a4,a0,0x8
    80008454:	0c0027b7          	lui	a5,0xc002
    80008458:	00e787b3          	add	a5,a5,a4
    8000845c:	40200713          	li	a4,1026
    80008460:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80008464:	00813083          	ld	ra,8(sp)
    80008468:	00013403          	ld	s0,0(sp)
    8000846c:	00d5151b          	slliw	a0,a0,0xd
    80008470:	0c2017b7          	lui	a5,0xc201
    80008474:	00a78533          	add	a0,a5,a0
    80008478:	00052023          	sw	zero,0(a0)
    8000847c:	01010113          	addi	sp,sp,16
    80008480:	00008067          	ret

0000000080008484 <plic_claim>:
    80008484:	ff010113          	addi	sp,sp,-16
    80008488:	00813023          	sd	s0,0(sp)
    8000848c:	00113423          	sd	ra,8(sp)
    80008490:	01010413          	addi	s0,sp,16
    80008494:	00000097          	auipc	ra,0x0
    80008498:	9fc080e7          	jalr	-1540(ra) # 80007e90 <cpuid>
    8000849c:	00813083          	ld	ra,8(sp)
    800084a0:	00013403          	ld	s0,0(sp)
    800084a4:	00d5151b          	slliw	a0,a0,0xd
    800084a8:	0c2017b7          	lui	a5,0xc201
    800084ac:	00a78533          	add	a0,a5,a0
    800084b0:	00452503          	lw	a0,4(a0)
    800084b4:	01010113          	addi	sp,sp,16
    800084b8:	00008067          	ret

00000000800084bc <plic_complete>:
    800084bc:	fe010113          	addi	sp,sp,-32
    800084c0:	00813823          	sd	s0,16(sp)
    800084c4:	00913423          	sd	s1,8(sp)
    800084c8:	00113c23          	sd	ra,24(sp)
    800084cc:	02010413          	addi	s0,sp,32
    800084d0:	00050493          	mv	s1,a0
    800084d4:	00000097          	auipc	ra,0x0
    800084d8:	9bc080e7          	jalr	-1604(ra) # 80007e90 <cpuid>
    800084dc:	01813083          	ld	ra,24(sp)
    800084e0:	01013403          	ld	s0,16(sp)
    800084e4:	00d5179b          	slliw	a5,a0,0xd
    800084e8:	0c201737          	lui	a4,0xc201
    800084ec:	00f707b3          	add	a5,a4,a5
    800084f0:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
    800084f4:	00813483          	ld	s1,8(sp)
    800084f8:	02010113          	addi	sp,sp,32
    800084fc:	00008067          	ret

0000000080008500 <consolewrite>:
    80008500:	fb010113          	addi	sp,sp,-80
    80008504:	04813023          	sd	s0,64(sp)
    80008508:	04113423          	sd	ra,72(sp)
    8000850c:	02913c23          	sd	s1,56(sp)
    80008510:	03213823          	sd	s2,48(sp)
    80008514:	03313423          	sd	s3,40(sp)
    80008518:	03413023          	sd	s4,32(sp)
    8000851c:	01513c23          	sd	s5,24(sp)
    80008520:	05010413          	addi	s0,sp,80
    80008524:	06c05c63          	blez	a2,8000859c <consolewrite+0x9c>
    80008528:	00060993          	mv	s3,a2
    8000852c:	00050a13          	mv	s4,a0
    80008530:	00058493          	mv	s1,a1
    80008534:	00000913          	li	s2,0
    80008538:	fff00a93          	li	s5,-1
    8000853c:	01c0006f          	j	80008558 <consolewrite+0x58>
    80008540:	fbf44503          	lbu	a0,-65(s0)
    80008544:	0019091b          	addiw	s2,s2,1
    80008548:	00148493          	addi	s1,s1,1
    8000854c:	00001097          	auipc	ra,0x1
    80008550:	a9c080e7          	jalr	-1380(ra) # 80008fe8 <uartputc>
    80008554:	03298063          	beq	s3,s2,80008574 <consolewrite+0x74>
    80008558:	00048613          	mv	a2,s1
    8000855c:	00100693          	li	a3,1
    80008560:	000a0593          	mv	a1,s4
    80008564:	fbf40513          	addi	a0,s0,-65
    80008568:	00000097          	auipc	ra,0x0
    8000856c:	9e0080e7          	jalr	-1568(ra) # 80007f48 <either_copyin>
    80008570:	fd5518e3          	bne	a0,s5,80008540 <consolewrite+0x40>
    80008574:	04813083          	ld	ra,72(sp)
    80008578:	04013403          	ld	s0,64(sp)
    8000857c:	03813483          	ld	s1,56(sp)
    80008580:	02813983          	ld	s3,40(sp)
    80008584:	02013a03          	ld	s4,32(sp)
    80008588:	01813a83          	ld	s5,24(sp)
    8000858c:	00090513          	mv	a0,s2
    80008590:	03013903          	ld	s2,48(sp)
    80008594:	05010113          	addi	sp,sp,80
    80008598:	00008067          	ret
    8000859c:	00000913          	li	s2,0
    800085a0:	fd5ff06f          	j	80008574 <consolewrite+0x74>

00000000800085a4 <consoleread>:
    800085a4:	f9010113          	addi	sp,sp,-112
    800085a8:	06813023          	sd	s0,96(sp)
    800085ac:	04913c23          	sd	s1,88(sp)
    800085b0:	05213823          	sd	s2,80(sp)
    800085b4:	05313423          	sd	s3,72(sp)
    800085b8:	05413023          	sd	s4,64(sp)
    800085bc:	03513c23          	sd	s5,56(sp)
    800085c0:	03613823          	sd	s6,48(sp)
    800085c4:	03713423          	sd	s7,40(sp)
    800085c8:	03813023          	sd	s8,32(sp)
    800085cc:	06113423          	sd	ra,104(sp)
    800085d0:	01913c23          	sd	s9,24(sp)
    800085d4:	07010413          	addi	s0,sp,112
    800085d8:	00060b93          	mv	s7,a2
    800085dc:	00050913          	mv	s2,a0
    800085e0:	00058c13          	mv	s8,a1
    800085e4:	00060b1b          	sext.w	s6,a2
    800085e8:	00006497          	auipc	s1,0x6
    800085ec:	a7048493          	addi	s1,s1,-1424 # 8000e058 <cons>
    800085f0:	00400993          	li	s3,4
    800085f4:	fff00a13          	li	s4,-1
    800085f8:	00a00a93          	li	s5,10
    800085fc:	05705e63          	blez	s7,80008658 <consoleread+0xb4>
    80008600:	09c4a703          	lw	a4,156(s1)
    80008604:	0984a783          	lw	a5,152(s1)
    80008608:	0007071b          	sext.w	a4,a4
    8000860c:	08e78463          	beq	a5,a4,80008694 <consoleread+0xf0>
    80008610:	07f7f713          	andi	a4,a5,127
    80008614:	00e48733          	add	a4,s1,a4
    80008618:	01874703          	lbu	a4,24(a4) # c201018 <_entry-0x73dfefe8>
    8000861c:	0017869b          	addiw	a3,a5,1
    80008620:	08d4ac23          	sw	a3,152(s1)
    80008624:	00070c9b          	sext.w	s9,a4
    80008628:	0b370663          	beq	a4,s3,800086d4 <consoleread+0x130>
    8000862c:	00100693          	li	a3,1
    80008630:	f9f40613          	addi	a2,s0,-97
    80008634:	000c0593          	mv	a1,s8
    80008638:	00090513          	mv	a0,s2
    8000863c:	f8e40fa3          	sb	a4,-97(s0)
    80008640:	00000097          	auipc	ra,0x0
    80008644:	8bc080e7          	jalr	-1860(ra) # 80007efc <either_copyout>
    80008648:	01450863          	beq	a0,s4,80008658 <consoleread+0xb4>
    8000864c:	001c0c13          	addi	s8,s8,1
    80008650:	fffb8b9b          	addiw	s7,s7,-1
    80008654:	fb5c94e3          	bne	s9,s5,800085fc <consoleread+0x58>
    80008658:	000b851b          	sext.w	a0,s7
    8000865c:	06813083          	ld	ra,104(sp)
    80008660:	06013403          	ld	s0,96(sp)
    80008664:	05813483          	ld	s1,88(sp)
    80008668:	05013903          	ld	s2,80(sp)
    8000866c:	04813983          	ld	s3,72(sp)
    80008670:	04013a03          	ld	s4,64(sp)
    80008674:	03813a83          	ld	s5,56(sp)
    80008678:	02813b83          	ld	s7,40(sp)
    8000867c:	02013c03          	ld	s8,32(sp)
    80008680:	01813c83          	ld	s9,24(sp)
    80008684:	40ab053b          	subw	a0,s6,a0
    80008688:	03013b03          	ld	s6,48(sp)
    8000868c:	07010113          	addi	sp,sp,112
    80008690:	00008067          	ret
    80008694:	00001097          	auipc	ra,0x1
    80008698:	1d8080e7          	jalr	472(ra) # 8000986c <push_on>
    8000869c:	0984a703          	lw	a4,152(s1)
    800086a0:	09c4a783          	lw	a5,156(s1)
    800086a4:	0007879b          	sext.w	a5,a5
    800086a8:	fef70ce3          	beq	a4,a5,800086a0 <consoleread+0xfc>
    800086ac:	00001097          	auipc	ra,0x1
    800086b0:	234080e7          	jalr	564(ra) # 800098e0 <pop_on>
    800086b4:	0984a783          	lw	a5,152(s1)
    800086b8:	07f7f713          	andi	a4,a5,127
    800086bc:	00e48733          	add	a4,s1,a4
    800086c0:	01874703          	lbu	a4,24(a4)
    800086c4:	0017869b          	addiw	a3,a5,1
    800086c8:	08d4ac23          	sw	a3,152(s1)
    800086cc:	00070c9b          	sext.w	s9,a4
    800086d0:	f5371ee3          	bne	a4,s3,8000862c <consoleread+0x88>
    800086d4:	000b851b          	sext.w	a0,s7
    800086d8:	f96bf2e3          	bgeu	s7,s6,8000865c <consoleread+0xb8>
    800086dc:	08f4ac23          	sw	a5,152(s1)
    800086e0:	f7dff06f          	j	8000865c <consoleread+0xb8>

00000000800086e4 <consputc>:
    800086e4:	10000793          	li	a5,256
    800086e8:	00f50663          	beq	a0,a5,800086f4 <consputc+0x10>
    800086ec:	00001317          	auipc	t1,0x1
    800086f0:	9f430067          	jr	-1548(t1) # 800090e0 <uartputc_sync>
    800086f4:	ff010113          	addi	sp,sp,-16
    800086f8:	00113423          	sd	ra,8(sp)
    800086fc:	00813023          	sd	s0,0(sp)
    80008700:	01010413          	addi	s0,sp,16
    80008704:	00800513          	li	a0,8
    80008708:	00001097          	auipc	ra,0x1
    8000870c:	9d8080e7          	jalr	-1576(ra) # 800090e0 <uartputc_sync>
    80008710:	02000513          	li	a0,32
    80008714:	00001097          	auipc	ra,0x1
    80008718:	9cc080e7          	jalr	-1588(ra) # 800090e0 <uartputc_sync>
    8000871c:	00013403          	ld	s0,0(sp)
    80008720:	00813083          	ld	ra,8(sp)
    80008724:	00800513          	li	a0,8
    80008728:	01010113          	addi	sp,sp,16
    8000872c:	00001317          	auipc	t1,0x1
    80008730:	9b430067          	jr	-1612(t1) # 800090e0 <uartputc_sync>

0000000080008734 <consoleintr>:
    80008734:	fe010113          	addi	sp,sp,-32
    80008738:	00813823          	sd	s0,16(sp)
    8000873c:	00913423          	sd	s1,8(sp)
    80008740:	01213023          	sd	s2,0(sp)
    80008744:	00113c23          	sd	ra,24(sp)
    80008748:	02010413          	addi	s0,sp,32
    8000874c:	00006917          	auipc	s2,0x6
    80008750:	90c90913          	addi	s2,s2,-1780 # 8000e058 <cons>
    80008754:	00050493          	mv	s1,a0
    80008758:	00090513          	mv	a0,s2
    8000875c:	00001097          	auipc	ra,0x1
    80008760:	e40080e7          	jalr	-448(ra) # 8000959c <acquire>
    80008764:	02048c63          	beqz	s1,8000879c <consoleintr+0x68>
    80008768:	0a092783          	lw	a5,160(s2)
    8000876c:	09892703          	lw	a4,152(s2)
    80008770:	07f00693          	li	a3,127
    80008774:	40e7873b          	subw	a4,a5,a4
    80008778:	02e6e263          	bltu	a3,a4,8000879c <consoleintr+0x68>
    8000877c:	00d00713          	li	a4,13
    80008780:	04e48063          	beq	s1,a4,800087c0 <consoleintr+0x8c>
    80008784:	07f7f713          	andi	a4,a5,127
    80008788:	00e90733          	add	a4,s2,a4
    8000878c:	0017879b          	addiw	a5,a5,1
    80008790:	0af92023          	sw	a5,160(s2)
    80008794:	00970c23          	sb	s1,24(a4)
    80008798:	08f92e23          	sw	a5,156(s2)
    8000879c:	01013403          	ld	s0,16(sp)
    800087a0:	01813083          	ld	ra,24(sp)
    800087a4:	00813483          	ld	s1,8(sp)
    800087a8:	00013903          	ld	s2,0(sp)
    800087ac:	00006517          	auipc	a0,0x6
    800087b0:	8ac50513          	addi	a0,a0,-1876 # 8000e058 <cons>
    800087b4:	02010113          	addi	sp,sp,32
    800087b8:	00001317          	auipc	t1,0x1
    800087bc:	eb030067          	jr	-336(t1) # 80009668 <release>
    800087c0:	00a00493          	li	s1,10
    800087c4:	fc1ff06f          	j	80008784 <consoleintr+0x50>

00000000800087c8 <consoleinit>:
    800087c8:	fe010113          	addi	sp,sp,-32
    800087cc:	00113c23          	sd	ra,24(sp)
    800087d0:	00813823          	sd	s0,16(sp)
    800087d4:	00913423          	sd	s1,8(sp)
    800087d8:	02010413          	addi	s0,sp,32
    800087dc:	00006497          	auipc	s1,0x6
    800087e0:	87c48493          	addi	s1,s1,-1924 # 8000e058 <cons>
    800087e4:	00048513          	mv	a0,s1
    800087e8:	00002597          	auipc	a1,0x2
    800087ec:	02058593          	addi	a1,a1,32 # 8000a808 <CONSOLE_STATUS+0x7f8>
    800087f0:	00001097          	auipc	ra,0x1
    800087f4:	d88080e7          	jalr	-632(ra) # 80009578 <initlock>
    800087f8:	00000097          	auipc	ra,0x0
    800087fc:	7ac080e7          	jalr	1964(ra) # 80008fa4 <uartinit>
    80008800:	01813083          	ld	ra,24(sp)
    80008804:	01013403          	ld	s0,16(sp)
    80008808:	00000797          	auipc	a5,0x0
    8000880c:	d9c78793          	addi	a5,a5,-612 # 800085a4 <consoleread>
    80008810:	0af4bc23          	sd	a5,184(s1)
    80008814:	00000797          	auipc	a5,0x0
    80008818:	cec78793          	addi	a5,a5,-788 # 80008500 <consolewrite>
    8000881c:	0cf4b023          	sd	a5,192(s1)
    80008820:	00813483          	ld	s1,8(sp)
    80008824:	02010113          	addi	sp,sp,32
    80008828:	00008067          	ret

000000008000882c <console_read>:
    8000882c:	ff010113          	addi	sp,sp,-16
    80008830:	00813423          	sd	s0,8(sp)
    80008834:	01010413          	addi	s0,sp,16
    80008838:	00813403          	ld	s0,8(sp)
    8000883c:	00006317          	auipc	t1,0x6
    80008840:	8d433303          	ld	t1,-1836(t1) # 8000e110 <devsw+0x10>
    80008844:	01010113          	addi	sp,sp,16
    80008848:	00030067          	jr	t1

000000008000884c <console_write>:
    8000884c:	ff010113          	addi	sp,sp,-16
    80008850:	00813423          	sd	s0,8(sp)
    80008854:	01010413          	addi	s0,sp,16
    80008858:	00813403          	ld	s0,8(sp)
    8000885c:	00006317          	auipc	t1,0x6
    80008860:	8bc33303          	ld	t1,-1860(t1) # 8000e118 <devsw+0x18>
    80008864:	01010113          	addi	sp,sp,16
    80008868:	00030067          	jr	t1

000000008000886c <panic>:
    8000886c:	fe010113          	addi	sp,sp,-32
    80008870:	00113c23          	sd	ra,24(sp)
    80008874:	00813823          	sd	s0,16(sp)
    80008878:	00913423          	sd	s1,8(sp)
    8000887c:	02010413          	addi	s0,sp,32
    80008880:	00050493          	mv	s1,a0
    80008884:	00002517          	auipc	a0,0x2
    80008888:	f8c50513          	addi	a0,a0,-116 # 8000a810 <CONSOLE_STATUS+0x800>
    8000888c:	00006797          	auipc	a5,0x6
    80008890:	9207a623          	sw	zero,-1748(a5) # 8000e1b8 <pr+0x18>
    80008894:	00000097          	auipc	ra,0x0
    80008898:	034080e7          	jalr	52(ra) # 800088c8 <__printf>
    8000889c:	00048513          	mv	a0,s1
    800088a0:	00000097          	auipc	ra,0x0
    800088a4:	028080e7          	jalr	40(ra) # 800088c8 <__printf>
    800088a8:	00002517          	auipc	a0,0x2
    800088ac:	aa850513          	addi	a0,a0,-1368 # 8000a350 <CONSOLE_STATUS+0x340>
    800088b0:	00000097          	auipc	ra,0x0
    800088b4:	018080e7          	jalr	24(ra) # 800088c8 <__printf>
    800088b8:	00100793          	li	a5,1
    800088bc:	00004717          	auipc	a4,0x4
    800088c0:	5cf72623          	sw	a5,1484(a4) # 8000ce88 <panicked>
    800088c4:	0000006f          	j	800088c4 <panic+0x58>

00000000800088c8 <__printf>:
    800088c8:	f3010113          	addi	sp,sp,-208
    800088cc:	08813023          	sd	s0,128(sp)
    800088d0:	07313423          	sd	s3,104(sp)
    800088d4:	09010413          	addi	s0,sp,144
    800088d8:	05813023          	sd	s8,64(sp)
    800088dc:	08113423          	sd	ra,136(sp)
    800088e0:	06913c23          	sd	s1,120(sp)
    800088e4:	07213823          	sd	s2,112(sp)
    800088e8:	07413023          	sd	s4,96(sp)
    800088ec:	05513c23          	sd	s5,88(sp)
    800088f0:	05613823          	sd	s6,80(sp)
    800088f4:	05713423          	sd	s7,72(sp)
    800088f8:	03913c23          	sd	s9,56(sp)
    800088fc:	03a13823          	sd	s10,48(sp)
    80008900:	03b13423          	sd	s11,40(sp)
    80008904:	00006317          	auipc	t1,0x6
    80008908:	89c30313          	addi	t1,t1,-1892 # 8000e1a0 <pr>
    8000890c:	01832c03          	lw	s8,24(t1)
    80008910:	00b43423          	sd	a1,8(s0)
    80008914:	00c43823          	sd	a2,16(s0)
    80008918:	00d43c23          	sd	a3,24(s0)
    8000891c:	02e43023          	sd	a4,32(s0)
    80008920:	02f43423          	sd	a5,40(s0)
    80008924:	03043823          	sd	a6,48(s0)
    80008928:	03143c23          	sd	a7,56(s0)
    8000892c:	00050993          	mv	s3,a0
    80008930:	4a0c1663          	bnez	s8,80008ddc <__printf+0x514>
    80008934:	60098c63          	beqz	s3,80008f4c <__printf+0x684>
    80008938:	0009c503          	lbu	a0,0(s3)
    8000893c:	00840793          	addi	a5,s0,8
    80008940:	f6f43c23          	sd	a5,-136(s0)
    80008944:	00000493          	li	s1,0
    80008948:	22050063          	beqz	a0,80008b68 <__printf+0x2a0>
    8000894c:	00002a37          	lui	s4,0x2
    80008950:	00018ab7          	lui	s5,0x18
    80008954:	000f4b37          	lui	s6,0xf4
    80008958:	00989bb7          	lui	s7,0x989
    8000895c:	70fa0a13          	addi	s4,s4,1807 # 270f <_entry-0x7fffd8f1>
    80008960:	69fa8a93          	addi	s5,s5,1695 # 1869f <_entry-0x7ffe7961>
    80008964:	23fb0b13          	addi	s6,s6,575 # f423f <_entry-0x7ff0bdc1>
    80008968:	67fb8b93          	addi	s7,s7,1663 # 98967f <_entry-0x7f676981>
    8000896c:	00148c9b          	addiw	s9,s1,1
    80008970:	02500793          	li	a5,37
    80008974:	01998933          	add	s2,s3,s9
    80008978:	38f51263          	bne	a0,a5,80008cfc <__printf+0x434>
    8000897c:	00094783          	lbu	a5,0(s2)
    80008980:	00078c9b          	sext.w	s9,a5
    80008984:	1e078263          	beqz	a5,80008b68 <__printf+0x2a0>
    80008988:	0024849b          	addiw	s1,s1,2
    8000898c:	07000713          	li	a4,112
    80008990:	00998933          	add	s2,s3,s1
    80008994:	38e78a63          	beq	a5,a4,80008d28 <__printf+0x460>
    80008998:	20f76863          	bltu	a4,a5,80008ba8 <__printf+0x2e0>
    8000899c:	42a78863          	beq	a5,a0,80008dcc <__printf+0x504>
    800089a0:	06400713          	li	a4,100
    800089a4:	40e79663          	bne	a5,a4,80008db0 <__printf+0x4e8>
    800089a8:	f7843783          	ld	a5,-136(s0)
    800089ac:	0007a603          	lw	a2,0(a5)
    800089b0:	00878793          	addi	a5,a5,8
    800089b4:	f6f43c23          	sd	a5,-136(s0)
    800089b8:	42064a63          	bltz	a2,80008dec <__printf+0x524>
    800089bc:	00a00713          	li	a4,10
    800089c0:	02e677bb          	remuw	a5,a2,a4
    800089c4:	00002d97          	auipc	s11,0x2
    800089c8:	e74d8d93          	addi	s11,s11,-396 # 8000a838 <digits>
    800089cc:	00900593          	li	a1,9
    800089d0:	0006051b          	sext.w	a0,a2
    800089d4:	00000c93          	li	s9,0
    800089d8:	02079793          	slli	a5,a5,0x20
    800089dc:	0207d793          	srli	a5,a5,0x20
    800089e0:	00fd87b3          	add	a5,s11,a5
    800089e4:	0007c783          	lbu	a5,0(a5)
    800089e8:	02e656bb          	divuw	a3,a2,a4
    800089ec:	f8f40023          	sb	a5,-128(s0)
    800089f0:	14c5d863          	bge	a1,a2,80008b40 <__printf+0x278>
    800089f4:	06300593          	li	a1,99
    800089f8:	00100c93          	li	s9,1
    800089fc:	02e6f7bb          	remuw	a5,a3,a4
    80008a00:	02079793          	slli	a5,a5,0x20
    80008a04:	0207d793          	srli	a5,a5,0x20
    80008a08:	00fd87b3          	add	a5,s11,a5
    80008a0c:	0007c783          	lbu	a5,0(a5)
    80008a10:	02e6d73b          	divuw	a4,a3,a4
    80008a14:	f8f400a3          	sb	a5,-127(s0)
    80008a18:	12a5f463          	bgeu	a1,a0,80008b40 <__printf+0x278>
    80008a1c:	00a00693          	li	a3,10
    80008a20:	00900593          	li	a1,9
    80008a24:	02d777bb          	remuw	a5,a4,a3
    80008a28:	02079793          	slli	a5,a5,0x20
    80008a2c:	0207d793          	srli	a5,a5,0x20
    80008a30:	00fd87b3          	add	a5,s11,a5
    80008a34:	0007c503          	lbu	a0,0(a5)
    80008a38:	02d757bb          	divuw	a5,a4,a3
    80008a3c:	f8a40123          	sb	a0,-126(s0)
    80008a40:	48e5f263          	bgeu	a1,a4,80008ec4 <__printf+0x5fc>
    80008a44:	06300513          	li	a0,99
    80008a48:	02d7f5bb          	remuw	a1,a5,a3
    80008a4c:	02059593          	slli	a1,a1,0x20
    80008a50:	0205d593          	srli	a1,a1,0x20
    80008a54:	00bd85b3          	add	a1,s11,a1
    80008a58:	0005c583          	lbu	a1,0(a1)
    80008a5c:	02d7d7bb          	divuw	a5,a5,a3
    80008a60:	f8b401a3          	sb	a1,-125(s0)
    80008a64:	48e57263          	bgeu	a0,a4,80008ee8 <__printf+0x620>
    80008a68:	3e700513          	li	a0,999
    80008a6c:	02d7f5bb          	remuw	a1,a5,a3
    80008a70:	02059593          	slli	a1,a1,0x20
    80008a74:	0205d593          	srli	a1,a1,0x20
    80008a78:	00bd85b3          	add	a1,s11,a1
    80008a7c:	0005c583          	lbu	a1,0(a1)
    80008a80:	02d7d7bb          	divuw	a5,a5,a3
    80008a84:	f8b40223          	sb	a1,-124(s0)
    80008a88:	46e57663          	bgeu	a0,a4,80008ef4 <__printf+0x62c>
    80008a8c:	02d7f5bb          	remuw	a1,a5,a3
    80008a90:	02059593          	slli	a1,a1,0x20
    80008a94:	0205d593          	srli	a1,a1,0x20
    80008a98:	00bd85b3          	add	a1,s11,a1
    80008a9c:	0005c583          	lbu	a1,0(a1)
    80008aa0:	02d7d7bb          	divuw	a5,a5,a3
    80008aa4:	f8b402a3          	sb	a1,-123(s0)
    80008aa8:	46ea7863          	bgeu	s4,a4,80008f18 <__printf+0x650>
    80008aac:	02d7f5bb          	remuw	a1,a5,a3
    80008ab0:	02059593          	slli	a1,a1,0x20
    80008ab4:	0205d593          	srli	a1,a1,0x20
    80008ab8:	00bd85b3          	add	a1,s11,a1
    80008abc:	0005c583          	lbu	a1,0(a1)
    80008ac0:	02d7d7bb          	divuw	a5,a5,a3
    80008ac4:	f8b40323          	sb	a1,-122(s0)
    80008ac8:	3eeaf863          	bgeu	s5,a4,80008eb8 <__printf+0x5f0>
    80008acc:	02d7f5bb          	remuw	a1,a5,a3
    80008ad0:	02059593          	slli	a1,a1,0x20
    80008ad4:	0205d593          	srli	a1,a1,0x20
    80008ad8:	00bd85b3          	add	a1,s11,a1
    80008adc:	0005c583          	lbu	a1,0(a1)
    80008ae0:	02d7d7bb          	divuw	a5,a5,a3
    80008ae4:	f8b403a3          	sb	a1,-121(s0)
    80008ae8:	42eb7e63          	bgeu	s6,a4,80008f24 <__printf+0x65c>
    80008aec:	02d7f5bb          	remuw	a1,a5,a3
    80008af0:	02059593          	slli	a1,a1,0x20
    80008af4:	0205d593          	srli	a1,a1,0x20
    80008af8:	00bd85b3          	add	a1,s11,a1
    80008afc:	0005c583          	lbu	a1,0(a1)
    80008b00:	02d7d7bb          	divuw	a5,a5,a3
    80008b04:	f8b40423          	sb	a1,-120(s0)
    80008b08:	42ebfc63          	bgeu	s7,a4,80008f40 <__printf+0x678>
    80008b0c:	02079793          	slli	a5,a5,0x20
    80008b10:	0207d793          	srli	a5,a5,0x20
    80008b14:	00fd8db3          	add	s11,s11,a5
    80008b18:	000dc703          	lbu	a4,0(s11)
    80008b1c:	00a00793          	li	a5,10
    80008b20:	00900c93          	li	s9,9
    80008b24:	f8e404a3          	sb	a4,-119(s0)
    80008b28:	00065c63          	bgez	a2,80008b40 <__printf+0x278>
    80008b2c:	f9040713          	addi	a4,s0,-112
    80008b30:	00f70733          	add	a4,a4,a5
    80008b34:	02d00693          	li	a3,45
    80008b38:	fed70823          	sb	a3,-16(a4)
    80008b3c:	00078c93          	mv	s9,a5
    80008b40:	f8040793          	addi	a5,s0,-128
    80008b44:	01978cb3          	add	s9,a5,s9
    80008b48:	f7f40d13          	addi	s10,s0,-129
    80008b4c:	000cc503          	lbu	a0,0(s9)
    80008b50:	fffc8c93          	addi	s9,s9,-1
    80008b54:	00000097          	auipc	ra,0x0
    80008b58:	b90080e7          	jalr	-1136(ra) # 800086e4 <consputc>
    80008b5c:	ffac98e3          	bne	s9,s10,80008b4c <__printf+0x284>
    80008b60:	00094503          	lbu	a0,0(s2)
    80008b64:	e00514e3          	bnez	a0,8000896c <__printf+0xa4>
    80008b68:	1a0c1663          	bnez	s8,80008d14 <__printf+0x44c>
    80008b6c:	08813083          	ld	ra,136(sp)
    80008b70:	08013403          	ld	s0,128(sp)
    80008b74:	07813483          	ld	s1,120(sp)
    80008b78:	07013903          	ld	s2,112(sp)
    80008b7c:	06813983          	ld	s3,104(sp)
    80008b80:	06013a03          	ld	s4,96(sp)
    80008b84:	05813a83          	ld	s5,88(sp)
    80008b88:	05013b03          	ld	s6,80(sp)
    80008b8c:	04813b83          	ld	s7,72(sp)
    80008b90:	04013c03          	ld	s8,64(sp)
    80008b94:	03813c83          	ld	s9,56(sp)
    80008b98:	03013d03          	ld	s10,48(sp)
    80008b9c:	02813d83          	ld	s11,40(sp)
    80008ba0:	0d010113          	addi	sp,sp,208
    80008ba4:	00008067          	ret
    80008ba8:	07300713          	li	a4,115
    80008bac:	1ce78a63          	beq	a5,a4,80008d80 <__printf+0x4b8>
    80008bb0:	07800713          	li	a4,120
    80008bb4:	1ee79e63          	bne	a5,a4,80008db0 <__printf+0x4e8>
    80008bb8:	f7843783          	ld	a5,-136(s0)
    80008bbc:	0007a703          	lw	a4,0(a5)
    80008bc0:	00878793          	addi	a5,a5,8
    80008bc4:	f6f43c23          	sd	a5,-136(s0)
    80008bc8:	28074263          	bltz	a4,80008e4c <__printf+0x584>
    80008bcc:	00002d97          	auipc	s11,0x2
    80008bd0:	c6cd8d93          	addi	s11,s11,-916 # 8000a838 <digits>
    80008bd4:	00f77793          	andi	a5,a4,15
    80008bd8:	00fd87b3          	add	a5,s11,a5
    80008bdc:	0007c683          	lbu	a3,0(a5)
    80008be0:	00f00613          	li	a2,15
    80008be4:	0007079b          	sext.w	a5,a4
    80008be8:	f8d40023          	sb	a3,-128(s0)
    80008bec:	0047559b          	srliw	a1,a4,0x4
    80008bf0:	0047569b          	srliw	a3,a4,0x4
    80008bf4:	00000c93          	li	s9,0
    80008bf8:	0ee65063          	bge	a2,a4,80008cd8 <__printf+0x410>
    80008bfc:	00f6f693          	andi	a3,a3,15
    80008c00:	00dd86b3          	add	a3,s11,a3
    80008c04:	0006c683          	lbu	a3,0(a3) # 2004000 <_entry-0x7dffc000>
    80008c08:	0087d79b          	srliw	a5,a5,0x8
    80008c0c:	00100c93          	li	s9,1
    80008c10:	f8d400a3          	sb	a3,-127(s0)
    80008c14:	0cb67263          	bgeu	a2,a1,80008cd8 <__printf+0x410>
    80008c18:	00f7f693          	andi	a3,a5,15
    80008c1c:	00dd86b3          	add	a3,s11,a3
    80008c20:	0006c583          	lbu	a1,0(a3)
    80008c24:	00f00613          	li	a2,15
    80008c28:	0047d69b          	srliw	a3,a5,0x4
    80008c2c:	f8b40123          	sb	a1,-126(s0)
    80008c30:	0047d593          	srli	a1,a5,0x4
    80008c34:	28f67e63          	bgeu	a2,a5,80008ed0 <__printf+0x608>
    80008c38:	00f6f693          	andi	a3,a3,15
    80008c3c:	00dd86b3          	add	a3,s11,a3
    80008c40:	0006c503          	lbu	a0,0(a3)
    80008c44:	0087d813          	srli	a6,a5,0x8
    80008c48:	0087d69b          	srliw	a3,a5,0x8
    80008c4c:	f8a401a3          	sb	a0,-125(s0)
    80008c50:	28b67663          	bgeu	a2,a1,80008edc <__printf+0x614>
    80008c54:	00f6f693          	andi	a3,a3,15
    80008c58:	00dd86b3          	add	a3,s11,a3
    80008c5c:	0006c583          	lbu	a1,0(a3)
    80008c60:	00c7d513          	srli	a0,a5,0xc
    80008c64:	00c7d69b          	srliw	a3,a5,0xc
    80008c68:	f8b40223          	sb	a1,-124(s0)
    80008c6c:	29067a63          	bgeu	a2,a6,80008f00 <__printf+0x638>
    80008c70:	00f6f693          	andi	a3,a3,15
    80008c74:	00dd86b3          	add	a3,s11,a3
    80008c78:	0006c583          	lbu	a1,0(a3)
    80008c7c:	0107d813          	srli	a6,a5,0x10
    80008c80:	0107d69b          	srliw	a3,a5,0x10
    80008c84:	f8b402a3          	sb	a1,-123(s0)
    80008c88:	28a67263          	bgeu	a2,a0,80008f0c <__printf+0x644>
    80008c8c:	00f6f693          	andi	a3,a3,15
    80008c90:	00dd86b3          	add	a3,s11,a3
    80008c94:	0006c683          	lbu	a3,0(a3)
    80008c98:	0147d79b          	srliw	a5,a5,0x14
    80008c9c:	f8d40323          	sb	a3,-122(s0)
    80008ca0:	21067663          	bgeu	a2,a6,80008eac <__printf+0x5e4>
    80008ca4:	02079793          	slli	a5,a5,0x20
    80008ca8:	0207d793          	srli	a5,a5,0x20
    80008cac:	00fd8db3          	add	s11,s11,a5
    80008cb0:	000dc683          	lbu	a3,0(s11)
    80008cb4:	00800793          	li	a5,8
    80008cb8:	00700c93          	li	s9,7
    80008cbc:	f8d403a3          	sb	a3,-121(s0)
    80008cc0:	00075c63          	bgez	a4,80008cd8 <__printf+0x410>
    80008cc4:	f9040713          	addi	a4,s0,-112
    80008cc8:	00f70733          	add	a4,a4,a5
    80008ccc:	02d00693          	li	a3,45
    80008cd0:	fed70823          	sb	a3,-16(a4)
    80008cd4:	00078c93          	mv	s9,a5
    80008cd8:	f8040793          	addi	a5,s0,-128
    80008cdc:	01978cb3          	add	s9,a5,s9
    80008ce0:	f7f40d13          	addi	s10,s0,-129
    80008ce4:	000cc503          	lbu	a0,0(s9)
    80008ce8:	fffc8c93          	addi	s9,s9,-1
    80008cec:	00000097          	auipc	ra,0x0
    80008cf0:	9f8080e7          	jalr	-1544(ra) # 800086e4 <consputc>
    80008cf4:	ff9d18e3          	bne	s10,s9,80008ce4 <__printf+0x41c>
    80008cf8:	0100006f          	j	80008d08 <__printf+0x440>
    80008cfc:	00000097          	auipc	ra,0x0
    80008d00:	9e8080e7          	jalr	-1560(ra) # 800086e4 <consputc>
    80008d04:	000c8493          	mv	s1,s9
    80008d08:	00094503          	lbu	a0,0(s2)
    80008d0c:	c60510e3          	bnez	a0,8000896c <__printf+0xa4>
    80008d10:	e40c0ee3          	beqz	s8,80008b6c <__printf+0x2a4>
    80008d14:	00005517          	auipc	a0,0x5
    80008d18:	48c50513          	addi	a0,a0,1164 # 8000e1a0 <pr>
    80008d1c:	00001097          	auipc	ra,0x1
    80008d20:	94c080e7          	jalr	-1716(ra) # 80009668 <release>
    80008d24:	e49ff06f          	j	80008b6c <__printf+0x2a4>
    80008d28:	f7843783          	ld	a5,-136(s0)
    80008d2c:	03000513          	li	a0,48
    80008d30:	01000d13          	li	s10,16
    80008d34:	00878713          	addi	a4,a5,8
    80008d38:	0007bc83          	ld	s9,0(a5)
    80008d3c:	f6e43c23          	sd	a4,-136(s0)
    80008d40:	00000097          	auipc	ra,0x0
    80008d44:	9a4080e7          	jalr	-1628(ra) # 800086e4 <consputc>
    80008d48:	07800513          	li	a0,120
    80008d4c:	00000097          	auipc	ra,0x0
    80008d50:	998080e7          	jalr	-1640(ra) # 800086e4 <consputc>
    80008d54:	00002d97          	auipc	s11,0x2
    80008d58:	ae4d8d93          	addi	s11,s11,-1308 # 8000a838 <digits>
    80008d5c:	03ccd793          	srli	a5,s9,0x3c
    80008d60:	00fd87b3          	add	a5,s11,a5
    80008d64:	0007c503          	lbu	a0,0(a5)
    80008d68:	fffd0d1b          	addiw	s10,s10,-1
    80008d6c:	004c9c93          	slli	s9,s9,0x4
    80008d70:	00000097          	auipc	ra,0x0
    80008d74:	974080e7          	jalr	-1676(ra) # 800086e4 <consputc>
    80008d78:	fe0d12e3          	bnez	s10,80008d5c <__printf+0x494>
    80008d7c:	f8dff06f          	j	80008d08 <__printf+0x440>
    80008d80:	f7843783          	ld	a5,-136(s0)
    80008d84:	0007bc83          	ld	s9,0(a5)
    80008d88:	00878793          	addi	a5,a5,8
    80008d8c:	f6f43c23          	sd	a5,-136(s0)
    80008d90:	000c9a63          	bnez	s9,80008da4 <__printf+0x4dc>
    80008d94:	1080006f          	j	80008e9c <__printf+0x5d4>
    80008d98:	001c8c93          	addi	s9,s9,1
    80008d9c:	00000097          	auipc	ra,0x0
    80008da0:	948080e7          	jalr	-1720(ra) # 800086e4 <consputc>
    80008da4:	000cc503          	lbu	a0,0(s9)
    80008da8:	fe0518e3          	bnez	a0,80008d98 <__printf+0x4d0>
    80008dac:	f5dff06f          	j	80008d08 <__printf+0x440>
    80008db0:	02500513          	li	a0,37
    80008db4:	00000097          	auipc	ra,0x0
    80008db8:	930080e7          	jalr	-1744(ra) # 800086e4 <consputc>
    80008dbc:	000c8513          	mv	a0,s9
    80008dc0:	00000097          	auipc	ra,0x0
    80008dc4:	924080e7          	jalr	-1756(ra) # 800086e4 <consputc>
    80008dc8:	f41ff06f          	j	80008d08 <__printf+0x440>
    80008dcc:	02500513          	li	a0,37
    80008dd0:	00000097          	auipc	ra,0x0
    80008dd4:	914080e7          	jalr	-1772(ra) # 800086e4 <consputc>
    80008dd8:	f31ff06f          	j	80008d08 <__printf+0x440>
    80008ddc:	00030513          	mv	a0,t1
    80008de0:	00000097          	auipc	ra,0x0
    80008de4:	7bc080e7          	jalr	1980(ra) # 8000959c <acquire>
    80008de8:	b4dff06f          	j	80008934 <__printf+0x6c>
    80008dec:	40c0053b          	negw	a0,a2
    80008df0:	00a00713          	li	a4,10
    80008df4:	02e576bb          	remuw	a3,a0,a4
    80008df8:	00002d97          	auipc	s11,0x2
    80008dfc:	a40d8d93          	addi	s11,s11,-1472 # 8000a838 <digits>
    80008e00:	ff700593          	li	a1,-9
    80008e04:	02069693          	slli	a3,a3,0x20
    80008e08:	0206d693          	srli	a3,a3,0x20
    80008e0c:	00dd86b3          	add	a3,s11,a3
    80008e10:	0006c683          	lbu	a3,0(a3)
    80008e14:	02e557bb          	divuw	a5,a0,a4
    80008e18:	f8d40023          	sb	a3,-128(s0)
    80008e1c:	10b65e63          	bge	a2,a1,80008f38 <__printf+0x670>
    80008e20:	06300593          	li	a1,99
    80008e24:	02e7f6bb          	remuw	a3,a5,a4
    80008e28:	02069693          	slli	a3,a3,0x20
    80008e2c:	0206d693          	srli	a3,a3,0x20
    80008e30:	00dd86b3          	add	a3,s11,a3
    80008e34:	0006c683          	lbu	a3,0(a3)
    80008e38:	02e7d73b          	divuw	a4,a5,a4
    80008e3c:	00200793          	li	a5,2
    80008e40:	f8d400a3          	sb	a3,-127(s0)
    80008e44:	bca5ece3          	bltu	a1,a0,80008a1c <__printf+0x154>
    80008e48:	ce5ff06f          	j	80008b2c <__printf+0x264>
    80008e4c:	40e007bb          	negw	a5,a4
    80008e50:	00002d97          	auipc	s11,0x2
    80008e54:	9e8d8d93          	addi	s11,s11,-1560 # 8000a838 <digits>
    80008e58:	00f7f693          	andi	a3,a5,15
    80008e5c:	00dd86b3          	add	a3,s11,a3
    80008e60:	0006c583          	lbu	a1,0(a3)
    80008e64:	ff100613          	li	a2,-15
    80008e68:	0047d69b          	srliw	a3,a5,0x4
    80008e6c:	f8b40023          	sb	a1,-128(s0)
    80008e70:	0047d59b          	srliw	a1,a5,0x4
    80008e74:	0ac75e63          	bge	a4,a2,80008f30 <__printf+0x668>
    80008e78:	00f6f693          	andi	a3,a3,15
    80008e7c:	00dd86b3          	add	a3,s11,a3
    80008e80:	0006c603          	lbu	a2,0(a3)
    80008e84:	00f00693          	li	a3,15
    80008e88:	0087d79b          	srliw	a5,a5,0x8
    80008e8c:	f8c400a3          	sb	a2,-127(s0)
    80008e90:	d8b6e4e3          	bltu	a3,a1,80008c18 <__printf+0x350>
    80008e94:	00200793          	li	a5,2
    80008e98:	e2dff06f          	j	80008cc4 <__printf+0x3fc>
    80008e9c:	00002c97          	auipc	s9,0x2
    80008ea0:	97cc8c93          	addi	s9,s9,-1668 # 8000a818 <CONSOLE_STATUS+0x808>
    80008ea4:	02800513          	li	a0,40
    80008ea8:	ef1ff06f          	j	80008d98 <__printf+0x4d0>
    80008eac:	00700793          	li	a5,7
    80008eb0:	00600c93          	li	s9,6
    80008eb4:	e0dff06f          	j	80008cc0 <__printf+0x3f8>
    80008eb8:	00700793          	li	a5,7
    80008ebc:	00600c93          	li	s9,6
    80008ec0:	c69ff06f          	j	80008b28 <__printf+0x260>
    80008ec4:	00300793          	li	a5,3
    80008ec8:	00200c93          	li	s9,2
    80008ecc:	c5dff06f          	j	80008b28 <__printf+0x260>
    80008ed0:	00300793          	li	a5,3
    80008ed4:	00200c93          	li	s9,2
    80008ed8:	de9ff06f          	j	80008cc0 <__printf+0x3f8>
    80008edc:	00400793          	li	a5,4
    80008ee0:	00300c93          	li	s9,3
    80008ee4:	dddff06f          	j	80008cc0 <__printf+0x3f8>
    80008ee8:	00400793          	li	a5,4
    80008eec:	00300c93          	li	s9,3
    80008ef0:	c39ff06f          	j	80008b28 <__printf+0x260>
    80008ef4:	00500793          	li	a5,5
    80008ef8:	00400c93          	li	s9,4
    80008efc:	c2dff06f          	j	80008b28 <__printf+0x260>
    80008f00:	00500793          	li	a5,5
    80008f04:	00400c93          	li	s9,4
    80008f08:	db9ff06f          	j	80008cc0 <__printf+0x3f8>
    80008f0c:	00600793          	li	a5,6
    80008f10:	00500c93          	li	s9,5
    80008f14:	dadff06f          	j	80008cc0 <__printf+0x3f8>
    80008f18:	00600793          	li	a5,6
    80008f1c:	00500c93          	li	s9,5
    80008f20:	c09ff06f          	j	80008b28 <__printf+0x260>
    80008f24:	00800793          	li	a5,8
    80008f28:	00700c93          	li	s9,7
    80008f2c:	bfdff06f          	j	80008b28 <__printf+0x260>
    80008f30:	00100793          	li	a5,1
    80008f34:	d91ff06f          	j	80008cc4 <__printf+0x3fc>
    80008f38:	00100793          	li	a5,1
    80008f3c:	bf1ff06f          	j	80008b2c <__printf+0x264>
    80008f40:	00900793          	li	a5,9
    80008f44:	00800c93          	li	s9,8
    80008f48:	be1ff06f          	j	80008b28 <__printf+0x260>
    80008f4c:	00002517          	auipc	a0,0x2
    80008f50:	8d450513          	addi	a0,a0,-1836 # 8000a820 <CONSOLE_STATUS+0x810>
    80008f54:	00000097          	auipc	ra,0x0
    80008f58:	918080e7          	jalr	-1768(ra) # 8000886c <panic>

0000000080008f5c <printfinit>:
    80008f5c:	fe010113          	addi	sp,sp,-32
    80008f60:	00813823          	sd	s0,16(sp)
    80008f64:	00913423          	sd	s1,8(sp)
    80008f68:	00113c23          	sd	ra,24(sp)
    80008f6c:	02010413          	addi	s0,sp,32
    80008f70:	00005497          	auipc	s1,0x5
    80008f74:	23048493          	addi	s1,s1,560 # 8000e1a0 <pr>
    80008f78:	00048513          	mv	a0,s1
    80008f7c:	00002597          	auipc	a1,0x2
    80008f80:	8b458593          	addi	a1,a1,-1868 # 8000a830 <CONSOLE_STATUS+0x820>
    80008f84:	00000097          	auipc	ra,0x0
    80008f88:	5f4080e7          	jalr	1524(ra) # 80009578 <initlock>
    80008f8c:	01813083          	ld	ra,24(sp)
    80008f90:	01013403          	ld	s0,16(sp)
    80008f94:	0004ac23          	sw	zero,24(s1)
    80008f98:	00813483          	ld	s1,8(sp)
    80008f9c:	02010113          	addi	sp,sp,32
    80008fa0:	00008067          	ret

0000000080008fa4 <uartinit>:
    80008fa4:	ff010113          	addi	sp,sp,-16
    80008fa8:	00813423          	sd	s0,8(sp)
    80008fac:	01010413          	addi	s0,sp,16
    80008fb0:	100007b7          	lui	a5,0x10000
    80008fb4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    80008fb8:	f8000713          	li	a4,-128
    80008fbc:	00e781a3          	sb	a4,3(a5)
    80008fc0:	00300713          	li	a4,3
    80008fc4:	00e78023          	sb	a4,0(a5)
    80008fc8:	000780a3          	sb	zero,1(a5)
    80008fcc:	00e781a3          	sb	a4,3(a5)
    80008fd0:	00700693          	li	a3,7
    80008fd4:	00d78123          	sb	a3,2(a5)
    80008fd8:	00e780a3          	sb	a4,1(a5)
    80008fdc:	00813403          	ld	s0,8(sp)
    80008fe0:	01010113          	addi	sp,sp,16
    80008fe4:	00008067          	ret

0000000080008fe8 <uartputc>:
    80008fe8:	00004797          	auipc	a5,0x4
    80008fec:	ea07a783          	lw	a5,-352(a5) # 8000ce88 <panicked>
    80008ff0:	00078463          	beqz	a5,80008ff8 <uartputc+0x10>
    80008ff4:	0000006f          	j	80008ff4 <uartputc+0xc>
    80008ff8:	fd010113          	addi	sp,sp,-48
    80008ffc:	02813023          	sd	s0,32(sp)
    80009000:	00913c23          	sd	s1,24(sp)
    80009004:	01213823          	sd	s2,16(sp)
    80009008:	01313423          	sd	s3,8(sp)
    8000900c:	02113423          	sd	ra,40(sp)
    80009010:	03010413          	addi	s0,sp,48
    80009014:	00004917          	auipc	s2,0x4
    80009018:	e7c90913          	addi	s2,s2,-388 # 8000ce90 <uart_tx_r>
    8000901c:	00093783          	ld	a5,0(s2)
    80009020:	00004497          	auipc	s1,0x4
    80009024:	e7848493          	addi	s1,s1,-392 # 8000ce98 <uart_tx_w>
    80009028:	0004b703          	ld	a4,0(s1)
    8000902c:	02078693          	addi	a3,a5,32
    80009030:	00050993          	mv	s3,a0
    80009034:	02e69c63          	bne	a3,a4,8000906c <uartputc+0x84>
    80009038:	00001097          	auipc	ra,0x1
    8000903c:	834080e7          	jalr	-1996(ra) # 8000986c <push_on>
    80009040:	00093783          	ld	a5,0(s2)
    80009044:	0004b703          	ld	a4,0(s1)
    80009048:	02078793          	addi	a5,a5,32
    8000904c:	00e79463          	bne	a5,a4,80009054 <uartputc+0x6c>
    80009050:	0000006f          	j	80009050 <uartputc+0x68>
    80009054:	00001097          	auipc	ra,0x1
    80009058:	88c080e7          	jalr	-1908(ra) # 800098e0 <pop_on>
    8000905c:	00093783          	ld	a5,0(s2)
    80009060:	0004b703          	ld	a4,0(s1)
    80009064:	02078693          	addi	a3,a5,32
    80009068:	fce688e3          	beq	a3,a4,80009038 <uartputc+0x50>
    8000906c:	01f77693          	andi	a3,a4,31
    80009070:	00005597          	auipc	a1,0x5
    80009074:	15058593          	addi	a1,a1,336 # 8000e1c0 <uart_tx_buf>
    80009078:	00d586b3          	add	a3,a1,a3
    8000907c:	00170713          	addi	a4,a4,1
    80009080:	01368023          	sb	s3,0(a3)
    80009084:	00e4b023          	sd	a4,0(s1)
    80009088:	10000637          	lui	a2,0x10000
    8000908c:	02f71063          	bne	a4,a5,800090ac <uartputc+0xc4>
    80009090:	0340006f          	j	800090c4 <uartputc+0xdc>
    80009094:	00074703          	lbu	a4,0(a4)
    80009098:	00f93023          	sd	a5,0(s2)
    8000909c:	00e60023          	sb	a4,0(a2) # 10000000 <_entry-0x70000000>
    800090a0:	00093783          	ld	a5,0(s2)
    800090a4:	0004b703          	ld	a4,0(s1)
    800090a8:	00f70e63          	beq	a4,a5,800090c4 <uartputc+0xdc>
    800090ac:	00564683          	lbu	a3,5(a2)
    800090b0:	01f7f713          	andi	a4,a5,31
    800090b4:	00e58733          	add	a4,a1,a4
    800090b8:	0206f693          	andi	a3,a3,32
    800090bc:	00178793          	addi	a5,a5,1
    800090c0:	fc069ae3          	bnez	a3,80009094 <uartputc+0xac>
    800090c4:	02813083          	ld	ra,40(sp)
    800090c8:	02013403          	ld	s0,32(sp)
    800090cc:	01813483          	ld	s1,24(sp)
    800090d0:	01013903          	ld	s2,16(sp)
    800090d4:	00813983          	ld	s3,8(sp)
    800090d8:	03010113          	addi	sp,sp,48
    800090dc:	00008067          	ret

00000000800090e0 <uartputc_sync>:
    800090e0:	ff010113          	addi	sp,sp,-16
    800090e4:	00813423          	sd	s0,8(sp)
    800090e8:	01010413          	addi	s0,sp,16
    800090ec:	00004717          	auipc	a4,0x4
    800090f0:	d9c72703          	lw	a4,-612(a4) # 8000ce88 <panicked>
    800090f4:	02071663          	bnez	a4,80009120 <uartputc_sync+0x40>
    800090f8:	00050793          	mv	a5,a0
    800090fc:	100006b7          	lui	a3,0x10000
    80009100:	0056c703          	lbu	a4,5(a3) # 10000005 <_entry-0x6ffffffb>
    80009104:	02077713          	andi	a4,a4,32
    80009108:	fe070ce3          	beqz	a4,80009100 <uartputc_sync+0x20>
    8000910c:	0ff7f793          	andi	a5,a5,255
    80009110:	00f68023          	sb	a5,0(a3)
    80009114:	00813403          	ld	s0,8(sp)
    80009118:	01010113          	addi	sp,sp,16
    8000911c:	00008067          	ret
    80009120:	0000006f          	j	80009120 <uartputc_sync+0x40>

0000000080009124 <uartstart>:
    80009124:	ff010113          	addi	sp,sp,-16
    80009128:	00813423          	sd	s0,8(sp)
    8000912c:	01010413          	addi	s0,sp,16
    80009130:	00004617          	auipc	a2,0x4
    80009134:	d6060613          	addi	a2,a2,-672 # 8000ce90 <uart_tx_r>
    80009138:	00004517          	auipc	a0,0x4
    8000913c:	d6050513          	addi	a0,a0,-672 # 8000ce98 <uart_tx_w>
    80009140:	00063783          	ld	a5,0(a2)
    80009144:	00053703          	ld	a4,0(a0)
    80009148:	04f70263          	beq	a4,a5,8000918c <uartstart+0x68>
    8000914c:	100005b7          	lui	a1,0x10000
    80009150:	00005817          	auipc	a6,0x5
    80009154:	07080813          	addi	a6,a6,112 # 8000e1c0 <uart_tx_buf>
    80009158:	01c0006f          	j	80009174 <uartstart+0x50>
    8000915c:	0006c703          	lbu	a4,0(a3)
    80009160:	00f63023          	sd	a5,0(a2)
    80009164:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80009168:	00063783          	ld	a5,0(a2)
    8000916c:	00053703          	ld	a4,0(a0)
    80009170:	00f70e63          	beq	a4,a5,8000918c <uartstart+0x68>
    80009174:	01f7f713          	andi	a4,a5,31
    80009178:	00e806b3          	add	a3,a6,a4
    8000917c:	0055c703          	lbu	a4,5(a1)
    80009180:	00178793          	addi	a5,a5,1
    80009184:	02077713          	andi	a4,a4,32
    80009188:	fc071ae3          	bnez	a4,8000915c <uartstart+0x38>
    8000918c:	00813403          	ld	s0,8(sp)
    80009190:	01010113          	addi	sp,sp,16
    80009194:	00008067          	ret

0000000080009198 <uartgetc>:
    80009198:	ff010113          	addi	sp,sp,-16
    8000919c:	00813423          	sd	s0,8(sp)
    800091a0:	01010413          	addi	s0,sp,16
    800091a4:	10000737          	lui	a4,0x10000
    800091a8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800091ac:	0017f793          	andi	a5,a5,1
    800091b0:	00078c63          	beqz	a5,800091c8 <uartgetc+0x30>
    800091b4:	00074503          	lbu	a0,0(a4)
    800091b8:	0ff57513          	andi	a0,a0,255
    800091bc:	00813403          	ld	s0,8(sp)
    800091c0:	01010113          	addi	sp,sp,16
    800091c4:	00008067          	ret
    800091c8:	fff00513          	li	a0,-1
    800091cc:	ff1ff06f          	j	800091bc <uartgetc+0x24>

00000000800091d0 <uartintr>:
    800091d0:	100007b7          	lui	a5,0x10000
    800091d4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800091d8:	0017f793          	andi	a5,a5,1
    800091dc:	0a078463          	beqz	a5,80009284 <uartintr+0xb4>
    800091e0:	fe010113          	addi	sp,sp,-32
    800091e4:	00813823          	sd	s0,16(sp)
    800091e8:	00913423          	sd	s1,8(sp)
    800091ec:	00113c23          	sd	ra,24(sp)
    800091f0:	02010413          	addi	s0,sp,32
    800091f4:	100004b7          	lui	s1,0x10000
    800091f8:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
    800091fc:	0ff57513          	andi	a0,a0,255
    80009200:	fffff097          	auipc	ra,0xfffff
    80009204:	534080e7          	jalr	1332(ra) # 80008734 <consoleintr>
    80009208:	0054c783          	lbu	a5,5(s1)
    8000920c:	0017f793          	andi	a5,a5,1
    80009210:	fe0794e3          	bnez	a5,800091f8 <uartintr+0x28>
    80009214:	00004617          	auipc	a2,0x4
    80009218:	c7c60613          	addi	a2,a2,-900 # 8000ce90 <uart_tx_r>
    8000921c:	00004517          	auipc	a0,0x4
    80009220:	c7c50513          	addi	a0,a0,-900 # 8000ce98 <uart_tx_w>
    80009224:	00063783          	ld	a5,0(a2)
    80009228:	00053703          	ld	a4,0(a0)
    8000922c:	04f70263          	beq	a4,a5,80009270 <uartintr+0xa0>
    80009230:	100005b7          	lui	a1,0x10000
    80009234:	00005817          	auipc	a6,0x5
    80009238:	f8c80813          	addi	a6,a6,-116 # 8000e1c0 <uart_tx_buf>
    8000923c:	01c0006f          	j	80009258 <uartintr+0x88>
    80009240:	0006c703          	lbu	a4,0(a3)
    80009244:	00f63023          	sd	a5,0(a2)
    80009248:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    8000924c:	00063783          	ld	a5,0(a2)
    80009250:	00053703          	ld	a4,0(a0)
    80009254:	00f70e63          	beq	a4,a5,80009270 <uartintr+0xa0>
    80009258:	01f7f713          	andi	a4,a5,31
    8000925c:	00e806b3          	add	a3,a6,a4
    80009260:	0055c703          	lbu	a4,5(a1)
    80009264:	00178793          	addi	a5,a5,1
    80009268:	02077713          	andi	a4,a4,32
    8000926c:	fc071ae3          	bnez	a4,80009240 <uartintr+0x70>
    80009270:	01813083          	ld	ra,24(sp)
    80009274:	01013403          	ld	s0,16(sp)
    80009278:	00813483          	ld	s1,8(sp)
    8000927c:	02010113          	addi	sp,sp,32
    80009280:	00008067          	ret
    80009284:	00004617          	auipc	a2,0x4
    80009288:	c0c60613          	addi	a2,a2,-1012 # 8000ce90 <uart_tx_r>
    8000928c:	00004517          	auipc	a0,0x4
    80009290:	c0c50513          	addi	a0,a0,-1012 # 8000ce98 <uart_tx_w>
    80009294:	00063783          	ld	a5,0(a2)
    80009298:	00053703          	ld	a4,0(a0)
    8000929c:	04f70263          	beq	a4,a5,800092e0 <uartintr+0x110>
    800092a0:	100005b7          	lui	a1,0x10000
    800092a4:	00005817          	auipc	a6,0x5
    800092a8:	f1c80813          	addi	a6,a6,-228 # 8000e1c0 <uart_tx_buf>
    800092ac:	01c0006f          	j	800092c8 <uartintr+0xf8>
    800092b0:	0006c703          	lbu	a4,0(a3)
    800092b4:	00f63023          	sd	a5,0(a2)
    800092b8:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    800092bc:	00063783          	ld	a5,0(a2)
    800092c0:	00053703          	ld	a4,0(a0)
    800092c4:	02f70063          	beq	a4,a5,800092e4 <uartintr+0x114>
    800092c8:	01f7f713          	andi	a4,a5,31
    800092cc:	00e806b3          	add	a3,a6,a4
    800092d0:	0055c703          	lbu	a4,5(a1)
    800092d4:	00178793          	addi	a5,a5,1
    800092d8:	02077713          	andi	a4,a4,32
    800092dc:	fc071ae3          	bnez	a4,800092b0 <uartintr+0xe0>
    800092e0:	00008067          	ret
    800092e4:	00008067          	ret

00000000800092e8 <kinit>:
    800092e8:	fc010113          	addi	sp,sp,-64
    800092ec:	02913423          	sd	s1,40(sp)
    800092f0:	fffff7b7          	lui	a5,0xfffff
    800092f4:	00006497          	auipc	s1,0x6
    800092f8:	eeb48493          	addi	s1,s1,-277 # 8000f1df <end+0xfff>
    800092fc:	02813823          	sd	s0,48(sp)
    80009300:	01313c23          	sd	s3,24(sp)
    80009304:	00f4f4b3          	and	s1,s1,a5
    80009308:	02113c23          	sd	ra,56(sp)
    8000930c:	03213023          	sd	s2,32(sp)
    80009310:	01413823          	sd	s4,16(sp)
    80009314:	01513423          	sd	s5,8(sp)
    80009318:	04010413          	addi	s0,sp,64
    8000931c:	000017b7          	lui	a5,0x1
    80009320:	01100993          	li	s3,17
    80009324:	00f487b3          	add	a5,s1,a5
    80009328:	01b99993          	slli	s3,s3,0x1b
    8000932c:	06f9e063          	bltu	s3,a5,8000938c <kinit+0xa4>
    80009330:	00005a97          	auipc	s5,0x5
    80009334:	eb0a8a93          	addi	s5,s5,-336 # 8000e1e0 <end>
    80009338:	0754ec63          	bltu	s1,s5,800093b0 <kinit+0xc8>
    8000933c:	0734fa63          	bgeu	s1,s3,800093b0 <kinit+0xc8>
    80009340:	00088a37          	lui	s4,0x88
    80009344:	fffa0a13          	addi	s4,s4,-1 # 87fff <_entry-0x7ff78001>
    80009348:	00004917          	auipc	s2,0x4
    8000934c:	b5890913          	addi	s2,s2,-1192 # 8000cea0 <kmem>
    80009350:	00ca1a13          	slli	s4,s4,0xc
    80009354:	0140006f          	j	80009368 <kinit+0x80>
    80009358:	000017b7          	lui	a5,0x1
    8000935c:	00f484b3          	add	s1,s1,a5
    80009360:	0554e863          	bltu	s1,s5,800093b0 <kinit+0xc8>
    80009364:	0534f663          	bgeu	s1,s3,800093b0 <kinit+0xc8>
    80009368:	00001637          	lui	a2,0x1
    8000936c:	00100593          	li	a1,1
    80009370:	00048513          	mv	a0,s1
    80009374:	00000097          	auipc	ra,0x0
    80009378:	5e4080e7          	jalr	1508(ra) # 80009958 <__memset>
    8000937c:	00093783          	ld	a5,0(s2)
    80009380:	00f4b023          	sd	a5,0(s1)
    80009384:	00993023          	sd	s1,0(s2)
    80009388:	fd4498e3          	bne	s1,s4,80009358 <kinit+0x70>
    8000938c:	03813083          	ld	ra,56(sp)
    80009390:	03013403          	ld	s0,48(sp)
    80009394:	02813483          	ld	s1,40(sp)
    80009398:	02013903          	ld	s2,32(sp)
    8000939c:	01813983          	ld	s3,24(sp)
    800093a0:	01013a03          	ld	s4,16(sp)
    800093a4:	00813a83          	ld	s5,8(sp)
    800093a8:	04010113          	addi	sp,sp,64
    800093ac:	00008067          	ret
    800093b0:	00001517          	auipc	a0,0x1
    800093b4:	4a050513          	addi	a0,a0,1184 # 8000a850 <digits+0x18>
    800093b8:	fffff097          	auipc	ra,0xfffff
    800093bc:	4b4080e7          	jalr	1204(ra) # 8000886c <panic>

00000000800093c0 <freerange>:
    800093c0:	fc010113          	addi	sp,sp,-64
    800093c4:	000017b7          	lui	a5,0x1
    800093c8:	02913423          	sd	s1,40(sp)
    800093cc:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800093d0:	009504b3          	add	s1,a0,s1
    800093d4:	fffff537          	lui	a0,0xfffff
    800093d8:	02813823          	sd	s0,48(sp)
    800093dc:	02113c23          	sd	ra,56(sp)
    800093e0:	03213023          	sd	s2,32(sp)
    800093e4:	01313c23          	sd	s3,24(sp)
    800093e8:	01413823          	sd	s4,16(sp)
    800093ec:	01513423          	sd	s5,8(sp)
    800093f0:	01613023          	sd	s6,0(sp)
    800093f4:	04010413          	addi	s0,sp,64
    800093f8:	00a4f4b3          	and	s1,s1,a0
    800093fc:	00f487b3          	add	a5,s1,a5
    80009400:	06f5e463          	bltu	a1,a5,80009468 <freerange+0xa8>
    80009404:	00005a97          	auipc	s5,0x5
    80009408:	ddca8a93          	addi	s5,s5,-548 # 8000e1e0 <end>
    8000940c:	0954e263          	bltu	s1,s5,80009490 <freerange+0xd0>
    80009410:	01100993          	li	s3,17
    80009414:	01b99993          	slli	s3,s3,0x1b
    80009418:	0734fc63          	bgeu	s1,s3,80009490 <freerange+0xd0>
    8000941c:	00058a13          	mv	s4,a1
    80009420:	00004917          	auipc	s2,0x4
    80009424:	a8090913          	addi	s2,s2,-1408 # 8000cea0 <kmem>
    80009428:	00002b37          	lui	s6,0x2
    8000942c:	0140006f          	j	80009440 <freerange+0x80>
    80009430:	000017b7          	lui	a5,0x1
    80009434:	00f484b3          	add	s1,s1,a5
    80009438:	0554ec63          	bltu	s1,s5,80009490 <freerange+0xd0>
    8000943c:	0534fa63          	bgeu	s1,s3,80009490 <freerange+0xd0>
    80009440:	00001637          	lui	a2,0x1
    80009444:	00100593          	li	a1,1
    80009448:	00048513          	mv	a0,s1
    8000944c:	00000097          	auipc	ra,0x0
    80009450:	50c080e7          	jalr	1292(ra) # 80009958 <__memset>
    80009454:	00093703          	ld	a4,0(s2)
    80009458:	016487b3          	add	a5,s1,s6
    8000945c:	00e4b023          	sd	a4,0(s1)
    80009460:	00993023          	sd	s1,0(s2)
    80009464:	fcfa76e3          	bgeu	s4,a5,80009430 <freerange+0x70>
    80009468:	03813083          	ld	ra,56(sp)
    8000946c:	03013403          	ld	s0,48(sp)
    80009470:	02813483          	ld	s1,40(sp)
    80009474:	02013903          	ld	s2,32(sp)
    80009478:	01813983          	ld	s3,24(sp)
    8000947c:	01013a03          	ld	s4,16(sp)
    80009480:	00813a83          	ld	s5,8(sp)
    80009484:	00013b03          	ld	s6,0(sp)
    80009488:	04010113          	addi	sp,sp,64
    8000948c:	00008067          	ret
    80009490:	00001517          	auipc	a0,0x1
    80009494:	3c050513          	addi	a0,a0,960 # 8000a850 <digits+0x18>
    80009498:	fffff097          	auipc	ra,0xfffff
    8000949c:	3d4080e7          	jalr	980(ra) # 8000886c <panic>

00000000800094a0 <kfree>:
    800094a0:	fe010113          	addi	sp,sp,-32
    800094a4:	00813823          	sd	s0,16(sp)
    800094a8:	00113c23          	sd	ra,24(sp)
    800094ac:	00913423          	sd	s1,8(sp)
    800094b0:	02010413          	addi	s0,sp,32
    800094b4:	03451793          	slli	a5,a0,0x34
    800094b8:	04079c63          	bnez	a5,80009510 <kfree+0x70>
    800094bc:	00005797          	auipc	a5,0x5
    800094c0:	d2478793          	addi	a5,a5,-732 # 8000e1e0 <end>
    800094c4:	00050493          	mv	s1,a0
    800094c8:	04f56463          	bltu	a0,a5,80009510 <kfree+0x70>
    800094cc:	01100793          	li	a5,17
    800094d0:	01b79793          	slli	a5,a5,0x1b
    800094d4:	02f57e63          	bgeu	a0,a5,80009510 <kfree+0x70>
    800094d8:	00001637          	lui	a2,0x1
    800094dc:	00100593          	li	a1,1
    800094e0:	00000097          	auipc	ra,0x0
    800094e4:	478080e7          	jalr	1144(ra) # 80009958 <__memset>
    800094e8:	00004797          	auipc	a5,0x4
    800094ec:	9b878793          	addi	a5,a5,-1608 # 8000cea0 <kmem>
    800094f0:	0007b703          	ld	a4,0(a5)
    800094f4:	01813083          	ld	ra,24(sp)
    800094f8:	01013403          	ld	s0,16(sp)
    800094fc:	00e4b023          	sd	a4,0(s1)
    80009500:	0097b023          	sd	s1,0(a5)
    80009504:	00813483          	ld	s1,8(sp)
    80009508:	02010113          	addi	sp,sp,32
    8000950c:	00008067          	ret
    80009510:	00001517          	auipc	a0,0x1
    80009514:	34050513          	addi	a0,a0,832 # 8000a850 <digits+0x18>
    80009518:	fffff097          	auipc	ra,0xfffff
    8000951c:	354080e7          	jalr	852(ra) # 8000886c <panic>

0000000080009520 <kalloc>:
    80009520:	fe010113          	addi	sp,sp,-32
    80009524:	00813823          	sd	s0,16(sp)
    80009528:	00913423          	sd	s1,8(sp)
    8000952c:	00113c23          	sd	ra,24(sp)
    80009530:	02010413          	addi	s0,sp,32
    80009534:	00004797          	auipc	a5,0x4
    80009538:	96c78793          	addi	a5,a5,-1684 # 8000cea0 <kmem>
    8000953c:	0007b483          	ld	s1,0(a5)
    80009540:	02048063          	beqz	s1,80009560 <kalloc+0x40>
    80009544:	0004b703          	ld	a4,0(s1)
    80009548:	00001637          	lui	a2,0x1
    8000954c:	00500593          	li	a1,5
    80009550:	00048513          	mv	a0,s1
    80009554:	00e7b023          	sd	a4,0(a5)
    80009558:	00000097          	auipc	ra,0x0
    8000955c:	400080e7          	jalr	1024(ra) # 80009958 <__memset>
    80009560:	01813083          	ld	ra,24(sp)
    80009564:	01013403          	ld	s0,16(sp)
    80009568:	00048513          	mv	a0,s1
    8000956c:	00813483          	ld	s1,8(sp)
    80009570:	02010113          	addi	sp,sp,32
    80009574:	00008067          	ret

0000000080009578 <initlock>:
    80009578:	ff010113          	addi	sp,sp,-16
    8000957c:	00813423          	sd	s0,8(sp)
    80009580:	01010413          	addi	s0,sp,16
    80009584:	00813403          	ld	s0,8(sp)
    80009588:	00b53423          	sd	a1,8(a0)
    8000958c:	00052023          	sw	zero,0(a0)
    80009590:	00053823          	sd	zero,16(a0)
    80009594:	01010113          	addi	sp,sp,16
    80009598:	00008067          	ret

000000008000959c <acquire>:
    8000959c:	fe010113          	addi	sp,sp,-32
    800095a0:	00813823          	sd	s0,16(sp)
    800095a4:	00913423          	sd	s1,8(sp)
    800095a8:	00113c23          	sd	ra,24(sp)
    800095ac:	01213023          	sd	s2,0(sp)
    800095b0:	02010413          	addi	s0,sp,32
    800095b4:	00050493          	mv	s1,a0
    800095b8:	10002973          	csrr	s2,sstatus
    800095bc:	100027f3          	csrr	a5,sstatus
    800095c0:	ffd7f793          	andi	a5,a5,-3
    800095c4:	10079073          	csrw	sstatus,a5
    800095c8:	fffff097          	auipc	ra,0xfffff
    800095cc:	8e8080e7          	jalr	-1816(ra) # 80007eb0 <mycpu>
    800095d0:	07852783          	lw	a5,120(a0)
    800095d4:	06078e63          	beqz	a5,80009650 <acquire+0xb4>
    800095d8:	fffff097          	auipc	ra,0xfffff
    800095dc:	8d8080e7          	jalr	-1832(ra) # 80007eb0 <mycpu>
    800095e0:	07852783          	lw	a5,120(a0)
    800095e4:	0004a703          	lw	a4,0(s1)
    800095e8:	0017879b          	addiw	a5,a5,1
    800095ec:	06f52c23          	sw	a5,120(a0)
    800095f0:	04071063          	bnez	a4,80009630 <acquire+0x94>
    800095f4:	00100713          	li	a4,1
    800095f8:	00070793          	mv	a5,a4
    800095fc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80009600:	0007879b          	sext.w	a5,a5
    80009604:	fe079ae3          	bnez	a5,800095f8 <acquire+0x5c>
    80009608:	0ff0000f          	fence
    8000960c:	fffff097          	auipc	ra,0xfffff
    80009610:	8a4080e7          	jalr	-1884(ra) # 80007eb0 <mycpu>
    80009614:	01813083          	ld	ra,24(sp)
    80009618:	01013403          	ld	s0,16(sp)
    8000961c:	00a4b823          	sd	a0,16(s1)
    80009620:	00013903          	ld	s2,0(sp)
    80009624:	00813483          	ld	s1,8(sp)
    80009628:	02010113          	addi	sp,sp,32
    8000962c:	00008067          	ret
    80009630:	0104b903          	ld	s2,16(s1)
    80009634:	fffff097          	auipc	ra,0xfffff
    80009638:	87c080e7          	jalr	-1924(ra) # 80007eb0 <mycpu>
    8000963c:	faa91ce3          	bne	s2,a0,800095f4 <acquire+0x58>
    80009640:	00001517          	auipc	a0,0x1
    80009644:	21850513          	addi	a0,a0,536 # 8000a858 <digits+0x20>
    80009648:	fffff097          	auipc	ra,0xfffff
    8000964c:	224080e7          	jalr	548(ra) # 8000886c <panic>
    80009650:	00195913          	srli	s2,s2,0x1
    80009654:	fffff097          	auipc	ra,0xfffff
    80009658:	85c080e7          	jalr	-1956(ra) # 80007eb0 <mycpu>
    8000965c:	00197913          	andi	s2,s2,1
    80009660:	07252e23          	sw	s2,124(a0)
    80009664:	f75ff06f          	j	800095d8 <acquire+0x3c>

0000000080009668 <release>:
    80009668:	fe010113          	addi	sp,sp,-32
    8000966c:	00813823          	sd	s0,16(sp)
    80009670:	00113c23          	sd	ra,24(sp)
    80009674:	00913423          	sd	s1,8(sp)
    80009678:	01213023          	sd	s2,0(sp)
    8000967c:	02010413          	addi	s0,sp,32
    80009680:	00052783          	lw	a5,0(a0)
    80009684:	00079a63          	bnez	a5,80009698 <release+0x30>
    80009688:	00001517          	auipc	a0,0x1
    8000968c:	1d850513          	addi	a0,a0,472 # 8000a860 <digits+0x28>
    80009690:	fffff097          	auipc	ra,0xfffff
    80009694:	1dc080e7          	jalr	476(ra) # 8000886c <panic>
    80009698:	01053903          	ld	s2,16(a0)
    8000969c:	00050493          	mv	s1,a0
    800096a0:	fffff097          	auipc	ra,0xfffff
    800096a4:	810080e7          	jalr	-2032(ra) # 80007eb0 <mycpu>
    800096a8:	fea910e3          	bne	s2,a0,80009688 <release+0x20>
    800096ac:	0004b823          	sd	zero,16(s1)
    800096b0:	0ff0000f          	fence
    800096b4:	0f50000f          	fence	iorw,ow
    800096b8:	0804a02f          	amoswap.w	zero,zero,(s1)
    800096bc:	ffffe097          	auipc	ra,0xffffe
    800096c0:	7f4080e7          	jalr	2036(ra) # 80007eb0 <mycpu>
    800096c4:	100027f3          	csrr	a5,sstatus
    800096c8:	0027f793          	andi	a5,a5,2
    800096cc:	04079a63          	bnez	a5,80009720 <release+0xb8>
    800096d0:	07852783          	lw	a5,120(a0)
    800096d4:	02f05e63          	blez	a5,80009710 <release+0xa8>
    800096d8:	fff7871b          	addiw	a4,a5,-1
    800096dc:	06e52c23          	sw	a4,120(a0)
    800096e0:	00071c63          	bnez	a4,800096f8 <release+0x90>
    800096e4:	07c52783          	lw	a5,124(a0)
    800096e8:	00078863          	beqz	a5,800096f8 <release+0x90>
    800096ec:	100027f3          	csrr	a5,sstatus
    800096f0:	0027e793          	ori	a5,a5,2
    800096f4:	10079073          	csrw	sstatus,a5
    800096f8:	01813083          	ld	ra,24(sp)
    800096fc:	01013403          	ld	s0,16(sp)
    80009700:	00813483          	ld	s1,8(sp)
    80009704:	00013903          	ld	s2,0(sp)
    80009708:	02010113          	addi	sp,sp,32
    8000970c:	00008067          	ret
    80009710:	00001517          	auipc	a0,0x1
    80009714:	17050513          	addi	a0,a0,368 # 8000a880 <digits+0x48>
    80009718:	fffff097          	auipc	ra,0xfffff
    8000971c:	154080e7          	jalr	340(ra) # 8000886c <panic>
    80009720:	00001517          	auipc	a0,0x1
    80009724:	14850513          	addi	a0,a0,328 # 8000a868 <digits+0x30>
    80009728:	fffff097          	auipc	ra,0xfffff
    8000972c:	144080e7          	jalr	324(ra) # 8000886c <panic>

0000000080009730 <holding>:
    80009730:	00052783          	lw	a5,0(a0)
    80009734:	00079663          	bnez	a5,80009740 <holding+0x10>
    80009738:	00000513          	li	a0,0
    8000973c:	00008067          	ret
    80009740:	fe010113          	addi	sp,sp,-32
    80009744:	00813823          	sd	s0,16(sp)
    80009748:	00913423          	sd	s1,8(sp)
    8000974c:	00113c23          	sd	ra,24(sp)
    80009750:	02010413          	addi	s0,sp,32
    80009754:	01053483          	ld	s1,16(a0)
    80009758:	ffffe097          	auipc	ra,0xffffe
    8000975c:	758080e7          	jalr	1880(ra) # 80007eb0 <mycpu>
    80009760:	01813083          	ld	ra,24(sp)
    80009764:	01013403          	ld	s0,16(sp)
    80009768:	40a48533          	sub	a0,s1,a0
    8000976c:	00153513          	seqz	a0,a0
    80009770:	00813483          	ld	s1,8(sp)
    80009774:	02010113          	addi	sp,sp,32
    80009778:	00008067          	ret

000000008000977c <push_off>:
    8000977c:	fe010113          	addi	sp,sp,-32
    80009780:	00813823          	sd	s0,16(sp)
    80009784:	00113c23          	sd	ra,24(sp)
    80009788:	00913423          	sd	s1,8(sp)
    8000978c:	02010413          	addi	s0,sp,32
    80009790:	100024f3          	csrr	s1,sstatus
    80009794:	100027f3          	csrr	a5,sstatus
    80009798:	ffd7f793          	andi	a5,a5,-3
    8000979c:	10079073          	csrw	sstatus,a5
    800097a0:	ffffe097          	auipc	ra,0xffffe
    800097a4:	710080e7          	jalr	1808(ra) # 80007eb0 <mycpu>
    800097a8:	07852783          	lw	a5,120(a0)
    800097ac:	02078663          	beqz	a5,800097d8 <push_off+0x5c>
    800097b0:	ffffe097          	auipc	ra,0xffffe
    800097b4:	700080e7          	jalr	1792(ra) # 80007eb0 <mycpu>
    800097b8:	07852783          	lw	a5,120(a0)
    800097bc:	01813083          	ld	ra,24(sp)
    800097c0:	01013403          	ld	s0,16(sp)
    800097c4:	0017879b          	addiw	a5,a5,1
    800097c8:	06f52c23          	sw	a5,120(a0)
    800097cc:	00813483          	ld	s1,8(sp)
    800097d0:	02010113          	addi	sp,sp,32
    800097d4:	00008067          	ret
    800097d8:	0014d493          	srli	s1,s1,0x1
    800097dc:	ffffe097          	auipc	ra,0xffffe
    800097e0:	6d4080e7          	jalr	1748(ra) # 80007eb0 <mycpu>
    800097e4:	0014f493          	andi	s1,s1,1
    800097e8:	06952e23          	sw	s1,124(a0)
    800097ec:	fc5ff06f          	j	800097b0 <push_off+0x34>

00000000800097f0 <pop_off>:
    800097f0:	ff010113          	addi	sp,sp,-16
    800097f4:	00813023          	sd	s0,0(sp)
    800097f8:	00113423          	sd	ra,8(sp)
    800097fc:	01010413          	addi	s0,sp,16
    80009800:	ffffe097          	auipc	ra,0xffffe
    80009804:	6b0080e7          	jalr	1712(ra) # 80007eb0 <mycpu>
    80009808:	100027f3          	csrr	a5,sstatus
    8000980c:	0027f793          	andi	a5,a5,2
    80009810:	04079663          	bnez	a5,8000985c <pop_off+0x6c>
    80009814:	07852783          	lw	a5,120(a0)
    80009818:	02f05a63          	blez	a5,8000984c <pop_off+0x5c>
    8000981c:	fff7871b          	addiw	a4,a5,-1
    80009820:	06e52c23          	sw	a4,120(a0)
    80009824:	00071c63          	bnez	a4,8000983c <pop_off+0x4c>
    80009828:	07c52783          	lw	a5,124(a0)
    8000982c:	00078863          	beqz	a5,8000983c <pop_off+0x4c>
    80009830:	100027f3          	csrr	a5,sstatus
    80009834:	0027e793          	ori	a5,a5,2
    80009838:	10079073          	csrw	sstatus,a5
    8000983c:	00813083          	ld	ra,8(sp)
    80009840:	00013403          	ld	s0,0(sp)
    80009844:	01010113          	addi	sp,sp,16
    80009848:	00008067          	ret
    8000984c:	00001517          	auipc	a0,0x1
    80009850:	03450513          	addi	a0,a0,52 # 8000a880 <digits+0x48>
    80009854:	fffff097          	auipc	ra,0xfffff
    80009858:	018080e7          	jalr	24(ra) # 8000886c <panic>
    8000985c:	00001517          	auipc	a0,0x1
    80009860:	00c50513          	addi	a0,a0,12 # 8000a868 <digits+0x30>
    80009864:	fffff097          	auipc	ra,0xfffff
    80009868:	008080e7          	jalr	8(ra) # 8000886c <panic>

000000008000986c <push_on>:
    8000986c:	fe010113          	addi	sp,sp,-32
    80009870:	00813823          	sd	s0,16(sp)
    80009874:	00113c23          	sd	ra,24(sp)
    80009878:	00913423          	sd	s1,8(sp)
    8000987c:	02010413          	addi	s0,sp,32
    80009880:	100024f3          	csrr	s1,sstatus
    80009884:	100027f3          	csrr	a5,sstatus
    80009888:	0027e793          	ori	a5,a5,2
    8000988c:	10079073          	csrw	sstatus,a5
    80009890:	ffffe097          	auipc	ra,0xffffe
    80009894:	620080e7          	jalr	1568(ra) # 80007eb0 <mycpu>
    80009898:	07852783          	lw	a5,120(a0)
    8000989c:	02078663          	beqz	a5,800098c8 <push_on+0x5c>
    800098a0:	ffffe097          	auipc	ra,0xffffe
    800098a4:	610080e7          	jalr	1552(ra) # 80007eb0 <mycpu>
    800098a8:	07852783          	lw	a5,120(a0)
    800098ac:	01813083          	ld	ra,24(sp)
    800098b0:	01013403          	ld	s0,16(sp)
    800098b4:	0017879b          	addiw	a5,a5,1
    800098b8:	06f52c23          	sw	a5,120(a0)
    800098bc:	00813483          	ld	s1,8(sp)
    800098c0:	02010113          	addi	sp,sp,32
    800098c4:	00008067          	ret
    800098c8:	0014d493          	srli	s1,s1,0x1
    800098cc:	ffffe097          	auipc	ra,0xffffe
    800098d0:	5e4080e7          	jalr	1508(ra) # 80007eb0 <mycpu>
    800098d4:	0014f493          	andi	s1,s1,1
    800098d8:	06952e23          	sw	s1,124(a0)
    800098dc:	fc5ff06f          	j	800098a0 <push_on+0x34>

00000000800098e0 <pop_on>:
    800098e0:	ff010113          	addi	sp,sp,-16
    800098e4:	00813023          	sd	s0,0(sp)
    800098e8:	00113423          	sd	ra,8(sp)
    800098ec:	01010413          	addi	s0,sp,16
    800098f0:	ffffe097          	auipc	ra,0xffffe
    800098f4:	5c0080e7          	jalr	1472(ra) # 80007eb0 <mycpu>
    800098f8:	100027f3          	csrr	a5,sstatus
    800098fc:	0027f793          	andi	a5,a5,2
    80009900:	04078463          	beqz	a5,80009948 <pop_on+0x68>
    80009904:	07852783          	lw	a5,120(a0)
    80009908:	02f05863          	blez	a5,80009938 <pop_on+0x58>
    8000990c:	fff7879b          	addiw	a5,a5,-1
    80009910:	06f52c23          	sw	a5,120(a0)
    80009914:	07853783          	ld	a5,120(a0)
    80009918:	00079863          	bnez	a5,80009928 <pop_on+0x48>
    8000991c:	100027f3          	csrr	a5,sstatus
    80009920:	ffd7f793          	andi	a5,a5,-3
    80009924:	10079073          	csrw	sstatus,a5
    80009928:	00813083          	ld	ra,8(sp)
    8000992c:	00013403          	ld	s0,0(sp)
    80009930:	01010113          	addi	sp,sp,16
    80009934:	00008067          	ret
    80009938:	00001517          	auipc	a0,0x1
    8000993c:	f7050513          	addi	a0,a0,-144 # 8000a8a8 <digits+0x70>
    80009940:	fffff097          	auipc	ra,0xfffff
    80009944:	f2c080e7          	jalr	-212(ra) # 8000886c <panic>
    80009948:	00001517          	auipc	a0,0x1
    8000994c:	f4050513          	addi	a0,a0,-192 # 8000a888 <digits+0x50>
    80009950:	fffff097          	auipc	ra,0xfffff
    80009954:	f1c080e7          	jalr	-228(ra) # 8000886c <panic>

0000000080009958 <__memset>:
    80009958:	ff010113          	addi	sp,sp,-16
    8000995c:	00813423          	sd	s0,8(sp)
    80009960:	01010413          	addi	s0,sp,16
    80009964:	1a060e63          	beqz	a2,80009b20 <__memset+0x1c8>
    80009968:	40a007b3          	neg	a5,a0
    8000996c:	0077f793          	andi	a5,a5,7
    80009970:	00778693          	addi	a3,a5,7
    80009974:	00b00813          	li	a6,11
    80009978:	0ff5f593          	andi	a1,a1,255
    8000997c:	fff6071b          	addiw	a4,a2,-1
    80009980:	1b06e663          	bltu	a3,a6,80009b2c <__memset+0x1d4>
    80009984:	1cd76463          	bltu	a4,a3,80009b4c <__memset+0x1f4>
    80009988:	1a078e63          	beqz	a5,80009b44 <__memset+0x1ec>
    8000998c:	00b50023          	sb	a1,0(a0)
    80009990:	00100713          	li	a4,1
    80009994:	1ae78463          	beq	a5,a4,80009b3c <__memset+0x1e4>
    80009998:	00b500a3          	sb	a1,1(a0)
    8000999c:	00200713          	li	a4,2
    800099a0:	1ae78a63          	beq	a5,a4,80009b54 <__memset+0x1fc>
    800099a4:	00b50123          	sb	a1,2(a0)
    800099a8:	00300713          	li	a4,3
    800099ac:	18e78463          	beq	a5,a4,80009b34 <__memset+0x1dc>
    800099b0:	00b501a3          	sb	a1,3(a0)
    800099b4:	00400713          	li	a4,4
    800099b8:	1ae78263          	beq	a5,a4,80009b5c <__memset+0x204>
    800099bc:	00b50223          	sb	a1,4(a0)
    800099c0:	00500713          	li	a4,5
    800099c4:	1ae78063          	beq	a5,a4,80009b64 <__memset+0x20c>
    800099c8:	00b502a3          	sb	a1,5(a0)
    800099cc:	00700713          	li	a4,7
    800099d0:	18e79e63          	bne	a5,a4,80009b6c <__memset+0x214>
    800099d4:	00b50323          	sb	a1,6(a0)
    800099d8:	00700e93          	li	t4,7
    800099dc:	00859713          	slli	a4,a1,0x8
    800099e0:	00e5e733          	or	a4,a1,a4
    800099e4:	01059e13          	slli	t3,a1,0x10
    800099e8:	01c76e33          	or	t3,a4,t3
    800099ec:	01859313          	slli	t1,a1,0x18
    800099f0:	006e6333          	or	t1,t3,t1
    800099f4:	02059893          	slli	a7,a1,0x20
    800099f8:	40f60e3b          	subw	t3,a2,a5
    800099fc:	011368b3          	or	a7,t1,a7
    80009a00:	02859813          	slli	a6,a1,0x28
    80009a04:	0108e833          	or	a6,a7,a6
    80009a08:	03059693          	slli	a3,a1,0x30
    80009a0c:	003e589b          	srliw	a7,t3,0x3
    80009a10:	00d866b3          	or	a3,a6,a3
    80009a14:	03859713          	slli	a4,a1,0x38
    80009a18:	00389813          	slli	a6,a7,0x3
    80009a1c:	00f507b3          	add	a5,a0,a5
    80009a20:	00e6e733          	or	a4,a3,a4
    80009a24:	000e089b          	sext.w	a7,t3
    80009a28:	00f806b3          	add	a3,a6,a5
    80009a2c:	00e7b023          	sd	a4,0(a5)
    80009a30:	00878793          	addi	a5,a5,8
    80009a34:	fed79ce3          	bne	a5,a3,80009a2c <__memset+0xd4>
    80009a38:	ff8e7793          	andi	a5,t3,-8
    80009a3c:	0007871b          	sext.w	a4,a5
    80009a40:	01d787bb          	addw	a5,a5,t4
    80009a44:	0ce88e63          	beq	a7,a4,80009b20 <__memset+0x1c8>
    80009a48:	00f50733          	add	a4,a0,a5
    80009a4c:	00b70023          	sb	a1,0(a4)
    80009a50:	0017871b          	addiw	a4,a5,1
    80009a54:	0cc77663          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009a58:	00e50733          	add	a4,a0,a4
    80009a5c:	00b70023          	sb	a1,0(a4)
    80009a60:	0027871b          	addiw	a4,a5,2
    80009a64:	0ac77e63          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009a68:	00e50733          	add	a4,a0,a4
    80009a6c:	00b70023          	sb	a1,0(a4)
    80009a70:	0037871b          	addiw	a4,a5,3
    80009a74:	0ac77663          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009a78:	00e50733          	add	a4,a0,a4
    80009a7c:	00b70023          	sb	a1,0(a4)
    80009a80:	0047871b          	addiw	a4,a5,4
    80009a84:	08c77e63          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009a88:	00e50733          	add	a4,a0,a4
    80009a8c:	00b70023          	sb	a1,0(a4)
    80009a90:	0057871b          	addiw	a4,a5,5
    80009a94:	08c77663          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009a98:	00e50733          	add	a4,a0,a4
    80009a9c:	00b70023          	sb	a1,0(a4)
    80009aa0:	0067871b          	addiw	a4,a5,6
    80009aa4:	06c77e63          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009aa8:	00e50733          	add	a4,a0,a4
    80009aac:	00b70023          	sb	a1,0(a4)
    80009ab0:	0077871b          	addiw	a4,a5,7
    80009ab4:	06c77663          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009ab8:	00e50733          	add	a4,a0,a4
    80009abc:	00b70023          	sb	a1,0(a4)
    80009ac0:	0087871b          	addiw	a4,a5,8
    80009ac4:	04c77e63          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009ac8:	00e50733          	add	a4,a0,a4
    80009acc:	00b70023          	sb	a1,0(a4)
    80009ad0:	0097871b          	addiw	a4,a5,9
    80009ad4:	04c77663          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009ad8:	00e50733          	add	a4,a0,a4
    80009adc:	00b70023          	sb	a1,0(a4)
    80009ae0:	00a7871b          	addiw	a4,a5,10
    80009ae4:	02c77e63          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009ae8:	00e50733          	add	a4,a0,a4
    80009aec:	00b70023          	sb	a1,0(a4)
    80009af0:	00b7871b          	addiw	a4,a5,11
    80009af4:	02c77663          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009af8:	00e50733          	add	a4,a0,a4
    80009afc:	00b70023          	sb	a1,0(a4)
    80009b00:	00c7871b          	addiw	a4,a5,12
    80009b04:	00c77e63          	bgeu	a4,a2,80009b20 <__memset+0x1c8>
    80009b08:	00e50733          	add	a4,a0,a4
    80009b0c:	00b70023          	sb	a1,0(a4)
    80009b10:	00d7879b          	addiw	a5,a5,13
    80009b14:	00c7f663          	bgeu	a5,a2,80009b20 <__memset+0x1c8>
    80009b18:	00f507b3          	add	a5,a0,a5
    80009b1c:	00b78023          	sb	a1,0(a5)
    80009b20:	00813403          	ld	s0,8(sp)
    80009b24:	01010113          	addi	sp,sp,16
    80009b28:	00008067          	ret
    80009b2c:	00b00693          	li	a3,11
    80009b30:	e55ff06f          	j	80009984 <__memset+0x2c>
    80009b34:	00300e93          	li	t4,3
    80009b38:	ea5ff06f          	j	800099dc <__memset+0x84>
    80009b3c:	00100e93          	li	t4,1
    80009b40:	e9dff06f          	j	800099dc <__memset+0x84>
    80009b44:	00000e93          	li	t4,0
    80009b48:	e95ff06f          	j	800099dc <__memset+0x84>
    80009b4c:	00000793          	li	a5,0
    80009b50:	ef9ff06f          	j	80009a48 <__memset+0xf0>
    80009b54:	00200e93          	li	t4,2
    80009b58:	e85ff06f          	j	800099dc <__memset+0x84>
    80009b5c:	00400e93          	li	t4,4
    80009b60:	e7dff06f          	j	800099dc <__memset+0x84>
    80009b64:	00500e93          	li	t4,5
    80009b68:	e75ff06f          	j	800099dc <__memset+0x84>
    80009b6c:	00600e93          	li	t4,6
    80009b70:	e6dff06f          	j	800099dc <__memset+0x84>

0000000080009b74 <__memmove>:
    80009b74:	ff010113          	addi	sp,sp,-16
    80009b78:	00813423          	sd	s0,8(sp)
    80009b7c:	01010413          	addi	s0,sp,16
    80009b80:	0e060863          	beqz	a2,80009c70 <__memmove+0xfc>
    80009b84:	fff6069b          	addiw	a3,a2,-1
    80009b88:	0006881b          	sext.w	a6,a3
    80009b8c:	0ea5e863          	bltu	a1,a0,80009c7c <__memmove+0x108>
    80009b90:	00758713          	addi	a4,a1,7
    80009b94:	00a5e7b3          	or	a5,a1,a0
    80009b98:	40a70733          	sub	a4,a4,a0
    80009b9c:	0077f793          	andi	a5,a5,7
    80009ba0:	00f73713          	sltiu	a4,a4,15
    80009ba4:	00174713          	xori	a4,a4,1
    80009ba8:	0017b793          	seqz	a5,a5
    80009bac:	00e7f7b3          	and	a5,a5,a4
    80009bb0:	10078863          	beqz	a5,80009cc0 <__memmove+0x14c>
    80009bb4:	00900793          	li	a5,9
    80009bb8:	1107f463          	bgeu	a5,a6,80009cc0 <__memmove+0x14c>
    80009bbc:	0036581b          	srliw	a6,a2,0x3
    80009bc0:	fff8081b          	addiw	a6,a6,-1
    80009bc4:	02081813          	slli	a6,a6,0x20
    80009bc8:	01d85893          	srli	a7,a6,0x1d
    80009bcc:	00858813          	addi	a6,a1,8
    80009bd0:	00058793          	mv	a5,a1
    80009bd4:	00050713          	mv	a4,a0
    80009bd8:	01088833          	add	a6,a7,a6
    80009bdc:	0007b883          	ld	a7,0(a5)
    80009be0:	00878793          	addi	a5,a5,8
    80009be4:	00870713          	addi	a4,a4,8
    80009be8:	ff173c23          	sd	a7,-8(a4)
    80009bec:	ff0798e3          	bne	a5,a6,80009bdc <__memmove+0x68>
    80009bf0:	ff867713          	andi	a4,a2,-8
    80009bf4:	02071793          	slli	a5,a4,0x20
    80009bf8:	0207d793          	srli	a5,a5,0x20
    80009bfc:	00f585b3          	add	a1,a1,a5
    80009c00:	40e686bb          	subw	a3,a3,a4
    80009c04:	00f507b3          	add	a5,a0,a5
    80009c08:	06e60463          	beq	a2,a4,80009c70 <__memmove+0xfc>
    80009c0c:	0005c703          	lbu	a4,0(a1)
    80009c10:	00e78023          	sb	a4,0(a5)
    80009c14:	04068e63          	beqz	a3,80009c70 <__memmove+0xfc>
    80009c18:	0015c603          	lbu	a2,1(a1)
    80009c1c:	00100713          	li	a4,1
    80009c20:	00c780a3          	sb	a2,1(a5)
    80009c24:	04e68663          	beq	a3,a4,80009c70 <__memmove+0xfc>
    80009c28:	0025c603          	lbu	a2,2(a1)
    80009c2c:	00200713          	li	a4,2
    80009c30:	00c78123          	sb	a2,2(a5)
    80009c34:	02e68e63          	beq	a3,a4,80009c70 <__memmove+0xfc>
    80009c38:	0035c603          	lbu	a2,3(a1)
    80009c3c:	00300713          	li	a4,3
    80009c40:	00c781a3          	sb	a2,3(a5)
    80009c44:	02e68663          	beq	a3,a4,80009c70 <__memmove+0xfc>
    80009c48:	0045c603          	lbu	a2,4(a1)
    80009c4c:	00400713          	li	a4,4
    80009c50:	00c78223          	sb	a2,4(a5)
    80009c54:	00e68e63          	beq	a3,a4,80009c70 <__memmove+0xfc>
    80009c58:	0055c603          	lbu	a2,5(a1)
    80009c5c:	00500713          	li	a4,5
    80009c60:	00c782a3          	sb	a2,5(a5)
    80009c64:	00e68663          	beq	a3,a4,80009c70 <__memmove+0xfc>
    80009c68:	0065c703          	lbu	a4,6(a1)
    80009c6c:	00e78323          	sb	a4,6(a5)
    80009c70:	00813403          	ld	s0,8(sp)
    80009c74:	01010113          	addi	sp,sp,16
    80009c78:	00008067          	ret
    80009c7c:	02061713          	slli	a4,a2,0x20
    80009c80:	02075713          	srli	a4,a4,0x20
    80009c84:	00e587b3          	add	a5,a1,a4
    80009c88:	f0f574e3          	bgeu	a0,a5,80009b90 <__memmove+0x1c>
    80009c8c:	02069613          	slli	a2,a3,0x20
    80009c90:	02065613          	srli	a2,a2,0x20
    80009c94:	fff64613          	not	a2,a2
    80009c98:	00e50733          	add	a4,a0,a4
    80009c9c:	00c78633          	add	a2,a5,a2
    80009ca0:	fff7c683          	lbu	a3,-1(a5)
    80009ca4:	fff78793          	addi	a5,a5,-1
    80009ca8:	fff70713          	addi	a4,a4,-1
    80009cac:	00d70023          	sb	a3,0(a4)
    80009cb0:	fec798e3          	bne	a5,a2,80009ca0 <__memmove+0x12c>
    80009cb4:	00813403          	ld	s0,8(sp)
    80009cb8:	01010113          	addi	sp,sp,16
    80009cbc:	00008067          	ret
    80009cc0:	02069713          	slli	a4,a3,0x20
    80009cc4:	02075713          	srli	a4,a4,0x20
    80009cc8:	00170713          	addi	a4,a4,1
    80009ccc:	00e50733          	add	a4,a0,a4
    80009cd0:	00050793          	mv	a5,a0
    80009cd4:	0005c683          	lbu	a3,0(a1)
    80009cd8:	00178793          	addi	a5,a5,1
    80009cdc:	00158593          	addi	a1,a1,1
    80009ce0:	fed78fa3          	sb	a3,-1(a5)
    80009ce4:	fee798e3          	bne	a5,a4,80009cd4 <__memmove+0x160>
    80009ce8:	f89ff06f          	j	80009c70 <__memmove+0xfc>
	...
