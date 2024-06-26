#include "Stack.h"

Stack::~Stack() {
	brisi();
}

Tree::Elem* Stack::Pop() {
	if (!this->stack_pointer) {
		return nullptr;
	}
	Elem* tren = this->stack_pointer;
	this->stack_pointer = this->stack_pointer->next;
	Tree::Elem* el = tren->funkcija;
	delete tren;
	return el;
}

Tree::Elem* Stack::Top() const {
	return (this->stack_pointer ? this->stack_pointer->funkcija : nullptr);
}

bool Stack::Empty() const {
	return this->stack_pointer == nullptr ;
}

int Stack::NumOfEl() const {
	int num = 0;
	for (Elem* p = this->stack_pointer; p ; p = p->next) {
		num++;
	}
	return num;
}

void Stack::Push(Tree::Elem& e) {
	this->stack_pointer = new Elem(&e, this->stack_pointer);
}

void Stack::brisi() {
	Elem* tren = this->stack_pointer, *prev = nullptr;
	while (tren) {
		prev = tren;
		tren = tren->next;
		delete prev;
	}
	this->stack_pointer = nullptr;
}

ostream& operator<<(ostream& os, const Stack& s) {
	if (!s.stack_pointer)return os << "Prazan stack." << endl;
	for (Stack::Elem* p = s.stack_pointer; p; p = p->next) {
		os << p->funkcija->info;
		if (p == s.stack_pointer)os << "\t<-SP";
		os << endl;
	}
	os << "---dno steka---" << endl;
	return os;
}
