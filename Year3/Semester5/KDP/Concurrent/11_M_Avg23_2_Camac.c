// На једној обали реке се налази чамац који превози путнике са
// једне на другу обалу и који може да прими тачно десет путника. Чамац
// могу да користе мушкарци, жене и деца. Чамац може да исплови само ако
// се у њему налази тачно онолико путника колики му је капацитет, али само
// под условом да се у чамцу налазе бар два мушкарца. Деца не смеју ући у
// чамац уколико се у њему не налазе бар једна одрасла особа и по завршетку
// вожње у чамцу не смеју да остану само деца. Сматрати да ће чамац након
// искрцавања свих путника одмах бити спреман да прими наредну групу
// путника. Користећи мониторе који имају signal and wait дисциплину
// решити овај проблем.

monitor Camac{
  const int K = 10;
  bool otplovio = false;
  int m = 0, z = 0, d = 0; // brojaci
  cond um, uz, ud; // ulazi
  cond im, iz, id; // izlazi

  void enterM(){
    if(m+z+d == K || otplovio)
      qm.wait();
    m++;

    if(qm.queue() && m < 2) // prvo se ukrcavaju muskarci
        qm.signal();
    else if(m+z+d < K && m >= 2) {// ima mesta za jos
      if(qz.queue()) // -> zene -> deca -> muskarci
        qz.signal();
      else if(qd.queue()) 
        qd.signal();
    }

    if(m+z+d == K){otplovio = true; return;}
    else im.wait();
  }

  void exitM(){
    if(m+z+d == 1)
      otplovio = false;

    if(id.queue()) // prednost deci
      id.signal();
    else if(iz.queue())
      iz.signal();
    else if(im.queue())
      im.signal();
    m--;

  }

  void enterZ(){
    if(m+z+d == K || m < 2 || otplovio)
      qz.wait();
    z++;

    if(m+z+d < K) {
      if(qd.queue()) // -> decu
        qd.signal();
      else if(qm.queue())
        qm.signal();
      else if(qz.queue())
        qz.signal();
    }

    if(m+z+d == K){otplovio = true;}
    else iz.wait();
    

  }

  void exitZ(){
    if(m+z+d == 1)
      otplovio = false;

    if(id.queue()) // prednost deci
      id.signal();
    else if(im.queue())
      im.signal();
    else if(iz.queue())
      iz.signal();
    z--;
  }

  void enterD(){
    if(m+z+d == K || m+z == 0 || m < 2 || otplovio)
      dz.wait();
    d++;

    if(m+z+d < K) {
      if(qm.queue()) // -> muskarce
        qm.signal();
      else if(qz.queue()) 
        qz.signal();
      else if(qd.queue())
        qd.signal();
    }

    if(m+z+d == K){otplovio = true; return;}
    else id.wait();
  }

  void exitD(){
    if(m+z+d == 1)
      otplovio = false;
    d--;
    if(id.queue()) // prednost deci
      id.signal();
    else if(im.queue())
      im.signal();
    else if(iz.queue())
      iz.signal();

  }
};