// Решити проблем читалаца и писаца (Readers –
// Writers Problem) користећи поштанске сандучиће.
// Дозвољено је да само један процес чита поруке из
// једног сандучета.

struct msg {
  int id;
  string type; // rs, re, ws, we
}

mbx r[N];
void reader(int id){
  mbx me = r[id];
  while(true){
    msg m;
    c.put({id, "rs"});
    me.get(m,INF);
    read();
    c.put({id, "re"});
  }
}

mbx w[N];
void writer(int id){
  mbx me = w[id];
  while(true){
    msg m;
    c.put({id, "ws"});
    me.get(m,INF);
    write();
    c.put({id, "we"});
  }

}

mbx c;
void coordinator(){
  Queue<msg> rq;
  Queue<msg> wq;
  int rcnt, wcnt;
  while(true){
    msg m;
    c.get(m, INF);

    switch(m.type){
      case "rs":
        if(wq.size() > 0 || wcnt > 0)rq.put(m);
        else {
          r[m.id].put(m);
          rcnt++;
        }
      break;
      case "re":
        rcnt--;
        
        if(rcnt == 0 && wq.size()>0){
          // pusti da pise onaj koji ceka
          m = wq.remove();
          w[m.id].put(m);
          wcnt++;
          break;
        }

        if(wq.size() == 0){
          // pusti da citaju svi iz q
          while(rq.size()>0){
            m = rq.remove();
            r[m.id].put(m);
            rcnt++;
          }
        }


      break;
      case "ws":
        if(rq.size() > 0 || wcnt > 0 || rcnt > 0)wq.put(m);
        else {
          w[m.id].put(m);
          wcnt++;
        }
      break;
      case "we":
        wcnt--;
        if(rq.size()>0){
          // pusti da citaju svi iz q
          while(rq.size()>0){
            m = rq.remove();
            r[m.id].put(m);
            rcnt++;
          }
          break;
        }

        // pusti da pise onaj koji ceka
        if(wq.size()>0){
          m = wq.remove();
          w[m.id].put(m);
          wcnt++;
        }

        
      break;
    }
  
  }
}