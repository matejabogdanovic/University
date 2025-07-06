// На уласку у једну железничку станицу са једном улазном
// пругом и једним слепим колосеком десио се квар, па се на улазу
// направила колона међународних и домаћих возова. Квар је отклоњен и
// треба пуштати возове. Да би међународни возови мање каснили, они се
// пуштају први, по редоследу доласка. Пошто постоји само једна пруга и
// возови се не могу „претицати”, сви домаћи возови који су били испред
// међународних у колони се пребацују на слепи колосек који је довољно
// велики да сви возови могу да стану. Када сви међународни возови оду,
// пуштају се прво возови са слепог колосека, па онда преостали домаћи
// возови из колоне. Сама станица има N перона, тј. N возова истовремено
// могу да укрцавају и искрцавају путнике. Возови који у међувремену
// пристижу треба да буду опслужени, али новопристигли међународни
// немају приоритет у односу на возове који су испред њих у колони.
// Решити проблем користећи C-Linda. Написати потребну
// иницијализацију која осликава стање након отклањања квара. Водити
// рачуна о томе да су композиције возова тешке и да је потребно време
// да се воз помери са једног места на друго.
const int K = ...;
const int N = ...;

// spageti kod incoming ...

void voz(int id, string tip, bool novopristigao){ // tip "m" or "d"
  int myTicket, myKolosek = -1, cnt = -1, myPeron;
  if(!novopristigao){
    myTicket = id;
  } else {
    in("ticket", ?myTicket);
    out("ticket", myTicket+1);
  }
  in("next", myTicket); // cekam moj red da krenem
  if(!novopristigao){ 
    switch(tip){
      case "d": // moram na slepi kolosek ako ima jos medjunaridnih koji nisu novopristigli
        rd("waiting m", ?cnt);
        if(cnt == 0)break; // svi !novopristigli medjunarodni su otisli pa se ponasaj normalno
        in("kolosekTicket", ?myKolosek); // uzmi moju poziciju na koloseku
        out("kolosekTicket", myKolosek+1);
        in("kolosekNext", myKolosek); 

        MOVE(on_kolosek); 

        out("kolosekNext", myKolosek+1); // poslednji kolosekNext ce biti za 1 veci
        out("next", myTicket+1); // pusti sledeceg da prodje ili udje na kolosek

        in("kolosekNext", myKolosek);
        
        MOVE(from_kolosek); // vracanje na glavnu 

        break;
      case "m":
        in("waiting m", ?cnt);
        out("waiting m", --cnt);

        break;
    }
  }
          
  in("peron", ?myPeron); // uzmi bilo koji slobodan peron

  MOVE(to_peron, myPeron);

  if(tip == "d" && myKolosek >= 0 && !novopristigao){
    out("kolosekNext", (myKolosek == 0)?0:myKolosek-1); // pusti sledeceg sa koloseka ili stavi kolosekNext na 0
    if(myKolosek == 0) out("next", myTicket+1); // pusti sledeceg sa rampe
  }
  else if(tip == "m" && !novopristigao && cnt == 0){
    // pusti da krenu da izlaze sa koloseka
    in("kolosekNext", ?myKolosek);
    out("kolosekNext", myKolosek-1); // prvi sa koloseka LIFO
  } else  
    out("next", myTicket+1); // pusti sledeceg sa rampe

  PUTNICI(); // ukrcavanje iskrcavanje

  MOVE(from_peron, myPeron);

  out("peron", myPeron); // oslobodi moj peron
}

// recimo da je prvih 10 vozova cekalo a svaki treci voz je domaci
void init(){
  for(int i = 0; i < N; i++)out("peron", i);

  out("kolosekTicket", 0);
  out("kolosekNext", 0);
  out("ticket", 10);
  out("next", 0);
  out("waiting m", 6);

  for(int i = 0; i < K; i++){
    string tip = i%3==0?"d":"m"; 
    bool novopristigao = i>10;
    eval(voz(i, tip, novopristigao));
  }

}