#include "Graph.h"
#include "Queue.h"
#include "GraphQueue.h"
#include "StringQueue.h"
Graph::~Graph() {
	brisi();
}

void Graph::convertTree(Tree& t) { // konverzija stabla u graf
	if (!t.root) {
		cout << "NE POSTOJI STABLO" << endl;
		return;
	} 
	if (this->lista) { // postoji vec graf, dealociraj pa dodaj novo stablo
		brisi();
	}
	this->kap = t.getNumOfEl();
	this->lista = new Elem * [kap];
	
	Tree::Elem* p = t.root;
	Tree::Elem* granicnik = new Tree::Elem("|");
	t.q->Insert(*p);
	t.q->Insert(*granicnik);
	int tren = 0;
	bool found;
	// radimo level order sa granicnikom
	while (t.q->Front()->info != granicnik->info) {
		p = t.q->Delete();
		found = false; // da li je nadjen cvor
		
		for (int i = 0; i < this->num_of_el; i++) {
			tren = i; // cuvamo indeks elementa kojeg treba obraditi
			if (this->lista[i]->info == p->info) {
				found = true;
				break;
			}
		}
		if (!found) {// ako nije pronadjen
			tren = this->num_of_el; // to ce biti poslednji element niza
			this->lista[this->num_of_el++] = new Elem(p->info); // stavljamo header 
		}// ako je pronadjen idemo na sledecu fazu a to je ubacivanje suseda/sinova
		
		if (p->left) { // stavljamo mu sinove u queue
			t.q->Insert(*p->left); // stavljamo prvog sina
			// ubacimo prvog sina/suseda u listu
			ubaciSuseda(*p->left, tren);
			p = p->left; // ulazimo u listu sinova

			while (p->right) { // ubacujemo svu bracu u q
				t.q->Insert(*p->right);
				ubaciSuseda(*p->right, tren);
				p = p->right;
			}
		}

		if (t.q->Front()->info == granicnik->info) { // kraj nivoa
			t.q->Delete();

			t.q->Insert(*granicnik);
		}
	}
	t.q->Delete(); // skidamo granicnik
	delete granicnik;
}

bool Graph::checkRek() const {
	if (this->lista) {
		// treba obilaziti graf po bfs algoritmu, detekcijom povratne grane => 
		// ... grane koja pokazuje na svog posecenog pretka, se detektuje ciklus
		const int k = this->num_of_el; 
		bool* visit = new bool[k];// pravimo vektor visit
		for (int i = 0; i < k; i++)visit[i] = false; // inicijalizujemo visit na false za sve covorove

		visit[0] = true; // koren stavljamo na true
		this->gq->Insert(*this->lista[0]); // ubacujemo koren u red
		Elem* tmp = nullptr;
		Graph::Elem* v, * x; 
		int index = 0;
	
		while (!this->gq->Empty()) {
			v = this->gq->Delete(); // skidamo prvi element / header
			x = v->next; // sa v->next ulazimo iz niza zaglavlja u listu 
			while (x) { // dok postoji sused, tj. za svakog suseda radimo sledece
				index = 0; 
				while (x->info != this->lista[index]->info)index++; // iz liste suseda za svaki sused trazimo 
				// ... njegov index u listi zaglavlja da bismo zaglavlje ubacili u red
				if (!visit[index]) { // pozicija u listi zaglavlja i visit vektora je ista za svaki cvor
					visit[index] = true; // ako nije posecen, posecujemo ga
					
					this->gq->Insert(*this->lista[index]); // ubacujemo suseda u red
				}
				else {// dakle, cvor v->info pokazuje na posecen cvor lista[index]->info
					// da li je lista[index]->info prethodnik cvora v->info
					// pokusacemo da dokazemo da je grana povratna(poprecna) <=> ima_rekurzije(nema_rekurzije)
					
					if (nadjiPut(*lista[index], *v)) {
						// ako je nadjen put postoji ciklus
						delete[] visit;
						this->gq->~GraphQueue();
						return true;
					}
					
				}
				
				x = x->next; // predji na sledeceg suseda
			}// end_while x

		}// end_while (!this->gq->Empty())
		delete[] visit; // dealociraj vektor visit
		cout << "Nema rekurzije." << endl;
		return false; // nema ciklusa
	} 
	else {
		cout << "NE POSTOJI GRAF" << endl;
	}
}

void Graph::brisi() {
	for (int i = 0; i < this->num_of_el; i++)delete this->lista[i]->next, delete this->lista[i]; 
	delete[] this->lista;

	this->lista = nullptr;
	this->kap = 0;
	this->num_of_el = 0;
}

void Graph::ubaciSuseda(Tree::Elem& elem, int index) {
	Elem* listaSuseda = this->lista[index]->next, *prev = listaSuseda;
	if (!listaSuseda) {// ako ne postoji lista suseda, dodaj element
		this->lista[index]->next = new Elem(elem.info);
		return;
	}
	while (listaSuseda && listaSuseda->info != elem.info) {
		prev = listaSuseda; // uvek cuvamo prethodni element da bi ako dodjemo do nullptr mogli da ubacimo na kraj
		listaSuseda = listaSuseda->next;
	}
	if (!listaSuseda) { // znaci da smo odgurali do kraja i da ga nema u nizu, dodajemo na kraj
		prev->next = new Elem(elem.info);
	}else{ // ako lista suseda nije nula znaci da smo nasli podudaranje
		return;
	}
}

bool Graph::nadjiPut(Elem& pocetak, Elem& kraj) const {
	// trazimo put od cvora pocetak do cvora kraj 
	GraphQueue q;
	const int k = this->num_of_el;
	bool* visit = new bool[k];
	for (int i = 0; i < k; i++)visit[i] = false; 

	visit[0] = true; // koren stavljamo na true
	q.Insert(pocetak); // ubacujemo pocetak u red

	Graph::Elem* v, * x;
	int index = 0;

	while (!q.Empty()) {
		v = q.Delete(); 
		x = v->next; // sa v->next ulazimo iz niza zaglavlja u listu 
		while (x) { // dok postoji sused, tj. za svakog suseda radimo sledece
			if (x->info == kraj.info) {
				cout << "Pronadjena rekurzija izmedju cvora [" << pocetak.info << "] i [" << kraj.info << "]." << endl;
				delete[] visit; // dealociraj vektor visit
				return true; 
			}
			if (x->info == v->info) { // rekurzija na samog sebe
				cout << "Pronadjena rekurzija izmedju cvora [" << pocetak.info << "] i [" << pocetak.info << "]." << endl;
				delete[] visit;
				return true;
			}
			index = 0;
			while (x->info != this->lista[index]->info)index++; // iz liste suseda za svaki sused trazimo 
			// ... njegov index u listi zaglavlja da bismo zaglavlje ubacili u red
			if (!visit[index]) { // pozicija u listi zaglavlja i visit vektora je ista za svaki cvor
				visit[index] = true; // ako nije posecen, posecujemo ga
				q.Insert(*this->lista[index]); // ubacujemo suseda u red
			}
			x = x->next; // predji na sledeceg suseda
		}// end_while x

	}// while (!q.Empty())
	delete[] visit; // dealociraj vektor visit
	return false; // nije nadjen put 
}

ostream& operator<<(ostream& os, const Graph& g) {
	// koriscenje BFS algoritma sa granicnikom za ispis
	if (g.lista) {

		const int k = g.num_of_el;
		bool* visit = new bool[k];
		for (int i = 0; i < k; i++) {
			visit[i] = false;
		}
		visit[0] = true;

		Graph::Elem* granicnik = new Graph::Elem("|");
		g.gq->Insert(*g.lista[0]);
		g.gq->Insert(*granicnik);
		Graph::Elem* v, * x;
		int index = 0;
		while (g.gq->Front()->info != granicnik->info){
			v = g.gq->Delete();
			x = v->next; // lista suseda
			os << v->info << "[";
			while (x) {
				index = 0;
				while (x->info != g.lista[index]->info)index++; // trazimo index za visit vektor
				if (!visit[index]) {
					visit[index] = true;
					g.gq->Insert(*g.lista[index]);
				}
				os << x->info; if (x->next) os << ", ";
				x = x->next;
			}os << "] ";

			if (g.gq->Front()->info == granicnik->info) {
				g.gq->Delete();
				os << endl;
				g.gq->Insert(*granicnik);

			}
		}
		g.gq->Delete(); // skidamo granicnik
		delete[] visit;
		delete granicnik;
	}
	else {
		os << "NE POSTOJI GRAF" << endl;
	}
	
	return os;
}
