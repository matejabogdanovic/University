/*Два типа процеса, читаоци и писци, приступају
једном запису (у општем случају запис може
припадати некој колекцији података - бази
података, датотеци, низу, уланчаној листи, табели
итд.) Читаоци само читају садржај записа, а писци
могу да читају и мењају садржај записа. Да не би
дошло до нерегуларне ситуације у којој запису
истовремено приступа више писаца или
истовремено приступају и писци и читаоци, писци
имају право ексклузивног приступа. Са друге
стране, дозвољено је да више читалаца
истовремено приступа запису (нема ограничења у
њиховом броју). Написати програм којим се
реализује рад процеса читалаца и писаца.*/
sem mutexr = 1; // semafor za pristup brojaču čitalaca
sem semw = 1; // semafor za ekskluzivni pristup zapisima
sem entry = 1;
int rcnt = 0; // broj aktivnih čitalaca

void reader() {
    entry.wait();
    mutexr.wait();        // čitač dobija pristup brojaču
    rcnt++;
    if (rcnt == 1) {    // prvi čitalac blokira pisce
        semw.wait();
    }
    mutexr.signal();      // oslobodi brojač
    entry.signal();

    read();             // čitanje podataka

    mutexr.wait();        // pristup brojaču da se smanji broj čitalaca
    rcnt--;
    if (rcnt == 0) {    // poslednji čitalac oslobađa pisce
        semw.signal();
    }
    mutexr.signal();      // oslobodi brojač
}

void writer() {
    entry.wait();
    semw.wait();        // ekskluzivni pristup zapisima

    write();            // pisanje podataka

    semw.signal();
    entry.signal();      // oslobodi zapis
}
// REGIONI

struct RW{
    int cntR = 0, cntW = 0;
    int wtR = 0, wtW = 0;
};
RW rw;

void reader(){
    while(true){
        region(rw){
            await(cntW == 0);
            cntR++;
        }

        read();
        
        region(rw){
            cntR--;
        }
    }
}

void writer(){
    while(true){
        region(rw){
            await(cntW == 0); // cekam na vratima
            cntW++; // prosao sam => zatvaram vrata <=> mutex

            await(cntR == 0);
        }

        write();

        region(rw){
            cntW--; // otvaram vrata da moze drugi da prodje
        }
    }
}

// MONITOR - sw
// pisci konstantno pisu pa onda prvi citalac ih blokira
monitor RW{
    cond r, w;
    int cntR = 0, cntW = 0;

    void startRead(){   
        
    }

    void stopRead(){



    }

    void startWrite(){

    }

    void stopWrite(){

    }


};