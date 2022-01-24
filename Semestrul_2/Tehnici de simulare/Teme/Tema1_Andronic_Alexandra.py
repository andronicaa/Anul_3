from random import random 

# generez o lista cu zile de nastere de o anumita dimensiune(este data ca paramentru -> numarul de persoane din "camera")
def genereaza_lista_zile_nastere(lg_list):

    zi_lista = [int(random() * 365) for _ in range(lg_list)]
    # returnez lista generata
    return zi_lista


# functie ce primeste ca input o lista ce contine zile de nastere si returneaza true daca exista persoane ce au aceeasi zi de nastere
def ex_sim(zi_lista):
    return len(zi_lista) != len(set(zi_lista))

def estimare(nr_pers):
    nr_sim = 0
    for _ in range(1000):
        # generez la fiecare iteratie o lista ce contine zile de nastere generate aleator
        zi_lista = genereaza_lista_zile_nastere(nr_pers)
        if ex_sim(zi_lista):
            nr_sim += 1
    
    # calculez probabilitatea
    prob = nr_sim / 1000
    # returnez probabilitatea calculata
    return prob

# calculez probabilitatile de a exista cel putin 2 persoane cu aceeasi data de nastere pentru mai multe nr de persoane

def est_prob_person():
    # lista ce retine probabilitatile
    k_prob = []
    # k_prob.append(estimare(23))
    for pers in range(2, 60):
        k_prob.append(estimare(pers))
    
    # returnez lista de probabilitati pentru fiecare numar de persoane pentru care vrem sa calculam aceasta probabilitate
    return k_prob


if __name__ == '__main__':

    lista_probs = est_prob_person()

    # afisez probabilitatile
    for nr_pers in range(len(lista_probs)):
        print(f"Pentru {nr_pers + 2} persoane probabilitatea ca cel putin 2 persoane sa aiba aceeasi data de nastere este {round(lista_probs[nr_pers] * 100, 2)}")
 