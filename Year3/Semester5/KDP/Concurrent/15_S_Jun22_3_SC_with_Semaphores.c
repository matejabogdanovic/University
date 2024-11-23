// SC + moguce pozivanje iz monitorskih procedura

// 1. metode
monitor Monitor{
  sem entryQ = 1;
  int executing = -1;
  int nesting_level = 0;

  { // ovo ugradjuje prevodilac
  if(executing != get_pid())
    entryQ.wait();

  nesting_level++;
  executing = get_pid(); // process id  
  
  void user_code_for_method(){ // ovo pise korisnik
  // telo metode
  }

  nesting_level--;
  if(nesting_level == 0)
    entryQ.signal();

  }//

}


// 2. wait na uslovnoj promenljivoj
sem condQ = 0;
int blocked_cnt = 0;
void wait(){
  blocked_cnt++;

  int myNestingLevel = nesting_level; // moj kontekst za monitor
  executing = -1;

  entryQ.signal();
  condQ.wait();
  // neko pozvao signal
  blocked_cnt--;

  entryQ.wait(); // prebacujem se u entryQ

  // ja nastavljam da izvrsavam monitor
  executing = get_pid(); 
  nesting_level = myNestingLevel; // vracam kontekst

}

// 3. signal na uslovnoj promenljivoj
void signal(){
  if(blocked_cnt > 0){
    condQ.signal(); // signal and continue
  }
}

// 4. signalAll
void signalAll(){
  for(int i = blocked_cnt; i > 0; i--)
    condQ.signal();

}