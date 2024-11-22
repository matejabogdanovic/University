//  Постоји тоалет капацитета N (N > 1) који могу да користе
// жене, мушкарци, деца и домар (Single Bathroom Problem) такав да важе
// следећа правила коришћења: у исто време у тоалету не могу наћи и
// жене и мушкарци; деца могу да деле тоалет и са женама и са
// мушкарцима; дете може да се нађе у тоалету само ако се тамо налази
// барем једна жена или мушкарац; домар има ексклузивно право
// коришћења тоалета. Написати монитор са signal and wait дисциплином
// који решава дати проблем, као и главне програме за мушкарце, жене,
// децу и домаре, кроз које су дати примери коришћења мониторских
// процедура.

// ukratko: Cim domar dodje ili suprotni pol, niko ne moze da udje u wc. Mogu samo da izadju.
// ako domara nema, onaj ko prvi dodje ulazi. Pusta decu a deca pustaju njih i tako
// naizmenicno (pusta se svoja sorta ako nema one sa kojom si u wcu).

void enterRepairman(){
    if(ako je bilo ko u wc)
      cekaj.

    r++;
  }
  void exitRepairman(){
    pusti zene ili muskarce da nema izgladnjivanja
  }

 void enterX(){ 
    if(ako su u wc: suprotni ili domar ili ako nema mesta ili ako domar ceka da udje)
      blokiraj se.
    x++;
        
    if(ako je pun wc ili domar ceka ili suprotni pol ceka, ne pustaj nikog da udje vise)
      return;

    if(ako ceka dete) // pusti dete
      pusti dete
    else if(ako ceka moj pol) // pusti muskarca
      pusti moj pol
  }
  void exitX(){
    if(ako ima dece a ti si poslednji)
      cekaj da dete izadje. blokiraj se.
    x--;

    if(ako si poslednji){
      if(ako ceka domar)
        pusti ga
      else if(ako ceka suprotni) 
        pusti suprotni
      else if(ako ceka tvoj)
        pusti tvoje
    }
  }
  void enterChild(){
    if(ako nema muskaraca ili zene ili ako domar je u wc ili ako ceka ili ako nema mesta u wc)
      cekaj.
    c++;

    if(ako je pun wc ili domar ceka ili ako ceka suprotni pol od onog koji me je pustio, ne pustaj nikog da udje vise)
      return;

    if(ako su me pustile zene u wc) 
      pusti zene
    else if(ako su me pustili muskarci u wc)
      pusti muskarce
    else if(ako ima dece) // pusti dete
      pusti decu
  }

  void exitChild(){
    c--;
    if(ako neko ceka da izadjem)
      pusti ga
    else if(ako domar ne ceka i ako su me pustile zene u wc) 
      pusti zene
    else if(ako domar ne ceka i ako su me pustili muskarci u wc)
      pusti muskarce
    
  }
monitor Bathroom{
  const int N = ...;
  int m = 0, w = 0, r = 0, c = 0;
  int turn = 0; // 0 - musko, 1 - zensko
  cond qm, qw, qr, qc;  
  cond exit;
  
  void enterRepairman(){
    if(m > 0 || w > 0 || c > 0)
      qr.wait();
    r++;
  }
  void exitRepairman(){
    if(qm.queue() && (turn == 0 || turn == 1 && qw.empty())) // muski
      {qm.signal();}
    else if(qw.queue() && (turn == 1|| turn == 0 && qm.empty()))
      {qw.signal();}
  }

  void enterMan(){ 
    if(w > 0 || r > 0 || qr.queue() || qw.queue() || w+m+c == N)
      qm.wait();
    m++;
        
    if(w+m+c == N || qr.queue() || qw.queue())
      return;

    if(qc.queue()) // pusti dete
      qc.signal();
    else if(mq.queue()) // pusti muskarca
      mq.signal();
  }
  void exitMan(){
    if(m == 1 && c > 0)
      exit.wait(); // cekaj da izadje dete
    m--;

    if(m == 0){
      if(qr.queue())
        qr.signal(); // domar
      else if(qw.queue()) 
        qw.signal(); // zene
      else if(qm.queue())
        qm.signal(); // muski
    }
  }
  void enterWoman(){
    if(m > 0 || r > 0 || qr.queue() || qm.queue() || w+m+c == N)
      qw.wait();
    w++;

    if(w+m+c == N || qr.queue() || qm.queue())
      return;

    if(qc.queue()) // pusti dete
      qc.signal();
    else if(mw.queue()) // pusti zenu
      mw.signal();

  }
  void exitWoman(){
    if(w == 1 && c > 0)
      exit.wait();
    w--;
    if(w == 0){
      if(qr.queue())
        qr.signal(); // domar
      else if(qm.queue()) 
        qm.signal(); // muski
      else if(qw.queue())
        qw.signal(); // zene
    }
  }
  void enterChild(){
    if(m == 0 && w == 0 || r > 0 || qr.queue() || w+m+c == N)
      qc.wait();
    c++;

    if(w+m+c == N || qr.queue() || m > 0 && wq.queue() || w > 0 && mq.queue())
      return;

    if(m > 0 && mq.queue()) // pusti muskarca
      mq.signal();
    else if(w > 0 && wq.queue() ) // pusti zenu
      wq.signal();
    else if(qc.queue()) // pusti dete
      qc.signal();
  }
  void exitChild(){
    c--;
    if(exit.queue())
      exit.signal();
    else if(qw.queue() && w > 0 && qr.empty()) 
      qw.signal(); // zene
    else if(qm.queue() && m > 0 && qr.empty())
      qm.signal(); // muski
    
  }
};
