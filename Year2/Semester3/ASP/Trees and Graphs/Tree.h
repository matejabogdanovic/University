#ifndef _tree_h_
#define _tree_h_
#include <string>
#include <iostream>
#include <sstream>
using namespace std;

class Queue;
class StringQueue;
class Stack;
class Tree {
public:
	friend class Queue;
	friend class Stack;
	friend class Graph;
	Tree(Queue* qq, StringQueue* sqq, Stack* ss) : q(qq), sq(sqq), s(ss) {};
	Tree(const Tree&) = delete;
	Tree& operator=(const Tree&) = delete;

	~Tree();
	void addStack(const string&);
	void removeStack(const string&);
	friend ostream& operator<<(ostream&, const Tree&);

	void emptyTree();
	int getNumOfEl() const;
private:
	Queue* q;
	StringQueue* sq;
	Stack* s;
	int num_of_el = 0;
	struct Elem {
		string info;
		Elem* left;
		Elem* right;
		Elem(const string& i, Elem* l = nullptr, Elem* r = nullptr) : info(i), left(l), right(r) {}
	};
	Elem* root = nullptr;

	void brisiStack();
	void dodajStack();
	void brisi();
};


#endif // !_tree_h_



