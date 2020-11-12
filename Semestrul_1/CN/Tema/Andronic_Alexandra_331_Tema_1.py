import matplotlib.pyplot as plt
import numpy as np
import math



# Functia pentru afisarea graficelor 
def plot_function(a, b, f1, sol, plotTitle, f2 = None):
    # plot-uim graficul
    plt.figure(plotTitle)
    plt.xlabel('x') # axa Ox
    plt.ylabel('y') # axa Oy
    plt.axvline(0, c = 'black') # Adauga axa Oy
    plt.axhline(0, c = 'black') # Adauga axa Ox
    x = np.linspace(a, b, 70)
    yF1 = np.vectorize(f1)(x)
    plt.plot(x, yF1, 'r')
    # cazul in care avem 2 functii de adaugat de grafic 
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
    # Avem o functie f(x) = x^2 - a
    # functia pentru care trebuie sa calculam solutia (adica cea care ne da aproximarea radicalului unui numar)
    f = lambda x: x**2 - 11
    # derivata functiei data ca parametru
    df = lambda x: 2*x
    # epsilon -> eroarea pe care o permitem sa se faca in calculul solutiei(toleranta)
    eps = 1e-5
    # si x0
    # pentru x0 alegem o valoare astfel incat sa f(x0) * f''(x0) >= 0 (am ales o valoare cat mai apropiata de solutia ecuatiei)
    x0 = 3.4
    result = newton_method(f, df, x0, eps)
    print(f"Una din solutii este {result[0]} dupa {result[1]} iteratii.")



def newton_method(f, df, x0, eps):
    # Numarul de iteratii dupa care se opreste algoritmul
    iteratii = 0
    # Voi afla solutia curenta in functie de solutia precedenta (x_prec) si raportul dintre functia in acel punct si derivata
    # Initial avem o solutie "ghicita" aleasa in functie de niste criterii: f(x0) * f''(x0) > 0
    # Avand in vedere ca x0(sau la fiecare iteratie-x_prec- este "aproape" solutie) => Incercam sa gasim o solutie mai buna prin trasarea unei tangente la x0 si intersectia acesteia cu axa Ox, unde vom gasi din nou un punct ce va reprezenta o posibile solutie. Continuam acest calcul pana conditia nu va mai fi respectata
    x_prec = x0 - f(x0) / df(x0) 
    x_curr = x_prec - f(x_prec) / df(x_prec)
    # Cautam solutia atat timp cat conditia de oprire nu este indeplinita
    while abs(x_curr - x_prec) / abs(x_prec) >= eps:
        # creste numarul de iteratii in care se afla solutia ecuatiei
        iteratii = iteratii + 1
        # solutia precedenta va lua valoarea solutiei curente pentru a putea continua calculul
        x_prec = x_curr
        # aflam solutia curenta aproximata prin intersectia tangentei cu axa Ox
        x_curr = x_curr - f(x_prec) / df(x_prec)
    
    
    return x_curr, iteratii


# ----------------- Exercitiul 2-----------------------
def call_bisection_method():
    # Functiile din ipoteza
    fLeft = lambda x : math.e ** (x - 2)
    fRight = lambda x: math.cos(math.e ** (x - 2)) + 1
    # Trecem functia din dreapta in stanga si aflam solutia pentru functia noua rezultata => parametru pentru metoda bisectiei
    f = lambda x: math.e ** (x - 2) - math.cos(math.e ** (x - 2)) - 1
    # Alegem un interval astfel incat f(a) * f(b) < 0, acest interval asigura unicitatea solutiei
    # f(a) = -0.99709
    # f(b) = 1.44236
    a = 1.7
    b = 2.7
    eps = 1e-5
    sol = []
    # Calculam N - numarul de iteratii dupa care trebuie sa se opreasca algoritmul
    N = math.floor(math.log((b - a) / eps, 2) - 1)
    result = bisection_method(a, b, N, f)
    sol.append(result)
    print(f"Solutia obtinuta este {result} dupa {N} iteratii")
    # Plot-uim graficul
    plot_function(-1, 4, fLeft, sol, "Graficul pentru intersectia celor doua functii", fRight)
    # Am ales sa folosesc metoda bisectiei deoarece aceasta nu necesita calcularea derivatei


def bisection_method(a, b, N, f):
    # Se primesc capetele de interval: a si b
    # N -> dupa cate repetari trebuie sa se opreasca algoritmul - precizia
    # f -> functia pentru care se cere determinarea solutiei pe ub subinterval [a, b]
    # Mai intai verificam daca se poate aplica aceasta metoda, respectiv daca exista solutie in acest interval

    if f(a) * f(b) >= 0:
        print("Nu se poate aplica metoda bisectiei deoarece f(a) * f(b) >= 0")
        return None
    # determinam sirurile ak(k >= 0), bk(k >= 0)
    ak = a
    bk = b
    for i in range(0, N):
        # calculam mijlocul intervalului
        xk = (ak + bk) / 2
        # daca solutia se afla intre ak si xk => restrangem intervalul(adica solutia se afla intre capetele a si xk)
        if f(ak) * f(xk) < 0:
            ak = ak
            bk = xk
        # daca solutia se afla intre xk si bk => restrangem intervalul(adica solutia se afla intre capetele xk si b)
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
    # Valorile lui a si b vor fi alese ca perechi de pe aceeasi pozitie din vectorii a respectiv b
    # Acestea sunt alese astfel incat f(a) * f(b) < 0, iar in intervalele unde capatul este deja solutie se face verificare in functie si se returneaza capatul de interval care este solutie
    a = [-5.0, -4.5, -3.4]
    b = [-4.9, -3.5, -2.9]
    f = lambda x: x ** 3 + 12 * x ** 2 + 47 * x + 60
    # toleranta
    eps = 1e-5
    # vectorul cu solutii
    sol = []
    # Numarul de iteratii pentru aflarea fiecarei solutii
    Nr_iteratii = []
    # Apelam functia pentru fiecare subinterval
    for i in range(3):
        result = false_position_method(a[i], b[i], f, eps)
        sol.append(result[0])
        Nr_iteratii.append(result[1])

    for i in range(3):
        print(f"Pentru al {i+1}-lea subinterval s-a gasit solutia {sol[i]} dupa {Nr_iteratii[i]} iteratii")

    # Afisam graficul cu solutiile aflate cu metoda pozitiei false
    plot_function(-5, 5, f, sol, "Grafic ex3.b")


def false_position_method(a, b, f, eps):
    # Numarul de iteratii
    N = 0
    # Ne definim doua siruri ak si bk ca la metoda bisectiei
    a_k = a
    b_k = b
    # Calculam solutia initiala
    x_prec = (a_k * f(b_k) - b_k * f(a_k)) / (f(b_k) - f(a_k))
    # La fiecare iteratie se calculeaza intersectia dintre dreapta determinata de capetele intervalului A(a_k, f(a_k)), B(b_k, f(b_k)) si axa Ox(acest punct este x_aprox)
    while True:
        N = N + 1
        # Verificam daca unul din capete este solutie
        if f(x_prec) == 0:
            x_aprox = x_prec
            break
        if f(a_k) == 0:
            return [a_k, N]
        if f(b_k) == 0:
            return [b_k, N]
        # Daca solutia se afla in intervalul [a_k, x_prec] => restrangem intervalul cu capetele in [a_k, (b_k = x_prev)]
        elif f(a_k) * f(x_prec) < 0:
            a_k = a_k
            b_k = x_prec
            x_aprox = (a_k * f(b_k) - b_k * f(a_k)) / (f(b_k) - f(a_k))
        # Daca solutia se afla in intervalul [b_k, x_prec] -> restrangem intervalul cu capetele in [(a_k = x_prec), b_k]
        elif f(a_k) * f(x_prec) > 0:
            a_k = x_prec
            b_k = b_k
            x_aprox = (a_k * f(b_k) - b_k * f(a_k)) / (f(b_k) - f(a_k))

        # Conditie de oprire
        # Daca eroarea relativa este mai mica decat eps(o toleranta definita de noi), inseamna ca am ajuns la o solutie aproximativa ce indeplineste conditiile 
        if abs(x_aprox - x_prec) / abs(x_prec) < eps:
            break
        x_prec = x_aprox
    
    # Returnez un vector ce contine solutia determinata si numarul de iteratii in care s-a aflat solutia aproximativa
    return [x_aprox, N]


# ----------------- Exercitiul 4-----------------------
def call_secant_method():

    # Functia data ca parametru
    f1 = lambda x: x ** 3 - 3 * x ** 2 + 2 * x
    # O solutie este 0 => trebuie sa dam factor comun un x pentru a putea aplica algoritmul(altfel ar fi la un moment dat impartire la 0)
    f = lambda x: x ** 2 - 3 * x + 2
    # In urma aflarii solutiilor functiei f si  derivatei(am aflat subintervalele de monotonie si cele pe care solutia este unica)
    a = [0.5, 1.6] # f(0.5) > 0, f(1.6) < 0
    b = [1.5, 2.5] # f(1,5) < 0, f(2.5) > 0 
    # Am ales x0 si x1 intre intervalele corespunzatoare fiecarei perechi din vectorii a si b
    x0 = [0.95, 2.1]
    x1 = [0.90, 2.2]
    eps = 1e-5
    sol = []
    Nr_iteratii = []
    # 0 este solutie, o adaugam la vectorul de solutii
    sol.append(0.)
    Nr_iteratii.append(1)
    for i in range(2):
        result = secant_method(f, a[i], b[i], x0[i], x1[i], eps)
        sol.append(result[0])
        Nr_iteratii.append(result[1])
    for i in range(len(sol)):
        print(f"Pentru al {i+1}-lea subinterval s-a gasit solutia {sol[i]} dupa {Nr_iteratii[i]} iteratii")

    # Afisam graficul functiei
    plot_function(-3, 3, f1, sol, "Grafic ex4.b")


def secant_method(f, a, b, x0, x1, eps):
    # numarul de iteratii 
    N = 1
    x_aprox = x1
    x_prec = x0
    # La pasul curent aproximarea solutiei se face intersectand dreapta determinata de capatul intervalului corespunzator lui a la pasul precedent(k-1) si capatul corespunzator lui b la pasul k-2 cu axa Ox. Astfel nu mai este nevoie de derivata ca la metoda lui Newton deoarece nu se mai intersecteaza tangenta la grafic intr-un punct x0 cu asa Ox
    while abs(x_aprox - x_prec) / abs(x_prec) >= eps:

        N = N + 1
        x_aux = (x_prec * f(x_aprox) - x_aprox * f(x_prec)) / (f(x_aprox) - f(x_prec))
        x_prec = x_aprox
        x_aprox = x_aux
        # Daca solutia aproximata la pasul curent iese din interval oprim algoritmul
        # Valorile date pentru x1 si x0 nu au fost alese corespunzator
        if x_aprox < a or x_aprox > b:
            print(f"Introduceti alte valori pentru x0 si x1 pentru {a} si {b}")
            break
        
        
        
    return [x_aprox, N]





if __name__ == "__main__":
    print("EXERCITIUL 1")
    call_newton_method()

    print()
    print("EXERCITIUL 2")
    call_bisection_method()

    print()
    print("EXERCITIUL 3: ")
    call_false_position_method()

    print()
    print("EXERCITIUL 4")
    call_secant_method()
    

    
    
