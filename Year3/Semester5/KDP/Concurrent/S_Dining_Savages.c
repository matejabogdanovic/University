// Племе људождера једе заједничку вечеру из казана
// који може да прими M порција куваних мисионара.
// Када људождер пожели да руча, онда се он сам
// послужи из заједничког казана, уколико казан није
// празан. Уколико је казан празан, људождер буди
// кувара и сачека док кувар не напуни казан. Није
// дозвољено будити кувара уколико се налази бар
// мало хране у казану. Користећи семафоре
// написати програм који симулира понашање
// људождера и кувара.

const int M = ...;
int kazan = M;
sem mutex = 1;
sem empty = 0;
sem full = 0;
void savage(){

  mutex.wait();
  if(kazan == 0){
    empty.signal();
    full.wait();
  }
  kazan--;
  mutex.signal();

}



void cook(){

  // napuni kazan
  empty.wait();
  kazan = M;
  full.signal();

}