// Решити проблем читалаца и писаца користећи CSP. Решење
// треба да обезбеди да када стигне захтев од писца за тражење дозволе за
// започињање писања не треба прихватати захтеве за започињање било
// од читалаца било од писаца док тај писац не заврши са писањем.

[R(i:1..RCNT):reader||W(j:1..WCNT):writer||C:coordinator]

reader::*[
  C!startRead();
  // read
  C!endRead();
]

writer::*[
  C!startWrite();
  C?OK();
  // write
  C!endWrite();
]


coordinator::[
  int rcnt = 0;
  *[
   (j:1..WCNT)W(j)?startWrite() -> [
      *[
        rcnt>0, (i:1..RCNT)R(i)?endRead() -> rcnt--;  
      ]
      W(j)!OK()
      W(j)?endWrite(); // wait to end writing
 
    ]
    []
    (i:1..RCNT)R(i)?startRead() -> [
      rcnt++;
    ]
    []
    (i:1..RCNT)R(i)?endRead() -> [
      rcnt--;
    ]

  ]
]