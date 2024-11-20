// coarse grain

struct Node{
  bool next_cant_go;
};
Node tail = {false}; 
void process(){
  Node prev, node = {true};
  <prev = tail; tail = node;>
  <await(!prev.next_cant_go);>

  node.next_cant_go = false;
}

// fine grain

void process(){
  Node = prev, node = {true};
  prev = GS(tail, node); 
  while(prev.next_cant_go)skip;

  node.next_cant_go = false;
}

//   SWAP(var1, var2): < temp = var1; var1 = var2; var2 = temp; >

void process(){  // prev <= tail, tail <= node
  Node prev = {true};
  Node node = prev; // pokazuje na objekat prev
  SWAP(tail, prev); // tail <= node OK ali node<=tail
  while(prev.next_cant_go)skip;

  node.next_cant_go = false;
}