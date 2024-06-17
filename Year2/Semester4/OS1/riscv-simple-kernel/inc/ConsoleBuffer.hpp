//
// Created by os on 5/20/24.
//

#ifndef PROJECT_BASE_CONSOLEBUFFER_HPP
#define PROJECT_BASE_CONSOLEBUFFER_HPP

#include "../inc/syscall_c.hpp"

class ConsoleBuffer {
private:
    int cap;
    char *buffer;
    int head, tail;

    _sem* spaceAvailable;
    _sem* itemAvailable;


public:
    ConsoleBuffer(int _cap = 256);
    ~ConsoleBuffer();

    void put(char val);
    char get();

    int getCnt();
};


#endif //PROJECT_BASE_CONSOLEBUFFER_HPP
