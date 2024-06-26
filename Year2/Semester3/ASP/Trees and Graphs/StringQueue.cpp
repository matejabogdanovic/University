#include "StringQueue.h"

StringQueue::~StringQueue() {
	brisi();
}

void StringQueue::Insert(const string& e) {
	Elem* novi = new Elem(e);
	if (!this->top) {
		this->top = novi;
		this->bottom = novi;
	}
	else {
		this->bottom->next = novi;
		this->bottom = novi;
	}
}

string StringQueue::Delete() {
	if (this->top) {
		string el = this->top->str;
		Elem* tmp = this->top;
		if (this->top == this->bottom) this->bottom = nullptr; // znamo da imamo samo 1 element
		this->top = this->top->next;

		delete tmp;
		return el;
	}
	return "";
}

string StringQueue::Top() const {
	return this->top->str;
}

bool StringQueue::Empty() const {
	return this->top == nullptr;
}

void StringQueue::brisi() {
	Elem* tren = this->top, * prev = nullptr;
	while (tren) {
		prev = tren;
		tren = tren->next;
		delete prev;
	}
	this->top = nullptr;
	this->bottom = nullptr;
}

ostream& operator<<(ostream& os, const StringQueue& q) {
	for (StringQueue::Elem* p = q.top; p; p = p->next) {
		os << p->str << " ";
	}
	if (q.top)os << endl;
	return os;
}
