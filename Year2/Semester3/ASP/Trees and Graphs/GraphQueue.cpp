#include "GraphQueue.h"

GraphQueue::~GraphQueue() {
	brisi();
}

void GraphQueue::Insert(Graph::Elem& e) {
	Elem* novi = new Elem(&e);
	if (!this->front) {
		this->front = novi;
		this->back = novi;
	}
	else {
		this->back->next = novi;
		this->back = novi;
	}
}

Graph::Elem* GraphQueue::Delete() {
	if (this->front) {
		Graph::Elem* el = this->front->el;
		Elem* tmp = this->front;
		if (this->front == this->back) this->back = nullptr; // znamo da imamo samo 1 element
		this->front = this->front->next;

		delete tmp;
		return el;
	}
	return nullptr;
}

Graph::Elem* GraphQueue::Front() const {
	return this->front->el;
}

bool GraphQueue::Empty() const {
	return this->front == nullptr;
}

int GraphQueue::NumOfEl() const {
	int num = 0;
	for (Elem* p = this->front; p; p = p->next) {
		num++;
	}
	return num;
}

void GraphQueue::brisi() {
	Elem* tren = this->front, * prev = nullptr;
	while (tren) {
		prev = tren;
		tren = tren->next;
		delete prev;
	}
	this->front = nullptr;
	this->back = nullptr;
}

ostream& operator<<(ostream& os, const GraphQueue& q) {
	for (GraphQueue::Elem* p = q.front; p; p = p->next) {
		os << p->el->info << " ";
	}
	if (q.front)os << endl;
	return os;
}

