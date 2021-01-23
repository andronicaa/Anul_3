import matplotlib.pyplot as plt
import numpy as np
import math


# --------------------------------------------------- EXERCITIUL 1 -------------------------------------------------
def f1(x):
    return math.cos(-0.5 * x)

# a doua derivata a functiei
def sdf(x):
    return (-0.25) * math.cos(0.5 * x)



def aproximeaza_derivata_2():

    # FORMULA DE APROXIMARE PRIN DIFERENTE FINITE CENTRALE PENTRU CALCULUL f''(x)
    N = 1
    a = -np.pi / 2
    b = np.pi
    # Cat timp nu se indeplineste conditia ca eroarea maxima de trunchiere sa fie mai mica decat o valoare data(1e-5) continuam sa crestem N-ul
    # Cand conditia va fi satisfacuta => bucla se va opri si astfel va fi ales cel mai mic N
    while True:
        print(f"Pentru N = {N} nu se respecta conditia pentru eroarea de trunchiere")
        N = N + 1
        # Determin intervalele echidistante
        x = np.linspace(a, b, N + 1)

        # calculam y
        y = np.zeros((N + 1, 1))
        for i in range(len(x)):
            y[i] = f1(x[i])

        # Folosesc o discretizare echidistanta, h-ul este mereu acelasi(deoarece si intervalele sunt echidistante)
        h = x[1] - x[0]

        # Calculam derivata, dar fara capete
        sec_der = np.zeros(len(x) - 2)

        for i in range(1, len(x) - 1):
            sec_der[i - 1] = (y[i + 1] - 2 * y[i] + y[i - 1]) / h ** 2

        # calculam doar pentru punctele din interiorul intervalului, fara capete
        x_int = x[1:-1]

        sdf2 = np.vectorize(sdf)
        # Derivata reala
        y_grafic = sdf2(x_int)
        # Derivata aproximata
        y_aproximat = sec_der

        # calculez eroarea de trunchiere
        eroare = np.abs(y_grafic - y_aproximat)
        # determinam maximul erorii dintre cele calculate
        er_max = np.max(eroare)

        # Verific daca eroarea maxima de trunchiere satisface urmatoarea relatie
        if er_max <= 1e-5: 
            print(f"Eroarea maxima este: {er_max}")
            # plotuim functia
            # trebuie sa afisam functia fara capetele intervalului(adica fara a si b)   
            plt.figure("Aproximarea derivatei a doua")
            plt.plot(x_int, y_grafic, label="Derivata exacta")
            plt.plot(x_int, y_aproximat, label="Aproximarea numerica")
            plt.legend()
            plt.show()

            # afisez si graficul erorii de trunchiere
            plot_eroare_trunchiere_ex_3(x_int, y_grafic, y_aproximat, a, b)
            break

    

# ----------- Metoda pentru afisarea erorii de trunchiere
def plot_eroare_trunchiere_ex_3(x_grafic, y_grafic, y_aprox, mrg_inf, mrg_sup):

    eroare = np.abs(y_grafic - y_aprox)
    # determinam maximul erorii dintre cele calculate
    er_max = np.max(eroare)

    plt.figure("Eroarea de trunchiere")
    plt.plot(x_grafic, eroare)
    # afisez pe grafic valoarea 1e-5
    plt.hlines(1e-5, xmin = mrg_inf, xmax=mrg_sup, color="blue")
    # afisez pe grafic cea mai mare eroare pe care o am eu
    plt.hlines(er_max, label="Eroarea maxima din algoritmul meu", xmin = mrg_inf, xmax=mrg_sup, color="orange")
    plt.legend()
    plt.show()

# -------------------------------------- EXERCITIUL 2 ------------------------------------------
def f(x):
    sigma = 1.8
    return (1 / (sigma * np.sqrt(2 * np.pi))) * np.exp(((-1) * (x ** 2)) / (2 * (sigma ** 2)))



def integrare(f, x, metoda):

    # dimensiunea diviziunei echidistante x
    n = len(x)
    y = np.zeros((n, 1))
    # calculam y
    for i in range(len(x)):
        y[i] = f(x[i])

    # In functie de metoda apelata trebuie sa impartim intervalul intr-un numar diferit de subintervale
    if metoda == 'dreptunghi':
        # ------------ FORMULA DE CUADRATURA SUMATA A DREPTUNGHIULUI -------------------------
        # dimensiunea intervalului
        m = (int)((n - 1) / 2)

        # discretizarea h
        h = (x[2 * m] - x[0]) / (2 * m)
        # aplicam formula de cuadratura a dreptunghiului pe fiecare subinterval
        sum = 0
        for k in range(m):
            sum = sum + y[2 * k + 1]
        
        # aproximarea finala a integralei folosind metoda dreptunghiului
        I = 2 * h * sum

    elif metoda == 'trapez':
        # ------------- FORMULA DE CUADRATURA SUMATA A TRAPEZULUI ------------------------
        m = n - 1
        h = (x[m] - x[0]) / m
        sum = 0
        for k in range(1, m):
            sum = sum + y[k]
        
        # aproximarea finala a integralei folosind metoda trapezului
        I = (h / 2) * (y[0] + 2 * sum + y[m])
    elif metoda == 'simpson':
        # -------------- FORMULA DE CUADRATURA SUMATA A LUI SIMPSON ------------
        m = (int)((n - 1) / 2)
        h = (x[2 * m] - x[0]) / (2 * m)
        sum_par = 0
        sum_impar = 0
        for k in range(m):
            sum_par = sum_par + y[2 * k + 1]
        for k in range(1, m):
            sum_impar = sum_impar + y[2 * k]
        
        # aproximarea finala a integralei folosind metoda simpson
        I = (h / 3) * (y[0] + 4 * sum_par + 2 * sum_impar + y[2 * m])
        
        

    return I


def aplica_metode(metoda):
    mrg_inf = -18
    mrg_sup = 18
    a = 5
    b = 20

    # vector in care voi retine aproximarile integralei pentru diferite valori ale lui N(numarul de intervale in care impartim intervalul [a, b])
    # este de dimensiune (b - a)(captele intervalului)
    rez_integrala = np.zeros(b - a)
    for N in range(a, b, 1):
        # daca metoda apelata este cea a dreptunghiului sau Simpson => trebuie sa impartim intervalul in 2 * N + 1(subintervalele sunt de forma [x_2*k-1, x_2*k+1])
        if metoda == 'dreptunghi' or metoda == 'simpson':
            x = np.linspace(mrg_inf, mrg_sup, 2 * N + 1)
        else:
            # daca metoda apelata este cea a trapezului => trebuie sa impartim intervalul in N + 1 (subintervalele sunt de forma [x_k, x_k+1])
            x = np.linspace(mrg_inf, mrg_sup, N + 1)

        # apelez metoda de integrare
        I = integrare(f, x, metoda)
        # o adaug la vectorul cu toate aproximarile
        rez_integrala[N - a] = I
        print(f"Pentru N = {N} si METODA = {metoda} valoarea aproximativa a integralei este I = {I}")

    return rez_integrala


def plot_resp_metode():
    # functia pentru afisarea graficului
    a = 5
    b = 20
    interval_ab = range(a, b, 1)
    plt.figure("Aproximarea integralei folosind formule de cuadratura sumate")
    plt.plot(interval_ab, aplica_metode('dreptunghi'), label="dreptunghi")
    plt.plot(interval_ab, aplica_metode('trapez'), label="trapez")
    plt.plot(interval_ab, aplica_metode('simpson'), label="simpson")
    plt.hlines([1], xmin=a, xmax=b - 1, linestyle='--', color='red')
    plt.legend()
    plt.show()

if __name__ == "__main__":
    # --------------------- EXERCITIUL 1 -----------------------
    print("--------------------------- EXERCITIUL 1 -----------------------------")
    aproximeaza_derivata_2()

    # ---------------------- EXERCITIUL 2 ---------------------------
    print("--------------------------- EXERCITIUL 2 -----------------------------")
    plot_resp_metode()