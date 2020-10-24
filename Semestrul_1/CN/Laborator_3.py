import numpy as np

def rezolvSistem(U, b):
    x = np.array([[0.], [0.], [0.]])
    n = U.shape[0]
    if abs(np.linalg.det(A)) > 1e-15: 
        for i in range(n-1, -1, -1):
            suma = 0
            for j in range(i+1, n):
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma

            
        return x



U = np.array([[2., -1., -2.], [0., 4., 4.], [0., 0., 1.]])
b = np.array([[-1.], [8.], [1.]])
print(rezolvSistem(U, b))