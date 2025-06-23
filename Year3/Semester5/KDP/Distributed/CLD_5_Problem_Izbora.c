// Користећи C-Linda написати програм који решава
// следећи проблем: Постоје три особе међу којима
// треба изабрати једну. Свака од тих особа
// поседује новчић који има две стране. Избор особе
// се одиграва тако што свака особа независно баца
// свој новчић. Уколико постоји особа којој је новчић
// пао на другу страну у односу на преостале две
// онда се та особа изабира. Уколико све три особе
// имају исто постављен новчић поступак се
// понавља све док се не изабере једна. 

void player(int id){
  int c1, c2;
  int n;
  int imWinner = false;
  int id1 = (id+1)%3, id2 = (id+2)%3;
  do{
    int coin = rand(0, 2); // 0, 1
    out("coin", id, coin);
    out("coin", id, coin);

    in("coin", id1, ?c1);
    in("coin", id2, ?c2);
    
    imWinner = coin != c1 && coin != c2;
    
    in("barrier", ?n); 
    out("barrier", (n+1)%3); // 3rd will reset the barrier to 0 
    if(n!=2)rd("barrier", 0); // wait for last then continue
  }while(coin == c1 && coin == c2);

}

void init(){
  for(int i = 0; i<3; i++)eval(player(i));
  out("barrier", 0);
}