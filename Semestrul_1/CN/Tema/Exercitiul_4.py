import matplotlib.pyplot as plt
import numpy as np
import math

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
    plt.figure("Graficul pentru functia de la ex4.b")
    plt.xlabel('x') # Label pentru axa OX
    plt.ylabel('y') # Label pentru axa OY
    plt.axvline(0, c = 'black') # Adauga axa OY
    plt.axhline(0, c = 'black') # Adauga axa OX
    x = np.linspace(-3, 3, 70)
    yLeft = np.vectorize(f1)(x)
    plt.plot(x, yLeft, 'r')
    for i in range(len(sol)):
        plt.scatter(sol[i], f1(sol[i]), s = 50, c = 'black', marker = 'o') # adauga solutia pe grafic
    plt.show()
