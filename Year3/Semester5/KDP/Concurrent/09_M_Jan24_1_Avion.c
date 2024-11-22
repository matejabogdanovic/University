// Авиопревозник на линији Београд-Франкфурт-Лондон треба да врши
// резервацију карата помоћу софтвера заснованог на мониторима. Реализовати
// софтвер тако да се конкурентно могу резервисати карте Београд-Франкфурт и
// Франкфурт-Лондон, али да се позивом само једне мониторске процедуре могу
// резервисати и карте Београд-Лондон. Процедуре монитора морају бити
// угњеждене.



monitor Rezervacija{

  cond bgf, fl, bgl;
  int BG_F_left = N, F_L_left = N;
  bool neko_rezervise_bgf = false, neko_rezervise_fl = false;
  bool obaleta = false;

  void new_tickets_BG_F(int cnt){
    BG_F_left += cnt;
    else if(BG_F_left > 0 && bgf.queue() && neko_rezervise_bgf == false) 
      bgf.signal();
  }

  void new_tickets_F_L(int cnt){
    F_L_left += cnt;
    if(F_L_left > 0 && fl.queue() && neko_rezervise_fl == false)
      fl.signal();
  }

  void start_BG_F(){
    if(obaleta)
      return;

    if(BG_F_left == 0 || neko_rezervise_bgf // nema karata ili neko vec rezervise let
    || fl.queue()) // da ne bi bilo izgladnjivanja 
      bgf.wait();
    neko_rezervise_bgf = true;
    // prolazi i rezervisi
  }

  void end_BG_F(){
    if(obaleta)
      {BG_F_left--; return;} // ne smem da pustam druge da se ne bih blokirao

    neko_rezervise_bgf = false;
    BG_F_left--; // rezervisao
    
    if(F_L_left > 0 && fl.queue() && neko_rezervise_fl == false) // prvo pusti druge
      fl.signal();
    else if(BG_F_left > 0 && bgf.queue() // ako nema durgih pusti svoje
    && neko_rezervise_bgf == false) // suvisno al ajde, posto samo 1 od svoje vrste moze da rezervise
      bgf.signal();
  }
  // analogno F_L start i end!!!!
  

  void BG_L(){
    if(BG_F_left == 0 || neko_rezervise_bgf == true)
      bgf.wait();

    
    obaleta = true;
    BG_F_start(); // samo prodje metodu
    rezervisi_BG_F();
    BG_F_end(); // samo smanji brojac
    obaleta = false;

    if(F_L_left == 0 || neko_rezervise_fl == true)
      fl.wait();

    obaleta = true;
    F_L_start(); // samo prodje metodu
    rezervisi_F_L();
    F_L_start(); // samo smanji brojac
    obaleta = false;
  }
};



