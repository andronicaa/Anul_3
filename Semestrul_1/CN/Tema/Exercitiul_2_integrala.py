import matplotlib.pyplot as plt
import numpy as np
import math

def f(x, sigma):
    return (1 / (sigma * np.sqrt(2 * np.pi))) * np.exp(((-1) * (x ** 2)) / (2 * (sigma ** 2)))



def integrare(f, x, metoda):
    sigma = 1.9
    n = len(x)
    y = np.zeros((n, 1))
    # print(np.shape(y))
    # calculam y
    for i in range(len(x)):
        y[i] = f(x[i], sigma)


    if metoda == 'dreptunghi':
        m = (int)((n - 1) / 2)
        h = (x[2 * m] - x[0]) / (2 * m)
        sum = 0
        for k in range(m):
            sum = sum + y[2 * k + 1]
        I = 2 * h * sum

    elif metoda == 'trapez':
        m = n - 1
        h = (x[m] - x[0]) / m
        sum = 0
        for k in range(1, m):
            sum = sum + y[k]
        I = (h / 2) * (y[0] + 2 * sum + y[m])
    elif metoda == 'simpson':
        m = (int)((n - 1) / 2)
        h = (x[2 * m] - x[0]) / (2 * m)
        sum_par = 0
        sum_impar = 0
        for k in range(m):
            sum_par = sum_par + y[2 * k + 1]
        for k in range(1, m):
            sum_impar = sum_impar + y[2 * k]
        
        I = (h / 3) * (y[0] + 4 * sum_par + 2 * sum_impar + y[2 * m])
        
        

    return I


def aplica_metode(metoda):
    mrg_inf = -19
    mrg_sup = 19
    a = 5
    b = 15
    rez_integrala = []
    for N in range(a, b, 1):
        x = np.linspace(mrg_inf, mrg_sup, N)
        I = integrare(f, x, metoda)
        rez_integrala.append(I)
    return rez_integrala


def plot_resp_metode():
    a = 5
    b = 15
    interval_ab = range(a, b, 1)
    plt.figure("Aproximarea integralei folosind formule de cuadratura sumate")
    plt.plot(interval_ab, aplica_metode('dreptunghi'), label="dreptunghi")
    plt.plot(interval_ab, aplica_metode('trapez'), label="trapez")
    plt.plot(interval_ab, aplica_metode('simpson'), label="simpson")
    plt.legend()
    plt.show()

# APELURILE
if __name__ == "__main__":
    plot_resp_metode()
    