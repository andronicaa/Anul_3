import matplotlib.pyplot as plt
import numpy as np
import math


def call_newton_method():
    # Notam valoarea pentru care vrem sa gasim radicalul cu a
    # sqrt(a) = x (x este rezultatul calculului -> solutia problemei pe care dorim sa o aflam)
    # Daca ridicam la patrat => a = x^2
    # Daca trecem termenul in dreapta => x^2 - a = 0 => avem o ecuatie pentru care dorim sa aflam solutia
    # Avem o functie f(x) = x^2 - a
    # functia pentru care trebuie sa calculam solutia (adica cea care ne da aproximarea radicalului unui numar)
    f = lambda x: x**2 + 2 * x - 1
    # derivata functiei data ca parametru
    df = lambda x: 2*x + 2
    # epsilon -> eroarea pe care o permitem sa se faca in calculul solutiei(toleranta)
    eps = 1e-5
    # si x0
    # pentru x0 alegem o valoare astfel incat sa f(x0) * f''(x0) >= 0 (am ales o valoare cat mai apropiata de solutia ecuatiei)
    x0 = -2
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
        er_rel = abs(x_curr - x_prec) / abs(x_prec)
        print(f"Eroarea relativa e = {er_rel}")
    
    
    return x_curr, iteratii


if __name__ == "__main__":
    call_newton_method()