import matplotlib.pyplot as plt
import numpy as np
import math



def f(x):
    return (-1) * math.sin((-4) * x) - 5 * math.cos(4 * x) - 23.55 * x


def sub_ascendenta(U, b):

    # Algoritm pentru metoda substitutiei ascendente(elementele de deasupra diagonalei principale sunt egale cu 0)
    # dimensiunea matricei asociate sistemului(este patratica)
    n = U.shape[0]
    # initializam x(vectorul solutie) cu zero
    x = np.zeros((n, 1))
    # daca determinantul este egal cu 0(aproximarea sa) => sistemul nu are solutie unica
    # altfel  => are solutie unica(este compatibil determinat)
    # punem conditie ca acesta sa fie mai mare decat o aproximare a lui 0 data de noi(in modul)
    if abs(np.linalg.det(U)) > 1e-15:
        # merg de la prima ecuatie catre ultima
        for i in range(0, n):
            suma = 0
            for j in range(i+1):
                # calculez suma produselor din fiecare ecuatie, exceptand elementul ce trebuie aflat
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma
        return x
    else:
        # returnez -1 daca determinantul este egal cu 0
        return -1

def noduri_chebyshev(i, a, b, N):
    # Se folosesc nodurile Chebysev pentru a se imbunatati din punct de vedere numeric eroarea de trunchiere(pentru a evita erorile mari in apropierea marginilor)
    return (a + b) / 2 + (b - a) / 2 * np.cos(np.pi * (N - i) / N)

def evaluare(f, x, coef, N, val):
    s = coef[0]
    for i in range(1, N + 1):
        p = coef[i]
        for j in range(i):
            p = p * (val - x[j])
        s += p

    return s

def interpolare_metoda_newton(mrg_inf, mrg_sup):
    N = 20
    # Calculez x in functie de nodurile Chebysev
    x = np.array([noduri_chebyshev(i,a,b,N) for i in range(N + 1)])
    y = np.zeros((N + 1, 1))
    for i in range(len(x)):
        y[i] = f(x[i])

    # Construiect matricea A
    A = np.zeros((N + 1, N + 1))
    # Are doar 1 pe prima coloana
    A[:,0] = 1
    # Pe fiecare coloana sub diagonala principala este un produs de diferente

    for i in range(1, N + 1):
        p = 1
        for j in range(i):
            p = p * (x[i] - x[j])
            A[i][j + 1] = p
    
    print(A)
    # Determin coeficientii calculand sistemul determinat de matricile A si y
    coeficienti = sub_ascendenta(A, y)
    # Afisez graficul
    nr_puncte = 200
    f2 = np.vectorize(f)
    x_grafic = np.linspace(mrg_inf, mrg_sup, nr_puncte)
    y_grafic = f2(x_grafic)
    y_polinom = [evaluare(f,x,coeficienti,N,val) for val in x_grafic]

    plt.figure("Interpolare cu polinoame Lagrange: Metoda Newton")
    plt.plot(x_grafic, y_grafic, label='Functia data ca parametru')
    # plt.plot(x_grafic, y_polinom, linestyle='--', label='Polinomul')
    plt.scatter(x, y, label='Nodurile de interpolare')
    plt.legend()
    plt.show()
    



if __name__ == "__main__":

    a = (-1) * math.pi
    # Marginea superioara
    b = math.pi
    interpolare_metoda_newton(a, b)