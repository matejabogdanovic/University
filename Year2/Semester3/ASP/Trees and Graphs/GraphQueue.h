#ifndef _graphqueue_h_
#define _graphqueue_h_
#include <string>
#include <iostream>
#include "Graph.h"
using namespace std;

class GraphQueue {
public:

	GraphQueue() {};
	GraphQueue(const Queue&) = delete;
	GraphQueue& operator=(const Queue&) = delete;

	~GraphQueue();
	friend ostream& operator<<(ostream&, const GraphQueue&);

	void Insert(Graph::Elem&);
	Graph::Elem* Delete();
	Graph::Elem* Front() const;
	bool Empty() const;
	int NumOfEl() const;

private:
	struct Elem {
		Graph::Elem* el;
		Elem* next;
		Elem(Graph::Elem* e, Elem* n = nullptr) : el(e), next(n) {};
	};
	Elem* front = nullptr;
	Elem* back = nullptr;

	void brisi();
};

#endif // !_graphqueue_h_

