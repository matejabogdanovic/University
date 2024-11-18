// Користећи мониторе са signal and wait дисциплином решити
// проблем забавишта (The Child Care Problem). У неком забавишту
// постоји правило које каже да се на свака три детета мора наћи барем
// једна васпитачица. Родитељ доводи једно или више деце у забавиште.
// Уколико има места оставља их, уколико не, чека. Васпитачица сме да
// напусти забавиште само уколико то не нарушава правило. Монитор
// садржи процедуре за родитеље који доводе и одводе децу и
// васпитачице које долазе на посао и одлазе са посла. Иницијализовати
// почетне услове.

monitor ChildCare{
  cond r, v;  
  int rc = 0, vc = 0, dc = 0; // cnt

  void dovediDecu(int cnt){
    if(dc + cnt > vc * 3)
      r.wait(cnt); // nema slobodno mesta
    dc += cnt;

    if(r.queue() && dc + r.minrank() <= vc * 3)
      r.signal();
  }

  void odvediDecu(int cnt){
    dc -= cnt; 
    if(v.queue() && dc <= (vc-1) * 3) // pusti sve vaspitacice
      v.signal();
    else if(r.queue() && dc + r.minrank() <= vc * 3) // ili pusti sve roditelje
      r.signal();
  }

  void dodji(){
    vc++;
    if(r.queue() && dc + r.minrank() <= vc * 3) // pusti sve roditelje
      r.signal();
    else if(v.queue() && dc <= (vc-1) * 3) // ili pusti sve vaspitacice
      v.signal();
  }

  void idi(){
    if(dc > (vc-1) * 3)
      v.wait(); // ne smes da ides
    vc--;
    if(v.queue() && dc <= (vc-1) * 3) // odu sve vaspitacice koje mogu
      v.signal();
  }



};