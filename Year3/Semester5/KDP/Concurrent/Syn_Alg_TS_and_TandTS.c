int lock = 0;
// coarse grain
<await(lock == 0)lock = 1;>
lock = 0;

// fine grain
while(TS(lock))skip; // TS => <var var1 = lock; lock = 1; return var1;>
lock = 0;
// fine grain sa optimizacijom kesa
// TEST AND TEST AND SET

while(lock == 1)skip; // test 
// moze neko da zauzme lock pre nas
while(TS(lock)){ // test and set
  while(lock == 1)skip; // test
}
lock = 0;