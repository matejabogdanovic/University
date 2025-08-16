// Користећи активне мониторе решити проблем филозофа који
// ручавају (The Dining Philosophers). Филозофи могу да комуницирају
// искључиво са процесом координатором (централизовано решење).
// Обезбедити да филозоф који је пре затражио да једе пре и започиње са
// јелом. Написати код за филозофе и за процес координатор.

const int N = ...;

chan request(int id, string op);
chan reply[N]();

void coordinator(){
  // 1 1 1 1 1
  int forks[N] = {1}; // all forks initially available
  int id; string op;
  Queue <int>q; // want to eat queue
  while(true){
    recieve request(id, op);
    int left = id, right = (id+1)%N;  
    if(op == "end"){
      forks[left] = forks[right] = 1; // free forks
      while(!q.empty()){ // release others
        int check = q.first(); // see first
        int newLeft = check, newRight = (check+1)%N;
        if(forks[newLeft] && forks[newRight]){
          q.remove(); // remove first
          forks[newLeft] = forks[newRight] = 0;
          send reply[check]();
        } else break;
      }
    }else if(op=="start"){
      if(!q.empty() || !(forks[left] && forks[right])){q.put(id); continue;}
      forks[left] = forks[right] = 0; // take forks
      send reply[id](); 
    } 
  }

}


void phils(int id){
  chan myChan = reply[id]; 
  while(true){
    think();
    send request(id, "start");
    recieve myChan();
    eating();
    send request(id, "end");
  }

}


