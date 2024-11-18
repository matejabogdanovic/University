// Реализовати монитор који омогућава програму који
// га позива да чека n јединица времена. Користити
// signal and wait дисциплину.

// vise programa moze da poziva

monitor Timer{
  cond q;
  int current = 0;
  void tick(){
    current++;
    if(q.queue() && current >= q.minrank()){ // ako vise njih cekaju isto vreme, ne moze while
                                            // jer ce se nagomilavati tickovi
      q.signal();
    }
  }

  void wait_time(int n){
  
    q.wait(current+n); // probudi me tad

    if(q.queue() && current >= q.minrank()){ 
      q.signal();
    }
  }


}