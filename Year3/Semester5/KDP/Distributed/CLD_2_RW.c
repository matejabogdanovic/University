// ticket algoritam



void reader(){
  int myTicket, cnt;
  while(1){
    // get ticket
    in("ticket", ?myTicket);
    out("ticket", myTicket+1);
    // wait for my turn
    in("next", myTicket);
    // let next 
    out("next", myTicket+1);
    // increment reading
    in("rcnt", ?cnt); 
    out("rcnt", cnt+1);

    READING();

    in("rcnt", ?cnt);
    out("rcnt", cnt-1);

  }
}

void writer(){
  int myTicket, cnt;
  while(1){
  // get ticket
  in("ticket", ?myTicket);
  out("ticket", myTicket+1);
    
  in("next", myTicket);
  
  rd("rcnt", 0); //  await rcnt = 0 and hold next so no one can enter

  WRITING();

  out("next", myTicket+1);


 }
}


void init(){
  out("ticket",0);
  out("next", 0);
  out("rcnt", 0);

  for(...)eval(reader());
  for(...)eval(writer());
};
