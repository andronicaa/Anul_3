import matplotlib.pyplot as plt
import numpy as np
import math

def false_position_method(a, b, f, exp):
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

def plot_one_function(a, b, f1, sol):
    # plot
    plt.figure("Graficul pentru functia de la ex3.b")
    plt.xlabel('x') # Label pentru axa OX
    plt.ylabel('y') # Label pentru axa OY
    plt.axvline(0, c = 'black') # Adauga axa OY
    plt.axhline(0, c = 'black') # Adauga axa OX
    x = np.linspace(-5, 5, 70)
    yF1 = np.vectorize(f1)(x)
    plt.plot(x, yF1, 'r')
    for i in range(len(sol)):
        plt.scatter(sol[i], f1(sol[i]), s = 50, c = 'black', marker = 'o') # adauga solutia pe grafic
    plt.show()

if __name__ == "__main__":
    # valorile lui a si b vor fi alese ca perechi de pe aceeasi pozitie din vectorii a respectiv b
    # acestea sunt alese astfel incat f(a) * f(b) < 0, iar in intervalele unde capatul este deja solutie se face verificare in functie si se returneaza capatul de interval care este solutie
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
    plot_one_function(-5, 5, f, sol)