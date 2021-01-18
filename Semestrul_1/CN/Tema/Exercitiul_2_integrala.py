import matplotlib.pyplot as plt
import numpy as np
import math

def f(x, sigma):
    return (1 / (sigma * math.sqrt(2 * np.pi))) * np.exp(((-1) * (x ** 2)) / (2 * (sigma ** 2)))

def integrare(f, x, metoda):
    sigma = 1.8
    n = len(x)
    y = np.zeros((n, 1))

    # calculam y
    for i in range(len(x)):
        y[i] = f(x[i], sigma)

    # calculam h-ul(echidistant)
    h = x[1] - x[0]
    if metoda == 'dreptunghi':
        I = 2 * h * np.sum(y[::2])
    elif metoda == 'trapez':
        I = (h / 2) * (y[0] + 2 * np.sum(y[1:-2]) + y[-1])
    elif metoda == 'simpson':
        I = (h / 3) * (y[0] + 4 * np.sum(y[1:-1:2]) + 2 * np.sum(y[2:-1:2]) + y[-1])

    return I


def aplica_metode(metoda):
    mrg_inf = -18
    mrg_sup = 18
    a = 3
    b = 20
    rez_integrala = []
    for N in range(a, b):
        x = np.linspace(mrg_inf, mrg_sup, N)
        I = integrare(f, x, metoda)
        rez_integrala.append(I)
    return rez_integrala


def plot_resp_metode():
    a = 3
    b = 20
    interval_ab = range(a, b, 1)
    plt.figure("Aproximarea integralei folosind formule de cuagratura sumate")
    plt.plot(interval_ab, aplica_metode('dreptunghi'), label="dreptunghi")
    plt.plot(interval_ab, aplica_metode('trapez'), label="trapez")
    plt.plot(interval_ab, aplica_metode('simpson'), label="simpson")
    plt.legend()
    plt.show()

# APELURILE
if __name__ == "__main__":
    plot_resp_metode()
    