import matplotlib.pyplot as plt
import numpy as np
import math


def calc_polinom_S(A, B, X, x):
    S = 0
    for j in range(len(A)-1):
        if x >= X[j] and x <= X[j+1]:
            S = S + A[j] + B[j] * (x - X[j])
    return S

# graficul pentru determinarea graficului erorii de trunchiere
def plot_function(A, B, X, a, b, f):
    # plot-uim graficul
    # subdiviziuni
    v_func = np.linspace(a, b, 50)
    f2 = np.vectorize(f)
    plt.plot(v_func, f2(v_func), linestyle='-', linewidth=3)

    # x_grafic = np.linspace(a, b, 50)
    # x_grafic_poli = np.zeros(50)
    # for i in range(50):
    #     x_grafic_poli[i] = calc_polinom_S(A, B, X, v_func[i])

    # plt.plot(v_func, calc_polinom_S(A, B, X, v_func), linestyle='--', linewidth=3)

    plt.legend(['f(x)', 'polinom(x)'])  # Adauga legenda
    plt.axvline(0, c='black')  # Adauga axa OY
    plt.axhline(0, c='black')  # Adauga axa OX
    plt.xlabel('x')  # Label pentru axa OX
    plt.ylabel('y')  # Label pentru axa OY
    # Titlul figurii
    plt.title('Metoda lagrange')

    plt.show()  # Arata graficul  



def interpolare_liniara(X, Y, N, a, b):
    # calculam coeficientii
    A = np.zeros((N, 1))
    B = np.zeros((N, 1))
    for j in range(len(Y) - 1):
        A[j] = Y[j]
        B[j] = (Y[j+1] - Y[j]) / (Y[j+1] - X[j])
    
    plot_function(A, B, X, a, b, f)
        



def f(x):
    return math.cos(2 * x) - 2 * math.sin(3 * x)

if __name__ == "__main__":
    N = 15
    a = (-1) * math.pi
    b = math.pi
    X = np.linspace(a, b, N+1)
    Y = np.zeros((N+1, 1))
    print(f"{X.shape[0]}")
    # il calculam pe y
    for i in range(len(X)):
        Y[i] = f(X[i])
    

    interpolare_liniara(X, Y, N, a, b)
