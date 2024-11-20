// Решити проблем читалаца и писаца (Reader Writers Problem)
// користећи семафоре. Обезбедити да процеси започињу приступ ресурсу
// по редоследу слања захтева. Претпоставити да у неком тренутку
// максимално N процеса може упутити захтев за приступ ресурсу. 
struct Info{
  sem semafor = null;
  char tip = '';
};

Queue<Info> q = {null};
int rcnt = 0, wcnt = 0;
sem mutex = 1;

void reader(){
 mutex.wait();
 if(wcnt > 0 || !q.empty()){
  sem mySem = 0;
  q.insert({mySem, 'r'});
  mutex.signal();

  mySem.wait();
 }else{
  rcnt++;
  mutex.signal();
 }


 read();

 mutex.wait();
 rcnt--;
  while(!q.empty() && q.first().tip == 'r') // moze if ali radi sporije
    {rcnt++; q.remove().semafor.signal(); }
  
  if(!q.empty() && rcnt==0 && q.first().tip == 'w')
    q.remove().semafor.signal();

  mutex.signal();

}

void writer(){
   mutex.wait();
 if(wcnt > 0 || rcnt > 0 || !q.empty()){
  sem mySem = 0;
  q.insert({mySem, 'w'});
  mutex.signal();

  mySem.wait();
 }else{
  wcnt++;
  mutex.signal();
 }


 write();

 mutex.wait();
 wcnt--;
  if(!q.empty() && q.first().tip == 'w') {
    wcnt++; q.remove().semafor.signal(); 
  }
  
  if(!q.empty() && wcnt==0 && q.first().tip == 'r')
    q.remove().semafor.signal();

  mutex.signal();

}