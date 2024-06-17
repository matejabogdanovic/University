//
// Created by os on 4/29/24.
//

#ifndef PROJECT_BASE_Handlers_HPP
#define PROJECT_BASE_Handlers_HPP



class Handlers {
public:
    static void trapHandler(); // extern .S function
    static void yieldHandler();
private:
    static void handleSyscalls(); // SWITCH between syscalls
    static int handleTimer();
    static int handleConsole();
};


#endif //PROJECT_BASE_Handlers_HPP
