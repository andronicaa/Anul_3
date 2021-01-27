import numpy as np
import math

def gauss_fara_pivotare(U, b):

    U = np.append(U, b, axis = 1)
    n = U.shape[0]
    # print(U)
    # print(n)
    for k in range(0, n-1):
        print(f"--------------------------- Linia k = {k} ----------------------")
        print(f"U = {U}")
        # trebuie sa caut primul element nenul
        ok = False
        for p in range(k, n):
            if U[p][k]:
                ok = True
        if ok == False:
            print("Sistemul este incompatibil")
            return
        else:
            print(f"Linia pivotului p = {p}")
            if p != k:
                print(f"Pivotul nu se afla pe diagonala principala(linia k = {k}) => trebuie sa facem interschimbarea liniilor")
                U[[k, p]] = U[[p, k]]
                print(f"Matricea dupa interschimbarea liniilor \nU = {U}")

            for l in range(k+1, n):
                U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
        
    # daca ultimul element de pe ultima linie si ultima coloana este zero => sistemul este incompatibil
    if U[n-1][n-1] == 0:
        print("Sistem incompatibil sau nedeterminat")
        return
    b = np.zeros((n, 1))
    for i in range(n):
        b[i] = U[i][n]
    U = np.delete(U, n, 1)
    print("In final, U si b arata asta: ")
    print(f"U = {U}")
    print(f"b = {b}")
    print(f"Solutia sistemului folosind Gauss fara pivotare\n: {sub_descendenta(U, b)}")



def sub_descendenta(U, b):
    # Algoritm pentru metoda substitutiei descendenta(elementele de sub diagonala principala sunt egale cu 0)
    # dimensiunea matricei asociate sistemului(este patratica)
    n = U.shape[0]
    x = np.zeros((n, 1))
    # daca determinantul este diferit de 0
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
    # U = np.array([[0., 1., 2.], [1., 0., 1.], [3., 2., 1.]])
    # b = np.array([[8.], [4.], [10.]])
    # U = np.array([[0., 1., 1.], [2., 1., 5.], [4., 2., 1.]])
    # b = np.array([[3.], [5.], [1.]])
    U = np.array([[1., 0., -2.],[2., -2., 0.], [1., 2., 1.]])
    b = np.array([[-5.], [-6.], [5.]])
    # U = np.array([[2., -2., 1.], [1., 3., -2], [3., -1., -1.]])
    # b = np.array([[-3.], [1.], [2.]])
    gauss_fara_pivotare(U, b)
