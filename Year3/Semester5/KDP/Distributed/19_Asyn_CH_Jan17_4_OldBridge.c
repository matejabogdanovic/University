// Аутомобили који долазе са севера и југа морају да пређу реку преко
// неког старог моста (Old Bridge problem). На мосту постоји само једна
// возна трака, па сви аутомобили на мосту морају да се крећу у истом смеру.
// Због оптерећења моста које мост може да поднесе, укупна тежина свих
// аутомобила који се налазе на мосту не сме да пређе K тона (K > 0).
// Користећи размену порука написати програм који решава дати проблем.


const int N = ...;
const int K = ...;
chan autos[N]();
chan bridge(char dir, int kg, int id, string op);

// pretpostavka da nikad nece dodji vozilo koje je vece od K
void Bridge(){
  char dir, currdir = "";
  int kg, id, currkg = 0;
  string op; // start or end
  Queue<struct E {int id, int kg}> north, south; // pair (id and kg)
  while(1){
    recieve bridge(dir, kg, id, op);
    
    switch(op){
      case "start":
        if(currdir == ""){
          currdir = dir;
        }
        else if(dir == "s" && currdir == "n"){
            south.put(id, kg);
            break;
        }else if(dir == "n" && currdir == "s"){
            north.put(id, kg);
            break;
        }
        if(currkg + kg > K // previse kila 
           || !north.empty() 
           || !south.empty()){ // ima neko pre mene
            if(dir == "n")north.put(id, kg);
            else south.put(id, kg);
          break;
        }
        
        currkg += kg;
        send autos[id](); // go
      break;
      
      case "end":
        currkg -= kg;
        send autos[id](); // ack
        if(currkg == 0 &&
          currdir == "n" && 
          !south.empty()
          || 
          currdir == "s" &&
          north.empty() &&
          !south.empty()
        ){
          currdir = "s";
         while(!south.empty()){
          if(south.peek().kg + currkg > K)break;
          E e = south.remove();
          currkg += e.kg;
          send autos[e.id](); // go
         }
        }
        else if( 
          currkg == 0 && 
          currdir == "s" && 
          !north.empty()
          ||
          currdir == "n" &&
          south.empty() &&
          !north.empty()
        ) {
         currdir = "n";
         while(!north.empty()){
          if(north.peek().kg + currkg > K)break;
          E e = north.remove();
          currkg += e.kg;
          send autos[e.id](); // go
         }
        }else if (currkg == 0 && north.empty() && south.empty())else currdir = "";
     break;
  }
  
}

void Auto(char dir, int kg, int id){
  chan myChan = autos[id];
  send bridge(dir, kg, id, "start");
  revieve myChan(); // go 

  // cross

  send bridge(dir, kg, id, "end");
  revieve myChan(); // ack
}

