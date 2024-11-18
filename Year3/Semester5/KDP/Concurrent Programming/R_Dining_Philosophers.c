// Пет филозофа седи око стола. Сваки филозоф
// наизменично једе и размишља. Испред сваког
// филозофа је тањир шпагета. Када филозоф
// пожели да једе, он узима две виљушке које се
// налазе уз његов тањир. На столу, међутим, има
// само пет виљушки. Значи, филозоф може да једе
// само када ниједан од његових суседа не једе.
// Прокоментарисати дата решења описаног
// проблема (исправност, праведност, ...).


// problem sto se ticket uvecava stalno
const int N = 5;

struct Tickets{
  int phils[N] = {-1}; // za cuvanje tiketa, -1 - ne zeli da jede jos
  int ticket = 0;
  int next = 0;
};
Tickets tickets;


void filozof(int id){
  razmislja();
  // uzima viljuske
  region(tickets){
    int ja = ticket++; // moj tiket veci od bilo kog suseda => ne smem da jedem jos
    
    phils[id] = ja;
    levi = state[(id-1)%N];
    desni = state[(id+1)%N]
    await((levi == -1 || levi > ja) && (desni == -1 || desni > ja));

  }

  jede();

  region(tickets){
    phils[id] = -1; // ne jedem vise
  }
  // vraca viljuske


}