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
    x = np.zeros(n)
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
    

def noduri_chebyshev(k, mrg_inf, mrg_sup, N):
    # Se folosesc nodurile Chebysev pentru a se imbunatati din punct de vedere numeric eroarea de trunchiere(pentru a evita erorile mari in apropierea marginilor)
    return (mrg_inf + mrg_sup) / 2 + (mrg_sup - mrg_inf) / 2 * np.cos(np.pi * (N - k) / N)


def evaluare(x, coef, N, val):
    s = coef[0]
    for i in range(1, N + 1):
        p = coef[i]
        for j in range(i):
            p = p * (val - x[j])
        s += p
    
    return s

def newton(N, mrg_inf, mrg_sup):


    X = np.array([noduri_chebyshev(i, mrg_inf, mrg_sup, N) for i in range(N + 1)])
    
    Y = np.zeros((N + 1, 1))
    for i in range(len(X)):
        Y[i] = f(X[i])

    # construim matricea A
    A = np.zeros((N + 1, N + 1))
    A[:,0] = 1
    for i in range(1, N + 1):
        p = 1
        for j in range(i):
            p = p * (X[i] - X[j])
            A[i][j + 1] = p

    # print(A)
    
    coeficienti = sub_ascendenta(A, Y)
    # cof1 = subsAsc(A, Y)
    # print(f"coeficienti = {coeficienti}")
    # print(f"cof1 = {cof1}")
    # print(f"coeficientii = {coeficienti}")
    # print(f" numarul de linii la coef = {np.shape(coeficienti)}")
    # print(f"numarul de linii la A este {np.shape(A)}")
    # print(f"numarul de linii la y este {np.shape(Y)}")

    nr_puncte = 200
    xGrafic = np.linspace(mrg_inf, mrg_sup, nr_puncte)
    f2 = np.vectorize(f)
    yGrafic = f2(xGrafic)
    yPolinom = [evaluare(X,coeficienti,N,val) for val in xGrafic]

    erori, maxim = eroare_trunchiere(yGrafic, yPolinom)
    if maxim <= 1e-5:
        return N, coeficienti, X, erori, maxim, xGrafic

    return -1, None, None, None, None, None
    

def eroare_trunchiere(y, y_aproximat):
    eroare = np.abs(y - y_aproximat)
    maxim = np.max(eroare)

    return eroare, maxim

def main():
    
    a = - np.pi
    b = np.pi

    N = 1
    while True:
        N += 1
        print(f"Pentru N = {N} nu se respecta conditia pentru eroarea de trunchiere")
        ret, coeficienti, x, erori, maxim, vals = newton(N, a, b)
        if ret != -1:
            print(f"Numar pasi:{N}")
            print(f"Coeficienti polinom: {coeficienti}")
            print(f"Noduri de interpolare: {x}")
            xGrafic = np.linspace(a,b,200)
            f2 = np.vectorize(f)
            yGrafic = f2(xGrafic)
            # yGrafic = f(xGrafic)
            yPolinom = [evaluare(x,coeficienti,N,val) for val in xGrafic]

            # Grafic cu functia, polinomul si nodurile de interpolare
            plt.figure("Aproximare numerica")
            plt.plot(xGrafic, yGrafic, label = "Functie originala")
            plt.plot(xGrafic, yPolinom, linestyle = "--", label = "Polinom de interpolare")

            plt.scatter(x, f2(x), marker=".") # noduri de interpolare
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