// napraviti semafor od monitora
wait:
<await(s>0)s--;>
signal:
<s++>

// SW
monitor Semaphore{
  cond q;
  int s = 0;
  void Semaphore(int i){ // konstruktor
    s = i;
  }

  void wait(){
    if(s == 0) // while ako SC
      q.wait();
    s--;
  }

  void signal(){
    s++;
    q.signal();
  }

};


// da radi i za SC i SW => passing the condition

monitor Semaphore{
  cond q;
  int s = 0;
  void Semaphore(int i){ // konstruktor
    s = i;
  }

  void wait(){
    if(s == 0) 
      q.wait();
    else s--; // ako te niko nije budio, sam moras da smanjis promenljivu
  }

  void signal(){ // onaj koji budi radi posoooooo
    if(q.queue()) // ako neko ceka
      q.signal(); // samo signaliziraj i ne uvecavaj promenljivu
    else s++;
  }

};
