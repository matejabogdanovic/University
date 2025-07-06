// Реализујте coarse grain ticket алгоритам за улазак у критичну
// секцију користећи CSP.

// ???? valjda ne treba jer je at most once property ispunjeno pa je 
// coarse grain isto sto i fine grain?

[T:ticket||P(id:1..N):process]

process:[
  
  T!ticket();
  T?ok();
  // kriticna sekcija
  T!next();
]

ticket:[
  int ticket = 0, next = 0;
  int arr(0..N-1) = {0}; // init na 0
  *[
    (i:1..N)T(i)?ticket() ->[
      arr(ticket) = i;
      ticket = (ticket+1) % N;
    ]
    []
    arr(next)>0 ->[
      T(arr(next))!ok();
      arr(next) = 0;
    ]
    []
    (i:1..N)T(i)?next() ->[
      next = (next+1) % N;
    ]
  ]

]