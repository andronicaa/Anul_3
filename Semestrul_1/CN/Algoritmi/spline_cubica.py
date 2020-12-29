import matplotlib.pyplot as plt
import numpy as np
import math

def f(x):
    return 3 * math.sin((-2) * x) - 4 * math.cos(4 * x) - 0.31 * x

def df(x):
    return (-6) * math.cos(2 * x) + 16 * math.sin(4 * x) - 0.31



def int_spline_cubica(mrg_inf, mrg_sup):
    N = 200
    x = np.linspace(mrg_inf, mrg_sup, N+1)
    y = np.zeros((N + 1, 1))
    for i in range(len(x)):
        y[i] = f(x[i])

    # calculam coeficientii
    # A - ul
    a = y.copy()

    # B - ul
    B = np.zeros((N+1, N+1))

    B[0][0] = 1
    for i in range(1, N):
        B[i][i - 1] = 1
        B[i][i] = 4
        B[i][i + 1] = 1

    B[N][N] = 1
    # folosesc o discretizare echidistanta, h-ul este mereu acelasi
    h = x[1] - x[0]

    # trebuie sa rezolvam sistemul
    W = np.zeros((N + 1, 1))
    W[0] = df(x[0])
    for i in range(1, N):
        W[i] = 3 * (y[i + 1] - y[i - 1]) / h
    W[N] = df(x[N])

    
    b = gauss_pivotare_partiala(B, W)
    # calculam c si d
    c = np.zeros((N, 1))
    d = np.zeros((N, 1))
    for i in range(N):
        c[i] = 3 * (y[i + 1] - y[i]) / (h * h) - (b[i + 1] + 2 * b[i]) / h
        d[i] = (-2) * (y[i + 1] - y[i]) / (h * h * h) + (b[i + 1] + b[i]) / (h * h)

    def polinom(j):
        def spline(X):
            return a[j] + b[j] * (X - x[j]) + c[j] * (X - x[j]) ** 2 + d[j] * (X - x[j]) ** 3
        return spline

    nr_puncte = 100
    f2 = np.vectorize(f)
    x_grafic = np.linspace(mrg_inf, mrg_sup, nr_puncte)
    y_grafic = f2(x_grafic)
    
    # functie definita pe intervale
    y_aproximat = np.piecewise(
    x_grafic,
    [
        # conditii
        (x[i] <= x_grafic) & (x_grafic < x[i + 1])
        for i in range(N - 1)
    ],
    [
        # polinoamele
        polinom(i)
        for i in range(N)
    ]
)
    plt.figure("Interpolare spline cubica")
    plt.plot(x_grafic, y_grafic, linestyle='--', label="Functia")
    plt.plot(x_grafic, y_aproximat, label="Interpolarea spline cubica")
    plt.scatter(x, y, label='Nodurile de interpolare')
    plt.legend()
    plt.show()

    # eroare de trunchiere
    eroare_trunchiere(x_grafic, y_grafic, y_aproximat, mrg_inf, mrg_sup)

# ----------- Metoda pentru afisarea erorii de trunchiere
def eroare_trunchiere(x_grafic, y_grafic, y_aprox, mrg_inf, mrg_sup):
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
    


def gauss_pivotare_partiala(U, b):
    U = np.append(U, b, axis=1)
    n = U.shape[0]
    for k in range(0, n-1):
        # sa adaug si cazul in care sistemul nu este compatibil => adica nu se gaseste un element nenul pe coloana respectiva
        # se alege primul element nenul de pe fiecare coloana
        # se interschimba
        p = np.argmax(abs(U[k:,k])) + k
        U[[k, p]] = U[[p, k]]
        for l in range(k+1, n):
            U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
        
    # daca ultimul element de pe ultima linie si ultima coloana este zero => sistemul este incompatibil
    
    b = np.zeros((n, 1))
    for i in range(n):
        b[i] = U[i][n]
    U = np.delete(U, n, 1)
    return rezolvSistem(U, b)



def rezolvSistem(U, b):
    n = U.shape[0]
    x = np.zeros((n, 1))
    if abs(np.linalg.det(U)) > 1e-15: 
        for i in range(n-1, -1, -1):
            suma = 0
            for j in range(i+1, n):
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma

            
        return x
     




if __name__ == "__main__":
    a = (-1) * math.pi
    b = math.pi
    int_spline_cubica(a, b)