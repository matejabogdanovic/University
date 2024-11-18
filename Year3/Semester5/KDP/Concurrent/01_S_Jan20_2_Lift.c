// Користећи семафоре написати програм који решава проблем путовања лифтом. Путник позива лифт са произвољног спрата. Када лифт стигне на неки спрат сви путници који су изразили жељу да сиђу на том спрату обавезно изађу. Након изласка путника сви путници који су чекали на улазак уђу у лифт и кажу на који спрат желе да пређу. Тек када се сви изјасне лифт прелази даље. Лифт редом обилази спратове и стаје само на оне где има путника који улазе или излазе. Може се претпоставити да постоји N спратова.

const int N = ...;

sem pozivam_sa_sprata[N] = {0}; // blokiram se na spratu N dok cekam lift
int cnt_sa_sprata[N] = {0}; // broj ljudi koji je blokiran na N spratu
sem zelim_sprat[N] = {0}; // kad lift dodje blokiram se na semaforu N koji odgovara spratu N
int cnt_na_sprat[N] = {0}; // opet broj ljudi koji su u liftu i cekaju na N spratu
sem izjasnio_se = 0;
sem izasao = 0;
sem mutex = 1;
void putnik(int sa_sprat, int na_sprat){
  while(true){
    mutex.wait()
      cnt_sa_sprata[sa_sprat]++;
    mutex.signal();
    
    pozivam_sa_sprata[sa_sprat].wait();
    // lift stigao, izjasni se
    mutex.wait();
      cnt_na_sprat[na_sprat]++;
    mutex.signal();
    
    izjasnio_se.signal();
    zelim_sprat[na_sprat].wait();
    // izadji
    izasao.signal();

  }
}

void lift(){
  int sprat = 0;
  char smer = 1; // Up = 1 ili Down = -1
  while(true){
    mutex.wait(); 
      for(int i = 0; i < cnt_na_sprat[sprat]; i++)// nek izadju svi
        zelim_sprat[sprat].signal();
      
      cnt = cnt_na_sprat[sprat];
      cnt_na_sprat[sprat] = 0;
    mutex.signal(); 

    while(cnt+1){ // cekamo da se svi izadju
      izasao.wait();
      cnt--;
    }

    mutex.wait();
      for(int i = 0; i < cnt_sa_sprata[sprat]; i++)// nek se izjasne
          pozivam_sa_sprata[sprat].signal();

      int cnt = cnt_sa_sprata[sprat];
      cnt_sa_sprata[sprat] = 0;
    mutex.signal();

    while(cnt+1){ // cekamo da se svi izjasne pa nastavljamo
      izjasnio_se.wait();
      cnt--;
    }

    // lift ide gore pa dole
    if(smer == 1 && sprat + 1 == N)
      smer = -1;
    else if(smer == -1 && sprat - 1 == -1)
      smer = 1;
    sprat = sprat + smer;
  }
}





const int N = ...;

sem cekUl[N] = {0}; // ovde cekaju putnici koji zele da udju na datom spratu
sem cekIzl[N] = {0}; // ovde cekaju putnici koji zele da izadju na datom spratu

sem cekLiftUl[N] = {0}; // ovde lift ceka da svi udju na datom spratu
sem cekLiftIzl[N] = {0}; // ovde lift ceka da svi izadju na datom spratu

int cekUlCnt[N] = {0}; // broj putnika koji ceka da udje na datom spratu
int cekIzlCnt[N] = {0}; // broj putnika koji ceka da izadje na datom spratu

sem mutex[N] = {1}; // mutex za svaki sprat

void putnik(int ulaz, int izlaz, int id) {
pozoviLift();

// cekam da lift dodje na moj sprat
mutex[ulaz].wait();
cekUlCnt[ulaz]++;
mutex[ulaz].signal();

cekUl[ulaz].wait();

// ulazim u lift
mutex[ulaz].wait();
cekUlCnt[ulaz]--;
// posledji koji udje, signalizira liftu da nastavi dalje
if (cekUlCnt[ulaz] == 0) cekLift[ulaz].signal();
mutex[ulaz].signal();

// cekam da lift dodje na sprat gde izlazim
mutex[izlaz].wait();
cekIzlCnt[izlaz]++;
mutex[izlaz].signal();

cekIzl[izlaz].wait();

// izlazim iz lifta
mutex[izlaz].wait();
cekIzlCnt[izlaz]--; 
// poslednji koji izadje, signalizira liftu da nastavi dalje
if (cekIzlCnt[izlaz] == 0) cekLiftIzl[izlaz].signal();
mutex[izlaz].signal();
}

void lift() {
int sprat = 0;
int smer = 1; prvo lift ide gore, pa onda dole, itd...

while (1) {
// pustam sve koji zele da izadju na datom spratu
mutex[sprat].wait();
for (int i = 0; i < cekIzlCnt[sprat]; i++) cekIzl[sprat].signal();
mutex[sprat].signal();
// cekam da svi izadju
cekLiftIzl[sprat].wait();

// pustam sve koji zele da udju na datom spratu
mutex[sprat].wait();
for (int i = 0; i < cekUlCnt[sprat]; i++) cekUl[sprat].signal();
mutex[sprat].signal();
// cekam da svi udju
cekLiftUl[sprat].wait();

sprat += smer;
if (sprat == N - 1) smer = -1;
else if (sprat == 0) smer = 1;
}
}