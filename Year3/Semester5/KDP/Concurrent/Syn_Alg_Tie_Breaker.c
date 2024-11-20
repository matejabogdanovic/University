
int stanje[N] = {-1}; // stanje[IDProcesa] = 0 do N-1 stanja, -1 ako nece da udje 
int poslednji[N] = {-1}; // poslednji[i] = IDProcesa - poslednji dosao u i stanje

void process(int id){
  for(int i = 0; i < N; i++){
    stanje[id] = i;
    poslednji[i] = id;
    for(int j = 0; j < N; j++){ // uporedjivanje sa ostalim procesima
      if(j == id)continue;
      while(poslednji[i] == id && stanje[j] >= stanje[id])skip; 
      // blokiram se ako sam poslednji a nisam jedini
      
      // preskacem sve procese ako:
        // Nisam poslednji u mom stanju
        // Ako sam u vecoj iteraciji nego svi ostali procesi (prvi prolazi najbrze)
      

      // PROLAZIM DALJE AKO NISAM POSLEDNJI ILI AKO SAM U VECOJ ITERACIJI OD SVIH DRUGIH PROCESA
    }
  }


  stanje[id] = -1;
}