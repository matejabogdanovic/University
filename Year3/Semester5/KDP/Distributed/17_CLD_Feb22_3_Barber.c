// Користећи C-Linda библиотеку решити проблем берберина
// који спава (The Sleeping Barber Problem). Берберница се састоји од
// чекаонице са n=5 столица и берберске столице на којој се људи брију.
// Уколико нема муштерија, брица спава. Уколико муштерија уђе у
// берберницу и све столице су заузете, муштерија не чека, већ одмах
// излази. Уколико је берберин зaузет, а има слободних столица,
// муштерија седа и чека да дође на ред. Уколико берберин спава,
// муштерија га буди.
const int K = ...; // musterije
const int N = 5;


void customer(){
  int next = 0, cnt = 0, seat = 0;
  in("seats", ?next, ?cnt);
  if(cnt == N){
    // full
    out("seats", next, cnt);
    return;
  }
  seat = (next + cnt)%N; // calculate my seat
  if(inp("sleeping")){ 
    out("wakeup");
  }
  out("seats", next, cnt+1); 
  
  in("chair", seat); // wait for haircut

  // haircut

  in("finished", next);
  out("bye", next);
}


void barber(){
  int next = 0, cnt = 0;
  while(1){
    in("seats", ?next, ?cnt);
    if(cnt == 0){
      out("sleeping");
      out("seats", next, cnt);
      in("wakeup"); // wait to wake up
      in("seats", ?next, ?cnt);
    }
    out("seats", (next+1)%N, cnt-1);
    out("chair", next); // sit on chair

    // haircut

    out("finished", next);
    in("bye", next); // he is out
  
  }
}

void init(){

  out("seats", 0, 0);
  
  eval(barber());
  for(int i = 0; i < K; i++)eval(customer());

}