# GAUSS CU PIVOTARE TOTALA  

import numpy as np

def gauss_pivotare_totala(U, b):
    # determinam dimensiunea matricei asociate sistemului
    n = U.shape[0]
    U = np.append(U, b, axis = 1)
    # vector ce retine indicii coloanelor 
    index = np.arange(0, n)
    for k in range(0, n-1):
        print(f"--------------------------- Linia k = {k} ----------------------")
        print(f"U = {U}")
        # sa adaug si cazul in care sistemul nu este compatibil => adica nu se gaseste un element nenul pe coloana respectiva
        # se cauta elementul cu valoarea absoluta maxima din submatrice
        p = k
        m = k
        result_maxim = np.where(U[k:, k:n] == np.amax(U[k:, k:n]))
        # print(f"Submatricea este U = {U[k:, k:n]}")
        # print(result_maxim)
        coord = list(zip(result_maxim[0], result_maxim[1]))
        # print(coord)
        p = coord[0][0] + k
        m = coord [0][1] + k
        print(f"Linia pivotului p = {p}")
        print(f"Coloana pivotului m = {m}")
        if U[p][m] == 0:
            print("Sistemul este incompatibil")
            break
        if p != k:
            print(f"Pivotul nu se afla pe diagonala principala(linia k = {k}) => trebuie sa facem interschimbarea liniilor")
            U[[k, p]] = U[[p, k]]
            print(f"Matricea dupa interschimbarea liniilor \nU = {U}")
        # print(f"matricea dupa interschimbarea cu p => U = {U}")
        if m != k:
            print(f"Pivotul nu se afla pe diagonala principala(linia k = {k}) => trebuie sa facem interschimbarea coloanelor")
            U[:, [k, m]] = U[:, [m, k]]
            index [m], index [k] = index[k], index[m]
            print(f"Matricea dupa interschimbarea coloanelor \nU = {U}")

        # print(f"Matricea dupa interschimbarea cu m => U = {U}")
        for l in range(k+1, n):
            U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
    
    # daca ultimul element de pe ultima linie si ultima coloana este zero => sistemul este incompatibil
    if U[n-1][n-1] == 0:
        print("Sistemul este incompatibil")
    

    b = U[0:, n]
    U = U[0:, 0:n]
    print("In final, U si b arata asta: ")
    print(f"U = {U}")
    print(f"b = {b}")
    y = x = np.zeros((n, 1))
    
    
    y = sub_descendenta(U, b)
    for i in range(n):
        x[index[i]] = y[i]
    return f"Solutia este:\n {x}"



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
    eps = 10e-20
    # U = np.array([[0., 6., 1., -7.], [-3., 0., 5., 0.], [-4., -8., -5., 2.], [-8., 8., -8., 1.]])
    # b = np.array([[-13.], [14.], [-42.], [-19.]])
    # U = np.array([[0., 1., 2., 8],[1., 0., 1., 4.], [3., 2., 1., 10.]])
    # U = np.array([[0., 1., 2.], [1., 0., 1.], [3., 2., 1.]])
    # b = np.array([[8.], [4.], [10.]])
    # U = np.array([[0., 3., 5., -6.], [-6., 2., 5., 8.], [1., -1., -6., 9.], [-10., 7., -10., -9.]])
    # b = np.array([[-1.], [54.], [20.], [-84.]])
    # U = np.array([[0., -6., 1., 9.], [5., -1., -7., 3.], [1., -4., -6., 7.], [7., 9., -10., 9.]])
    # b = np.array([[35.], [-6.], [-1.], [61.]])
    # U = np.array([[0., 1., 2.], [1., 0., 1.], [3., 2., 1.]])
    # b = np.array([[8.], [4.], [10.]])
    # U = np.array([[0., 1., 1.], [2., 1., 5.], [4., 2., 1.]])
    # b = np.array([[3.], [5.], [1.]])
    U = np.array([[1., 0., -2.],[2., -2., 0.], [1., 2., 1.]])
    b = np.array([[-5.], [-6.], [5.]])
    print(gauss_pivotare_totala(U, b))