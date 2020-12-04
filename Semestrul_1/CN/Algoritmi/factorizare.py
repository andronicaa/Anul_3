import numpy as np
def factorizare_pivotare_partiala(U, b):
    n = U.shape[0]
    x = np.zeros((n, 1))
    index = np.arange(0, n)
    
    L = np.zeros((n, n))
    for k in range(0, n-1):
        p = np.argmax(abs(U[k:,k])) + k
        if U[p][k] == 0:
            return "Matricea data nu admite factorizarea LU"
        if p != k:
            U[[k, p]] = U[[p, k]]
            L[[k, p]] = L[[p, k]]
            index[p], index[k] = index[k], index[p]
        for l in range(k+1, n):
            L[l][k] = U[l][k] / U[k][k]
            U[l] = U[l] - L[l][k] * U[k]

    if U[n-1][n-1] == 0:
        return "Matricea data nu admite factorizare LU"
    # trebuie sa modificam vectorul b
    size_b = b.shape[0]
    b_copy = np.copy(b)
    # print(index)
    for i in range(size_b):
        b[i] = b_copy[index[i]]
    # print(b) 
    L = L + np.identity(n)
    # b = np.array([[0.], [0.]])
    # for i in range(n):
    #     b[i] = U[i][n]
    # # trebuie sa luam ultima coloana din U
    # # stergem ultima coloana din U
    # U = np.delete(U, n, 1)
    # print(f"Fara pivotare: {rezolvSistem(U, b)}")
    
    # matricea rezultata este
    # print(f"Matricea U = ")
    # print(U)
    # print(f"Matricea L = ")
    # print(L)
    # print("Solutia sistemului ascendent este")
    # print(sub_ascendenta(L, b))
    sol_aux = np.zeros((n, 1))
    sol_aux = sub_ascendenta(L, b)
    if isinstance(sol_aux, int):
        return "Sistemul nu admite solutie unica"
    else:
        # print(sol_aux)
        print("Sistemul admite factorizare LU si solutie unica si aceasta este")
        return subst_descendenta(U, sol_aux)


def sub_ascendenta(U, b):
    n = U.shape[0]
    x = np.zeros((n, 1))
    # x[0] = b[0] / U[0][0]
    # print(x)
    if abs(np.linalg.det(U)) > 1e-15:
        for i in range(0, n):
            suma = 0
            # print(i)
            for j in range(i+1):
                # print(U[i][j])
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma
        return x
    else:
        return -1

def subst_descendenta(U, b):
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
    else:
        return -1

if __name__ == "__main__":
    U = np.array([[0., 3., -3., -6.], [9., -3., -6., -6], [7., -5., -5, -8.], [6., -2., -9., 9.]])
    b = np.array([[-33.], [-45.], [-61.], [15]])
    print(factorizare_pivotare_partiala(U, b))