// Користећи мониторе са Signal and wait дисциплином решити
// проблем берберина који спава (The Sleeping Barber Problem).
// Берберница се састоји од чекаонице са n=5 столица и берберске
// столице на којој се људи брију. Уколико нема муштерија, брица спава.
// Уколико муштерија уђе у берберницу и све столице су заузете,
// муштерија не чека, већ одмах излази. Уколико је берберин зaузет, а има
// слободних столица, муштерија седа и чека да дође на ред. Уколико
// берберин спава, муштерија га буди. Обезбедити да се муштерије
// опслужују по редоследу долазака. Условне променљиве нису FIFO
// нити имају приоритетне редове чекања.

monitor Barber{
  int mcnt = 0, slobodno_mesto = 0; // 
  int na_redu = 0; 
  const int N = 5;
  bool finished = false;
  cond q[N];
  cond izasao;
  cond gotovo;
  cond b;
  void udji(){
    if(mcnt == 5) // ako sve zauzeto izadji
      return;
    if(mcnt == 0 && b.queue()){ // ako spava 
      b.signal();   // probudi ga
      if(!finished) // cekaj da te osisa
        gotovo.wait();
    }else{
      mcnt++; // sigurno ima slobodno mesta jer cnt nije 5 (a vise ne moze biti)
      stolica = slobodno_mesto;
      slobodno_mesto = (slobodno_mesto+1)%N;

      q[slobodno_mesto].wait(); // cekaj red
      // kad te probudi 
      if(!finished) // cekaj da te osisa
        gotovo.wait();
    }
    
    izasao.signal();
    
  }

  void daj_sledeceg(){
    if(mcnt == 0){
      b.wait();
      // prvi koji ga probudi odma krece sisanje
    }else{
      mcnt--;
      q[na_redu].signal();
      // sisanje
    }
  }

  void zavrsio_cut(){
    finished = true;
    
    if(gotovo.queue())
      gotovo.signal(); // prepustam monitor zavrsenoj musteriji
    
    izasao.wait();
    finished = false; 
    na_redu = (na_redu + 1)%N; // prebaci red na sledeceg
  }
};