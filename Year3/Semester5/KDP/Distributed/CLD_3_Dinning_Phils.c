
//    | 0 | 1 | 2 | 3 | 4  (| 0 | 1 ...)



void philosopher(int id){
  int right = (id+1)%5, left = id;
  while(1){
    if(id == 0){
      in("fork", left);
      in("fork", right);
    }else{
      in("fork", right);
      in("fork", left);
    }

    EATING();

    out("fork", left);
    out("fork", right);


  }

}


void init(){


  for(int i = 0; i < 5)out("fork", i);
  for(int i = 0; i < 5)eval(philosopher(i));
}
