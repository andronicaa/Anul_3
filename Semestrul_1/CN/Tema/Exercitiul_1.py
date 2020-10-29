import matplotlib.pyplot as plt
import numpy as np
import math


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


if __name__ == "__main__":
    # -------------------------------------------Exercitiul 1-------------------------------------------
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