// coarse grain

int ticket = 0;
void process(){
  <int myTicket = ticket; ticket ++;>
  <await(myTicket == next);>
  next++;

}

// fine grain

void process(){
  myTicket = FA(ticket, 1); // fetch and add => return ticket and ticket = ticket + 1
  or
  myTicket = GS(ticket, ticket+1); // get and set => return ticket and set ticket = ticket + 1
  or
  myTicket = addAndGet(ticket, 1) - 1;//  < var = var + incr; return(var);
  while(myTicket != next)skip;
  next++;
}

