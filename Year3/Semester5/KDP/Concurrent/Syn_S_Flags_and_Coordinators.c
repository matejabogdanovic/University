
const int N = ...;
int arrived[N] = {0};
int continue[N] = {0};
// bez optimizacije kesa
<await(sum(arrived)==N)> // sum => cita svaki element niza ATOMICNO pa ih sabira
// sa optimizacijom kesa
for(int i = 0; i < N; i++)<await(arrived[i])>; // blokiram se dok ne dodje 0, 1, ... N

// => coarse grain resenje
void worker(int id){

  work();
  
  arrived[i] = 1;
  <await(continue[id])>;
  continue[id] = 0;

}

void coordinator(){
  for(int i = 0; i < N; i++){<await(arrived[i])>; arrived[i] = 0;} // blokiram se dok ne dodje 0, 1, ... N
  for(int i = 0; i < N; i++)continue[i] = 1; // obavesti ih da nastave
}