//

// resenje 1
monitor Vocnjak{
  const int prikolica_kapacitet;
  int br_gajbica = 0;
  cond q;
  int ticket = 0, next = 0;
  void ostavljam_gajbice(int cnt){
    br_gajbica += cnt;
    if(br_gajbica >= prikolica_kapacitet)
      q.signalAll();

    
  }


  void spreman_da_pokupim(){ // fifo

    myTicket = ticket++;
    while(myTicket != next || br_gajbica < prikolica_kapacitet)
      q.wait();
    next++;
    br_gajbica -= prikolica_kapacitet;

  }


};

