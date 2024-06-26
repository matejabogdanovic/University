#ifndef _graph_h_
#define _graph_h_
#include"Tree.h"

class GraphQueue;

class Graph {
public:
	friend class GraphQueue;
	Graph(GraphQueue* gqq) : gq(gqq){};
	Graph(const Graph&) = delete;
	Graph& operator=(const Graph&) = delete;
	~Graph();
	friend ostream& operator<<(ostream&, const Graph&);
	void convertTree(Tree&);
	bool checkRek() const;
private:
	GraphQueue* gq;
	struct Elem {
		string info;
		Elem* next;
		Elem(const string& i, Elem* n = nullptr) : info(i), next(n) {}
	};
	Elem** lista;
	int kap = 0;
	int num_of_el = 0;
	void brisi();
	void ubaciSuseda(Tree::Elem&, int);
	bool nadjiPut(Elem&, Elem&) const;

};

#endif // !_graph_h_
