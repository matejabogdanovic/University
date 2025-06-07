// Пројектовати бинарни семафор користећи
// програмски језик CSP.

[Semaphore::semaphore || Process (i:1..N)::process]

semaphore::[
  bool s = true;

  *[
    s, Process(i)?wait() -> s = false;

    []

    Process(i)?signal() -> s = true;

  ]


]