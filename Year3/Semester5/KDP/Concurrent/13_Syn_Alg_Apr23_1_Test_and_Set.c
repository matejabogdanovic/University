// Написати и објасните Test and Set алгоритам за критичну
// секцију (coarse grain). Реализовати (fine grain) верзију алгоритма
// уколико би на датом процесору уместо TS постојала операција
// Compare-And-Swap која би недељиво обављала (CAS(a, b, c):
// < if (a == c) { c = b; return true;}
// else { a = c; return false;}>).

// coarse grain
int lock = 0;

<await(!lock); lock = 1;>
// critical section
lock = 0;


// fine grain sa TS

while(TS(lock))skip; 

lock = 0;

// fine grain Compare and Swap
int jedan  = 1;

// Compare-And-Swap која би недељиво обављала (CAS(lock, 1, 1):
// < if (lock == 1) { 1 = 1; return true;}
// else { lock = 1; return false;}>).

// if(lock == 1)1 = 1 return true;
// else lock == 0 => lock = 1; return false;
while(CAS(lock, jedan, jedan))skip;
//...
lock = 0;