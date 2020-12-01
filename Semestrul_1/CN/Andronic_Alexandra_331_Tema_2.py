import numpy as np
import math

# Metoda pentru Gauss cu Pivotare Totala
def gauss_pivotare_totala(U, b, cerinta):
    # primim ca argumente matricea asociata sistemului si vectorul coloana b

    # verific daca sistemul are solutie unica prin calcularea determinantului
    if abs(np.linalg.det(U)) > 1e-15: 
        # determinam dimensiunea matricei asociate sistemului
        n = U.shape[0]
        # concatenam vectorul coloana b la matricea sistemului U pentru a putea aplica algoritmul
        U = np.append(U, b, axis = 1)
        # vector ce retine indicii coloanelor in vederea permutarii coloanelor(ce corespund vectorilor solutiilor)
        index = np.arange(0, n)
        for k in range(0, n-1):

            # se cauta elementul cu valoarea absoluta maxima din submatrice
            # amax gaseste maximul dintr-un array
            # where gaseste locul din matrice unde se afla acest maxim prin compararea fiecarul element cu maximul dat
            result_maxim = np.where(U[k:, k:n] == np.amax(U[k:, k:n]))
            # print(f"Submatricea este U = {U[k:, k:n]}")
            # print(result_maxim)
            coord = list(zip(result_maxim[0], result_maxim[1]))
            # determinam coordonatele corespunzatoare maximului
            # p -> linia
            # m -> coloana
            p = coord[0][0] + k # adunam k la aceste pozitii pentru ca gasi pozitia lor raportata la toata matricea, nu la submatricea in care au fost cautate
            m = coord [0][1] + k
            # daca elementul gasit ca fiind maxim este egal cu 0 => Sistemul este incompatibil
            if U[p][m] == 0:
                if cerinta == "sistem":
                    return "Sistem incompatibil"
                elif cerinta == "inversa":
                    return "Nu se poate calcula inversa acestei matrici"
            
            # print(f"p = {p} si m = {m}")

            if p != k:
                # daca indexul liniei pivotului este diferit de cel curent => trebuie sa interschimbam cele doua linii
                U[[k, p]] = U[[p, k]]
            print(f"matricea dupa interschimbarea cu p => U = {U}")

            if m != k:
                # daca indexul coloanei pivotului este diferit de cel curent => trebuie sa interschimbam cele doua coloane
                # deoarece am interschimbat doua coloane => trebuie sa schimbam si ordinea necunoscutelor sistemului cu ajutorul vectorului index
                U[:, [k, m]] = U[:, [m, k]]
                index [m], index [k] = index[k], index[m]

            print(f"Matricea dupa interschimbarea cu m => U = {U}")
            # aux = np.array(U[k])
            # U[k] = np.array(U[p])
            # U[p] = np.array(aux)
            # aplic pivotarea pe coloana curenta sub pivot
            for l in range(k+1, n):
                U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
        
        # daca ultimul element de pe ultima linie si ultima coloana este zero => sistemul este incompatibil
        if U[n-1][n-1] == 0:
            
            if cerinta == "sistem":
                return "Sistem incompatibil"
            elif cerinta == "inversa":
                return "Nu se poate calcula inversa acestei matrici"
        
        # extragem toata matricea asociata lui b (la un sistem va fi un vector coloana, dar la inversa b va fi tot o matrice din care vom extrage pe rand cate o coloana)
        A = np.copy(U)
        U = A[0:, 0:n]
        # print(U)
        size_b = b.shape[1]
        # print(size_b)
        solution = np.zeros((n, size_b))
        print("forma solutie este")
        print(solution)
        for i in range(size_b):
            # trebuie sa rezolv fiecare sistem in parte
            y = x = np.zeros((n, 1))
            b = A[0:, n + i]
            # print("Matricea b este")
            # print(b)
            # print("Matricea U este")
            # print(U)
            # print(type(rezolvSistem(U, b)))
            y = sub_descendenta(U, b)
            if isinstance(y, int):
                
                if cerinta == "sistem":
                    return "Sistem incompatibil"
                elif cerinta == "inversa":
                    return "Nu se poate calcula inversa acestei matrici"
            else:
                for j in range(n):
                    x[index[j]] = y[j]
                print(x)
                for l in range(n):
                    solution[l][i] = x[l]


        
        return solution
    else:
        
        if cerinta == "sistem":
            return "Sistem incompatibil"
        elif cerinta == "inversa":
            return "Nu se poate calcula inversa acestei matrici"

# Factorizare LU
def factorizare_pivotare_partiala(U, b, cerinta):
    n = U.shape[0]
    x = np.zeros((n, 1))
    index = np.arange(0, n)
    
    # initializam toata matricea L cu zero
    L = np.zeros((n, n))
    for k in range(0, n-1):
        p = np.argmax(abs(U[k:,k])) + k
        if U[p][k] == 0:
            if cerinta == "sistem":
                return "Sistem incompatibil"
            elif cerinta == "inversa":
                return "Nu se poate calcula inversa acestei matrici"
            elif cerinta == "factLU":
                return "Matricea nu admite factorizare LU"

        if p != k:
            # daca indicele pivotului nu corespunde cu cel curent => trebuie sa interschimbam liniile si in U si in L
            U[[k, p]] = U[[p, k]]            
            aux = np.array(L[p,:k])
            L[p,:k] = np.array(L[k,:k])
            L[k,:k] = np.array(aux) 
            # deoarece am interschimbat doua coloane => trebuie sa schimbam si ordinea necunoscutelor sistemului cu ajutorul vectorului index
            index[p], index[k] = index[k], index[p]

        for l in range(k+1, n):
            # matricea L contine raportul dintre elementul de pe linia curenta si pivot
            L[l][k] = U[l][k] / U[k][k]
            U[l] = U[l] - L[l][k] * U[k]

    if U[n-1][n-1] == 0:
        if cerinta == "sistem":
            return "Sistem incompatibil"
        elif cerinta == "inversa":
            return "Nu se poate calcula inversa acestei matrici"
        elif cerinta == "factLU":
            return "Matricea nu admite factorizare LU"
    
    # dimensiunea vectorului b
    size_b = b.shape[0]
    # copie a vectorului b
    b_copy = np.copy(b)

    # interschimb elementele vectorului coloana b conform permutarii indecsilor din vectorul index
    for i in range(size_b):
        b[i] = b_copy[index[i]]

    # adun la matricea L matricea identitate pentru a avea pe diagonala principala 1
    # aceasta este o matrice inferior triunghiulara 
    L = L + np.identity(n)
    
    # il scriem pe A = LU
    # LUx = b <=> il notam pe Ux cu un y si rezolvam sistemul Ly = b => Ux = y si aflam solutia sistemului 
    sol_aux = np.zeros((n, 1))
    sol_aux = sub_ascendenta(L, b)
    if isinstance(sol_aux, int):
        if cerinta == "sistem":
            return "Sistem incompatibil"
        elif cerinta == "inversa":
            return "Nu se poate calcula inversa acestei matrici"
        elif cerinta == "factLU":
            return "Matricea nu admite factorizare LU"
    else:
        print("Sistemul admite factorizare LU si solutie unica si aceasta este")
        return sub_descendenta(U, sol_aux)



def fact_cholesky(A):
    # verific daca matricea este simetrica, urmand ca verificarea daca determinantii minorilor sunt pozitivi sa fie facuta in cadrul algoritmului la fiecare par
    if A == A.transpose():
        # pentru a se aplica factorizarea Cholesky matricea trebuie sa fie simetrica si pozitiv definita
        # Mai intai calculez elementul L[0][0] => fiind egal cu  radical din primul element din matricea A
        alfa = A[0][0]
        # dimensiunea matricei A
        n = A.shape[0]
        # daca alfa <= 0 => matricea nu este pozitiv definita => nu se poate continua algoritmul
        if alfa <= 0:
            return "A nu este pozitiv definita"
        
        # initializez matricea L cu 0
        L = np.zeros((n, n))
        L[0][0] = math.sqrt(alfa)
        
        # completez prima coloana a acesteia
        for i in range(1, n):
            L[i][0] = A[i][0] / L[0][0]
        
        # continui cu submatricea 
        for k in range(1, n):
            suma = 0
            for s in range(0, k):
                suma = suma + L[k][s] ** 2
            alfa = A[k][k] - suma
            if alfa <= 0:
                return "A nu este pozitiv definita"
            L[k][k] = math.sqrt(alfa)
            
            
            for i in range(k+1, n):
                suma = 0
                for s in range(0, k):
                    suma = suma + L[i][s] * L[k][s]
                L[i][k] = (1. / L[k][k]) * (A[i][k] - suma)
        trans_L = L.transpose()
        return f"Factorizarea Cholesky a matricei este L = {L} si L ^ T = {trans_L}"
    else:
        return "Matricea nu este simetrica."



def sub_ascendenta(U, b):

    # Algoritm pentru metoda substitutiei ascendente(elementele de deasupra diagonalei principale sunt egale cu 0)
    # dimensiunea matricei asociate sistemului(este patratica)
    n = U.shape[0]
    # initializam x(vectorul solutie) cu zero
    x = np.zeros((n, 1))
    # daca determinantul este egal cu 0(aproximarea sa) => sistemul nu are solutie unica
    # altfel  => are solutie unica(este compatibil determinat)
    # punem conditie ca acesta sa fie mai mare decat o aproximare a lui 0 data de noi
    if abs(np.linalg.det(U)) > 1e-15:
        # merg de la prima ecuatie catre ultima
        for i in range(0, n):
            suma = 0
            for j in range(i+1):
                # calculez suma produselor din fiecare ecuatie, exceptand elementul ce trebuie aflat
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma
        return x
    else:
        # returnez -1 daca determinantul este egal cu 0
        return -1

def sub_descendenta(U, b):
    # Algoritm pentru metoda substitutiei ascendente(elementele de deasupra diagonalei principale sunt egale cu 0)
    # dimensiunea matricei asociate sistemului(este patratica)
    n = U.shape[0]
    x = np.zeros((n, 1))
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
    
    # Exercitiul 1 - aplicarea algoritmului lui Gauss(cu pivotare totala)
    # Rezolvarea urmatorului sistem
    U = np.array([[0., 3., 5., -6.], [-6., 2., 5., 8.], [1., -1., -6., 9.], [-10., 7., -10., -9.]])
    b = np.array([[-1.], [54.], [20.], [-84.]])
    print("Solutia sistemul de la exercitiul 1 este: ")
    print(gauss_pivotare_totala(U, b, "sistem"))

    # Exerctiul 2 - inversa unei matrici folosind Gauss cu Pivotare Totala
    U = np.array([[0., 0., -6., -6.], [-10., -6., 1., -3.], [-6., -7., -1., 7.], [3., 5., -9., -1.]])
    U = np.array([[1., 2., 3.], [-1., 0., -1.], [3., 4., 7.]])
    U = np.array([[1., 2.], [4., 9.]])
    b = np.identity(U.shape[0])

    print("Inversa matricii date este: ")
    print(gauss_pivotare_totala(U, b, "inversa"))

    # Exercitiul 3 - Factorizare LU
    # U = np.array([[0., 1., 1.], [2., 1., 5.], [4., 2., 1.]])
    # b = np.array([[3.], [5.], [1.]])
    U = np.array([[0., 3., -3., -6.], [9., -3., -6., -6.], [7., -5., -5., -8.], [6., -2., -9., 9.]])
    b = np.array([[-33.], [-45.], [-61.], [15.]])
    print("Solutia sistemului folosind factorizalea LU este: ")
    print(factorizare_pivotare_partiala(U, b, "factLU"))

    # Exercitiul 4 - Factorizarea Cholesky
    # C = np.array([[9., 0., -6., -3.], [0., 49., 35., 35.], [-6., 35., 65., 63.], [-3., 35., 63., 78.]])
    print("Factorizarea Cholesky este: ")
    print(fact_cholesky(C))
