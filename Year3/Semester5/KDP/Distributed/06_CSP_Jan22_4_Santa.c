// Деда Мраз који живи на северном полу већи део свог времена
// проводи спавајући (The Santa Claus Problem). Могу га пробудити или
// уколико се испред врата појаве свих 9 његових ирваса или 3 од укупно
// 10 патуљака. Када се Деда Мраз пробуди он ради једну од следећих
// ствари: Уколико га је пробудила група ирваса одмах се спрема и креће
// на пут да подели деци играчке. Када се врати са пута свим ирвасима
// даје награду. Уколико га је пробудила група патуљака онда их он уводи
// у своју кућу, разговара са њима и на крају их испрати до излазних
// врата. Група ирваса треба да буде опслужена пре групе патуљака.
// Користећи CSP написати програме за Деда Мраза, ирвасе и патуљке.

[S:santa||I(i:1..9):irvas||P(j:1..10):patuljak]

santa::[
  int irvasCnt = 0, patuljakCnt = 0;
  int patuljci(i:0..2); // 0, 1, 2

  *[
    (i:1..9)I(i)?vrata()->[
      irvasCnt++;
      [irvasCnt == 9 -> handleIrvas;]
    ]
    []
    (i:1..10)P(i)?vrata()->[
      patuljci(patuljakCnt++) = i;
      [patuljakCnt == 3 -> handlePatuljak;]
    ]

  ]
]
// patuljci(i:0..2)
handlePatuljak::[
  int j = 0;
  *[ // reci im da udju
    j < 3 ->[P(patuljci(j))!udji();  j++;];
  ]
  j=0;
  *[ // usli su
    j < 3, (k:1..10)P(k)?usao() -> j++;
  ]
  pricaj;
  j = 0;
  *[ // reci im da izadju
    j < 3 ->[P(patuljci(j))!dovidjenja(); j++;];
  ]
  j=0;
  *[ // izasli su
    j < 3, (k:1..10)P(k)?izasao() -> j++;
  ]
]


handleIrvas::[
  spremiSe;

  int j = 0;
  *[ // reci irvasima da idem na put
    j < 9 ->[I(j)!idemo(); j++;];
  ]
  putTamoINazad;
  j = 0;
  *[
    j < 9 ->[I(j)!poklon(); j++;];
  ]
  irvasCnt = 0;
]

irvas::[
  S!vrata();
  S?idemo();
  putTamoINazad;
  S?poklon();
]

patuljak::[
  S!vrata();
  S?udji();
  ulazak;
  S!usao();
  pricaj;
  S?dovidjenja();
  izlazak;
  S!izasao();
]