// Посматра се један узак и релативно кратак пут кроз кањон,
// којим пролазе каубоји и Индијанци. Ако њиме пролазе само каубоји
// или само Индијанци, они ће бити фини и проћи једни поред других.
// Ако кроз клисуру желе да прођу и каубоји и Индијанци, примењује се
// „закон јачег“, тј. оних којих има више имају првенство пролаза кроз
// кањон. Треба обезбедити да једном добијено првенство пролаза не
// важи баш заувек – када се однос снага промени, треба забранити
// долазак нових особа које су до тада биле бројније, како би они други
// (сада бројнији) могли да добију право проласка кроз кањон.
// Користећи условне критичне регионе написати програм који решава
// овај проблем.

struct Put{
  int kcnt = 0, icnt = 0;
  int wkcnt = 0, wicnt = 0;
  char turn = ''; // k ili i ili ''
};
Put put;

void kauboj(){
  region(put){

  }
  prolazak();

  region(put){

   


  }
}

void indijanac(){
  region(put){


  }
  prolazak();
  region(put){

  }
}