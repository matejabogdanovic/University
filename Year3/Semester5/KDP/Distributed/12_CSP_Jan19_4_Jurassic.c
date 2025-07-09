// Посматра се острво на коме људи могу да разгледају музеј о
// диносаурусима и парк са живим примерцима (The Jurassic Park Problem).
// У парку постоји m посетилаца и n безбедних возила која могу да приме
// једног путника. На почетку путник слободно разгледа музеј са
// експонатима. Када заврши разгледање музеја посетилац прелази на део са
// живим диносаурусима тако што сачека да се појави сигурно возило које ће
// га провести кроз парк. Када наиђе слободно возило посетилац прелази у
// вожњу по парку која траје неко време. На крају вожње посетилац напушта
// парк, а возило се враћа да прими следећег посетиоца. Уколико су сва
// возила заузета путник који жели да иде у обилазак чека слободно возило.
// Уколико постоји слободно возило, али не и посетиоца који тренутно чека
// да уђе онда возило чека. Користећи језик CSP решити овај проблем.

const int M = ...; // posetioci
const int N = ...; // vozila 

[(i:0..N-1)V(i):vozilo || R:rampa || (i:0..N-1)P(i):posetioc]


vozilo::[
  int idP; // id posetioca
  *[
    R!slobodan(); // rampi kazem da sam slobodan
    R?idP; // cekam putnika
    P(idP)!udji(); // kad primim putnika, kazem mu da udje
    P(idP)?usao(); // cekam da udje, kad udje krene voznja odmah

    VOZNJA;

    P(idP)!gotovo(); // signal da je gotova voznja
    P(idP)?izasao(); // cekam da izadje iz vozila
  ]
]

rampa::[
  int vcnt = 0; // br zauzetih vozila
  bool vozila(0:1..N-1); // true - zauzeto vozilo
  int j = 0; 
  *[j<N->[
      vozila(j) = false;
      j = j+1;
    ]
  ]

  *[
    vcnt < N, (i:0..M-1)P(i)?voznja()->[
      vcnt = vcnt + 1;
      j = 0;
      *[vozila(j) == true -> j = j+1;]
      vozila(j) = false;
      V(j)!i; // vozilu saljem id putnika
      P(i)!j; // putniku saljem id vozila
    ]

    []

    (i:0..N-1)V(i)?slobodan()->[
      vcnt = vcnt - 1;
      vozila(i) = false; // nije vise zauzeto vozilo
    ]

  ]


]

posetioc::[
  int idV; // id vozila
  *[
    SETNJA;

    R!voznja(); // zelim da se vozim
    R?idV; // primio vozilo
    V(idV)?udji(); // cekam da me vozilo primi
    ULAZAK; 
    V(idV)!usao(); // usao u kola, moze da krene voznja

    VOZNJA;

    V(idV)?gotovo(); // cekam da se zavrsi voznja
    IZLAZAK;
    V(idP)!izasao(); // signaliziram da sam izasao
  ]
]