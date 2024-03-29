import numpy as np
import matplotlib.pyplot as plt
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


def evaluare(x, coef, N, val):
    s = coef[0]
    for i in range(1, N + 1):
        p = coef[i]
        for j in range(i):
            p = p * (val - x[j])
        s += p

    return s



def interpolare_metoda_newton(N, mrg_inf, mrg_sup):

    x = np.array([noduri_chebyshev(i, mrg_inf, mrg_sup, N) for i in range(N + 1)])

    y = np.zeros((N + 1, 1))
    for i in range(len(x)):
        y[i] = f(x[i])

    # Construiesc matricea A
    A = np.zeros((N + 1, N + 1))
    # Are doar 1 pe prima coloana
    A[:,0] = 1
    # Pe fiecare coloana sub diagonala principala este un produs de diferente

    for i in range(1, N + 1):
        produs = 1
        for j in range(i):
            produs = produs * (x[i] - x[j])
            A[i][j + 1] = produs
    

    
    coeficienti = sub_ascendenta(A, y)
    nr_puncte = 100
    x_grafic = np.linspace(mrg_inf, mrg_sup, nr_puncte)
    f2 = np.vectorize(f)
    y_grafic = f2(x_grafic)
    y_aproximat = [evaluare(x,coeficienti,N,val) for val in x_grafic]

    erori, er_max = eroareMaxima(y_grafic, y_aproximat)
    if er_max <= 1e-5:
        return N, coeficienti, x, erori, er_max, x_grafic

    return -1, None, None, None, None, None
    

def eroareMaxima(y, y_aproximat):
    erori = np.abs(y - yAprox)
    maxim = np.max(erori)

    return erori, maxim

def main():
    
    a = -np.pi
    b = np.pi

    
    N = 1
    while True:
        N += 1
        print(N)
        ret, coeficienti, x, erori, maxim, vals = interpolare_metoda_newton(N, a, b)
        if ret != -1:
            print(f"Numar pasi:{N}")
            print(f"Coeficienti polinom: {coeficienti}")
            print(f"Noduri de interpolare: {x}")
            x_grafic = np.linspace(a, b, 200)
            f2 = np.vectorize(f)
            y_grafic = f2(x_grafic)
            y_polinom = [evaluare(x,coeficienti,N,val) for val in x_rafic]

            # Grafic cu functia, polinomul si nodurile de interpolare
            plt.figure("Aproximare numerica")
            plt.plot(x_grafic, y_grafic, label = "Functie originala")
            plt.plot(x_grafic, y_polinom, linestyle = "--", label = "Polinom de interpolare")

            plt.scatter(x, f(x), marker=".") # noduri de interpolare
            plt.legend()
            plt.show()

            # Grafic cu eroarea de trunchiere
            plt.figure("Eroare interpolare cu polinoame Lagrange")
            plt.plot(vals, erori, label = "Erori obtinute")
            plt.hlines(1e-5, xmin = a, xmax = b, color = 'red', label = "1e-5")
            plt.hlines(maxim, xmin = a, xmax = b, color = 'green', label = "Eroare maxima")
            plt.legend()
            plt.show()

            return


if __name__ == "__main__":
    main()
