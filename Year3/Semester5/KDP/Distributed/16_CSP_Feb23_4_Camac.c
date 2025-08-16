// На једној обали реке се налази чамац који превози путнике са
// једне на другу обалу и који може да прими тачно десет путника. Чамац
// могу да користе мушкарци, жене и деца. Чамац може да исплови само
// ако се у њему налази тачно онолико путника колики му је капацитет,
// али само под условом да се у чамцу налазе бар два мушкарца. Деца не
// смеју ући у чамац уколико се у њему не налазе бар једна одрасла особа
// и по завршетку вожње у чамцу не смеју да остану само деца. Сматрати
// да ће се чамац након искрцавања свих путника одмах бити спреман да
// прими наредну групу путника. Користећи CSP написати програм који
// решава овај проблем.

const int N = 10;

[CAM:camac || (0..CNTM)M:people || (0..CNTW)W:people || (0..CNTC)C:people]

camac::[
  bool can_in = true;
  int men(0..N-1);
  int wom(0..N-1);
  int chi(0..N-1);
  int currm = 0, currw = 0, currc = 0;
  
  *[  
    can_in, (id:0..CNTM)M?in()[
      men(currm++) = id;
      [currm+currw+currc == N -> can_in = false;]
    ] 
    []
    can_in, currm >= 2, (id:0..CNTW)W?in()[
      wom(currw++) = id;
      [currm+currw+currc == N -> can_in = false;]
    ]
    []
    can_in, currm >= 2, (id:0..CNTC)C?in()[
      chi(currc++) = id;
      [currm+currw+currc == N -> can_in = false;]
    ]
    []
    !can_in -> [
      int i = currm;
      [i != 0 -> [
        M(men(--i))!riding();
      ]]
      i = currw;
      [i != 0 -> [
        W(wom(--i))!riding();
      ]]
      i = currc;
      [i != 0 -> [
        C(chi(--i))!riding();
      ]]

      // RIDE

      [currc != 0 -> [
        C(chi(--currc))!endRide();
      ]]
      [currm != 0 -> [
        M(men(--currm))!endRide();
      ]]
      [currw != 0 -> [
        W(wom(--currw))!endRide();
      ]]
     
      can_in = true;
    ]

  ]

]

// analogno za ostale
people::[

  C!in();
  C?riding();
  // riding
  C?endRide();
]
