
[R(i:1..RCNT):reader||W(j:1..WCNT):writer||C:coordinator]

// NE VALJA

// WRITERS PREFERRED
reader::*[
  C!startRead();
  // reading
  C!endRead();
]

writer::*[
  C!startWrite();
  C?OK();
  // write
  C!endWrite();
]


coordinator::[
  int r = 0, w = 0;
  
  *[ w==0, (j:1..WCNT)W(j)?startWrite() -> w=j; // ako niko nece da pise zapisi me da hocu da pisem
     []
     w==0, (i:1..RCNT)R(i)?startRead() -> r++; // ako niko nece da pise ili niko ne pise pocni sa pisanjem
     []
     (j:1..WCNT)W(j)?endWrite() -> w=0; // zavrsio sam sa pisanjem
     []
     (i:1..RCNT)R(i)?endRead() -> [ 
      r--;
      r == 0, w>0 -> W(w)!OK();  // pusti pisca da pise ako oce
    ];
  ]
]