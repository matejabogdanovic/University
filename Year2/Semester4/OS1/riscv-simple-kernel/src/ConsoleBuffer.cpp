//
// Created by os on 5/20/24.
//

#include "../inc/ConsoleBuffer.hpp"
#include "../inc/_sem.hpp"

ConsoleBuffer::ConsoleBuffer(int _cap) : cap(_cap + 1), head(0), tail(0) {
    buffer = (char *)mem_alloc(sizeof(char) * cap);

    sem_open(&itemAvailable, 0);
    sem_open(&spaceAvailable, _cap);

}

ConsoleBuffer::~ConsoleBuffer() {


    while (getCnt()) {
        head = (head + 1) % cap;
    }

    mem_free(buffer);
    sem_close(itemAvailable);
    sem_close(spaceAvailable);

}

void ConsoleBuffer::put(char val) {

    spaceAvailable->semWait();


    buffer[tail] = val;
    tail = (tail + 1) % cap;


    itemAvailable->semSignal();

}

char ConsoleBuffer::get() {

    itemAvailable->semWait();



    char ret = buffer[head];
    head = (head + 1) % cap;


    spaceAvailable->semSignal();

    return ret;
}

int ConsoleBuffer::getCnt() {
    int ret;

    if (tail >= head) {
        ret = tail - head;
    } else {
        ret = cap - head + tail;
    }



    return ret;
}

