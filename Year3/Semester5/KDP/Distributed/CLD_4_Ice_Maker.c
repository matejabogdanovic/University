// Користећи C-Linda написати програм који решава
// проблем и симулира систем прављења
// сладоледа (Ice Cream Makers problem). Постоји
// један снабдевач и три сладолеџије. Сладолеџији
// су потребна три састојка да би направио
// сладолед – слатка павлака, шећер и ванила.
// Један сладолеџија има бесконачне залихе слатке
// павлаке, други шећера и трећи ваниле.
// Снабдевач има бесконачне залихе сва три
// састојка. Он на заједнички сто ставља два од три
// потребна састојка. Сладолеџија коме баш та два
// састојка фале их узима са стола, прави сладолед,
// и након што је завршио о томе обавести
// снабдевача. Снабдевач након тога поново ставља
// нека два састојка на сто, и циклус се понавља.


// stavlja odjednom
typedef enum Sastojak{
  P, S, V
}Sastojak;

void sladoledzija(Sastojak sastojak){
    Sastojak s1 = (Sastojak)((sastojak+1)%3);
    Sastojak s2 = (Sastojak)((sastojak+2)%3);
  while(1){

    in("take", s1, s2);
    out("taken");
  }
}

void snabdevac(){

  while(1){
    int i = rand(0, 3); // 0, 1, 2
    Sastojak s1 = (Sastojak)((i+1)%3);
    Sastojak s2 = (Sastojak)((i+2)%3);
    out("take", s1, s2);
    in("taken");
  }
}

void init(){
  for(int i = 0; i < 3; i++){
    eval(sladoledzija(i));
  }
  eval(snabdevac());
}

// stavlja pojedinacno
typedef enum Sastojak{
  P, S, V
}Sastojak;

void sladoledzija(Sastojak sastojak){
    Sastojak s1 = (Sastojak)((sastojak+1)%3);
    Sastojak s2 = (Sastojak)((sastojak+2)%3);
    int n;
    while(1){
      // ide jedan drugi treci
      in("ticket", ?n);
      out("ticket", n+1);
      in("next", n);
      // dosao sam na red
      in("take"); // cekam da bude spremno

      if(rdp(s1) && rdp(s2)){
        in(s1);
        in(s2);
        out("taken");
        out("next", n+1); // pusti sledeceg
        
        MAKE_ICE_CREAM()
      }else {
        out("take");
        out("next", n+1); // pusti sledeceg
      }
      

    
  }
}

void snabdevac(){

  while(1){
    int i = rand(0, 3); // 0, 1, 2
    Sastojak s1 = (Sastojak)((i+1)%3);
    Sastojak s2 = (Sastojak)((i+2)%3);
    out(s1);
    out(s2);
    out("take");
    in("taken");
  }
}

void init(){
  out("ticket", 0);
  out("next", 0);
  for(int i = 0; i < 3; i++){
    eval(sladoledzija(i));
  }
  eval(snabdevac());
  
}
