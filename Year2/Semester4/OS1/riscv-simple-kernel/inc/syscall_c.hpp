#ifndef _syscall_c
#define _syscall_c

#include "../lib/hw.h"

#ifdef __cplusplus
extern "C" {
#endif
/**
 * Alocira prostor od (najmanje) size bajtova memorije,
 * zaokruženo i poravnato na blokove veličine
 * MEM_BLOCK_SIZE . Vraća pokazivač na deo alociranog
 * prostora od kojeg do kraja datog prostora ima (najmanje)
 * size bajtova u slučaju uspeha, a null u slučaju neuspeha.
 * MEM_BLOCK_SIZE je celobrojna konstanta veća od ili
 * jednaka 64, a manja od ili jednaka 1024.
 * @param size
 * @return SUCCESS: pointer to allocated space ? ERROR: null
 */
void *mem_alloc(size_t size);

/**
 * Oslobađa prostor prethodno alociran pomoću mem_alloc .
 * Vraća 0 u slučaju uspeha, negativnu vrednost u slučaju greške
 * (kôd greške).
 * Argument mora imati vrednost vraćenu iz mem_alloc .
 * Ukoliko to nije slučaj, ponašanje je nedefinisano: jezgro
 * može vratiti grešku ukoliko može da je detektuje ili
 * manifestovati bilo kakvo drugo predvidivo ili nepredvidivo
 * ponašanje.
 * @param ptr
 * @return SUCCESS: 0 ? ERROR: negative int
 */
int mem_free(void *ptr);


class _thread;
typedef _thread *thread_t;
/**
 * Pokreće nit nad funkcijom start_routine , pozivajući je sa
 * argumentom arg . U slučaju uspeha, u *handle upisuje
 * „ručku“ novokreirane niti i vraća 0, a u slučaju neuspeha
 * vraća negativnu vrednost (kôd greške).
 *  „Ručka“ je interni identifikator koji jezgro koristi da bi
 * identifikovalo nit (pokazivač na neku internu
 * strukturu/objekat jezgra čije je ime sakriveno iza sinonima.
 * @param handle
 * @param start_routine
 * @param arg
 * @return SUCCESS: 0 ? ERROR: negative int
 */
int thread_create(thread_t *handle, void(*start_routine)(void *), void *arg);

/**
 * Gasi tekuću nit. U slučaju neuspeha vraća negativnu vrednost
 * (kôd greške).
 * @return SUCCESS: - ? ERROR: negative int
 */
int thread_exit();

/**
 * Potencijalno oduzima procesor tekućoj i daje nekoj drugoj (ili
 * istoj) niti.
 */
void thread_dispatch();

class _sem;
typedef _sem* sem_t;
/**
 * Kreira semafor sa inicijalnom vrednošću init . U slučaju
 * uspeha, u *handle upisuje ručku novokreiranog semafora i
 * vraća 0, a u slučaju neuspeha vraća negativnu vrednost (kôd
 * greške).
 * „Ručka“ je interni identifikator koji jezgro koristi da bi
 * identifikovalo semafore (pokazivač na neku internu
 * strukturu/objekat jezgra čije je ime sakriveno iza sinonima.
 * @param handle
 * @param init
 * @return SUCCESS: 0 ? ERROR: negative int
 */
int sem_open (sem_t* handle, unsigned init);

/**
 * Operacija wait na semaforu sa datom ručkom. U slučaju
 * uspeha vraća 0, a u slučaju neuspeha, uključujući i slučaj
 * kada je semafor dealociran dok je pozivajuća nit na njemu
 * čekala, vraća negativnu vrednost (kôd greške).
 * @param handle
 * @return SUCCESS: 0 ? ERROR: negative int
 */
int sem_close(sem_t handle);

/**
 * Operacija wait na semaforu sa datom ručkom. U slučaju
 * uspeha vraća 0, a u slučaju neuspeha, uključujući i slučaj
 * kada je semafor dealociran dok je pozivajuća nit na njemu
 * čekala, vraća negativnu vrednost (kôd greške).
 * @param id
 * @return SUCCESS: 0 ? ERROR: negative int
 */
int sem_wait (sem_t id);

/**
 * Operacija signal na semaforu sa datom ručkom. U slučaju
 * uspeha vraća 0, a u slučaju neuspeha vraća negativnu
 * vrednost (kôd greške).
 * @param id
 * @return SUCCESS: 0 ? ERROR: negative int
 */
int sem_signal (sem_t id);

/**
 * NOTE - THIS DOESN'T WORK PROPERLY?
 * Operacija wait na semaforu sa datom ručkom, pri čemu
 * čekanje traje maksimalno timeout internih jedinica
 * vremena (perioda tajmera). U slučaju uspeha vraća 0, u
 * slučaju kada je semafor dealociran dok je pozivajuća nit na
 * njemu čekala vraća SEMDEAD==-1 i u slučaju kada je
 * zadato maksimalno vreme čekanja isteklo vraća
 * TIMEOUT==-2.
 * @param id
 * @param timeout
 * @return SUCCESS: 0 ? ERROR: SEMDEAD==-1/TIMEOUT==-2
 */
int sem_timedwait(sem_t id, time_t timeout);

/**
 * Operacija wait na semaforu sa datom ručkom, pri čemu se
 * ne vrši čekanje. U slučaju zaključavanja semafora vraća 0, u
 * slučaju kada semafor nije zaključan 1, a u slučaju neuspeha
 * vraća negativnu vrednost (kod greške).
 * @param id
 * @return SUCCESS: SEMLOCKED == 0/ SEMFREE == 1 ? ERROR: negative int
 */
int sem_trywait(sem_t id);

typedef unsigned long time_t;
/**
 * Uspavljuje pozivajuću nit na zadati period u internim
 * jedinicama vremena (periodama tajmera). U slučaju uspeha
 * vraća 0, a u slučaju neuspeha vraća negativnu vrednost (kôd
 * greške).
 * @return SUCCESS: 0 ? ERROR: -1 if time is 0
 */
int time_sleep (time_t);

const int EOF = -1;
/**
 * Učitava jedan znak iz bafera znakova učitanih sa konzole. U
 * slučaju da je bafer prazan, suspenduje pozivajuću nit dok se
 * znak ne pojavi. Vraća učitani znak u slučaju uspeha, a
 * konstantu EOF u slučaju greške.
 * @return SUCCESS: char from console ? ERROR: -
 */
char getc ();

/**
 * Ispisuje dati znak na konzolu.
 */
void putc (char);

#ifdef __cplusplus
}
#endif
#endif

