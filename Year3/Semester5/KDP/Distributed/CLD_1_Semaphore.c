// Користећи библиотеку C-Linda приказати како се
// могу креирати “Семафори”.



void signal(string semName){
  out(semName); // puts one ticket 
}

void wait(string semName){
  in(semName); // gets one ticket or waits to get one ticket
}

void init(string name, unsigned int n){
  for(int i = 0; i < n; i++){
    out(name); // puts n tickets for semaphore
  }
}