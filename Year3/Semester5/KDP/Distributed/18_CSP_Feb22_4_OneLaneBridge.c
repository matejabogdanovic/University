// Аутомобили који долазе са севера и југа морају да пређу реку
// преко моста (One lane bridge problem). На мосту, на жалост, постоји
// само једна возна трака. Значи, у било ком тренутку мостом може да
// прође један или више аутомобила који долазе из истог смера (али не и
// из супротног смера). Користећи CSP написати програм који решава
// дати проблем. Спречити изгладњивање.

[B:bridge || (i:1..SCNT)S(i):vozilo || (i:1..JCNT)J(i):vozilo]

vozilo::*[

    B!want();
    B?go();
    B!end();

]


bridge::[
  int scnt = 0, jcnt = 0;
  *[
    (id:1..SCNT)S(id)?want() ->[
      // sacekaj da jug zavrsi
      *[ jcnt>0, (i:1..JCNT)J(i)?end()->jcnt--;]
      scnt++;
      S(id)!go();
      
    ] 
    []
    (id:1..JCNT)J(id)?want() ->[
      // sacekaj da sever zavrsi
      *[ scnt>0, (i:1..SCNT)S(i)?end()->scnt--;]
      jcnt++;
      J(id)!go();
    ] 
    []
    (id:1..SCNT)S(id)?end() -> scnt--;
    []
    (id:1..JCNT)J(id)?end() -> jcnt--;
    
  ]

]