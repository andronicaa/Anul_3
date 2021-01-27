import numpy as np
import matplotlib.pyplot as plt

# functia pentru care vrem sa interpolam liniar
def f(x):
    return x ** 2

def interpolare_spline_liniara(mrg_inf, mrg_sup, N):
    # impart x-ul in subintervale
    x = np.linspace(mrg_inf, mrg_sup, N + 1)
    y = f(x)
    

    def constr_polinom(i):
        a = y[i]
        b = (y[i + 1] - y[i]) / (x[i + 1] - x[i])  
        def spline(X):
            return a + b * (X - x[i])
        return spline


    print(f"x = {x}")
    print(f"y = {y}")
    x_grafic = np.linspace(mrg_inf, mrg_sup, 100)
    f1 = np.vectorize(f)
    y_grafic = f1(x_grafic)
    y_aprox = np.piecewise(
        x_grafic,
        [
            (x[i] <= x_grafic) & (x_grafic < x[i + 1])
            for i in range(N - 1)
        ],
        [
            constr_polinom(i)
            for i in range(N)
        ]
    )
    plt.plot(x_grafic, y_grafic, linestyle='--', label="Functia")
    plt.plot(x_grafic, y_aprox, label="Interpolarea spline cubica")
    plt.scatter(x, y, label='Nodurile de interpolare')
    plt.legend()
    plt.show()





if __name__ == "__main__":
    interpolare_spline_liniara(-np.pi, np.pi, 4)
    

