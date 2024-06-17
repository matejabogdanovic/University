//
// Created by os on 5/20/24.
//

#include "../inc/_console.hpp"
#include "../inc/riscv.hpp"

/*
Prekid od konzole je realizovan kao spoljašnji hardverski prekid. Postoji kontroler
prekida preko kog se može dobiti informacija o tome koji uređaj je generisao prekid. Za
to služi C funkcija plic_claim čija je deklaracija data u zaglavlju hw.inc . Povratna
vrednost ove funkcije je broj prekida. Prekid od konzole ima broj 10 ( 0x0a ). Nakon
obrade prekida, kontroler prekida treba obavestiti da je prekid obrađen i to putem
funkcije plic_complete čija je deklaracija data u zaglavlju hw.inc . Jedini parametar ove
funkcije je broj prekida koji je obrađen.
*/

ConsoleBuffer* _console::putcBuffer;
ConsoleBuffer* _console::getcBuffer;

void _console::putcHandle(void* arg) {
    while(true) {

        while (*((char *) CONSOLE_STATUS) & CONSOLE_TX_STATUS_BIT) {
            char c = (char) putcBuffer->get();

            *((char *) CONSOLE_TX_DATA) = c;

        }
    }


}

void _console::getcHandle() {
    if(plic_claim() != CONSOLE_IRQ)return; // not console interrupt?

    while (*((char *) CONSOLE_STATUS) & CONSOLE_RX_STATUS_BIT) {

        char c = *((char *) CONSOLE_RX_DATA);
        if((int)c == 13) // INTERPRET ENTER AS \n (ASCII 13 <=> Carriage Return)
            c = '\n';

        getcBuffer->put(c);

    }

    plic_complete(CONSOLE_IRQ);

}



void _console::putcS(uint64 c) {

   while(!(*(char *) CONSOLE_STATUS & CONSOLE_TX_STATUS_BIT)) {
        /* busy wait */
    }
    *((char *) CONSOLE_TX_DATA) = (char) c;
}







