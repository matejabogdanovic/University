// Аутомобили који долазе са севера и југа морају да
// пређу реку преко моста. На мосту, на жалост,
// постоји само једна возна трака. Значи, у било ком
// тренутку мостом може да прође један или више
// аутомобила који долазе из истог смера (али не и
// из супротног смера). Написати алгоритам за
// аутомобил са севера и аутомобил са југа који
// долазе на мост, прелазе га и напуштају га са
// друге стране.


// otprilike ovako, mozda da promenim malo
struct Most{
  int cnts = 0, cntj = 0;
  int presaos = 0, presaoj = 0;
  char pusti = 0; // 0 - niko, 1 - sever, 2 - jug
} most;

void sever(){
  region(most){
    cnts++;
    if(pusti == 0)pusti = 1;
    await(pusti == 1);
  }

  cross();

  region(most){
    presaos++;
    cnts--;
    if((cnts == 0 || presaos && presaos % 10 == 0) && cntj > 0 ) // pusti jug
      {pusti = 2; presaos = 0;}
    else if(cnts == 0  && cntj == 0) // niko ne zeli da predje, pusti ih da se bore za pravo
      pusti = 0; 
  }

}

void jug(){
  region(most){
    cntj++;
    if(pusti == 0)pusti = 2;
    await(pusti == 2);
  }

  cross();
   
  region(most){
    presaoj++;
    cntj--;
    if((cntj == 0 || presaos && presaoj % 10 == 0 )&& cnts > 0 ) // pusti sever
      {pusti = 1; presaoj = 0;}
    else if(cntj == 0  && cnts == 0)
      pusti = 0;
  }
}