#ifndef _stringqueue_h_
#define _stringqueue_h_
#include <string>
#include <iostream>

using namespace std;

class StringQueue {
public:

	StringQueue() {};
	StringQueue(const StringQueue&) = delete;
	StringQueue& operator=(const StringQueue&) = delete;

	~StringQueue();
	friend ostream& operator<<(ostream&, const StringQueue&);

	void Insert(const string&);
	string Delete();
	string Top() const;
	bool Empty() const;


private:
	struct Elem {
		string str;
		Elem* next;
		Elem(const string& s, Elem* n = nullptr) : str(s), next(n) {};
	};
	Elem* top = nullptr;
	Elem* bottom = nullptr;

	void brisi();
};

#endif // !_stringqueue_h_

