#include <fstream>
#include <string>
#include <iostream>
#include "Tree.h"
#include "Queue.h"
#include "StringQueue.h"
#include "Stack.h"
#include "Graph.h"
#include "GraphQueue.h"

using namespace std;

void read(string ime_fajla, Tree& t) {
    ifstream f(ime_fajla);

    if (!f.is_open()) {
        cout << "Nije moguce otvoriti fajl: " << ime_fajla << endl;
        return;
    }

    string stack;
    while (getline(f, stack)) {
        t.addStack(stack);
    }

    f.close();
}

int main() {
    Queue q1;
    StringQueue sq1;
    Stack s1;
    Tree t{&q1, &sq1, &s1};
    GraphQueue gq;
    Graph g{ &gq };
    int izbor = -1;
    
    while (izbor) {
       
        cout << "==========================================" << endl
            << "0) Zavrsi program." << endl
            << "1) Ucitaj iz fajla." << endl
            << "2) Ucitaj stack." << endl
            << "3) Obrisi stack." << endl
            << "4) Isprazni stablo." << endl
            << "5) Ispisi stablo po level order poretku." << endl
            << "------------------------------------------" << endl
            << "6) Konvertuj stablo u graf." << endl
            << "7) Da li ima rekurzije?" << endl
            << "8) Ispisi graf po BFS poretku." << endl
            << "==========================================" << endl;
        cin >> izbor;
        string stack;
        string fajl;
       
        switch(izbor) {
            case 8:
                cout << g;
                break;
            case 7:
                g.checkRek();
                break;
            case 6:
                g.convertTree(t);
                break;
            case 5:
                cout << t;
                break;
            case 4:
                t.emptyTree();
                break;
            case 3:
                cout << "Napisite stack za brisanje: ";

                getline(cin, stack);
                getline(cin, stack);
                t.removeStack(stack);
                break;
            case 2:
                cout << "Napisite stack za dodavanje: ";
           
                getline(cin, stack);
                getline(cin, stack);
                t.addStack(stack);
                break;
            case 1:
                cout << "Napisite ime fajla: ";

                getline(cin, fajl);
                getline(cin, fajl);
                read(fajl, t);
                break;
            case 0: default:
                izbor = 0;
                break;
            }

    }


	return 0;
    
}
