//
// Created by marko on 20.4.22..
//

#ifndef OS1_VEZBE07_RISCV_CONTEXT_SWITCH_1_SYNCHRONOUS_LIST_HPP
#define OS1_VEZBE07_RISCV_CONTEXT_SWITCH_1_SYNCHRONOUS_LIST_HPP
#include "../inc/MemoryAllocator.hpp"
template<typename T>
class List
{
private:
    friend class _thread;
    struct Elem
    {
        T *data;
        Elem *next;

        Elem(T *data, Elem *next) : data(data), next(next) {}

        void* operator new(size_t size){
            return MemoryAllocator::instance().malloc(size);
        }
        void operator delete(void* chunk){
            MemoryAllocator::instance().free(chunk);
        }
        void* operator new[](size_t size){
            return MemoryAllocator::instance().malloc(size);
        }
        void operator delete[](void* chunk){
            MemoryAllocator::instance().free(chunk);
        }
    };

    Elem *head, *tail;

public:

    List() : head(0), tail(0) {}

    List(const List<T> &) = delete;

    List<T> &operator=(const List<T> &) = delete;

    void addFirst(T *data)
    {
        Elem *elem = new Elem(data, head);
        head = elem;
        if (!tail) { tail = head; }
    }

    void addLast(T *data)
    {
        Elem *elem = new Elem(data, 0);
        if (tail)
        {
            tail->next = elem;
            tail = elem;
        } else
        {
            head = tail = elem;
        }
    }

    T *removeFirst()
    {
        if (!head) { return 0; }

        Elem *elem = head;
        head = head->next;
        if (!head) { tail = 0; }

        T *ret = elem->data;
        delete elem;
        return ret;
    }

    T *peekFirst()
    {
        if (!head) { return 0; }
        return head->data;
    }

    T *removeLast()
    {
        if (!head) { return 0; }

        Elem *prev = 0;
        for (Elem *curr = head; curr && curr != tail; curr = curr->next)
        {
            prev = curr;
        }

        Elem *elem = tail;
        if (prev) { prev->next = 0; }
        else { head = 0; }
        tail = prev;

        T *ret = elem->data;
        delete elem;
        return ret;
    }

    T *peekLast()
    {
        if (!tail) { return 0; }
        return tail->data;
    }

    bool remove(T* data){
        Elem* h = this->head, *prev = nullptr;
        for (; h ; prev = h, h = h->next) {
            if(h->data == data)break;
        }
        if(!h) return false;
        if(!prev) // it's first el
            return removeFirst()!= nullptr;
        if(!h->next) // it's last
            return removeLast()!= nullptr;
        // it's in between

        prev->next = h->next;
        //inc->next = nullptr;
        delete h;
        return true;
    }

};

#endif //OS1_VEZBE07_RISCV_CONTEXT_SWITCH_1_SYNCHRONOUS_LIST_HPP
