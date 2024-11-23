// coarse grain

const int N = ...;
int cnt = 0;
void process(){
  <cnt += 1>
  <await(cnt == N);>
}

// fine grain

const int N = ...;
int cnt = 0;
void process(){
  FA(cnt, 1);
  while(cnt != N)skip;
}

// za 2 procesa 

arrived1.signal();
arrived2.wait();


arrived2.signal();
arrived1.wait();
