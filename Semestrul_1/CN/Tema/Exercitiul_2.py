import matplotlib.pyplot as plt
import numpy as np
import math


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


def plot_two_function(a, b, f1, f2, sol):
    # plot
    plt.figure("Graficul pentru intersectia celor 2 functii")
    plt.xlabel('x') # Label pentru axa OX
    plt.ylabel('y') # Label pentru axa OY
    plt.axvline(0, c='black') # Adauga axa OY
    plt.axhline(0, c='black') # Adauga axa OX
    x = np.linspace(a, b, 70)
    yLeft = np.vectorize(f1)(x)
    yRight = np.vectorize(f2)(x)
    plt.plot(x, yLeft, 'r')
    plt.plot(x, yRight, 'b')
    # adaug punctul de intersectie pentru cele doua grafice
    plt.scatter(sol, f1(sol), s = 50, c = 'black', marker = 'o')
    plt.show()


if __name__ == "__main__":

    # --- parametrii pentru metoda bisectiei
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
    # calculam N - numarul de iteratii dupa care trebuie sa se opreasca algoritmul
    N = math.floor(math.log((b - a) / eps, 2) - 1)
    result = bisection_method(a, b, N, f)
    print("Solutia de la exercitiul 2: ", result)
    # plot-uim graficul
    plot_two_function(-1, 4, f1, f2, result)
    # Am ales sa folosesc metoda bisectiei deoarece aceasta nu necesita calcularea derivatei
    