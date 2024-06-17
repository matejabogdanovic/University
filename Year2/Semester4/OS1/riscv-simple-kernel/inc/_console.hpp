//
// Created by os on 5/20/24.
//

#ifndef PROJECT_BASE__CONSOLE_HPP
#define PROJECT_BASE__CONSOLE_HPP
#include "../lib/hw.h"
#include "../inc/ConsoleBuffer.hpp"
class _console {
public:


    static void putcHandle(void* );
    static void getcHandle();




    static void putcS(uint64 c);

    static ConsoleBuffer* getcBuffer;
    static ConsoleBuffer* putcBuffer;
};


#endif //PROJECT_BASE__CONSOLE_HPP
