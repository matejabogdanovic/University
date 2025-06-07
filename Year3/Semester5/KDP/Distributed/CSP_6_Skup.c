// Представити у CSP-у скуп од највише 100 целих
// бројева као процес S, који прихвата два типа
// инструкција од позивајућег процеса X:
// 1) S!insert (n), убацује цео број n у скуп, и
// 2) S!has (n);...;S?b, где је b истинито ако је n у скупу,
// односно неистинито у супротном случају.
// У почетку је скуп празан.

[S:skup || X:procedure]

search::[        
 int i = 0;
 *[
    i < cnt, arr(i) != n -> i++;
  ]
]

skup::[
  int arr(0..99), cnt = 0;
  
  *[
    int n;
    cnt < 100 -> [

      S?insert(n) -> [
        search;
        
        i == cnt -> arr(cnt++) = n;
        
      ]

      S?has(n) -> [
        search;
        X!(i<cnt);
      ]

    ]
  ]


]


// Проширити претходно решење, обезбеђујући брзи
// метод за скенирање свих елемената скупа, без
// мењања вредности. Кориснички програм садржи
// команду типа:
// S!scan (); more: boolean; more := true;
// *[ more; x: integer; S?next (x); → ...radi sa x...
// □
// more; S?noneleft () → more := false
// ]
// где S!scan () служи да постави скуп у скенирајући
// режим.

...
int arr(0..99);int cnt = 0;
...
X?scan()->[
  int i = 0;
  *[
    i < cnt -> S!next(arr(i++));
    // []
    // i == cnt -> S!noneleft();
  ] 
  S!noneleft();
]
...

// Решити проблем скупа од максимално 100 бројева,
// са две операције (из претпоследњег задатка)
// помоћу низа процеса, од којих сваки садржи
// највише један број. Када процес не садржи
// ниједан број, на сваки упит о садржини треба да
// одговори са "false"

// 1) S!insert (n), убацује цео број n у скуп, и
// 2) S!has (n);...;S?b, где је b истинито ако је n у скупу,
// односно неистинито у супротном случају.

[(i:1..100)S(i):s::[
  int num; bool has = false;
  int n;
  *[
    

    S(i-1)?has(n) -> [
      has == false -> S(i-1)!false; // ako nemam upisan broj onda ne postoji
      []
      has == true -> [ // ako imam upisan broj
        num == n -> S(i-1)!true; 
        []
        num > n -> S(i-1)!false; 
        []
        num < n ->[ // ali je upisan broj manji
          i == 99 -> S(i-1)!false;  // ako sam poslednji onda nema
          []
          i < 99 -> [
            bool reply;
            S(i+1)!has(n)
            S(i+1)?reply;

            S(i-1)!reply;
          
          ]
          // ako nisam poslednji, pitam sledeceg da li ima i tako rekurkzivno ide dok ne dobijem odgovor koji onda posaljem prethodnom
        ]
      ]
    ]
  
    []

    S(i-1)?insert(n) -> [
      has == false -> [has=true; num = n;] // insertujem ako nemam broj jer smo dosli do kraja
      []
      has == true ->[
        num == n -> skip; // vec upisan pa ne moram da pomeram niz udesno
        []
        num > n -> [
          i < 99 -> S(i+1)!insert(num); // pomeram niz udesno
          num = n; // prihvatam nov broj
        ]  
        []
        num < n ->[
          i < 99 -> S(i+1)!insert(n); // prosledi sledecem 
        ]

        ]
      ]
    ]


  ]

  

 
|| 

S(0):procedure
] 




