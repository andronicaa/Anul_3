import matplotlib.pyplot as plt
import numpy as np
import math


def call_bisection_method(a, b):
    
    # functia pentru care vrem sa aflam solutiile
    f = lambda x: x ** 3 - 4 * x + 1
    # Alegem un interval astfel incat f(a) * f(b) < 0, acest interval asigura unicitatea solutiei
    eps = 1e-5
    sol = []
    # Calculam N - numarul de iteratii dupa care trebuie sa se opreasca algoritmul
    N = math.floor(math.log((b - a) / eps, 2) - 1)
    result = bisection_method(a, b, N, f, eps)
    sol.append(result)
    print(f"Solutia obtinuta este {result} dupa {N} iteratii")
    


def bisection_method(a, b, N, f, eps):
    # Se primesc capetele de interval: a si b
    # N -> dupa cate repetari trebuie sa se opreasca algoritmul - precizia
    # f -> functia pentru care se cere determinarea solutiei pe un subinterval [a, b]
    # Mai intai verificam daca se poate aplica aceasta metoda, respectiv daca exista solutie in acest interval

    if f(a) * f(b) >= 0:
        print("Nu se poate aplica metoda bisectiei deoarece f(a) * f(b) >= 0")
        return None
    # determinam sirurile ak(k >= 0), bk(k >= 0)
    ak = a
    bk = b
    xk_prev = (ak + bk) / 2
    xk = (ak + bk) / 2
    for i in range(0, N):
        # calculam mijlocul intervalului
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
        # afisam eroarea relativa
        xk_prev = xk
        xk = (ak + bk) / 2
        er_rel = abs(xk - xk_prev) / abs(xk_prev + eps)
        print(f"Eroarea relativa e = {er_rel}")
    return (ak + bk) / 2

if __name__ == "__main__":
    
    call_bisection_method(-5, -1)
    call_bisection_method(-1, 1)
    call_bisection_method(1, 5)