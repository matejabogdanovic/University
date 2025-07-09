// У свемиру постоји N небеских тела која међусобно интерагују (N
// Body Gravitational Problem), по Њутновом закону гравитације. Свако тело
// интерагује са сваким, при чему размењују информације о позицији, брзини
// и вектору силе. Користећи CSP потребно је решити овај проблем
// користећи торбу послова за дохватање посла и синхронизацију на
// баријери у свакој итерацији. Потребно је реализовати следеће процесе:
// Worker (обавља израчунавање), Bag (обавља поделу посла) и Collector
// (обавља прикупљање резултата). Број процеса Worker није познат, али је
// познато да их има мање од N. Постоји тачно један процес Bag и тачно
// један процес Collector

[C:collector||B:bag||(i:0..K)W(i):worker]
// K < N

bag::[
    // data
    int posx(0..N-1);
    int posy(0..N-1);
    int speed(0..N-1);
    int forcex(0..N-1);
    int forcey(0..N-1);
    int barrier = 0;
    
    *[
        barrier < N->[
            (i:0..N-1)W(i)?get()->[
                W(i)!barrier; // planet id
                W(i)!posx;
                W(i)!posy;
                ...
                W(i)!forcey;
                barrier = barrier+1;
            ]
        
        ]
        []
        barrier == N->[ // iteration finished
            barrier=0;
            C?posx; // get new data from collector
            C?posy;
            ...
            C?forcey;
        ]
    
    ]    

]

collector::[
    // data
    int posx(0..N-1);
    int posy(0..N-1);
    int speed(0..N-1);
    int forcex(0..N-1);
    int forcey(0..N-1);
    int barrier = 0;
    int id;
    *[
        barrier < N->[
            (i:0..N-1)W(i)?send(id)->[
                W(i)?posx[id];
                W(i)!posy[id];
                ...
                W(i)!forcey[id];
                barrier = barrier+1;
            ]
        
        ]
        []
        barrier == N->[ // iteration finished
            barrier=0;
            B!posx; // send new data to bag
            B!posy;
            ...
            B!forcey;
        ]
    
    ]    

]


worker::*[
    // data
    int posx(0..N-1);
    int posy(0..N-1);
    int speed(0..N-1);
    int forcex(0..N-1);
    int forcey(0..N-1);
    int id; // id of planet
    B!get();
    B?posx;
    B?posy;
    ...
    B?forcey;
    
    CALCULATE; // using id and data
    
    C!send(id);
    C!posx[id];
    C!posy[id];
    ...
    C!forcey[id];
]