import matplotlib.pyplot as plt
import numpy as np
import math


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




# APELURILE
if __name__ == "__main__":
    plot_resp_metode()
    