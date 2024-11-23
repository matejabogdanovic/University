// coarse grain
<await(B) S;>
// => fine grain
mutex.wait();
if(!B)DELAY;
S;
SIGNAL;


// DELAY
if(!request_satisfied){
  r++;
  mutex.signal(); // pusti kljuc
  sr.wait(); // semafor za DELAY, svaki delay ima svoj semafor
}

// SIGNAL
if(request_satisfied){
  r--;
  sr.signal(); // predaj kriticnu sekciju bez pustanja mutexa
}
...
else
  mutex.signal();