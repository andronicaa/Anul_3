
# GAUSS CU PIVOTARE PARTIALA
# La fiecare pas se alege ca pivot corespunzator coloanei k elementul 
# de pe coloana respectiva cu valoarea absoluta cea mai mare

import numpy as np

def gauss_pivotare_partiala(U):
    n = U.shape[0]
    for k in range(0, n-1):
        # sa adaug si cazul in care sistemul nu este compatibil => adica nu se gaseste un element nenul pe coloana respectiva
        # se alege primul element nenul de pe fiecare coloana
        # se interschimba
        p = np.argmax(abs(U[k:,k])) + k
        U[[k, p]] = U[[p, k]]
        # aux = np.array(U[k])
        # U[k] = np.array(U[p])
        # U[p] = np.array(aux)
        for l in range(k+1, n):
            U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
        
    # daca ultimul element de pe ultima linie si ultima coloana este zero => sistemul este incompatibil
    
    b = np.array([[0.], [0.],[0.], [0.]])
    for i in range(n):
        b[i] = U[i][n]
    U = np.delete(U, n, 1)
    print(U)
    print(b)
    print(f"Pivotare partiala: {rezolvSistem(U, b)}")



def rezolvSistem(U, b):
    x = np.array([[0.], [0.],[0.], [0.]])
    n = U.shape[0]
    L = np.identity(n)
    
    if abs(np.linalg.det(U)) > 1e-15: 
        for i in range(n-1, -1, -1):
            suma = 0
            for j in range(i+1, n):
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma

            
        return x



if __name__ == "__main__":
    eps = 10e-20
    U = np.array([[0., 6., 1., -7., -13.], [-3., 0., 5., 0., 14.], [-4., -8., -5., 2., -42.], [-8., 8., -8., 1., -19.]])
    gauss_pivotare_partiala(U)
    