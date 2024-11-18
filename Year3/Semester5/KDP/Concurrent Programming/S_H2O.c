// Постоје два типа атома, водоник и кисеоник, који
// долазе до баријере. Да би се формирао молекул
// воде потребно је да се на баријери у истом
// тренутку нађу два атома водоника и један атом
// кисеоника. Уколико атом кисеоника дође до
// баријере на којој не чекају два атома водоника,
// онда он чека да се они сакупе. Уколико атом
// водоника дође до баријере на којој се не налазе
// један кисеоник и један водоник, он чека на њих.
// Баријеру треба да напусте два атома водоника и
// један атом кисеоника. Користећи семафоре
// написати програм који симулира понашање
// водоника и кисеоника.

//moze da se desi da neko nekom uleti i ukrade red?
sem semH = , semO = ;
sem entry = 1, exitH = 0, exitO = 0;
int cntH = 0, cntO = 0;
sem hExited = 0;
void atomH(char type){
  while(true){
    entry.wait();
    cntH++;
    if(cntH >= 2 && cntO >= 1) exitO.signal();
    else entry.signal();

    exitH.wait();
    
    hExited.signal();
  }
}

void atomO(char type){
  while(true){
    entry.wait();
    cntO++;
    if(cntH >= 2 && cntO >= 1) exitO.signal();
    else entry.signal();

    exitO.wait();
    cntO--;
    exitH.signal();
    exitH.signal();
    cnt = 0;
    while(cnt != 2){
      hExited.wait();
      cnt ++;
      cntH --;
    }
    entry.signal();
    
  }
}