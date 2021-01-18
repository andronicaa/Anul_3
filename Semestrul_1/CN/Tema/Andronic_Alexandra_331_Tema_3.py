import matplotlib.pyplot as plt
import numpy as np
import math


# ---------------- EXERCITIUL 1 ----------------------
def exercitiul_unu():
    # Trebuie sa calculam derivatele partiale in functie de x si y pentru a determina matricile A si b 
    # -----------------------
    # df1(x) = x - 8.0 * y - 7
    # df1(y) = -8.0 * x + 164 * y + 2
    # -----------------------
    # Determinarea matricelor A si b dupa calcularea derivatelor partiale
    A = np.array([[1, -8],[-8, 164]]).astype(float) # Matrice pozitiv definita
    b = np.array([[-7],[2]]).astype(float)
    
    if verif_sim_poz_def(A):
        # Daca matricea A este simetrica si pozitiv definita => f admite punct de minim
        # Retin pasii facuti la fiecare iteratie in vectori
        p_minim, steps_pas_desc = pas_descendent(A, b)
        p_minim, steps_grd_conj = gradient_conjugat(A, b)
        # Afisez graficul cu liniile de nivel
        # Pentru metoda pasului descendent
        linii_nivel(A, b, steps_pas_desc, steps_grd_conj, 1)
        # Pentru metoda gradientilor conjugati
        linii_nivel(A, b, steps_pas_desc, steps_grd_conj, 2)



# Functia pentru care vreau sa calculez punctul de minim
def f1(x, y):
    return 0.5 * x ** 2 - 8.0 * x * y - 7.0 * x + 82.0 * y ** 2 + 2 * y

# Functie care verifica daca o matrice este simetrica si pozitiv definita
def verif_sim_poz_def(A):

    # Verific daca matricea este simetrica
    # Calculez transpusa matricei
    transpusa = A.transpose()
    este_simetrica = np.all(A == transpusa)

    # O matrice este simetrica daca este egala cu transpusa ei
    # Daca matricea nu este simetrica => returnam False
    if este_simetrica == False:
        return False
    
    # Verific daca este pozitiv definita cu Criteriul lui Sylvester
    # Fiecare minor trebuie sa fie strict pozitiv

    for i in range(A.shape[0]):
        # daca unul din minori este <= 0 => se va returna False
        if np.linalg.det(A[:i, :i]) <= 0:
            return False
    
    # Daca niciuna din verificarile de mai sus nu a returnat False =>
    # Matricea este simetrica si pozitiv definita
    return True



def grid_discret(A, b):
    """
    Construieste un grid discret si evaleaza f in fiecare punct al gridului
    """
    
    size = 100 # Numar de puncte pe fiecare axa
    x1 = np.linspace(-100, 100, size) # Axa x1
    x2 = np.linspace(-4, 6, size) # Axa x2
    X1, X2 = np.meshgrid(x1, x2) # Creeaza un grid pe planul determinat de axele x1 si x2

    X3 = np.zeros((size, size))
    for i in range(size):
        for j in range(size):
            x = np.array([X1[i,j], X2[i,j]]) # x e vectorul ce contine coordonatele unui punct din gridul definit mai sus
            # functia este de forma urmatoare
            # f(x) = 1/2 * x.T * A * x - b * x
            X3[i,j] = .5 * x @ A @ x - x @ b # Evaluam functia in punctul x
            
    return X1, X2, X3

def grafic_f(A,b):
    """
    Construieste graficul functiei f
    """
    
    # Construieste gridul asociat functiei
    (X1, X2, X3) = grid_discret(A, b)

    # Defineste o figura 3D
    fig1 = plt.figure()
    ax = plt.axes(projection="3d")

    # Construieste graficul functiei f folosind gridul discret X1, X2, X3=f(X1,X2)
    ax.plot_surface(X1, X2, X3, rstride=1, cstride=1, cmap='winter', edgecolor='none')

    # Etichete pe axe
    ax.set_xlabel('x1')
    ax.set_ylabel('x2')
    ax.set_zlabel('f(x1,x2)')

    # Titlu
    ax.set_title('Graficul functiei f')

    # Afiseaza figura
    plt.show()

def linii_nivel(A,b, steps_pas_desc, steps_grd_conj, metoda):
    """
    Construieste liniile de nivel ale functiei f
    """
    
    # Construieste gridul asociat functiei
    (X1, X2, X3) = grid_discret(A, b)
    
    # Ploteaza liniile de nivel ale functiei f
    fig2 = plt.figure()
    plt.contour(X1, X2, X3, levels = 10) # levels = numarul de linii de nivel
    

    # ------------- PLOTEAZA TOTI PASII ALGORITMULUI ---------------
    # De la metoda pasului descendent
    if metoda == 1:
        for i in range(len(steps_pas_desc)-1):
            plt.plot([steps_pas_desc[i][0][0], steps_pas_desc[i+1][0][0]], [steps_pas_desc[i][1][0], steps_pas_desc[i+1][1][0]], linestyle='-', linewidth=3)
    
    if metoda == 2:
    # De la metoda gradientilor conjugati
        for i in range(len(steps_grd_conj)-1):
            plt.plot([steps_grd_conj[i][0][0], steps_grd_conj[i+1][0][0]], [steps_grd_conj[i][1][0], steps_grd_conj[i+1][1][0]], linestyle='-', linewidth=3)

    # Etichete pe axe
    plt.xlabel('x1')
    plt.ylabel('x2')
    
    # Titlu
    if metoda == 1:
        plt.title('Liniile de nivel ale functiei f pentru metoda pasului descendent')

    if metoda == 2:
        plt.title('Liniile de nivel ale functiei f pentru metoda gradientilor conjugati')
    
    # Afiseaza figura
    plt.show()


# ----------- METODA PASULUI DESCENDENT ---------------------
def pas_descendent(A, b):
    # Pentru a aplica acest algoritm matricea trebuie sa fie simetrica si pozitiv definita
    # Aleg punctul initial
    x_k = np.array([[-10], [1]]).astype(float)
    # Trebuie sa retin punctele prin care trec
    x_puncte_grafic = [x_k]

    # Reziduu -> ne arata cat de aproape este de solutie valoarea calculata de noi
    reziduu = b - A @ x_k
    # Punctul de oprire
    eps = 1e-8

    # Folosesc norma 2
    norma = lambda x: np.linalg.norm(x, ord = 2)
    iteratii = 0
    while norma(reziduu) > eps:
        iteratii += 1
        # Aceasta valoare determina cat de mult trebuie sa coboram pe gradient -> arata "dimensiunea" pasului la fiecare iteratie
        learning_rate = (reziduu.T @ reziduu) / (reziduu.T @ A @ reziduu)
        x_k = x_k + learning_rate * reziduu

        # Adaug punctul la vectorul de pasi
        x_puncte_grafic.append(x_k)
        reziduu = b - A @ x_k


    # Afisez numarul de iteratii
    print("Rezultatele pentru exercitiul 1 cu metoda pasului descendent sunt: ")
    print(f"Numarul de iteratii este {iteratii}")
    print(f"Punctul de minim este {x_k}")
    # Returnez punctul de minim si vectorul cu valorile de la fiecare iteratie
    return [x_k, x_puncte_grafic]
    
# ----------------------- METODA GRADIENTILOR CONJUGATI ---------------------------
def gradient_conjugat(A, b):
    # Aleg punctul initial
    x_k = np.array([[-10], [1]]).astype(float)
    # Adaug punctul initial la vectorul de pasi
    x_puncte_grafic = [x_k]

    # Calculez reziduu
    reziduu = b - A @ x_k
    # Directia se alege astfel incat sa fie egala cu solutia sistemului Ax = b (adica reziduul in prima faza)
    directie = reziduu
    norma = lambda x: np.linalg.norm(x, ord = 2)
    iteratii = 0
    eps = 1e-8

    # Cat timp n-am ajuns la solutie continuam sa calculam
    while norma(reziduu) > eps:

        # Marim numarul de iteratii
        iteratii += 1
        learning_rate = (directie.T @ reziduu) / (directie.T @ A @ directie)
        # La fiecare iteratie se merge ortogonal cu directiile precedente => numarul de iteratii scade considerabil astfel(doar 2 pasi)
        x_k = x_k + learning_rate * directie
        next_reziduu = reziduu - learning_rate * A @ directie
        direction_rate = (next_reziduu.T @ next_reziduu) / (reziduu.T @ reziduu)
        directie = next_reziduu + direction_rate * directie

        reziduu = next_reziduu
        x_puncte_grafic.append(x_k)

    print("Rezultatele pentru exercitiul 1 cu metoda gradientilor conjugati sunt: ")
    print(f"Numarul de iteratii este {iteratii}")
    print(f"Punctul de minim este {x_k}")
    return [x_k, x_puncte_grafic]


# --------------- END EXERCITIUL 1 -----------------------------


# --------------- EXERCITIUL 2 ---------------------------------
# Functia pentru care vrem sa calculam aproximarea
def f2(x):
    return (-1) * math.sin((-4) * x) - 5 * math.cos(4 * x) - 23.55 * x


def noduri_chebyshev(k, mrg_inf, mrg_sup, N):
    # Se folosesc nodurile Chebysev pentru a se imbunatati din punct de vedere numeric eroarea de trunchiere(pentru a evita erorile mari in apropierea marginilor)
    return (mrg_inf + mrg_sup) / 2 + (mrg_sup - mrg_inf) / 2 * np.cos(np.pi * (N - k) / N)

# Functie ce construieste polinomul cu ajutorul coeficientilor aflati din rezolvarea sistemului
def evaluare(x, C, N, X):
    s = C[0]
    for i in range(1, N + 1):
        produs = C[i]
        for j in range(i):
            produs = produs * (X - x[j])
        s = s + produs
    
    return s

def exercitiul_doi():
    # Marginile inferioare si superioare([-pi, pi])
    a = - np.pi
    b = np.pi
    # Cat timp nu se indeplineste conditia ca eroarea maxima de trunchiere sa fie mai mica decat o valoare data(1e-5) continuam sa crestem N-ul
    # Cand conditia va fi satisfacuta => bucla se va opri si astfel va fi ales cel mai mic N
    N = 1
    while True:
        N = N + 1
        # Afisez N-urile pentru care nu se respecta conditia
        print(f"Pentru N = {N} nu se respecta conditia pentru eroarea de trunchiere")
        ret, coeficienti, x, erori, maxim, vals = interpolare_metoda_newton(N, a, b)
        if ret != -1:
            print(f"N-ul pentru care se respecta conditia cu eroarea de trunchiere:{N}")
            # Plotez graficul
            nr_puncte = 100
            x_grafic = np.linspace(a, b, nr_puncte)
            f3 = np.vectorize(f2)
            y_grafic = f3(x_grafic)
            
            y_aproximat = [evaluare(x,coeficienti,N,X) for X in x_grafic]

            # Afisez functia originala, nodurile de interpolare si polinomul
            plt.figure("Interpolare Lagrange: Metoda Newton")
            plt.plot(x_grafic, y_grafic, label = "Functia")
            plt.plot(x_grafic, y_aproximat, linestyle = "-.", label = "Polinom de interpolare")
            
            # Afisam pe grafic nodurile de interpolare
            plt.scatter(x, f3(x), label = "Nodurile de interpolare") 
            plt.legend()
            plt.show()

            # Grafic cu eroarea de trunchiere
            plt.figure("Eroare interpolare cu polinoame Lagrange: metoda Newton")
            plt.plot(vals, erori, label = "Erori obtinute")
            plt.hlines(1e-5, xmin = a, xmax = b, color = 'blue')
            plt.hlines(maxim, xmin = a, xmax = b, color = 'orange', label = "Eroare maxima din algoritmul meu")
            plt.legend()
            plt.show()

            return

def interpolare_metoda_newton(N, mrg_inf, mrg_sup):

    # Determin intervalele folosindu-ma de nodurile Chebysev pentru a putea minimiza eroarea de trunchiere
    x = np.array([noduri_chebyshev(i, mrg_inf, mrg_sup, N) for i in range(N + 1)])
    
    # y = f(x)
    y = np.zeros((N + 1, 1))
    for i in range(len(x)):
        y[i] = f2(x[i])

    # Coeficientii se afla dintr-un sistem ce are deasupra diagonalei principale 0 si sub diagonala principala cate un produs de diferente
    # construim matricea A
    A = np.zeros((N + 1, N + 1))
    # Pe prima coloana sunt doar valori de 1
    A[:,0] = 1
    for i in range(1, N + 1):
        produs = 1
        for j in range(i):
            produs = produs * (x[i] - x[j])
            A[i][j + 1] = produs

    
    # Aflu coeficientii cu metoda substitutiei ascendente
    coeficienti = sub_ascendenta(A, y)
    
    nr_puncte = 100
    x_grafic = np.linspace(mrg_inf, mrg_sup, nr_puncte)
    f3 = np.vectorize(f2)
    y_grafic = f3(x_grafic)
    y_aproximat = [evaluare(x,coeficienti,N,val) for val in x_grafic]

    erori, er_max = eroare_trunchiere(y_grafic, y_aproximat)
    if er_max <= 1e-5:
        return N, coeficienti, x, erori, er_max, x_grafic

    return -1, None, None, None, None, None


def eroare_trunchiere(y, y_aproximat):
    eroare = np.abs(y - y_aproximat)
    maxim = np.max(eroare)

    return eroare, maxim


# ---------------- END EXERCITIUL 2 ----------------------------



# ----------------- EXERCITIUL 3 -------------------------------


def exercitiul_trei():
    # Marginea inferioara
    a = (-1) * math.pi
    # Marginea superioara
    b = math.pi
    int_spline_cubica(a, b)

# Functia care trebuie aproximata
def f3(x):
    return 3 * math.sin((-2) * x) - 4 * math.cos(4 * x) - 0.31 * x

# Derivata acestei functii
def df3(x):
    return (-6) * math.cos(2 * x) + 16 * math.sin(4 * x) - 0.31


def int_spline_cubica(mrg_inf, mrg_sup):

    # Numarul de intervale
    N = 144
    # Am ales N-ul 144 dupa o verificare intr-un while la fiecare pas, l-am sters deoarece dura prea mult sa se ajunga la acest rezultat

    # Diviziune a intervalului [mrg_inf, mrg_sup] ([-pi, pi])
    x = np.zeros((N+1, 1))
    x = np.linspace(mrg_inf, mrg_sup, N + 1)
    y = np.zeros((N + 1, 1))
    for i in range(len(x)):
        y[i] = f3(x[i])

    # Calculam coeficientii
    # A - ul
    # a = f(xj) (a = y)
    a = y.copy()

    # b - ul
    # Mai intai se formeaza o matrice 
    '''
    Matricea b este de forma = (1 0 0 0 .......
                                1 4 1 0 0 .....
                                0 1 4 1 0 0 ...
                                ...............
                                ...............
                                0 0 0 0 0 0 0 1)
    '''
    B = np.zeros((N+1, N+1))

    # Prima valoare din matrice este 1
    B[0][0] = 1
    # Construim urmatoarele linii (cu exceptia ultimei valori din matrice) dupa urmatorul tipar
    # La fiecare pas se shifteaza spre dreapta valorile 1 4 1
    for i in range(1, N):
        B[i][i - 1] = 1
        B[i][i] = 4
        B[i][i + 1] = 1

    # Ultima valoare din matrice este 1
    B[N][N] = 1

    # Folosesc o discretizare echidistanta, h-ul este mereu acelasi(deoarece si intervalele sunt echidistante)
    h = x[1] - x[0]

    # Trebuie sa rezolvam sistemul
    # Calculez valorile din matricea W(rezultate din formulele de recurenta)
    W = np.zeros((N + 1, 1))
    W[0] = df3(x[0])
    for i in range(1, N):
        W[i] = 3 * (y[i + 1] - y[i - 1]) / h
    W[N] = df3(x[N])

    # Determin b-ul cu ajutorul factorizarii LU(Gauss cu pivotare partiala)
    b = factorizare_pivotare_partiala(B, W)
    
    # Calculam c si d(cu ajutorul lui b calculat anterior)
    c = np.zeros((N, 1))
    d = np.zeros((N, 1))
    for i in range(N):
        c[i] = 3 * (y[i + 1] - y[i]) / (h * h) - (b[i + 1] + 2 * b[i]) / h
        d[i] = (-2) * (y[i + 1] - y[i]) / (h * h * h) + (b[i + 1] + b[i]) / (h * h)

    # Construiesc polinomul cu valorile coeficietilor a, b, c si d
    def polinom(j):
        def spline(X):
            return a[j] + b[j] * (X - x[j]) + c[j] * (X - x[j]) ** 2 + d[j] * (X - x[j]) ** 3
        return spline


    # ---------- GRAFICUL --------
    # Calculez functia in nr_puncte(=100)
    nr_puncte = 100
    f4 = np.vectorize(f3)
    x_grafic = np.linspace(mrg_inf, mrg_sup, nr_puncte)
    y_grafic = f4(x_grafic)
    
    # Functie definita pe intervale(care indeplinesc o anumita conditie)
    
    y_aproximat = np.piecewise(
    x_grafic,
    [
        # conditii
        (x[i] <= x_grafic) & (x_grafic < x[i + 1])
        for i in range(N - 1)
    ],
    [
        # polinoamele
        polinom(i)
        for i in range(N)
    ]
    )
    
    # Plotez graficul cu punctele de interpolare
    plt.figure("Interpolare spline cubica")
    plt.plot(x_grafic, y_grafic, linestyle='--', label="Functia")
    plt.plot(x_grafic, y_aproximat, label="Interpolarea spline cubica")
    plt.scatter(x, y, label='Nodurile de interpolare')
    plt.legend()
    plt.show()

    # Calculez eroarea de trunchiere
    plot_eroare_trunchiere_ex_3(x_grafic, y_grafic, y_aproximat, mrg_inf, mrg_sup)

        

# ----------- Metoda pentru afisarea erorii de trunchiere
def plot_eroare_trunchiere_ex_3(x_grafic, y_grafic, y_aprox, mrg_inf, mrg_sup):

    eroare = np.abs(y_grafic - y_aprox)
    # determinam maximul erorii dintre cele calculate
    er_max = np.max(eroare)

    plt.figure("Eroarea de trunchiere")
    plt.plot(x_grafic, eroare)
    # afisez pe grafic valoarea 1e-5
    plt.hlines(1e-5, xmin = mrg_inf, xmax=mrg_sup, color="blue")
    # afisez pe grafic cea mai mare eroare pe care o am eu
    plt.hlines(er_max, label="Eroarea maxima din algoritmul meu", xmin = mrg_inf, xmax=mrg_sup, color="orange")
    plt.legend()
    plt.show()



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
            return sub_descendenta(U, sol_aux)
    else:
        return "Sistemul nu admite solutie unica."



def sub_ascendenta(U, b):

    # Algoritm pentru metoda substitutiei ascendente(elementele de deasupra diagonalei principale sunt egale cu 0)
    # dimensiunea matricei asociate sistemului(este patratica)
    n = U.shape[0]
    # initializam x(vectorul solutie) cu zero
    x = np.zeros(n)
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

     

# ----------------- END EXERCITIUL 3

# ------------------ APELURILE ------------------------
if __name__ == "__main__":

    # --------------------- EXERCITIUL 1 ----------------
    print("---------------- EXERCITIUL 1 ---------------------")
    exercitiul_unu()

    # --------------------- EXERCITIUL 2 ---------------
    print("--------------- EXERCITIUL 2 -----------------------")
    exercitiul_doi()

    # ---------------------- EXERCITIUL 3 ----------------
    print("--------------- EXERCITIUL 3 ------------------------")
    exercitiul_trei()
