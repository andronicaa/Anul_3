import matplotlib.pyplot as plt
import numpy as np
import math

# functia pentru care vrem sa aproximam a doua derivata
def f(x):
    return math.cos(-0.5 * x)

# a doua derivata a functiei
def sdf(x):
    return (-0.25) * math.cos(0.5 * x)



def aproximeaza_derivata():
    # DIFERENTE FINITE CENTRALE PENTRU CALCULUL f''(x)
    N = 1
    a = -np.pi / 2
    b = np.pi
    while True:
        print(f"Pentru N = {N} nu se respecta conditia pentru eroarea de trunchiere")
        N = N + 1
        x = np.linspace(a, b, N + 1)

        # calculam y
        y = np.zeros((N + 1, 1))
        for i in range(len(x)):
            y[i] = f(x[i])

        # folosim diviziune echidistanta
        h = x[1] - x[0]

        # calculam derivata, dar fara capete
        sec_der = np.zeros(len(x) - 2)

        for i in range(1, len(x) - 1):
            sec_der[i - 1] = (y[i + 1] - 2 * y[i] + y[i - 1]) / h ** 2

        # calculam doar pentru punctele din interiorul intervalului, fara capete
        x_int = x[1:-1]

        sdf2 = np.vectorize(sdf)
        # Derivata reala
        y_grafic = sdf2(x_int)
        # Derivata aproximata
        y_aproximat = sec_der

        # calculez
        eroare = np.abs(y_grafic - y_aproximat)
        # determinam maximul erorii dintre cele calculate
        er_max = np.max(eroare)

        # verific daca eroarea maxima de trunchiere satisface urmatoarea relatie
        if er_max <= 1e-5: 
            print(f"Eroarea maxima este: {er_max}")
            # plotuim functia
            # trebuie sa afisam functia fara capetele intervalului(adica fara a si b)   
            plt.figure("Aproximarea derivatei a doua")
            plt.plot(x_int, y_grafic, label="Derivata exacta")
            plt.plot(x_int, y_aproximat, label="Aproximarea numerica")
            plt.legend()
            plt.show()

            # afisez si graficul erorii de trunchiere
            plot_eroare_trunchiere_ex_3(x_int, y_grafic, y_aproximat, a, b)
            break

    

# ----------- Metoda pentru afisarea erorii de trunchiere
def plot_eroare_trunchiere_ex_3(x_grafic, y_grafic, y_aprox, mrg_inf, mrg_sup):

    eroare = np.abs(y_grafic - y_aprox)
    # determinam maximul erorii dintre cele calculate
    er_max = np.max(eroare)

    plt.figure("Eroarea de trunchiere")
    plt.plot(x_grafic, eroare)
    # afisez pe grafic valoarea 1e-5
    plt.hlines(1e-5, xmin = mrg_inf, xmax=mrg_sup, color="blue")
    # afisez pe grafic cea mai mare eroare pe care o am eu
    plt.hlines(er_max, label="Eroarea maxima din algoritmul meu", xmin = mrg_inf, xmax=mrg_sup, color="orange")
    plt.legend()
    plt.show()


# APELURILE
if __name__ == "__main__":
    aproximeaza_derivata()