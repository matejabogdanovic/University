// Трајект за превоз возила превози возила са обале на обалу.
// Трајект поседује M трака од којих свака има N позиција које су
// линеарно постављене једна иза друге. Возило заузима једну позицију.
// Возило приликом доласка стаје у ред за случајно изабрану траку и чека
// на укрцавање. Нема могућности за престројавањем. Возила улазе у
// своју траку једно по једно по редоследу у којем чекају у траци, док на
// трајекту има места. Када је пун, трајект започиње превоз возила на
// другу обалу. На другој обали возила се искрцавају из своје траке у
// редоследу супротном од редоследа у којем су се укрцала у своју траку.
// Када се сва возила искрцају, празан трајект се враћа на почетну обалу.
// Користећи C-Linda написати програм који решава овај проблем.
const int M = ..., N = ...;
void trajekt() {
  int pos;
  while(1){
    // dozvoli ukrcavanje
    for(int traka = 0; traka < M; traka++){ 
      // dozvoli na svakoj traci da se ukrca sledeci
      inp("ukrcavanje next", traka, ?pos);
      out("ukrcavanje next", traka, pos+1);
    }
    for(int traka = 0; traka < M; traka++){ 
      // cekaj za svaku traku da je ukrcano N
      rd("cnt", traka, N);
    }
    
    VOZNJA(); // svi cekaju na iskrcavanje

    // dozvoli iskrcavanje
    for(int traka = 0; traka < M; traka++){ 
      // dozvoli na svakoj traci da se iskrca poslednji N-1
      inp("iskrcavanje next", traka, -1);
      out("iskrcavanje next", traka, N-1); 
    }
    for(int traka = 0; traka < M; traka++){ 
      // cekaj za svaku traku da je iskrcano N
      rd("cnt", traka, 0);
    }

    VOZNJANAZAD();
  }
}

void vozilo() {
  int traka = randInt(0, M-1); // [0, M-1]
  int pos; // pozicija u redu pri ukrcavanju i na traci pri iskrcavanju 
  int cnt; // broj vozila na traci [1, N] 
  // zauzmi poziciju na traci i cekaj dok ne budes sledeci
  in("ukrcavanje", traka, ?pos);
  out("ukrcavanje", traka, pos+1);
  in("ukrcavanje next", traka, pos);

  UKRCAVANJE();

  inp("cnt", traka, ?cnt);
  cnt++;
  if(cnt < N)out("ukrcavanje next", traka, pos+1); // nek se ukrca sledeci
  else out("ukrcavanje next", traka, pos); // traka puna pa nek ostane pos poslednjeg ukrcanog
  out("cnt", traka, cnt);

  pos = pos % N; // moja prava pozicija na traci [0, N-1]
  in("iskrcavanje next", traka, pos); // cekaj da se iskrcas

  ISKRCAVANJE();

  inp("cnt", traka, ?cnt);
  cnt--;
  if(cnt > 0)out("iskrcavanje next", traka, pos-1); // nek se iskrca sledeci
  else out("iskrcavanje next", traka, -1); // traka prazna 
  out("cnt", traka, cnt);

}

void init() {

  for(int traka = 0; traka < M; traka++){
    out("ukrcavanje", traka, 0);
    out("ukrcavanje next", traka, -1); 
    out("iskrcavanje next", traka, -1); 
    out("cnt", traka, 0); 
  }
  for(...)eval(vozilo());
  eval(trajekt());
}