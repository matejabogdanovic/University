// coarse grain

bool turn[N] = {false};
int slot = 0;
void process(){  
  <mySlot = slot % N; slot++>
  <await (turn[mySlot]);>

  turn[mySlot] = false;
  turn[(mySlot+1)%N] = true;
} 

// fine grain
bool turn[N] = {false};
int slot = 0;
void process(){  
  mySlot = FA(slot, 1)%N; 
  while (!turn[mySlot])skip;

  turn[mySlot] = false;
  turn[(mySlot+1)%N] = true;
} 