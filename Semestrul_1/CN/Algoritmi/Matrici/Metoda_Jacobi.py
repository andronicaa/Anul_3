import numpy as np

def modul_matrice(A):
    n = np.shape(A)[0]
    suma = 0

    for i in range(n):
        for j in range(n):
            if i!= j:
                suma = suma + A[i][j]**2
    
    return np.sqrt(suma)

def maxim_poz(A):
    n = np.shape(A)[0]
    maxim, p, q = -1, -1, -1

    for i in range(n-1):
        for j in range(i+1, n):
            if np.abs(A[i][j]) > maxim:
                p = i
                q = j
                maxim = np.abs(A[i][j])
    return p, q

def metoda_Jacobi(A):
    epsilon = 1e-5
    n = np.shape(A)[0]
    while modul_matrice(A) >= epsilon:
        p, q = maxim_poz(A)
        theta = 0
        if  abs(A[p][p] - A[q][q]) < epsilon :
            theta = np.pi/4
        else:
            theta = (1 / 2) * np.arctan((2 * A[p][q]) / (A[q][q] - A[p][p]))
        
        c = np.cos(theta)
        s = np.sin(theta)

        print(f"teta: {theta}, c: {c}(cos), s: {s}(sin)")

        u, v = 0, 0
        for j in range(n):
            if j != p and j != q:
                u = A[p][j] * c - A[q][j] * s
                v = A[p][j] * s + A[q][j] * c
                A[p][j] = u
                A[q][j] = v
                A[j][p] = u
                A[j][q] = v
        
        u = c * c * A[p][p] - 2 * c * s * A[p][q] + s * s * A[q][q]
        v = s * s * A[p][p] + 2 * c * s * A[p][q] + c * c * A[q][q]
        A[p][p] = u
        A[q][q] = v
        A[p][q] = 0
        A[q][p] = 0
    
        print(np.round(A,5))
        return np.round(A, 5)


A = np.array([
    [4., 1., 1.],
    [1., 4., 1.],
    [1., 1., 4.]
])

A1 = metoda_Jacobi(A)
print(A1)
A2 = metoda_Jacobi(A1)
print(A2)
print(f"Valorile proprii aproximative sunt: {np.diagonal(A2)}")