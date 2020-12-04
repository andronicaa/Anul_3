import numpy as np
import math

def verif_admite_cholesky(A):
    alfa = A[0][0]
    n = A.shape[0]
    if alfa <= 0:
        return "A nu este pozitiv definita"
    L = np.zeros((n, n))
    L[0][0] = math.floor(math.sqrt(alfa))
    # print(L[0][0])
    for i in range(1, n):
        L[i][0] = A[i][0] / L[0][0]
    # print(L)
    for k in range(1, n):
        suma = 0
        for j in range(1, k):
            suma = suma + L[k][j] ** 2
        alfa = A[k][k] - suma
        if alfa <= 0:
            return "A nu este pozitiv definita"
        L[k][k] = math.floor(math.sqrt(alfa))
        suma = 0
        for s in range(1, k):
            suma = suma + L[i][s] * L[k][s]
        for i in range(k+1, n):
            L[i][k] = math.floor((1 / L[k][k]) * (A[i][k] - suma))

    return f"Factorizarea Cholesky a matricei este L = {L}"
    # # rezolv sistemul ascendent
    # # matricea transpusa a lui L
    # trans_L = L.transpose()
    # print("transpusa lui este este")
    # print(trans_L)
    # sol_aux = np.zeros((n, 1))
    # sol_aux = sub_ascendenta(L, b)
    # print(sol_aux)
    # if (isinstance(sol_aux, int)):
    #     print(sol_aux)
    #     return "Sistemul nu are solutie unica"
    # else:
    #     print("DA")
    #     return subst_descendenta(trans_L, sol_aux)


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
    A = np.array([[9., 0., -6., -3.], [0., 49., 35., 35], [-6., 35., 65., 63], [-3., 35., 63., 78.]])
    b = np.array([[12.], [30.], [10.]])
    print(verif_admite_cholesky(A))