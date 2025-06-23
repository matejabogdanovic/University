// Пет филозофа седи око стола. Сваки филозоф
// наизменично једе и размишља. Испред сваког
// филозофа је тањир шпагета. Када филозоф
// пожели да једе, он узима две виљушке које се
// налазе уз његов тањир. На столу, међутим, има
// само пет виљушки. Значи, филозоф може да једе
// само када ниједан од његових суседа не једе.


struct msg{
  int id;
  string m; // start/end
} 
// phils[id].get(msg, time/INF/0, status) / put(msg)
mbx phils[5];
mbx room;
void philosopher(int id){
  msg m;bool status;
  while(1){
    room.put({id, "start"});
    phils[id].get(m, INF, status);

    EATING();

    room.put({id, "end"});

  }

}

void room(){
  int forks[5] = {1}; // 1 - free, 0 - not free
  msg m;bool status;
  int pending[5] = {0} // 0 - not pending, 1 - pending 
   while(1){
    room.get(m, INF, status); 
    int left = m.id, right = (m.id+1)%5;
    if(m.m=="start"){
      if(forks[left] && forks[right]){
        forks[left] = forks[right] = 0;
        phils[m.id].put(m); // can start eating 
      }else 
        pending[m.id] = 1;
    }else{ // m.m==end
      forks[left] = forks[right] = 1;
      for(int i = 0; i < 5 ; i++){
        if(!pending[i])continue;
        left = i, right = (i+1)%5;
        if(forks[left] && forks[right]){
          forks[left] = forks[right] = 0;
          phils[i].put(m); // can start eating
          pending[i] = 0; 
        }
      }
    }
  }
}


// Filozofi su povezani u prsten, ima samo levi i desni mbx



typedef string msg; 
// phils[id].get(msg, time/INF/0, status) / put(msg)
mbx phils[5];

void philosopher(int id){
  mbx left = phils[id], right = phils[(id+1)%5];
  while(1){
    if(id==0){
      left.put("")
    }else{

    }

  }

}
