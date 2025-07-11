// Користећи технику активних монитора потребно је реализовати
// семафор који поред стандардних атомских операција signal() и wait() има и
// атомске операције signal(n) и wait(n) која интерну семафорску
// променљиву атомски увећава односно умањује за n уколико је то могуће,
// уколико није чека док не буде били могуће. Процес који је раније упутио
// захтев треба раније да обави своју операцију


chan request(int, Operation); // client, op
chan reply[N]();

typedef struct Operation {
    string kind; // signal, wait
    int n=1;
}Operation;

typedef struct Request {
    int client;
    int n;
}Request;

void Semaphore(){
    int client;
    Operation op;
    int s = ...;
    Queue<Request> p();
    
    while(1){
        recieve request(client, op); 
        
        switch(op.kind){
            case "wait":
                if(s-op.n<0)
                    p.put({client, op.n});
                else {
                  s -= op.n;
                  send reply[op.client](); // continue  
                }
            
            break;
            
            case "signal":
                s+=op.n;
                while(p.size()>0 and s-p.first().n>=0){
                    Request r = p.remove();
                    s -= r.n;
                    send reply[r.client](); // continue
                }
            break;
        
        }
    
    
    }

}