// Написати програм за процес X који прослеђује знаке
// добијене од процеса west процесу east.

[west::WEST||east::EAST||X::method]
method::*[
  char c;
  west?c -> east!c
]

// Модификовати претходно решење тако да свака две
// суседне звездице “**” замени са “^”. Сматрати да
// последњи знак није звездица.

[west::WEST||east::EAST||X::method]

method::*[
  char c1, c2;
  
  west?c1 -> [
    c1 == "*", west?c2 ->[ // NE MOZE ODMA DA SE CITA C2 JER AKO C2 NE POSTOJI, NECE SE POSLATI C1 mora c1=="*" ->[west?c2->...]
      c2 == "*" -> east!"^";
      []
      c2 != "*" ->[east!c1; east!c2;]
    ]
    []
    c1 != "*" -> east!c1;
  ]

]



