// Постоји тоалет капацитета N (N > 1) који могу да
// користе жене и мушкарци, такав да се у исто
// време у тоалету не могу наћи и жене и мушкарци.
// Написати програм за жене и мушкарце који
// долазе до тоалета, користе га и напуштају га
// користећи семафоре. Избећи изгладњавање. 

// FIFO
struct Pair{
  sem* semaphore;
  char type;
} Pair;

Queue<Pair> q;

sem mutex = 1;

void men(){
  while(true){
    sem* s = nullptr;

    mutex.wait();
    if(!q.empty() || wcnt > 0 || mcnt > 0){
      s = new sem(0);
    }
    q.put(s, 'm');
    mutex.signal();

    if(s)
      s->wait();

    mutex.wait(); // mcnt broji koliko ima muskaraca u klonji a ne u redu cekanja
      if(!s){q.remove(); mcnt++;} // izbaci sebe jer si prvi i niko te nije probudio (nisi se blokirao)
      if(!q.empty() && q.first().type == 'm'){
        mcnt++; 
        q.remove().s->signal();
      }
    mutex.signal();
   
    //
    poop();
    //

    mutex.wait();
    mcnt--;
    // pusti zene
    if(mcnt == 0 && !q.empty() && q.first().type == 'w')q.remove().s->signal();
    mutex.signal();


  }
}

void women(){
  while(true){
  

  }
}