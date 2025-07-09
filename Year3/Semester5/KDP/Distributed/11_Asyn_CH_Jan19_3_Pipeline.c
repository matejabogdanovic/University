// Филтерски процеси имају један улаз и један излаз и раде следеће:
// примају позитивне вредности на улазу и прослеђују их на излаз ако су
// веће од запамћеног минимума процеса. Процеси имају само две локације,
// за сачувани минимум и за задњу примљену вредност. Када на улаз стигне
// EOS, избацују минималну вредност на излаз и затим EOS. Направите
// проточну обраду (pipeline) од n процеса који опадајуће сортирају: до n
// улазних позитивних вредности које се убацују на почетак проточне
// обраде, а завршавају се са EOS.


const int N = ...;

chan ch[N+1](int); 
void node(int id){
  chan in = ch[id];
  chan out = ch[id+1];
  int min, new;
  
  recieve in(new);
  if(new == EOS){
    send out(EOS);
    return;
  }
  else {
    min = new;
  }
  while(1){
    recieve in(new);
    if(new==EOS)break;
    // send bigger value and remember smallest
    if(new > min)
      send out(new);
    else {
      send out(min);
      min = new;
    }
  }
  send out(min);
  send out(EOS);
  

}

// pretpostavka da ce biti poslat bar 1 broj pre EOS

const int N = ...;

chan ch[N+1](int); 
void node(int id){
  chan in = ch[id];
  chan out = ch[id+1];
  int min, new;
  
  recieve in(new);
  min = new;
  while(1){
    recieve in(new);
    if(new==EOS)break;
    // send bigger value and remember smallest
    if(new > min)
      send out(new);
    else {
      send out(min);
      min = new;
    }
  }
  send out(min);
  send out(EOS);
  

}