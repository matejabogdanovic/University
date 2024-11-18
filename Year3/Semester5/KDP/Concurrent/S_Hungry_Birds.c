// У гнезду живи n птића и две родитељске птице (The
// Hungry Birds Problem). Птићи једу из заједничке
// посуде која прима F црвића. Сваки птић
// непрекидно једе из посуде по једног црвића, мало
// спава и поново се враћа да једе. Када посуда
// постане празна, птић који је испразнио посуду
// буди једног од родитеља. Родитељска птица може
// да крене у лов на црвиће само уколико у гнезду
// остане други родитељ. Из лова се родитељ враћа
// тек када накупи F црвића које сипа у посуду.
// Родитељске птице осим тога што чувају птиће и
// иду у лов могу да напусте гнездо да би саме јеле,
// тако да у гнезду увек остане један родитељ.
// Користећи семафоре написати програм који
// симулира понашање птића и родитеља.

// NE VALJAAA nemoj da kod zuji unaokolo nego ako ne rade nista nek se blokiraju
// stafetna palica
int posuda = F;
sem mutex_empty = 1, mutex_roditelji =1, mutex_posuda = 1;
int gnezdo_cnt = 2;
int stanja[2] = {0, 0}; // 0 - gnezdo, 1 - lov, 2 - jede
bool empty = false;
void ptic(){
  while(true){
    sleep();

    mutex_posuda.wait();
    if(posuda-1 >= 0){
      posuda--;
      if(posuda == 0){
        mutex_empty.wait();
        empty = true;
        mutex_empty.signal();
      }
    }
    mutex_posuda.signal();

  }
}

void roditelj(int id){
  
  while(true){
    mutex_empty.wait();
      if(empty == true){
        mutex_empty.signal();
        
        mutex_roditelji.wait();
        if(stanja[(id+1)%2] == 0){ // idem u lov
          stanja[id] = 2;
          mutex_roditelji.signal();
          // lovi
          mutex_posuda.wait();
          posuda = F; // sipaj
          empty = false;
          mutex_posuda.signal();

          mutex_roditelji.wait();
          stanja[id] = 0;// u gnezdu
          mutex_roditelji.signal();
        }
        
      }else mutex_empty.signal();
    
    mutex_roditelji.wait();

    mutex_roditelji.signal();
  }

}