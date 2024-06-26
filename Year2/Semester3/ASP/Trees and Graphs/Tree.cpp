#include "Queue.h"
#include "StringQueue.h"
#include "Stack.h"

Tree::~Tree() {
	brisi();
}

void Tree::addStack(const string& stack) {
	// ovo je funkcija koja se poziva kad se dodaje nov stek
	// ucitavanje iz fajla se vrsi preko ove funkcije tako sto se ucitava stek po stek

	stringstream stream(stack);
	string func;
	while (getline(stream, func, ' ')) {
		// napunimo StringQueue sa funkcijama sa steka
		sq->Insert(func);
	}
	if (!this->root) { this->root = new Elem(sq->Delete()); this->num_of_el++; } // postavljanje korena
	else {
		if (sq->Top() != this->root->info) { // na vrhu sq ce biti funkcija sa dna steka
			// ovde proveravamo da li je uopste ista pocetna main funkcija
			// posto je ovo stablo, mora imati samo jedan koren
			cout << "NE MOZETE DODATI NOVI KOREN" << endl;
			sq->~StringQueue(); // pozivamo destruktor StringQueue da bi se ocistio
			return;
		}
		sq->Delete(); // brisem main iz reda jer je obradjen
	}// obrisi koren jer je uvek isti?

	dodajStack();// ako je sve u redu pozivamo funkciju za dodavanje

}

void Tree::removeStack(const string& stack) {
	// prvo provera jel uopste postoji stablo
	if (!this->root) { cout << "NE POSTOJI STABLO" << endl; return; }
	stringstream stream(stack);
	string func;
	while (getline(stream, func, ' ')) {
		// opet punimo StringQueue
		sq->Insert(func);
	}
	if (sq->Top() == this->root->info) {
		// ima smisla krenuti da brisemo stek ako su
		//... main/pocetne funkcije iste
		brisiStack();
	}
	else {// slucaj kad je root main a prva funkcija u steku nije main
		sq->~StringQueue();
		cout << "ZADAT NEPOSTOJECI STEK (pocetna funkcija ne postoji)" << endl;
	}
}

void Tree::emptyTree() {
	brisi(); // hocemo da uradimo isto sto i destruktor
}

int Tree::getNumOfEl() const {
	return this->num_of_el;
}

void Tree::brisiStack() {
	// isti nacin kao pri dodavanju steka, obilazi stablo i na stek stavlja putanju kojom ide
	sq->Delete(); // sklanjamo koren  
	s->Push(*this->root); // stavljamo koren na stek
	
	if (sq->Empty()) { // slucaj kad je samo main, posto smo main skinuli iz reda
		if (this->root->left) { // provera da li main ima decu, ako ima onda nista
			cout << "NIJE STEK VEC SAMO PUTANJA" << endl;
			sq->~StringQueue(); // praznimo strukture
			s->~Stack();
			return;
		}// za slucaj da je dat stack = main, i utvrdili smo da je stablo samo main
		delete this->root; // dealociramo jedini cvor u stablu
		this->root = nullptr;
		this->num_of_el = 0;
		sq->~StringQueue();
		s->~Stack();
		return;
	}
	Elem* p = this->root, * x;
	string func;
	while (!sq->Empty()) { 

		func = sq->Delete();
		if (p->left) { // da li postoje sinovi
			p = p->left; // ulazimo u listu sinova
			x = p; // tmp promenljiva
			while (x) {
				if (x->info == func) { // nadjen cvor
					p = x;
					s->Push(*p); // stavljanje nadjenog cvora na stek (pamtimo putanju)
					if (sq->Empty() && p->left) {// ako je ovo poslednji element ali ima sinova onda nije stek vec samo putanja
						// znaci nema elemenata iz datog steka ali ipak poslednji element ima sinova, znaci ne sme da se brise nista
						cout << "NIJE STEK VEC SAMO PUTANJA" << endl;
						sq->~StringQueue();
						s->~Stack();
						return;
					}
					break;
				}
				p = x; // ...

				x = x->right; // ...
			}
			if (!x) { // ako x izadje iz liste sinova to znaci da ne postoji data funkcija u stablu na ovoj putanji
				cout << "NE POSTOJI STEK" << endl;
				sq->~StringQueue();
				s->~Stack();
				return;
			}

		}
		else {// ako nema levo, odnosno, nema sinova, znamo da je dato vise elemenata nego ocekivano
			// jer samo poslednji element/list nece imati sinova
			cout << "NE POSTOJI STEK (vise elemenata nego ocekivano)" << endl;
			sq->~StringQueue();
			s->~Stack();
			return;
		}
	}// sad u redu q imamo putanju od korena do lista, tj. imamo sve cvorove datog steka
	// na ovom putu treba naci oca od cvora sa najmanjom dubinom tako da svaki cvor na daljem putu ima iskljucivo po jednog sina
	// na steku imamo obrnutu putanju naseg datog steka za brisanje, prvi element je dakle funkcija koja je snimila stek/list

	Elem* prev, * tren;
	// sa steka skidamo trenutni element tren a cuvamo sledeci element, tj njegog oca, ali ne skidamo ga sa steka
	while (true) {
		tren = s->Pop(); // sin 
		prev = s->Top(); // otac
		if (!prev) { // uslov kad mozemo iskociti - kad je otac nullptr tad nam je sin ustvari koren stabla
			if (!tren->left) {// ako nema nista u stablu obrisi i koren
				delete tren; // tren je koren, pa ako nema sinova brisemo ga
				this->num_of_el = 0;
				this->root = nullptr;
			}
			s->~Stack();
			break;
		}
		if (tren->left) { // ako trenutni ima sina, zavrsavamo jer smo obrisali sve sto se sme
			s->~Stack();
			break;
		}
		if (prev->left->info == tren->info) {// slucaj kad je tren na pocetku liste
			// ako tren ima bracu hocemo da otac pokazuje na brata od tren 
			prev->left = tren->right;
			this->num_of_el--;
			delete tren;
			
		}
		else {
			// slucaj kad je tren u sredini liste, jer otac ne pokazuje direktno na tren
			Elem* tmp = prev->left; // prev->left je lista sinova
			while (tmp->right->info != tren->info) {
				// hocemo da nadjemo pokazivac na tren sa leve strane to je brat -> tren pokazivac 
				if (!tmp->right) break; // necemo da tmp bude 0, u najgorem slucaju tmp = tren
				tmp = tmp->right;
			}
			tmp->right = tren->right; // obicno odvezivanje iz liste preskacemo tren preko brata
			this->num_of_el--;
			delete tren;
		}
	}
}

void Tree::dodajStack() {
	Elem* p = this->root, * x; // krecemo od p=main
	string func;
	while (!sq->Empty()) {// praznimo string queue
		func = sq->Delete(); // skidamo funkcije sa queue
		if (p->left) { // zbog usvojene strukture, levo od cvora se nalaze sinovi a desno braca, ovde proveravamo jel cvor ima sinove
			p = p->left; // ako postoje sinovi/sin, ulazimo u tu listu
			// hocemo da nadjemo da li se neki sin podudara sa nasom func
			x = p; // pomocna promenljiva
			while (x) {
				if (x->info == func) { // nadjeno podudaranje
					p = x; // u sledecoj iteraciji krecemo od ovog cvora
					break;
				}
				p = x; // x ide ispred p. x moze postati 0 
				//... i postace 0 kad medju sinovima nema func 
				x = x->right;
			}
			if (!x) { // ... to je ovaj slucaj, treba dodati func
				this->num_of_el++;
				p->right = new Elem(func);
				p = p->right; // p je novi dodati element
			}

		}
		else { // ako cvor nema sinove onda mu pravimo sina jer znamo da trenutna funkcina func je u odnosu
			//... sin roditelj, tj. func je sin od p
			this->num_of_el++;
			p->left = new Elem(func);
			p = p->left; // nastavljamo od proslog dodatog cvora
			//... u ovom slucaju je to novi dodati sin
		}
	}
}

void Tree::brisi() {
	// brisanje je po level orderu. 
	if (!this->root) { // ako ne postoji root tj prazno stablo
		return;
	}
	Elem* p = this->root;

	this->q->Insert(*p); // ubacujemo koren u red
	while (!q->Empty()) {
		p = q->Delete(); // skine se element
		if (p->left) { // upise se levi pokazivac
			q->Insert(*p->left);
		}
		if (p->right) { // upise se desni pokazivac
			q->Insert(*p->right);
		}
		// buduci da smo oba pokazivaca upisali, nista necemo izgubiti ako odmah dealociramo
		delete p;
	}
	// dealociramo alocirano
	this->num_of_el = 0;
	this->root = nullptr;
}

ostream& operator<<(ostream& os, const Tree& t) {
	if (t.root) {
		// primena level ordera sa granicnikom da bismo ispisali
		//... stablo po nivoima. isto kao brisanje
		Tree::Elem* p = t.root;
		Tree::Elem* granicnik = new Tree::Elem("|");
		t.q->Insert(*p);
		t.q->Insert(*granicnik);
		//int level = 0;

		while (t.q->Front()->info != granicnik->info) {// bez granicnika samo uslov not empty
			p = t.q->Delete();

			os << p->info; // ispisujemo element
			if (p->left) { // ako p ima sinova
				t.q->Insert(*p->left); // stavljamo prvog sina
				os << "[" << p->left->info;
				p = p->left; // ulazimo u listu sinova
				while (p->right) { // ubacujemo svu bracu u q
					t.q->Insert(*p->right);
					os << ", " << p->right->info;
					p = p->right;
				}
				os << "] ";
			}
			else os << "[] ";
			

			if (t.q->Front()->info == granicnik->info) { // kraj nivoa
				t.q->Delete();
				//os << "level" << level++ << endl; // kazemo koji je nivo
				os << endl;
				t.q->Insert(*granicnik);
			}
		}
		t.q->Delete(); // skidamo granicnik
		delete granicnik;
	}
	else {
		os << "NEMA STABLA ZA ISPIS" << endl;
	}
	
	return os;
}