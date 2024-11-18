// У неком забавишту постоји правило које каже да се
// на свака три детета мора наћи барем једна
// васпитачица. Родитељ доводи једно или више
// деце у забавиште. Уколико има места оставља их,
// уколико не одводи их. Васпитачица сме да
// напусти забавиште само уколико то не нарушава
// правило. Написати процедуре, користећи
// семафоре, за родитеље који доводе и одводе
// децу и васпитачице и иницијализовати почетне
// услове.

int decacnt = 0;
int vaspcnt = 1;
int cekaV = 0;
sem mutex = 1, vasp_hoce_ide = 0, izasla = 0;
void roditelj_dodji(int deca){
  mutex.wait();
  if(decacnt + deca <= vaspcnt * 3)
    decacnt += deca;
  mutex.signal();
}

void roditelj_odvedi(int deca){
  mutex.wait();
    decacnt -= deca;
    while(cekaV>0 && decacnt <= (vaspcnt - 1) * 3){
      cekaV--;
      vaspcnt--;
      idi_kuci.signal();
    }
  mutex.signal();
  // moze da ide?
}

void vaspitacica_dodji(){
  mutex.wait();
    vaspcnt += 1;
    if(cekaV>0){
      cekaV--;
      vaspcnt--;
      idi_kuci.signal();
    }
  mutex.signal();
  // moze da ide?
}

void vaspitacica_odlazi(){
  mutex.wait();
  if(decacnt <= (vaspcnt - 1) * 3){
    vaspcnt -= 1;
    mutex.signal(); // otisla
  }else{
    cekaV++;
    mutex.signal();

    idi_kuci.wait();

  }
    
}