import matplotlib.pyplot as plt
import numpy as np
import math

def f(x):
    return 3 * np.sin((-2) * x) - 4 * np.cos(4 * x) - 0.31 * x

def df(x):
    return (-6) * np.cos(2 * x) + 16 * np.sin(4 * x) - 0.31




def int_spline_cubica(mrg_inf, mrg_sup):
    N = 100
    while True:
        N = N + 1
        print(N)
        x = np.zeros((N+1, 1))
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

        
        b = factorizare_pivotare_partiala(B, W)
        
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
        eroare, er_max = eroare_trunchiere(y_grafic, y_aproximat)
        if  er_max <= 1e-5:
            plt.figure("Interpolare spline cubica")
            plt.plot(x_grafic, y_grafic, linestyle='--', label="Functia")
            plt.plot(x_grafic, y_aproximat, label="Interpolarea spline cubica")
            plt.scatter(x, y, label='Nodurile de interpolare')
            plt.legend()
            plt.show()

            # eroare de trunchiere
            print(f"x_grafic este {x_grafic}")
            print(f"y_grafic este {y_grafic}")
            print(f"y_aproximat este {y_aproximat}")
            plot_eroare_trunchiere(x_grafic, y_grafic, y_aproximat, mrg_inf, mrg_sup)
            return


def eroare_trunchiere(y, y_aproximat):
    eroare = np.abs(y - y_aproximat)
    maxim = np.max(eroare)

    return eroare, maxim
# ----------- Metoda pentru afisarea erorii de trunchiere
def plot_eroare_trunchiere(x_grafic, y_grafic, y_aprox, mrg_inf, mrg_sup):
    eroare = np.abs(y_grafic - y_aprox)
    # determinam maximul erorii dintre cele calculate
    er_max = np.max(eroare)

    plt.figure("Eroarea de trunchiere")
    plt.plot(x_grafic, eroare)
    # afisez pe grafic valoarea 1e-5
    plt.hlines(1e-5, xmin = mrg_inf, xmax=mrg_sup, color="blue")
    # afisez pe grafic cea mai mare eroare pe care o am eu
    print(f"er_max este {er_max}")
    plt.hlines(er_max, label="Eroarea maxima din algoritmul meu", xmin = mrg_inf, xmax=mrg_sup, color="orange")
    plt.legend()
    plt.show()
    


# Factorizare LU
def factorizare_pivotare_partiala(U, b):

    # verific daca sistemul are solutie unica
    if abs(np.linalg.det(U)) > 1e-15: 
        n = U.shape[0] #dimensiunea matricei
        index = np.arange(0, n) #vector pentru indecsii solutiilor
        L = np.zeros((n, n)) # initializam toata matricea L cu zero
        # aplic algoritmul de pivotare partiala pe matricea U
        for k in range(0, n-1):

            p = np.argmax(abs(U[k:,k])) + k
            if U[p][k] == 0:
                return "Matricea nu admite factorizare LU"

            if p != k:
                # daca indicele pivotului nu corespunde cu cel curent => trebuie sa interschimbam liniile si in U si subliniile(elementele de sub diagonala principala) din L
                U[[k, p]] = U[[p, k]]   
                aux = np.array(L[p,:k])
                L[p,:k] = np.array(L[k,:k])
                L[k,:k] = np.array(aux) 
                # deoarece am interschimbat doua coloane => trebuie sa schimbam si ordinea necunoscutelor sistemului cu ajutorul vectorului index
                index[p], index[k] = index[k], index[p]

            for l in range(k+1, n):
                # matricea L contine raportul dintre elementul de pe linia curenta si pivot
                L[l][k] = U[l][k] / U[k][k]
                U[l] = U[l] - L[l][k] * U[k]

        if U[n-1][n-1] == 0:
            return "Matricea nu admite factorizare LU"
        
        
        size_b = b.shape[0] # dimensiunea vectorului b(numarul de linii)
        b_copy = np.copy(b) # copie a vectorului b

        # interschimb elementele vectorului coloana b conform permutarii indecsilor din vectorul index(folosindu-ma de vectorul copie al lui b)
        for i in range(size_b):
            b[i] = b_copy[index[i]]

        # adun la matricea L matricea identitate pentru a avea pe diagonala principala 1
        # aceasta este o matrice inferior triunghiulara 
        L = L + np.identity(n)
        
        # il scriem pe A = LU
        # LUx = b <=> il notam pe Ux cu un y si rezolvam sistemul Ly = b => Ux = y si aflam solutia sistemului 
        sol_aux = np.zeros((n, 1))
        
        if isinstance(sub_ascendenta(L, b), int):
            return "Matricea nu admite factorizare LU"
        else:
            sol_aux = sub_ascendenta(L, b)
            return sub_descendenta(U, sol_aux)
    else:
        return "Sistemul nu admite solutie unica."



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

def sub_descendenta(U, b):
    # Algoritm pentru metoda substitutiei ascendente(elementele de sub diagonala principala sunt egale cu 0)
    # dimensiunea matricei asociate sistemului(este patratica)
    n = U.shape[0]
    x = np.zeros((n, 1))
    if abs(np.linalg.det(U)) > 1e-15: 
        # parcurgem ecuatiile de la ultima(ce are doar o necunoscuta) spre prima
        for i in range(n-1, -1, -1):
            suma = 0
            for j in range(i+1, n):
                # calculez suma produselor elementelor aflate pana la ecuatia data
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma

            
        return x
    else:
        # returnez -1 daca sistemul nu are solutie unica
        return -1

     




if __name__ == "__main__":
    a = (-1) * math.pi
    b = math.pi
    int_spline_cubica(a, b)