// Посматра се сто у мензи за којим може да седи највише N
// особа (N > 2). Особа узима храну (getFood()), седа за сто
// (sitAtTable()), једе (eat()), устаје са стола (leaveTable()) и одлази
// (walkAway()). Потребно је обезбедити да ниједна особа не једе, тј.
// седи за столом сама. Такође, свака особа која је узела храну мора да
// седне за сто и једе. Користећи семафоре написати методе sitAtTable()
// и leaveTable() које решавају овај проблем.

const int N = ...;
// ne mozes da sednes ako nema bar jedne osobe za stolom
// ne mozes da odes ako ce broj osoba spasti na 1
int want_to_eat = 0, eating = 0;
int want_to_leave = 0;
sem mutex = 1, wte = 0, wtl = 0, lets_eat = 0;

bool sitAtTable(){
  mutex.wait();
  if(eating == N){mutex.signal(); return false;}
  if(eating == 0){ // ako niko ne jede moram da proverim
    if(want_to_eat == 0){ // da li neko hoce da jede sa mnom
      // ako nikog nema da jede sa mnom
      want_to_eat++;
      mutex.signal(); // pustam kljuc i 

      wte.wait(); // blokiram se

      want_to_eat--;
      lets_eat.signal();
      return true;
    }
    else{ 
      // ako ima neko ko ceka da jedemo
       
      wte.signal();  // signaliziram mu i drzim mutex
      if(want_to_eat != 0) // cekam da potvrdi da je izasao
        lets_eat.wait();
      eating++; // uvelicam za njega
      
    }
  }
  
  eating++; // ja jedem isto
  if(want_to_leave > 0) // ako neko zeli da ide, sad moze
    wtl.signal();
  else
    mutex.signal();
  return true;
}

//int ticket = 0, next = 0;

void leaveTable(){
  mutex.wait();
  if(eating-1 < 2){
    want_to_leave++;
    mutex.signal();
     
    wtl.wait();
    want_to_leave--;
  }

  eating--;
  if(eating-1 >= 2) // pusti sledeceg da izadje ako moze
    wtl.signal();
  else
    mutex.signal();

}