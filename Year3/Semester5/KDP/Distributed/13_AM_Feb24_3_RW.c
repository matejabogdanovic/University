// Решити проблем читалаца и писаца (Readers–Writers Problem)
// користећи активне мониторе. Обезбедити да процес који је пре упутио
// захтев за приступ ресурсу пре треба да буде опслужен.

enum op_kind = {wr, ww, er, ew};
typedef struct Pair {
  int id;
  op_kind req;
} Pair;
const int N = ...;
chan request(int, op_kind);
chan reply[N]();
void Monitor() {
  int id; op_kind req;
  int wcnt = 0, rcnt = 0;
  Queue<Pair>q; //
  while(1){
    recieve request(id, req);
 
    switch(req){
      case wr:
        if(q.size() > 0 || wcnt > 0){
          q.push({id, req});
          break;
        }
        // q is empty and no one is writing 
        rcnt++;
        send reply[id](); // go read
      break;
      case ww:
        if(q.size() > 0 || wcnt > 0 || rcnt > 0){
          q.push({id, req});
          break;
        }
        // q is empty and no one is reading or writing 
        wcnt = 1;
        send reply[id](); // go write
      break;
      case er:
        rcnt--;
        if(rcnt == 0 && q.size() > 0){
          Pair p;
          if(q.first().req == wr){
            while(q.first().req == wr){
              rcnt++;
              p = q.pop(); // remove from q
              send reply[p.id](); // go read
            }
          }else{
            wcnt = 1;
            p = q.pop();
            send reply[p.id](); // go write
          }
        } 
      break;
      case ew:
        wcnt = 0;
        if(q.size() > 0){
          Pair p;
          if(q.first().req == wr){
            while(q.first().req == wr){
              rcnt++;
              p = q.pop(); // remove from q
              send reply[p.id](); // go read
            }
          }else{
            wcnt = 1;
            p = q.pop();
            send reply[p.id](); // go write
          }
        } 
      break;
    }


  }

}

// skraceno

enum op_kind = {wr, ww, er, ew};
typedef struct Pair {
  int id;
  op_kind req;
} Pair;
const int N = ...;
chan request(int, op_kind);
chan reply[N]();
void Monitor() {
  int id; op_kind req;
  int wcnt = 0, rcnt = 0;
  Queue<Pair>q; //
  while(1){
    recieve request(id, req);
 
    switch(req){
      case wr:
        if(q.size() > 0 || wcnt > 0){
          q.push({id, req});
          break;
        }
        // q is empty and no one is writing 
        rcnt++;
        send reply[id](); // go read
      break;
      case ww:
        if(q.size() > 0 || wcnt > 0 || rcnt > 0){
          q.push({id, req});
          break;
        }
        // q is empty and no one is reading or writing 
        wcnt = 1;
        send reply[id](); // go write
      break;
      case er:
        rcnt--;
        if(rcnt == 0 && q.size() > 0){ // sigurno ceka pisac 
          wcnt = 1;
          send reply[q.pop().id](); // go write
        } 
      break;
      case ew:
        wcnt = 0;
        if(q.size() > 0){
          if(q.first().req == wr){
            while(q.first().req == wr){
              rcnt++;
              send reply[q.pop().id](); // go read
            }
          }else{
            wcnt = 1;
            send reply[q.pop().id](); // go write
          }
        } 
      break;
    }


  }

}
