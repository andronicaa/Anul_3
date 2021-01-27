import numpy as np
import math


def fact_cholesky(A, b):
    # verific daca matricea este simetrica, urmand ca verificarea daca determinantii minorilor sunt pozitivi sa fie facuta in cadrul algoritmului la fiecare pas
    transpusa = A.transpose()
    if np.allclose(A, transpusa):
        # pentru a se aplica factorizarea Cholesky matricea trebuie sa fie simetrica si pozitiv definita
        # Mai intai calculez elementul L[0][0] => fiind egal cu  radical din primul element din matricea A
        alfa = A[0][0]
        n = A.shape[0] # dimensiunea matricei A

        # daca alfa <= 0 => matricea nu este pozitiv definita => nu se poate continua algoritmul
        if alfa <= 0:
            return "A nu este pozitiv definita"
        
        
        L = np.zeros((n, n)) # initializez matricea L cu 0
        L[0][0] = math.sqrt(alfa)
        
        # completez prima coloana a acesteia
        for i in range(1, n):
            L[i][0] = A[i][0] / L[0][0]
        
        # continui cu submatricea astfel incat A = LL^T(transpusa matricei L)
        # L va fi o matrice inferior triunghiulara
        for k in range(1, n):
            suma = 0
            # calculez elementul de pe diagonala principala(corespunzator coloanei k)
            for s in range(0, k):
                # se calculeaza suma patratelor elementelor de pe linia curenta
                suma = suma + L[k][s] ** 2
            # alfa va fi diferenta dintre elementul de pe diagonala principala din A corespunzator lui A si suma calculata anterior
            alfa = A[k][k] - suma
            if alfa <= 0:
                return "A nu este pozitiv definita"
            L[k][k] = math.sqrt(alfa)


            # se calculeaza elementele ramase sub diagonala principala(fara elementul de pe acesta deoarece a fost calculat la pasul anterior)
            for i in range(k+1, n):
                suma = 0
                for s in range(0, k):
                    # se calculeaza suma produselor elementelor de sub diagonala principala din submatrice
                    # de pe liniile de sub linia k inmultite cu elementele de pe linia k
                    suma = suma + L[i][s] * L[k][s]
                # aflu necunoscuta
                L[i][k] = (1. / L[k][k]) * (A[i][k] - suma)

        trans_L = L.transpose()
        y = sub_ascendenta(L, b)
        x = sub_descendenta(trans_L, y)
        return f"Factorizarea Cholesky a matricei este \n L = \n {L} si \n L ^ T = \n {trans_L}, iar solutia sistemului este X = {x}"
    else:
        return "Matricea nu este simetrica."

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
    U = np.array([[4., 2., 4.], [2., 2., 3.], [4., 3., 14]])
    b = np.array([[10.], [6.], [11.]])
    print(fact_cholesky(U, b))