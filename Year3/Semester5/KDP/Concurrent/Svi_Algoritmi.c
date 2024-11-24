// Test and Set
int lock = 0;
while(TS(lock))skip; // <await(lock == 0)lock = 1;> 

lock = 0;


// Test and Test and Set
int lock = 0;
while(lock)skip;
while(TS(lock)){
  while(lock)skip;
}
lock = 0;

// Petersonov za 2 procesa
int last = 0; bool want1 = false, want2 = false; 
void process1(){
  want1 = true; last = 1;
  while(last == 1 && want2 == true)skip; //<await(last == 2 || want2 = false);>

  want1 = false;
}


// Tie Breaker 
const int N = ...;
int in[N] = {-1};
int last[N] = {-1};
void process(int id){
  for(int i = 0; i < N; i++){ // kroz sva stanja
    in[id] = i; last[i] = id; 
    for(int j = 0; j < N; j++){ // kroz sve susede
      if(j == id)continue; // ne proveravam za sebe
      while(last[i]==id && in[j]>=in[id])skip;
      // <await(last[i] != id || in[j] < in[id]);>
    }
  }
  // kriticna sekcija
  in[id] = -1;
}


// Ticket
int ticket = 0, next = 0;
void process(){
  int myTicket = FA(ticket, 1);//<int myTicket = ticket; ticket++;>
  while(next != myTicket)skip;//<await(next == myTicket);>

  next++; 
}

// Bakery za 2 procesa - prednost manji indeks
int turn1 = -1, turn2 = -1;
void process1(){
  turn1 = 1; turn1 = turn2 + 1;
  while(turn2 != -1 && turn1 > turn2)skip;

  turn1 = -1;
}
void process2(){
  turn2 = 1; turn2 = turn1 + 1;
  while(turn1 != -1 && turn2 >= turn1)skip;

  turn2 = -1;
}

// Bakery
const int N = ...;
int tickets[N] = {-1};
void process(int id){
  tickets[id] = 0; tickets[id] = max(tickets) + 1; // <tickets[id] = max(tickets) + 1;>
  for(int i = 0; i < N; i++)
    if(i==id)continue;
    //<await(tickets[i] == -1 || tickets[i] > tickets[id]));>
    while(tickets[i] != -1 && (myTicket, id)>(tickets[i], i))skip;

  tickets[id] = -1;
}

// Andersen
const int N = ...;
bool turn[N] = {false}; int slot = 0;
void process(int id){
  int mySlot = FA(slot, 1)%N; //<mySlot = slot % N; slot++>
  while(!turn[mySlot])skip;//<await(turn[mySlot]);>

  turn[mySlot] = false;
  turn[(mySlot + 1)%N] = true;
}

// CLH
struct Node{
  bool locked = false;
};
Node* tail = nullptr;

void process(){
  Node* node = new Node(true);
  Node* prev = nullptr;
  prev = GS(tail, node); //<prev = tail; tail = node;>
  while(prev.locked)skip; //<await(!prev.locked);>

  node.locked = false;
}







