// Разматра се проблем синхронизације на баријери
// (Barrier Synchronization). Синхронизациона
// баријера омогућава нитима да на њој сачекају док
// тачно N нити не достигне одређену тачку у
// извршавању, пре него што било која од тих нити
// не настави са својим извршавањем. Користећи
// семафоре решити овај проблем. Омогућити да се
// иста баријера може користити већи број пута.
const int N = ...;
int cnt = 0;
sem entry = 1, exit = 0;

void run(){
  while(true){

    entry.wait();
    cnt++;
    if(cnt == N) exit.signal(); // ne moze vise niko da udje, samo da izadju
    else entry.signal();

    exit.wait();
    cnt--;
    if(cnt == 0) entry.signal(); // otvori ulaz
    else exit.signal(); // pusti da izadje sledeci

  }
}