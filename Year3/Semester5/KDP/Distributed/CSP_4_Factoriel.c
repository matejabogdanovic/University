// Израчунати факторијел рекурзивном методом, до
// одређене границе.


// LIMIT procesa koji se zovu fac i izvrsavaju isti kod FACTORIEL
// jedan proces koji je takodje deo niza procesa fac ali izvrsava kod USER
[(i: 1..LIMIT)fac:FACTORIEL || fac(0):USER]

FACTORIEL::*[
  // ovde sad mogu da koristim i kao index mog procesa

]

USER::[
  int number = ...;
  int res;
  fac(1)!number;
  fac(1)?res;
  
]
