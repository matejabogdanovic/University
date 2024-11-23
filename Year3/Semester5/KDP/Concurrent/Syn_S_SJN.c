// coarse grain ako IGNORISAN TIME
bool resurs_free = true;

void request(int time, int id){
  <await(resurs_free) resurs_free = false;>
}

void release(){
  <resurs_free = true;>
}

// fine grain pomocu predaje stafetne palice IGNORISAN TIME
int free_waiting = 0;
void request(int time, int id){
  mutex.wait();
  if(!resurs_free){ // DELAY
    free_waiting++; 
    mutex.signal();
    free.wait();
  } //
  resurs_free = false;

  mutex.signal();
}

void release(){
  
  mutex.wait();
  resurs_free = true;
  // SIGNAL
  if(free_waiting){
    free_waiting--;
    free.signal();
  }else
    mutex.signal();
  
}
// Moguci coarse grain bez ignorisanja time
struct Pairs{
  int time;
  int id;
}
Queue<Pairs> q; // sortiran po time
void request(int time, int id){
  <await(resurs_free && q.first().id == id) resurs_free = false;>
}

void release(){
  <resurs_free = true;>
}
// fine grain POMOCU PRIVATNIH RASPODELJENIH BINARNIH SEMAFORA
void request(int time, int id){
  mutex.wait();
  if(!resurs_free){ // DELAY
    q.add(new Pairs(time, id)); //free_waiting++; 
    mutex.signal();
    free[id].wait(); //free.wait();
  } //
  resurs_free = false;

  mutex.signal();
}

void release(){
  
  mutex.wait();
  resurs_free = true;
  // SIGNAL
  if(q.size() > 0){ // free_waiting>0
    Pair p = q.remove(); // free_waiting--;
    free[p.id].signal();
  }else
    mutex.signal();
  
}