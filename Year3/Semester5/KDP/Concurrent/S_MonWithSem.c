// napraviti monitor od semafora




//SW
sem entryQ = 1;

entryQ.wait();
//... monitor's procedure
entryQ.signal();


sem condQ = 0;
int cnt = 0;

void wait(){
  cnt++;
  entryQ.signal(); // pustam monitor
  condQ.wait(); // bezuslovna blokada
  cnt--;
} 

void signal(){
  if(cnt > 0){ // ako imam koga da pustim 
    condQ.signal(); 
    entryQ.wait(); // vrati se u entryQ
  }

}

// SUW - signal and urgent wait
sem entryQ = 1; 
sem urgentQ = 0; int urgent_cnt = 0;

entryQ.wait();
//... monitor's procedure
if(urgent_cnt > 0) urgentQ.signal();
else entryQ.signal();


sem condQ = 0;
int cnt = 0;
void wait(){
  cnt++;
  if(urgent_cnt > 0) urgentQ.signal(); // pusti monitor sledecem
  else entryQ.signal();
  condQ.wait(); // bezuslovna blokada
  cnt--;
} 

void signal(){
  if(cnt > 0){ // ako imam koga da pustim 
    urgent_cnt++;
    condQ.signal(); // pusti sledeceg
    urgentQ.wait(); // cekaj na urgentQ
    urgent_cnt--;
  }

}





