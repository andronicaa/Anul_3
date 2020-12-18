import matplotlib.pyplot as plt
import numpy as np
import math

def g(x, a):
    rez = 0
    for i in range(len(a)):
        rez += (x**i) * a[i][0]

    return rez 

def f(x):
    return math.cos(2 * x) - 2 * math.sin(3 * x)


def calc_polinom(X, x, Y):
    suma = 0
    
    for i in range(len(X)):
        produs = 1
        for j in range(len(X)):
            if i != j:
                produs = produs * ((x - X[i]) / (X[j] - X[i]))
        suma = suma + produs * f(x)
    
    return suma

# graficul pentru metoda directa

# graficul pentru metoda lagrange de determinare a polinomului
def plot_function(f, a, b, X, Y):
    # plot-uim graficul
    # subdiviziuni
    v_func = np.linspace(a, b, 50)
    f2 = np.vectorize(f)
    plt.plot(v_func, f2(v_func), linestyle='-', linewidth=3)


    x_grafic_poli = np.zeros(50)
    for i in range(50):
        x_grafic_poli[i] = calc_polinom(X, v_func[i], Y)

    plt.plot(v_func, f2(v_func) - x_grafic_poli, linestyle='--', linewidth=3)

    plt.legend(['f(x)', 'polinom(x)'])  # Adauga legenda
    plt.axvline(0, c='black')  # Adauga axa OY
    plt.axhline(0, c='black')  # Adauga axa OX
    plt.xlabel('x')  # Label pentru axa OX
    plt.ylabel('y')  # Label pentru axa OY
    # Titlul figurii
    plt.title('Lagrange')
    plt.show()  # Arata graficul    

# graficul pentru determinarea graficului erorii de trunchiere
def plot_function(f, a, b, X, Y):
    # plot-uim graficul
    # subdiviziuni
    v_func = np.linspace(a, b, 50)
    f2 = np.vectorize(f)

    x_grafic_poli = np.zeros(50)
    for i in range(50):
        x_grafic_poli[i] = calc_polinom(X, v_func[i], Y)

    plt.plot(v_func, f2(v_func) - x_grafic_poli, linestyle='--', linewidth=3)

    plt.legend(['f(x)', 'polinom(x)'])  # Adauga legenda
    plt.axvline(0, c='black')  # Adauga axa OY
    plt.axhline(0, c='black')  # Adauga axa OX
    plt.xlabel('x')  # Label pentru axa OX
    plt.ylabel('y')  # Label pentru axa OY
    # Titlul figurii
    plt.title('Eroarea de trunchiere')

    plt.show()  # Arata graficul  


# --------------------------------functii pentru rezolvarea cu metoda directa
def gauss_pivotare_partiala(U):
    n = U.shape[0]
    for k in range(0, n-1):
        # sa adaug si cazul in care sistemul nu este compatibil => adica nu se gaseste un element nenul pe coloana respectiva
        # se alege primul element nenul de pe fiecare coloana
        # se interschimba
        p = np.argmax(abs(U[k:,k])) + k
        U[[k, p]] = U[[p, k]]
        # aux = np.array(U[k])
        # U[k] = np.array(U[p])
        # U[p] = np.array(aux)
        for l in range(k+1, n):
            U[l] = U[l] - (U[l][k] / U[k][k]) * U[k]
        
    # daca ultimul element de pe ultima linie si ultima coloana este zero => sistemul este incompatibil
    
    b = np.zeros((n, 1))
    for i in range(n):
        b[i] = U[i][n]
    U = np.delete(U, n, 1)
    # print(U)
    # print(b)
    # print(f"Pivotare partiala: {rezolvSistem(U, b)}")
    return rezolvSistem(U, b)


def rezolvSistem(U, b):
    n = U.shape[0]
    x = np.zeros((n, 1))
    
    L = np.identity(n)
    
    if abs(np.linalg.det(U)) > 1e-15: 
        for i in range(n-1, -1, -1):
            suma = 0
            for j in range(i+1, n):
                suma = suma + U[i][j] * x[j]
            suma = (b[i] - suma) / U[i][i]
            x[i] = suma

            
        return x


#  --------------------------------------------------------

# ---------------------metoda lagrange de determinare a polinomului

def metoda_lagrange(f, a, b):
    N = 15
    X = np.linspace(a, b, N+1)
    Y = np.zeros((N+1, 1))
    print(f"{X.shape[0]}")
    # il calculam pe y
    for i in range(len(X)):
        Y[i] = f(X[i])
    print(f"{Y.shape[0]}")
    # calculez L
    plot_function(f, a, b, X, Y)
                
    
#  -----------------------metoda directa
def interpolare(f, a, b):
    # plotam functia
    # plot_function(f, a, b)

    N = 15
    x = np.linspace(a, b, N+1)
    y = np.zeros((N+1, 1))

    for i in range(len(x)):
        y[i] = f(x[i])
    # print(f"numarul de coloane al lui y este {y.shape[0]}")
    
    # print('\n y: ', np.shape(y), '\n', y)
    # print(f"x este {x}")
    # print(f"y este {y}")

    # coloana 1 din matrice are doar 1
    A = np.vander(x, increasing = True)
    # print(A.shape[0])
    A = np.append(A, y, axis = 1)
    # print(A.shape[1])
    sol = gauss_pivotare_partiala(A)
    print("Solutiile sistemului sunt: ")
    print(sol)
    
    # adaugam polinoamele intr-un vector
    A = np.delete(A, N+1, 1)

    plot_function(f, a, b, x, sol)




if __name__ == "__main__":
    a = (-1) * math.pi
    b = math.pi
    # interpolare(f, a, b)
    metoda_lagrange(f, a, b)