# GAUSS CU PIVOTARE TOTALA  

import numpy as np

def gauss_pivotare_totala(U, b):
    # determinam dimensiunea matricei asociate sistemului
    n = U.shape[0]
    U = np.append(U, b, axis = 1)
    # print(U)
    # vector ce retine indicii coloanelor 
    index = np.arange(0, n)
    for k in range(0, n-1):
        # sa adaug si cazul in care sistemul nu este compatibil => adica nu se gaseste un element nenul pe coloana respectiva
        # se alege primul element nenul de pe fiecare coloana
        # se interschimba
        # se cauta elementul cu valoarea absoluta maxima din submatrice
        p = k
        m = k
        # caut maximul din submatrice
        # print(U)
        # print(U[k:, k:n])
        result_maxim = np.where(U[k:, k:n] == np.amax(U[k:, k:n]))
        # print(f"Submatricea este U = {U[k:, k:n]}")
        # print(result_maxim)
        coord = list(zip(result_maxim[0], result_maxim[1]))
        # print(coord)
        p = coord[0][0] + k
        m = coord [0][1] + k
        if U[p][m] == 0:
            return "Matricea nu este inversabila"
        # print(f"p = {p} si m = {m}")
        if p != k:
            U[[k, p]] = U[[p, k]]
        # print(f"matricea dupa interschimbarea cu p => U = {U}")
        if m != k:
            U[:, [k, m]] = U[:, [m, k]]
            index [m], index [k] = index[k], index[m]

        # print(f"Matricea dupa interschimbarea cu m => U = {U}")
        # aux = np.array(U[k])
        # U[k] = np.array(U[p])
        # U[p] = np.array(aux)
        for l in range(k+1, n):
            U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
    
    # daca ultimul element de pe ultima linie si ultima coloana este zero => sistemul este incompatibil
    if U[n-1][n-1] == 0:
        return "Matricea nu este inversabila"
    

    A = np.copy(U)
    U = U[0:, 0:n]
    # print(U)
    Inv = np.zeros((n, n))
    for i in range(n):
        # trebuie sa rezolv fiecare sistem in parte
        y = x = np.zeros((n, 1))
        b = A[0:, n + i]
        print("Matricea b este")
        print(b)
        print("Matricea U este")
        print(U)
        print(type(rezolvSistem(U, b)))
        y = rezolvSistem(U, b)
        if isinstance(y, int):
            return "Matricea nu este inversabila"
        else:
            for j in range(n):
                x[index[j]] = y[j]
            print(x)
            for l in range(n):
                Inv[l][i] = x[l]


    
    return Inv



def rezolvSistem(U, b):
    
    n = U.shape[0]
    L = np.identity(n)
    x = np.zeros((n, 1))
    if abs(np.linalg.det(U)) > 1e-15: 
        for i in range(n-1, -1, -1):
            suma = 0
            for j in range(i+1, n):
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma

            
        return x
    else:
        return -1


if __name__ == "__main__":
    eps = 10e-20
    # U = np.array([[1., 2.], [4., 9.]])
    
    
    # U = np.array([[0., 1., 2., 8],[1., 0., 1., 4.], [3., 2., 1., 10.]])
    # U = np.array([[1., 2., 3.], [-1., 0., -1.], [3., 4., 7.]])
    U = np.array([[0., 9., -7., -3.], [-1., -5., 9., -4.], [-1., -8., 8., 9.], [-7., 6., 1., 3.]])
    n = U.shape[0]
    b = np.identity(n)
    print(gauss_pivotare_totala(U, b))
    