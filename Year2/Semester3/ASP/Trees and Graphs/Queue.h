#ifndef _queue_h_
#define _queue_h_
#include <string>
#include <iostream>
#include "Tree.h"
using namespace std;

class Queue {
public:

	Queue() {};
	Queue(const Queue&) = delete;
	Queue& operator=(const Queue&) = delete;

	~Queue();
	friend ostream& operator<<(ostream&, const Queue&);

	void Insert(Tree::Elem&);
	Tree::Elem* Delete();
	Tree::Elem* Front() const;
	bool Empty() const;
	int NumOfEl() const;

private:
	struct Elem {
		Tree::Elem* el;
		Elem* next;
		Elem(Tree::Elem* e, Elem* n = nullptr) : el(e), next(n) {};
	};
	Elem* front = nullptr;
	Elem* back = nullptr;

	void brisi();
};

#endif // !_queue_h_

