#ifndef _stack_h_
#define _stack_h_
#include <iostream>
#include <string>
#include "Tree.h"
using namespace std;

class Stack {
public:
	Stack() {};
	Stack(const Stack&) = delete;
	Stack& operator=(const Stack&) = delete;

	~Stack();
	friend ostream& operator<<(ostream&, const Stack&);

	void Push(Tree::Elem&);
	Tree::Elem* Pop();
	Tree::Elem* Top() const;
	bool Empty() const;
	int NumOfEl() const;
private:
	struct Elem {
		Tree::Elem* funkcija;
		Elem* next;
		Elem(Tree::Elem* f, Elem* n=nullptr) : funkcija(f), next(n) {};
	};
	Elem* stack_pointer = nullptr;

	void brisi();
};

#endif // !_stack_h_


