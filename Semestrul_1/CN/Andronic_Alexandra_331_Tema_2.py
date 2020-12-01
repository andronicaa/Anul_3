import numpy as np
import math

# Metoda pentru Gauss cu Pivotare Totala
def gauss_pivotare_totala(U, b, cerinta):
    # primim ca argumente matricea asociata sistemului si vectorul coloana b

    # verific daca sistemul are solutie unica prin calcularea determinantului
    if abs(np.linalg.det(U)) > 1e-15: 
        # determinam dimensiunea matricei asociate sistemului
        n = U.shape[0]
        # concatenez vectorul coloana b la matricea sistemului U pentru a putea aplica algoritmul
        U = np.append(U, b, axis = 1)
        # vector ce retine indicii coloanelor in vederea permutarii coloanelor(ce corespund vectorilor solutiilor)
        index = np.arange(0, n)
        for k in range(0, n-1):

            # se cauta elementul cu valoarea absoluta maxima din submatrice
            # amax gaseste maximul dintr-un array
            # where gaseste locul din matrice unde se afla acest maxim prin compararea fiecarul element cu maximul dat
            result_maxim = np.where(U[k:, k:n] == np.amax(U[k:, k:n]))
            coord = list(zip(result_maxim[0], result_maxim[1]))
            # determinam coordonatele corespunzatoare maximului
            # p -> linia
            # m -> coloana
            p = coord[0][0] + k # adunam k la aceste pozitii pentru a gasi pozitia lor raportata la toata matricea, nu la submatricea in care au fost cautate
            m = coord [0][1] + k
            # daca elementul gasit ca fiind maxim este egal cu 0 => Sistemul este incompatibil
            if U[p][m] == 0:
                if cerinta == "sistem":
                    return "Sistem incompatibil"
                elif cerinta == "inversa":
                    return "Nu se poate calcula inversa acestei matrici"
            
            if p != k:
                # daca indexul liniei pivotului este diferit de cel curent => trebuie sa interschimbam cele doua linii
                U[[k, p]] = U[[p, k]]

            if m != k:
                # daca indexul coloanei pivotului este diferit de cel curent => trebuie sa interschimbam cele doua coloane
                # deoarece am interschimbat doua coloane => trebuie sa schimbam si ordinea necunoscutelor sistemului cu ajutorul vectorului index
                U[:, [k, m]] = U[:, [m, k]]
                index [m], index [k] = index[k], index[m]

            # aplic pivotarea pe coloana curenta sub pivot
            for l in range(k+1, n):
                U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
        
        # daca ultimul element de pe ultima linie si ultima coloana este zero(corespunzator matricei sistemului) => sistemul este incompatibil
        if U[n-1][n-1] == 0:
            # in functie de cerinta afisez un mesaj corespunzator
            if cerinta == "sistem":
                return "Sistem incompatibil"
            elif cerinta == "inversa":
                return "Nu se poate calcula inversa acestei matrici"
        
        
        A = np.copy(U) # ii fac o copie matricei U
        U = A[0:, 0:n] # extrag matricea U asociata sistemului dupa ce s-a facut pivotarea
        size_b = b.shape[1] # aflu cate coloane are b
        solution = np.zeros((n, size_b)) # vector solutie cu numarul de linii egal cu n(numarul de linii din U) si coloane egal cu size_b(numarul de coloane din b)
        for i in range(size_b):
            # trebuie sa rezolv fiecare sistem in parte(in cazul unui sistem va fi de rezolvat doar unul)
            y = x = np.zeros((n, 1))
            # extragem toata matricea asociata lui b (la un sistem va fi un vector coloana, dar la inversa b va fi tot o matrice din care vom extrage pe rand cate o coloana)
            b = A[0:, n + i]
            # aplic algoritmul de substitutie descendenta(deoarece matricea U obtinuta este o matrice superior triunghiulara)
            # verificare pentru afisare
            if isinstance(sub_descendenta(U, b), int):
                if cerinta == "sistem":
                    return "Sistem incompatibil"
                elif cerinta == "inversa":
                    return "Nu se poate calcula inversa acestei matrici"
            else:
                y = sub_descendenta(U, b)
                for j in range(n):
                    x[index[j]] = y[j]
                for l in range(n):
                    solution[l][i] = x[l]


        # returnez solutia
        return solution
    else:
        # pe aceasta ramura va intra daca determinantul va fi mai mic decat acel prag dat
        if cerinta == "sistem":
            return "Sistem incompatibil"
        elif cerinta == "inversa":
            return "Nu se poate calcula inversa acestei matrici"

# Factorizare LU
def factorizare_pivotare_partiala(U, b):

    # verific daca sistemul are solutie unica
    if abs(np.linalg.det(U)) > 1e-15: 
        n = U.shape[0] #dimensiunea matricei
        index = np.arange(0, n) #vector pentru indecsii solutiilor
        L = np.zeros((n, n)) # initializam toata matricea L cu zero
        # aplic algoritmul de pivotare partiala pe matricea U
        for k in range(0, n-1):

            p = np.argmax(abs(U[k:,k])) + k
            if U[p][k] == 0:
                return "Matricea nu admite factorizare LU"

            if p != k:
                # daca indicele pivotului nu corespunde cu cel curent => trebuie sa interschimbam liniile si in U si subliniile(elementele de sub diagonala principala) din L
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
            return "Matricea nu admite factorizare LU"
        
        
        size_b = b.shape[0] # dimensiunea vectorului b(numarul de linii)
        b_copy = np.copy(b) # copie a vectorului b

        # interschimb elementele vectorului coloana b conform permutarii indecsilor din vectorul index(folosindu-ma de vectorul copie al lui b)
        for i in range(size_b):
            b[i] = b_copy[index[i]]

        # adun la matricea L matricea identitate pentru a avea pe diagonala principala 1
        # aceasta este o matrice inferior triunghiulara 
        L = L + np.identity(n)
        
        # il scriem pe A = LU
        # LUx = b <=> il notam pe Ux cu un y si rezolvam sistemul Ly = b => Ux = y si aflam solutia sistemului 
        sol_aux = np.zeros((n, 1))
        
        if isinstance(sub_ascendenta(L, b), int):
            return "Matricea nu admite factorizare LU"
        else:
            sol_aux = sub_ascendenta(L, b)
            return f"Sistemul admite factorizare LU si solutia unica este: \n {sub_descendenta(U, sol_aux)}"
    else:
        return "Sistemul nu admite solutie unica."


def fact_cholesky(A):
    # verific daca matricea este simetrica, urmand ca verificarea daca determinantii minorilor sunt pozitivi sa fie facuta in cadrul algoritmului la fiecare pas
    transpusa = A.transpose()
    if np.allclose(A, transpusa):
        # pentru a se aplica factorizarea Cholesky matricea trebuie sa fie simetrica si pozitiv definita
        # Mai intai calculez elementul L[0][0] => fiind egal cu  radical din primul element din matricea A
        alfa = A[0][0]
        n = A.shape[0] # dimensiunea matricei A

        # daca alfa <= 0 => matricea nu este pozitiv definita => nu se poate continua algoritmul
        if alfa <= 0:
            return "A nu este pozitiv definita"
        
        
        L = np.zeros((n, n)) # initializez matricea L cu 0
        L[0][0] = math.sqrt(alfa)
        
        # completez prima coloana a acesteia
        for i in range(1, n):
            L[i][0] = A[i][0] / L[0][0]
        
        # continui cu submatricea astfel incat A = LL^T(transpusa matricei L)
        # L va fi o matrice inferior triunghiulara
        for k in range(1, n):
            suma = 0
            # calculez elementul de pe diagonala principala(corespunzator coloanei k)
            for s in range(0, k):
                # se calculeaza suma patratelor elementelor de pe linia curenta
                suma = suma + L[k][s] ** 2
            # alfa va fi diferenta dintre elementul de pe diagonala principala din A corespunzator lui A si suma calculata anterior
            alfa = A[k][k] - suma
            if alfa <= 0:
                return "A nu este pozitiv definita"
            L[k][k] = math.sqrt(alfa)


            # se calculeaza elementele ramase sub diagonala principala(fara elementul de pe acesta deoarece a fost calculat la pasul anterior)
            for i in range(k+1, n):
                suma = 0
                for s in range(0, k):
                    # se calculeaza suma produselor elementelor de sub diagonala principala din submatrice
                    # de pe liniile de sub linia k inmultite cu elementele de pe linia k
                    suma = suma + L[i][s] * L[k][s]
                # aflu necunoscuta
                L[i][k] = (1. / L[k][k]) * (A[i][k] - suma)

        trans_L = L.transpose()
        return f"Factorizarea Cholesky a matricei este \n L = \n {L} si \n L ^ T = \n {trans_L}"
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
    # punem conditie ca acesta sa fie mai mare decat o aproximare a lui 0 data de noi(in modul)
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
    # Algoritm pentru metoda substitutiei ascendente(elementele de sub diagonala principala sunt egale cu 0)
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
    
    # Exercitiul 1 - Rezolvarea unui sistem cu algoritmul Gauss cu Pivotare Totala
    U = np.array([[0., 6., 1., -7.], [-3., 0., 5., 0.], [-4., -8., -5., 2.], [-8., 8., -8., 1.]])
    b = np.array([[-13.], [14.], [-42.], [-19.]])
    print("Solutia sistemul de la exercitiul 1 este: ")
    print(gauss_pivotare_totala(U, b, "sistem"))

    print("----------------------------------------")
    # Exerctiul 2 - Inversa unei matrici folosind Gauss cu Pivotare Totala
    B = np.array([[0., 0., -6., -6.], [-10., -6., 1., -3.], [-6., -7., -1., 7.], [3., 5., -9., -1.]])
    b = np.identity(B.shape[0])
    print("Inversa matricii date este: ")
    print(gauss_pivotare_totala(B, b, "inversa"))

    print("----------------------------------------")

    # Exercitiul 3 - Factorizare LU
    U = np.array([[0., 0., 9., -2.], [-7., 3., 2., -9.], [6., -3., -10., -5], [1., 7., 2., 2.]])
    b = np.array([[26.], [-42.], [-62.], [41.]])
    print("Solutia sistemului folosind factorizalea LU este: ")
    print(factorizare_pivotare_partiala(U, b))

    print("----------------------------------------")

    # Exercitiul 4 - Factorizarea Cholesky
    C = np.array([[9., 0., -6., -3.], [0., 49., 35., 35.], [-6., 35., 65., 63.], [-3., 35., 63., 78.]])
    print(fact_cholesky(C))
