import matplotlib.pyplot as plt
import numpy as np
import math

def f(x):
    return (-1) * math.sin((-4) * x) - 5 * math.cos(4 * x) - 23.55 * x


def plot_function():
    a = (-1) * math.pi
    b = math.pi
    nr_puncte = 100
    f2 = np.vectorize(f)
    x_grafic = np.linspace(a, b, nr_puncte)
    y_grafic = f2(x_grafic)
    plt.figure("Interpolare cu polinoame Lagrange: Metoda Newton")
    plt.plot(x_grafic, y_grafic, label="Functia originala")
    plt.show()

if __name__ == "__main__":

    plot_function()