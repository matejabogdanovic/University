//
// Created by os on 4/30/24.
//

#ifndef PROJECT_BASE_SYSID_HPP
#define PROJECT_BASE_SYSID_HPP

enum sysID : uint64{
    MEM_ALLOC = 0x01,
    MEM_FREE = 0x02,
    THREAD_CREATE = 0x11,
    THREAD_EXIT = 0x12,
    THREAD_DISPATCH = 0x13,
    SEM_OPEN = 0x21,
    SEM_CLOSE = 0x22,
    SEM_WAIT = 0x23,
    SEM_SIGNAL = 0x24,
    SEM_TIMEDWAIT = 0x25,
    SEM_TRYWAIT = 0x26,
    TIME_SLEEP = 0x31,
    GET_C = 0x41,
    PUT_C = 0x42,
    CHANGE_MODE = 0x99
};

#endif //PROJECT_BASE_SYSID_HPP
