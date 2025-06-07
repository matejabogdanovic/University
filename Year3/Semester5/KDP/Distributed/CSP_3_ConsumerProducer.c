[C(c:1..C_CNT)::consumer||P(p:1..P_CNT)::producer||buffer::buffer]


consumer::*[
  int item;

  buffer!get();
  buffer?item;

  // do something
]


producer::*[
  int item = ...; // make item
  buffer!put(item);
]

buffer::[
  int b(0..N-1);
  int start = 0, end = 0, cnt = 0;
  int item;
  *[
    cnt < N, (p:1..P_CNT)P(p)?put(item) -> [ // kada bi bilo kod producer samo !item onda moze odma ?b(end) da se odma primi i upise
      b(end) = item;
      end = (end + 1)%N;
      cnt++;
    ]

    []

     cnt > 0, (c:1..C_CNT)C(c)?get() -> [
      // item = b(start);
      C(c)!b(start);
      start = (start + 1)%N;
      cnt--;
      // C(c)!item;
    ]

  ]

]

