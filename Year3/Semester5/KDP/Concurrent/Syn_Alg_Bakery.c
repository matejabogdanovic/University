
// coarse grain

int ticket[N] = {-1};

void process(int id){
  <ticket[id] = max(ticket)+1;>
  for(int i = 0; i<N; i++){
    if(i == id)continue;
    <await(ticket[i] == 0 || ticket[i] > ticket[id]);> // bespotrebno ticket[i] == 0
  }

  
  ticket[id] = -1;
}

// fine grain
int ticket[N] = {-1};
void process(int id){
  
  ticket[id] = 0; // zelim da udjem
  ticket[id] = max(ticket)+1;
  for(int i = 0; i<N; i++){
    if(i == id)continue;
    while(ticket[i] != -1 && (ticket[i], i) < (ticket[id], id))skip; 
  }

  
  ticket[id] = -1;
}