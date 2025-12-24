// Негде у Африци постоји дубок кањон на чијим литицама живе два
// чопора бабуна (The Baboons Crossing Problem). Између две литице кањона
// постоји хоризонтална лијана преко које бабуни прелазе реку, потенцијално се
// мимоилазећи. Да би се избегао сукоб између бабуна у једном тренутку на
// лијани смеју да се нађу само бабуни који припадају истом чопору. Такође,
// лијана може да издржи највише 5 бабуна, иначе пуца. Обезбедити да се мења
// чопор које користи лијану најкасније након што пређе 10 бабуна који
// припадају истом чопору, ако су за то време један или више бабуна који
// припадају другом чопору чекали да пређу реку. Користећи C-Lindu написати
// програм који решава овај проблем.


void baboon1(){
  bool wait = false;
  while(1){
    in("cross", ?can_cross, ?crossing, ?wtc1, ?wtc2, ?turn);
    if(turn == 0){ // niciji red, onda je moj
      turn = 1;
      crossing++;

    }else // moj red i manje od 5 babuna i niko ne ceka  
    if (turn == 1 && can_cross && wtc1 == 0 && wtc2 == 0){
      crossing++;
      if(crossing == 5)can_cross = false; // ako je 5 babuna onda ne daj da prodju vise 
    }else{ // inace cekaj
      wtc1++; 
      wait = true;
    }
    out("cross", can_cross, crossing, wtc1, wtc2, turn);
    if(wait){// ako cekas
      // cekaj da mozes da prodjes i da je tvoj red
      in("cross", true, ?crossing, ?wtc1, ?wtc2, 1);
      crossing++;
      wtc1--;
      if(crossing == 5)can_cross = false;
      out("cross", can_cross, crossing, wtc1, wtc2, turn);
    }

    // cross

    in("cross", ?can_cross, ?crossing, ?wtc1, ?wtc2, ?turn);
    crossing--;
    if(wtc2 > 0){ // ako je neko cekao, reci da vise ne sme da se prodje
      can_cross = false;
    }
    // ako sam poslednji
    if(crossing == 0){
      if(wtc2 > 0){ // pusti da prodje drugi copor
        turn = 2;
        can_cross = true;
      }else{ // ako ne ceka drugi copor, pusti bilo kog da prodje
        turn = 0; can_cross = true;
      }
    }
    out("cross", can_cross, crossing, wtc1, wtc2, turn);

  }

}

void init(){

}