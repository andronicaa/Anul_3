# GAUSS FARA PIVOTARE


import numpy as np
def gauss_fara_pivotare(U):

    n = U.shape[0]
    for k in range(n-1):
        p = k
        if U[p][k] == 0:
            p = p + 1
            # print(f"A intrat aici pentru k = {k}")
            # trebuie sa gasim primul element nenul si sa interschimbam cele doua linii
            while p < n and U[p][k] == 0:
                # print(f"A intrat aici")
                # cresc p-ul
                p = p + 1
            # interschimb liniile
            if p != k:
                U[[k, p]] = U[[p, k]]
                # print(f"Matricea dupa interschimbarea liniilor este: ")
                # print(U)
        for l in range(k+1, n):
            # trebuie sa merg pe toata linia curenta
            # caut primul element nenul de pe acea coloana
            # daca elementul este 0
            
            pivot = U[l][k] / U[k][k]
            U[l] = U[l] - pivot * U[k]
    # extragem vectorul b din matrice
    b = np.array([[0.], [0.]])
    # merg pe ultima coloana
    for lin in range(n):
        b[lin] = U[lin][n]
    # print(b)
    # apelez metoda rezolvSistem
    U = np.delete(U, n, 1)
    # print(U)
    print(f"Solutia este {rezolvSistem(U, b)}") 


def rezolvSistem(U, b):
    # trebuie sa generalizez dimensiunea vectorului c
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


eps = 10e-20
U = np.array([[eps, 1., 1.], [1., 1., 2.]])
gauss_fara_pivotare(U)