// Посматра се један паркинг. Постоји само једна рампа која служи и за
// улаз, и за излаз са паркинга, кроз коју може пролазити само један аутомобил у
// једном тренутку. На паркингу има N места за паркирање. Аутомобили који
// улазе, могу да уђу, један по један, уколико има слободних места. Уколико
// нема слободног места, проверава се да ли има аутомобила који хоће да изађу.
// Ако након изласка свих аутомобила који желе да изађу и уласка аутомобила
// који су дошли пре њега за аутомобил неће бити места, он одлази у потрагу за
// другим паркингом. Аутомобили при изласку плаћају услуге паркинга и излазе
// један по један. Предност на рампи имају аутомобили који излазе са паркинга.
// Коришћењем једног низа од највише 2N + 1 семафора направити методе за
// тражење дозвола за улаз и излаз и обавештавање о уласку и изласку
// аутомобила са паркинга. Није дозвољено користити помоћне структуре
// података ни додатне елементе за синхронизацију процеса. Спречити
// изгладњивање.


// NMG DA RADIM OVO VISE
const int N = ...;
int slobodno = N, izlazcnt = 0, ulazcnt = 0;
int tail_ulaz = 0, tail_izlaz = 0;
int next_ulaz = 0, next_izlaz = 0;
sem ulaz[N] = 0;
sem izlaz[N] = 0;
sem rampa = 1;

bool dulaz(){
  rampa.wait();
  // trazi drugo mesto ako nema mesta da se udje ili ako je parking pun a kad izadju koji hoce opet nema mesta
  if(ulazcnt == N || slobodno == 0 && ulazcnt+1 > izlazcnt){rampa.signal(); return false;}

  if(ulazcnt > 0 || izlazcnt > 0){ 
    int mySemID = tail_ulaz;
    tail_ulaz = (tail_ulaz+1)%N;
    if(izlazcnt > 0)
      izlaz[next_izlaz].signal(); // prednost daj onima koji izlaze
    
    ulaz[mySemID].wait(); // cekaj da te neko pusti
  
  }

  ulazcnt++;
  

}

void oulaz(){
  slobodno--;
  ulazcnt--;
  
}

void dizlaz(){
  rampa.wait();
  izlazcnt++;
  int mySemID = tail_izlaz;
  tail_izlaz = (tail_izlaz+1)%N;
  if(izlazcnt > 1 || ulazcnt > 0){
    rampa.signal();
    izlaz[mySemID].wait();
  }
}

void oizlaz(){
  izlazcnt--;
  slobodno++;
  if(izlazcnt > 0){
    int sledeci = next_izlaz;
    next_izlaz = (next_izlaz+1)%N;
    izlaz[sledeci].signal();
  }else if(ulazcnt > 0){
    int sledeci = next_ulaz;
    next_ulaz = (next_ulaz+1)%N;
    ulaz[sledeci].signal();
  }else 
    rampa.signal();
}


