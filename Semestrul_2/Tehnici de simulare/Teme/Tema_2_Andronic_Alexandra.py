import random as rnd
import numpy as np
import math
'''
Problema 19
    1. Sa se genereze variabila Beta(3, 5) prin doua metode
    Prima metoda pentru generarea variabilei Beta
    Variabila Beta(a, b) poate fi generata cu ajutorul a doua variabile Gamma X1 si X2(conform teoremei -> are o complexitate mare)
    Astfel, variabila Beta va fi X1 / (X1 + X2)
'''
def gen_var_beta_1(a, b):
    # folosind distributia gamma
    # X1 = Gama(0, 1, a)
    # X2 = Gama(0, 1, b)
    # gammavariate genereaza variabile pseudo-aleatoare
    X1 = rnd.gammavariate(a, 1)
    X2 = rnd.gammavariate(b, 1)

    # aflam variabila Beta
    return X1 / (X1 + X2)

def gen_var_beta_2(a, b):
    # In cazul de fata a si b sunt 2 numere naturale nenule
    # Suntem in primul caz
    # Calculez n
    n = a + b - 1
    # Trebuie sa generez n variabile aleatoare uniforme pe [0, 1] independente
    U = [np.random.uniform() for _ in range(n)]
    # Valorile din vectorul U trebuie sa fie in ordine crescatoare
    U.sort()
    # Variabila Beta(a, b) va fi elementul din lista U de pe pozitia a
    return U[a - 1]


def verificare(a, b):
    # Pentru verificare
    no_samples = 100000
    # Calculez media si dispersia teoretica
    media_teoretica = a / (a + b)
    dispersia_teoretica = (a * b) / (((a + b) ** 2) * (a + b + 1))

    beta1 = [gen_var_beta_1(a, b) for _ in range(no_samples)]
    beta2 = [gen_var_beta_2(a, b) for _ in range(no_samples)]

    print(f"Valorile teoretice sunt media = {media_teoretica} si dispersia  = {dispersia_teoretica}")

    suma1 = sum(beta1)
    suma2 = sum(beta2)
    # Calculez media si dispersia empirica
    media_empirica_1 = suma1 / no_samples
    media_empirica_2 = suma2 / no_samples

    sum_sq1 = 0
    sum_sq2 = 0
    for i in range(len(beta1)):
        sum_sq1 += beta1[i] ** 2
        sum_sq2 += beta2[i] ** 2
    
    dispersia_empirica_1 = (sum_sq1 / no_samples) - media_empirica_1 ** 2
    dispersia_empirica_2 = (sum_sq2 / no_samples) - media_empirica_2 ** 2

    print(f"Pentru prima metoda: Media empirica = {media_empirica_1} si dispersia empirica = {dispersia_empirica_1}")
    print(f"Pentru a doua metoda: Media empirica= {media_empirica_2} si dispersia empirica = {dispersia_empirica_2}")


def bernoulli(p):

    # generez o variabila aleatoare
    U = np.random.uniform()
    q = 1 - p
    if U <= q:
        Z = 0
    else:
        Z = 1

    return Z


# 2. Simularea variabilei geometrice se poate realiza prin 2 metode: 
        # a. Algoritmul de generare a variabilei Pascal
        # b. Metoda inversa

def pascal(p):
    # X = nr. de esecuri pana la aparitia a k succese dintr-un sir oarecare de probe Bernoulli independente
    # Fac doar pentru cazul k = 1
    k = 1
    j = 0
    X = 0
    while j != k:
        Y = bernoulli(p)
        if Y == 0:
            X += 1
        else:
            j += 1
    
    # returnez variabila aleatoare X
    return X

def metoda_inversa(p):
    q = 1 - p
    U = np.random.uniform()
    X = math.ceil(math.log(U) / math.log(q)) - 1

    # returnez variabila aleatoare X
    return X

def subpunct_b():
    p = float(input("p = "))
    q = 1 - p

    media_teoretica = q / p
    dispersia_teoretica = q / (p ** 2)
    print(f"Media teoretica = {media_teoretica} si dispersia teoretica = {dispersia_teoretica}")
    # ------------- Pascal k = 1 -----------------------------
    no_samples = 100000
    rep_geom1 = [metoda_inversa(p) for _ in range(no_samples)]
    rep_geom2 = [pascal(p) for _ in range(no_samples)]

    # Calculez media si dispersia empirica
    suma_1 = sum(rep_geom1)
    suma_2 = sum(rep_geom2)
    media_empirica_1 = suma_1 / no_samples
    media_empirica_2 = suma_2 / no_samples

    sum_sq_1 = 0
    sum_sq_2 = 0
    for i in range(len(rep_geom1)):
        sum_sq_1 += rep_geom1[i] ** 2
        sum_sq_2 += rep_geom2[i] ** 2
        
    dispersia_empirica_1 = (sum_sq_1 / no_samples) - media_empirica_1 ** 2
    dispersia_empirica_2 = (sum_sq_2 / no_samples) - media_empirica_2 ** 2

    print(f"Pentru prima metoda: Media empirica = {media_empirica_1} si dispersia empirica = {dispersia_empirica_1}")
    print(f"Pentru a doua metoda: Media empirica = {media_empirica_2} si dispersia empirica = {dispersia_empirica_2}")


    


if __name__ == "__main__":
    print("Subpunctul a")
    print("--------------------------------------")
    verificare(3, 5)
    print()
    print("Subpunctul b")
    print("--------------------------------")
    subpunct_b()