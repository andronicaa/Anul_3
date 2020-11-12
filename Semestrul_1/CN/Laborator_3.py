import numpy as np

def gauss_pivotare_partiala(U):
    n = U.shape[0]
    for k in range(0, n-1):
        p = np.argmax(abs(U[k:,k])) + k
        aux = np.array(U[k])
        U[k] = np.array(U[p])
        U[p] = np.array(aux)
        for l in range(k+1, n):
            U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
    
    b = np.array([[0.], [0.]])
    for i in range(n):
        b[i] = U[i][n]
    U = np.delete(U, n, 1)
    print(U)
    print(b)
    print(f"Pivotare partiala: {rezolvSistem(U, b)}")

def gauss_fara_pivotare(U):
    n = U.shape[0]
    for k in range(0, n-1):
        for l in range(k+1, n):
            U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
    
    b = np.array([[0.], [0.]])
    for i in range(n):
        b[i] = U[i][n]
    # trebuie sa luam ultima coloana din U
    # stergem ultima coloana din U
    U = np.delete(U, n, 1)
    print(f"Fara pivotare: {rezolvSistem(U, b)}")


def rezolvSistem(U, b):
    x = np.array([[0.], [0.]])
    n = U.shape[0]
    if abs(np.linalg.det(U)) > 1e-15: 
        for i in range(n-1, -1, -1):
            suma = 0
            for j in range(i+1, n):
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma

            
        return x


eps = 10**(-20)
U = np.array([[eps, 1., 1.], [1., 1., 2.]])
# U = np.array([[2., -1., -2., -1],[4., 2., 0., 6.], [0., -2., -1., -3.]])
# U = np.array([[0., 1., 2., 8],[1., 0., 1., 4.], [3., 2., 1., 10.]])
# b = np.array([[-1.], [8.], [1.]])
gauss_fara_pivotare(U)
U = np.array([[eps, 1., 1.], [1., 1., 2.]])
gauss_pivotare_partiala(U)
