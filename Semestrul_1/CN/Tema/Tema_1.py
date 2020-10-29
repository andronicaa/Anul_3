import matplotlib.pyplot as plt
import numpy as np
import math



# plot function
def plot_function(a, b, f1, sol, plotTitle, f2 = None):
    # plot-uim graficul
    plt.figure(plotTitle)
    plt.xlabel('x') # Label pentru axa OX
    plt.ylabel('y') # Label pentru axa OY
    plt.axvline(0, c = 'black') # Adauga axa OY
    plt.axhline(0, c = 'black') # Adauga axa OX
    x = np.linspace(a, b, 70)
    yF1 = np.vectorize(f1)(x)
    plt.plot(x, yF1, 'r')
    if f2:
        yF2 = np.vectorize(f2)(x)
        plt.plot(x, yF2, 'b')
    # adaug solutiile functiei
    for i in range(len(sol)):
        plt.scatter(sol[i], f1(sol[i]), s = 50, c = 'black', marker = 'o')
    plt.show()




# ----------------- Exercitiul 1-----------------------
def call_newton_method():
    # Notam valoarea pentru care vrem sa gasim radicalul cu a
    # sqrt(a) = x (x este rezultatul calculului -> solutia problemei pe care dorim sa o aflam)
    # Daca ridicam la patrat => a = x^2
    # Daca trecem termenul in dreapta => x^2 - a = 0 => avem o ecuatie pentru care dorim sa aflam solutia
    # Avem o functie f(x) = x^2 - a (este unul din parametri)
    # functia pentru care trebuie sa calculam solutia
    f = lambda x: x**2 - 11
    # derivata functiei data ca parametru
    df = lambda x: 2*x
    # epsilon -> eroarea pe care o permitem sa se faca in calculul solutiei
    eps = 1e-5
    # si x0
    # pentru x0 alegem o valoare astfel incat sa f(x0) * f'(x0) >= 0 (am ales o valoare cat mai apropiata de solutia ecuatiei)
    x0 = 3.4
    result = newton_method(f, df, x0, eps)
    print(f"Solutia pentru exercitiul 1 este {result[0]} dupa {result[1]} iteratii.")



def newton_method(f, df, x0, eps):
    # numarul de ietratii dupa care se opreste algoritmul
    iteratii = 0
    x_prec = x0 - f(x0) / df(x0) 
    x_curr = x_prec - f(x_prec) / df(x_prec)
    # Cautam solutia atat timp cat conditie de oprire nu este indeplinita
    while abs(x_curr - x_prec) / abs(x_prec) >= eps:
        iteratii = iteratii + 1
        x_prec = x_curr
        x_curr = x_curr - f(x_prec) / df(x_prec)
    
    
    return x_curr, iteratii


# ----------------- Exercitiul 2-----------------------
def call_bisection_method():
    #  parametrii pentru metoda bisectiei
    f1 = lambda x : math.e ** (x - 2)
    f2 = lambda x: math.cos(math.e ** (x - 2)) + 1
    # trecem functia din dreapta in stanga si aflam solutia pentru functia noua rezultata
    f = lambda x: math.e ** (x - 2) - math.cos(math.e ** (x - 2)) - 1
    # alegem un interval astfel incat f(a) * f(b) < 0
    # f(a) = -0.99709
    # f(b) = 1.44236
    a = 1.7
    b = 2.7
    eps = 1e-5
    sol = []
    # calculam N - numarul de iteratii dupa care trebuie sa se opreasca algoritmul
    N = math.floor(math.log((b - a) / eps, 2) - 1)
    result = bisection_method(a, b, N, f)
    sol.append(result)
    print("Solutia de la exercitiul 2: ", result)
    # plot-uim graficul
    plot_function(-1, 4, f1, sol, "Graficul pentru intersectia celor doua functii", f2)
    # Am ales sa folosesc metoda bisectiei deoarece aceasta nu necesita calcularea derivatei


def bisection_method(a, b, N, f):
    # se primesc ca parametri capetele de interval: a si b
    # N -> dupa cate repetari trebuie sa se opreasca algoritmul - precizia
    # f -> functia pentru care se cere determinarea solutiilor
    # mai intai verificam daca se poate aplica aceasta metoda, respectiv daca exista solutie in acest interval

    if f(a) * f(b) >= 0:
        print("Nu se poate aplica metoda bisectiei deoarece f(a) * f(b) >= 0")
        return None
    # determinam sirurile ak(k >= 0), bk(k >= 0)
    ak = a
    bk = b
    for i in range(0, N):
        # calculam mijlocul intervalului
        xk = (ak + bk) / 2
        # daca solutia se afla intre ak si xk => restrangem intervalul
        if f(ak) * f(xk) < 0:
            ak = ak
            bk = xk
        # daca solutia se afla intre xk si bk => restrangem intervalul
        elif f(bk) * f(xk) < 0:
            ak = xk
            bk = bk
        elif f(xk) == 0:
            print("Am gasit solutia exacta: ")
            return xk
        else:
            print("Nu s-a gasit nicio solutie")
            return None
    return (ak + bk) / 2


# ----------------- Exercitiul 3-----------------------
def call_false_position_method():
    # valorile lui a si b vor fi alese ca perechi de pe aceeasi pozitie din vectorii a respectiv b
    # acestea sunt alese astfel incat f(a) * f(b) < 0, iar in intervalele unde capatul este deja solutie se face verificare 
    # in functie si se returneaza capatul de interval care este solutie
    a = [-5.0, -4.5, -3.4]
    b = [-4.9, -3.5, -2.4]
    f = lambda x: x ** 3 + 12 * x ** 2 + 47 * x + 60
    eps = 1e-5
    # vectorul cu cele 3 solutii
    sol = []
    # numarul de iteratii
    Nr_iteratii = []
    # apelam functia pentru fiecare subinterval
    for i in range(3):
        result = false_position_method(a[i], b[i], f, eps)
        sol.append(result[0])
        Nr_iteratii.append(result[1])

    for i in range(3):
        print(f"Pentru al {i+1}-lea subinterval s-a gasit solutia {sol[i]} dupa {Nr_iteratii[i]} iteratii")

    # plot
    plot_function(-5, 5, f, sol, "Grafic ex3.b")


def false_position_method(a, b, f, eps):
    # numarul de iteratii
    N = 0
    # ne definim doua siruri ak si bk ca la metoda bisectiei
    a_k = a
    b_k = b
    # calculam solutia initiala
    x_prev = (a_k * f(b_k) - b_k * f(a_k)) / (f(b_k) - f(a_k))
    while True:
        N = N + 1
        if f(x_prev) == 0:
            x_curr = x_prev
            break
        # verificam daca unul din capete este solutie
        # se aplica acelasi principiu ca la metoda bisectiei
        if f(a_k) == 0:
            return [a_k, N]
        if f(b_k) == 0:
            return [b_k, N]
        elif f(a_k) * f(x_prev) < 0:
            a_k = a_k
            b_k = x_prev
            x_curr = (a_k * f(b_k) - b_k * f(a_k)) / (f(b_k) - f(a_k))
        elif f(a_k) * f(x_prev) > 0:
            a_k = x_prev
            b_k = b_k
            x_curr = (a_k * f(b_k) - b_k * f(a_k)) / (f(b_k) - f(a_k))
        # conditie de oprire
        if abs(x_curr - x_prev) / abs(x_prev) < eps:
            break
        x_prev = x_curr
    
    # returnez un vector ce contine solutia determinata si numarul de iteratii care au respectat conditia data
    return [x_curr, N]


# ----------------- Exercitiul 4-----------------------
def call_secant_method():
    a = [0.5, 1.6]
    b = [1.5, 2.5]
    x0 = [0.95, 2.1]
    x1 = [0.90, 2.2]
    eps = 1e-5
    # functia data ca parametru
    f1 = lambda x: x ** 3 - 3 * x ** 2 + 2 * x
    # o solutie este 0 => trebuie sa dam factor comun un x pentru a putea aplica algoritmul(altfel ar fi la un moment dat impartire la 0)
    f = lambda x: x ** 2 - 3 * x + 2
    sol = []
    sol.append(.0)
    for i in range(2):
        result = secant_method(f, a[i], b[i], x0[i], x1[i], eps)
        sol.append(result)
    for i in range(len(sol)):
        print(f"A {i+1} - a solutie este {sol[i]}")

    # graficul functiei
    plot_function(-3, 3, f, sol, "Grafic ex4.b")


def secant_method(f, a, b, x0, x1, eps):
    # numarul de iteratii 
    k = 1
    x_curr = x1
    x_prev = x0
    while abs(x_curr - x_prev) / abs(x_prev) >= eps:

        k = k + 1
        x_aux = (x_prev * f(x_curr) - x_curr * f(x_prev)) / (f(x_curr) - f(x_prev))
        x_prev = x_curr
        x_curr = x_aux
        if x_curr < a or x_curr > b:
            print(f"Introduceti alte valori pentru x0 si x1 pentru {a} si {b}")
            break
        
        
        
    return x_curr





if __name__ == "__main__":
    # Solutia pentru exercitiul 1 este
    call_newton_method()

    # Solutia pentru exercitiul 2 este
    call_bisection_method()

    # Solutia pentru exercitiul 3 este
    print("Solutiile pentru exercitiul 3 sunt: ")
    call_false_position_method()

    # Solutia pentru exercitiul 4 este
    call_secant_method()
    

    
    
