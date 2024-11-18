/*Постоји један произвођач и N потрошача који деле
заједнички једноелементни бафер. Произвођач
убацује производ у бафер и чека док свих N
потрошача не узму исти тај производ. Тада
започиње нови циклус производње.*/


// UZIMACE JEDAN PO JEDAN - SMANJENA KONKURENTNOST
int b = 0;
sem take[N] = {0};
sem prod = 1;
void consumer(int id){
  while(true){
    int product = 0;
    take[id].wait();
   
    product = b;

    if(id == N-1)prod.signal();
    else take[id+1].signal();
  }
}

void producer(){
  while(true){
    int product = produce();
    prod.wait();   

    b = product;

    take[0].signal();
  }
}

// KONKURENTNO

int b = 0;
sem cons[N] = {0};
sem prod = 1;
int cnt = 0;

void consumer(int id){
  while(true){
    int product = 0;
    cons[id].wait(); // cekaj da uzmes
    
    // uzmi
    product = b;

    mutex.wait();
    cnt++;

    if(cnt == N){
      cnt = 0;
      prod.signal();
    }
    mutex.signal();
  }
}

void producer(){
  while(true){
    int product = produce();
    prod.wait();

    b = product;

    for(int i = 0; i<N; i++)
      cons[i].signal();
  }
}

// Постоји један произвођач и N потрошача који деле
// заједнички бафер капацитета B. Произвођач
// убацује производ у бафер на који чекају свих N
// потрошача, и то само у слободне слотове. Сваки
// потрошач мора да прими производ у тачно оном
// редоследу у коме су произведени, мада
// различити потрошачи могу у исто време да
// узимају различите производе.
