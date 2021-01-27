import numpy as np
import math



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
        print(f"L = {L}")
        print(f"U = {U}")
        if isinstance(sub_ascendenta(L, b), int):
            
            return "Matricea nu admite factorizare LU"
        else:

            sol_aux = sub_ascendenta(L, b)
            return f"Sistemul admite factorizare LU si solutia unica este: \n {sub_descendenta(U, sol_aux)}"
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
    U = np.array([[2., 3., 1.], [4., 8., 5.], [-4., 0., 10.]])
    b = np.array([[5.], [18.], [20.]])
    print(factorizare_pivotare_partiala(U, b))