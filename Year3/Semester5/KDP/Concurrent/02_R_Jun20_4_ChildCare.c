// У неком обданишту постоји правило које каже да се на свака три детета мора наћи барем једна васпитачица (The Child Care Problem). Родитељ доводи једно или више деце у обданиште и чека све док се не појави место, како би оставио сву децу одједном и отишао. Родитељ такође може да одведе једно или више деце, такође одједном. Васпитачица долази на посао и сме да напусти обданиште само уколико то не нарушава правило. Мора се поштовати редослед доласка родитеља који остављају децу и васпитачица које одлазе са посла. Користећи условне критичне регионе, написати процедуре за родитеље који доводе децу, родитеље који одводе децу, васпитачице које долазе на посао и васпитачице које одлазе са посла. Иницијализовати почетне услове.

struct CC{
  int brdece = 0, brvasp = 0;
  int ticketR = 0, nextR = 0;
  int ticketV = 0, nextV = 0;
};
CC cc;


void roditelj_dolazi(int cnt){
  region(cc){
    myTicket = ticketR++;
    await((brvasp * 3 >= brdece + cnt) && nextR == myTicket);
    nextR++;
    brdece+= cnt;
  
  }
}

void roditelj_odlazi(int cnt){
  region(cc){
    brdece -= cnt;
    //
  }
}

void vasp_dolazi(){
  region(cc){
    brvasp++;
    // 
  }
}

void vasp_odlazi(){
  region(cc){
    myTicket = ticketV++;
    await(((brvasp-1) * 3 >= brdece + cnt) && nextV == myTicket);
    nextV++;
    brvasp--;
  }
}