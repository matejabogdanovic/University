//
// Created by os on 5/17/24.
//

#ifndef PROJECT_BASE_LIST_SORTED_HPP
#define PROJECT_BASE_LIST_SORTED_HPP
#include "../inc/MemoryAllocator.hpp"
template<typename T, typename P>
class ListSorted {
private:
    friend class _thread;

    struct Elem {
        T *data; P* param;
        Elem *next;

        Elem(T *data, P* param, Elem *next = nullptr) : data(data), param(param), next(next) {}

        void *operator new(size_t size) {
            return MemoryAllocator::instance().malloc(size);
        }

        void operator delete(void *chunk) {
            MemoryAllocator::instance().free(chunk);
        }

        void *operator new[](size_t size) {
            return MemoryAllocator::instance().malloc(size);
        }

        void operator delete[](void *chunk) {
            MemoryAllocator::instance().free(chunk);
        }
    };

    Elem *head;

public:

    ListSorted() : head(0) {}

    ListSorted(const ListSorted<T, P> &) = delete;

    ListSorted<T, P> &operator=(const ListSorted<T, P> &) = delete;


    void add(T* data, P* param){

        Elem* h = head, *prev = nullptr;
        while (h && h->param <= param){
            prev = h;
            h = h->next;
        }

        Elem* el = new Elem(data, param, h);
        if(!prev) // first
            head = el;
        else // last and in between
            prev->next = el;


    }

    T* removeFirst(){
        if (!head) { return 0; }

        Elem *el = head;
        head = head->next;

        T *ret = el->data;
        delete el;
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
        // there is at least 1 element now
        Elem *prev = 0;
        for (Elem *h = head;h ; prev = h, h = h->next);
        if(prev == head){ // it's first element
            head = prev->next;
        }
        T* data = prev->data;
        delete prev;
        return data;

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
#endif //PROJECT_BASE_LIST_SORTED_HPP
