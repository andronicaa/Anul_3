import numpy as np




def Plot_functions_Newton_cu_DD(f1, polinom, nr_puncte, capat_st, capat_dr, x, Q):
    f = np.vectorize(f1)
    x_grafic = np.linspace(capat_st, capat_dr, nr_puncte)
    x_grafic_poli = np.zeros(nr_puncte)
    for i in range(nr_puncte):
        x_grafic_poli[i] = polinom(x_grafic[i], Q, x)

    # afisam graficele ambelor functii, precum si punctele vectorului c
    plt.figure(0)
    plt.plot(x_grafic, f(x_grafic), linestyle='-', linewidth=3)
    plt.plot(x_grafic, x_grafic_poli, linestyle='--', linewidth=3)

    plt.legend(['f(x)', 'polinom(x)'])  # Adauga legenda
    plt.axvline(0, c='black')  # Adauga axa OY
    plt.axhline(0, c='black')  # Adauga axa OX
    plt.xlabel('x')  # Label pentru axa OX
    plt.ylabel('y')  # Label pentru axa OY
    # Titlul figurii
    plt.title('Metoda Newton cu DD de determinare a polinomului Lagrange')

    # scatter pt nodurile (x,y)

    for elem in x:
        plt.scatter(elem, f(elem), s=30, c='black',
                    marker='o', zorder=10)  # adauga punct

    plt.show()  # Arata graficul


def Plot_error_Newton_cu_DD(f1, polinom, nr_puncte, capat_st, capat_dr, x, Q):
    f = np.vectorize(f1)
    x_grafic = np.linspace(capat_st, capat_dr, nr_puncte)
    x_grafic_poli = np.zeros(nr_puncte)
    for i in range(nr_puncte):
        x_grafic_poli[i] = polinom(x_grafic[i], Q, x)

    # afisam graficul erorii absolute de interpolare
    plt.figure(0)
    plt.plot(x_grafic, np.abs(f(x_grafic) - x_grafic_poli),
             linestyle='-', linewidth=3)

    plt.legend(['f(x)-polinom(x)'])  # Adauga legenda
    plt.axvline(0, c='black')  # Adauga axa OY
    plt.axhline(0, c='black')  # Adauga axa OX
    plt.xlabel('x')  # Label pentru axa OX
    plt.ylabel('y')  # Label pentru axa OY
    plt.title('Graficul erorii absolute de interpolare')  # Titlul figurii
    plt.show()  # Arata graficul

    # afisam graficul erorii relative de interpolare
    plt.figure(0)
    plt.plot(x_grafic, np.abs(f(x_grafic) - x_grafic_poli) /
             np.abs(f(x_grafic)), linestyle='-', linewidth=3)

    plt.legend(['(f(x)-polinom(x))/f(x)'])  # Adauga legenda
    plt.axvline(0, c='black')  # Adauga axa OY
    plt.axhline(0, c='black')  # Adauga axa OX
    plt.xlabel('x')  # Label pentru axa OX
    plt.ylabel('y')  # Label pentru axa OY
    plt.title('Graficul erorii relative de interpolare')  # Titlul figurii
    plt.show()  # Arata graficul


def Metoda_Newton_cu_DD_de_rezolvare_polinom_Lagrange(f, N, capat_st, capat_dr, nr_puncte):
    """
        Deoarece avem oscilatii mari in capete care strica convergenta (fenomenul Runge),
        trebuie sa impartim intervalul initial creand noduri Cebasev, noduri distribuite dens in jurul capetelor,
        deci renuntam la nodurile echidistante
    """

    # nodurile obtinute sunt pe intervalul [-1,1] si trebuie redimensionate la intervalul [capat_st, capat_dr]
    OldRange = (1 - (-1))
    NewRange = (capat_dr - capat_st)

    x = np.zeros(N+1)
    for i in range(N+1):
        # nod pe intervalul [-1,1]
        aux = np.cos(((N-i)/N) * np.pi)
        # nod pe intervalul [capat_st, capat_dr]
        x[i] = (((aux - (-1)) * NewRange) / OldRange) + capat_st

    # print('\n x: ', np.shape(x), '\n', x)

    # formam vectorul y cu yi = f(xi)
    y = np.array([[f(x[0])]])
    for i in range(1, len(x)):
        y = np.concatenate((y, [[f(x[i])]]), axis=0)

    # print('\n y: ', np.shape(y), '\n', y)

    # formam matricea Q, matrice inferior triunghiulara alecarei elemente coincid
    # cu diferentele divizate (corespunzatoare tabelului diferentelor divizate)
    Q = np.zeros((N+1, N+1))
    for i in range(N+1):
        Q[i][0] = y[i]
        for j in range(1, i+1):
            Q[i][j] = (Q[i][j-1] - Q[i-1][j-1])/(x[i] - x[i-j])

    # print('\n Q: ', np.shape(Q), '\n', Q)

    # construim o functie care are forma polinomului obtinut folosind vectorul de necunoscute

    def polinom(v, Q, x):
        rez = Q[0][0]
        for i in range(np.shape(Q)[0]-1):
            aux = 1
            for j in range(i+1):
                aux = aux * (v - x[j])

            rez = rez + Q[i+1][i+1] * aux

        return rez

    Plot_functions_Newton_cu_DD(f, polinom, nr_puncte,
                                capat_st, capat_dr, x, Q)
    Plot_error_Newton_cu_DD(f, polinom, nr_puncte, capat_st, capat_dr, x, Q)