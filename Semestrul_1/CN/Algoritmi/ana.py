import numpy as np
import matplotlib.pyplot as plt



def f(x):
    return (-1) * math.sin((-4) * x) - 5 * math.cos(4 * x) - 23.55 * x


def subsAsc(A, b):
    n = A.shape[0]
    x = np.empty(n)
    if abs(np.linalg.det(A)) > 1e-15:
        x[0] = b[0] / A[0][0]
        for k in range( 1, n):
            sum = np.sum(np.multiply(A[k][:k], x[:k]))
            x[k] = (b[k] - sum) / A[k][k]
        return x

def chebyshev(i, a, b, N):
    return (a + b) / 2 + (b - a) / 2 * np.cos(np.pi * (N - i) / N)

def evaluare(f, x, coef, N, val):
    s = coef[0]
    for i in range(1, N + 1):
        p = coef[i]
        for j in range(i):
            p = p * (val - x[j])
        s += p
    
    return s

def newton(N, a, b, f):
    X = np.array([chebyshev(i,a,b,N) for i in range(N + 1)])
    Y = f(X)

    # construim matricea A
    A = np.zeros((N + 1, N + 1))
    A[:,0] = 1
    for i in range(1, N + 1):
        p = 1
        for j in range(i):
            p = p * (X[i] - X[j])
            A[i][j + 1] = p
    
    coeficienti = subsAsc(A, Y)

    xGrafic = np.linspace(a, b, 200)
    yGrafic = f(xGrafic)
    yPolinom = [evaluare(f,X,coeficienti,N,val) for val in xGrafic]

    erori, maxim = eroareMaxima(yGrafic, yPolinom)
    if maxim <= 1e-5:
        return N, coeficienti, X, erori, maxim, xGrafic

    return -1, None, None, None, None, None
    

def eroareMaxima(y, yAprox):
    erori = np.abs(y - yAprox)
    maxim = np.max(erori)

    return erori, maxim

def main():
    f = lambda x: 3 * np.sin(-x) + 3 * np.cos(-4 * x) - 2.45 * x
    a = - np.pi
    b = np.pi

    # # Grafic
    # fig = plt.figure("Grafic")
    # X = np.linspace(a,b,50)
    # Y = f(X)
    # plt.plot(X, Y)
    # plt.show()

    N = 0
    while True:
        N += 1
        ret, coeficienti, x, erori, maxim, vals = newton(N, a, b, f)
        if ret != -1:
            print(f"Numar pasi:{N}")
            print(f"Coeficienti polinom: {coeficienti}")
            print(f"Noduri de interpolare: {x}")
            xGrafic = np.linspace(a,b,200)
            yGrafic = f(xGrafic)
            yPolinom = [evaluare(f,x,coeficienti,N,val) for val in xGrafic]

            # Grafic cu functia, polinomul si nodurile de interpolare
            plt.figure("Aproximare numerica")
            plt.plot(xGrafic, yGrafic, label = "Functie originala")
            plt.plot(xGrafic, yPolinom, linestyle = "--", label = "Polinom de interpolare")

            plt.scatter(x, f(x), marker=".") # noduri de interpolare
            plt.legend()
            plt.show()

            # Grafic cu eroarea de trunchiere
            plt.figure("Eroare interpolare cu polinoame Lagrange")
            plt.plot(vals, erori, label = "Erori obtinute")
            plt.hlines(1e-5, xmin = a, xmax = b, color = 'red', label = "1e-5")
            plt.hlines(maxim, xmin = a, xmax = b, color = 'green', label = "Eroare maxima")
            plt.legend()
            plt.show()

            return


if __name__ == "__main__":
    main()
