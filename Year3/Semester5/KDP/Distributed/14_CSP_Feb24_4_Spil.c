// Посматра се шпил од 24 карте, подељене у 4 боје, са по 6
// различитих бројева. Игру играју 4 играча, који седе за округлим столом
// и сваки од њих иницијално држи по 4 карте. Између два суседна играча
// се налази гомила са картама, која може у неком тренутку бити празна, а
// иницијално садржи 2 карте. Игра се завршава када бар један играч
// објави да има све 4 карте истог броја, у различитим бојама, и тада сви
// играчи прекидају игру. Сваки играч, док год нема 4 исте и нико није
// објавио да је победник, избацује једну карту из своје руке и ставља је
// на гомилу са своје леве стране, потом узима једну карту са врха из
// гомиле са своје десне стране. Претпоставити да су играчима
// иницијално подељене карте на случајан начин. Користећи CSP
// написати програме за играче и гомиле са картама. 


[(id:0..3)I(id):igrac||Pobednik:pobednik||(id:0..3)P(id):pile]
// karte brojevi 1..6, boja nije ni bitna 
igrac::[
  int id = ...; // 0..3 moj index
  int pId; // pobednik id 
  int pileLeft = id;
  int pileRight = (id+1)%4;
  bool kraj = false; 
  int cards(i:0..3) = ...; 
  int newCard;

  *[
    !kraj ->[ // proveri jel ima pobednik
      Pobednik!check();
      Pobednik?pId;
      [
        pId >= 0 -> kraj = true;
        []
        pId < 0 ->[
          // stavi u levi pile
          int cardRemoveIndex = ...; // index da se izbaci karta
          P(pileLeft)!putCard(cards(cardRemoveIndex)); // ubaci u levi pile

          // uzmi iz desnog pile
          P(pileRight)!getCard();
          P(pileRight)?newCard;
          // stavi u ruku novu kartu
          cards(cardRemoveIndex) = newCard;

          // provera jel sam pobedio
          int i = 1;
          int compareCard = cards(0);
          // compareCard uporedi sa svim ostalim i vidi jel isto
          *[i<4, compareCard>0 ->[ 
            [compareCard != cards(i) ->compareCard = -1]  
            i++;]]
          
          [compareCard > 0 ->[
            Pobednik()!pobeda(id); // pobedio sam!
            kraj = true;]]
            ]
      ]
      
    ]
  ]
]

pile::[
  int id = ...; // 0..3 moj index
  int cards(i:0..7) = ...; // inicijalno 2 karte al moze biti max 8, ako nema karte onda je 0 napisana
  int top = 1; // prva zauzeta
  int card; // prva zauzeta
  *[
    (i:0..3)I(i)?putCard(card)->[
      top = top +1; 
      cards(top) = card;
    ]
    []
    top>=0, (i:0..3)I(i)?getCard()->[
      I(i)!cards(top);
      top = top -1; // -1 kad nema karte
    ]
  ]
]

pobednik::[
  int pId = -1;
  *[
    (i:0..3)I(i)?check()->[
      I(i)!pId;
    ]
    []
    (i:0..3)I(i)?pobeda(pId)->[] // upis novog pId => pobednik nadjen
  ]
]