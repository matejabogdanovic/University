// Решити проблем филозофа који ручавају користећи C-Lindu.
// Филозоф који је раније изразио жељу за храном треба раније да буду
// опслужен

const int N = ...;

void philosopher(int left, int right){
  int myTicket;
  while(1){
    in("ticket", ?myTicket);
    out("ticket", myTicket+1);

    in("next", myTicket);
    // first take my forks
    in("fork", left);
    in("fork", right);
    // let next eat
    out("next", myTicket+1);


    EAT();

    out("fork", right);
    out("fork", left);

  }
}

void init(){

  out("ticket",  0);
  out("next",  0);
  for(int i = 0; i<N; i++)out("fork", i);
  for(int i = 0; i<N; i++)out(eval(philosopher(i, (i+1)%N)))
}