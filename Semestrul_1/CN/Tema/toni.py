def compute_b(N, x, a, h, dx):
    B = np.zeros((N + 1, N + 1))

    B[0, 0] = 1
    for i in range(1, N):
        B[i, i - 1] = 1
        B[i, i] = 4
        B[i, i + 1] = 1
    B[N, N] = 1

    W = np.zeros((N + 1, 1))
    W[0] = dx(x[0])
    for i in range(1, N):
        W[i] = 3 * (a[i + 1] - a[i - 1]) / h
    W[N] = dx(x[N])

    return np.linalg.solve(B, W)


def compute_c(N, a, b, h):
    c = np.zeros((N, 1))
    for i in range(N):
        c[i] = (3 * (a[i + 1] - a[i]) / h**2) - ((b[i + 1] + 2 * b[i]) / h)
    
    return c


def compute_d(N, a, b, h):
    d = np.zeros((N, 1))
    for i in range(N):
        d[i] = (- 2 * (a[i + 1] - a[i]) / h**3) + ((b[i + 1] + b[i]) / h**2)

    return d


def ex3():
    # Functia
    f = lambda x : np.sin(5 * x) + np.cos(-5 * x) - 21.54 * x

    # Derivata
    dx = lambda x : 5 * -np.sin(5 * x) + 5 * np.cos(5 * x) - 21.54

    # Nr de subintervale
    N = 200

    interval = Interval(-np.pi, +np.pi)

    x = np.linspace(interval.minim, interval.maxim, N+1)
    h = x[1] - x[0]

    a = f(x)
    b = compute_b(N, x, a, h, dx)
    c = compute_c(N, a, b, h)
    d = compute_d(N, a, b, h)

    def polinom(j):
        def spline(X):
            return a[j] + b[j] * (X - x[j]) + c[j] * (X - x[j]) ** 2 + d[j] * (X - x[j]) ** 3
        return spline
    
    nr_puncte = 200
    f2 = np.vectorize(f)
    x_grafic = np.linspace(interval.minim, interval.maxim, nr_puncte)
    y_grafic = f2(x_grafic)
    
    # functie definita pe intervale
    y_aproximat = np.piecewise(
        x_grafic,
        [
            # conditii
            (x[i] <= x_grafic) & (x_grafic < x[i + 1])
            for i in range(N - 1)
        ],
        [
            # polinoamele
            polinom(i)
            for i in range(N)
        ]
    )
    plt.figure("Interpolare spline cubica")
    plt.plot(x_grafic, y_grafic, linestyle='--', label="Functia")
    plt.plot(x_grafic, y_aproximat, label="Interpolarea spline cubica")
    plt.scatter(x, b, label='Nodurile de interpolare')
    plt.legend()
    plt.show()
    
    # eroare de trunchiere
    eroare_trunchiere(x_grafic, y_grafic, y_aproximat, interval.minim, interval.maxim)
    
    # ----------- Metoda pentru afisarea erorii de trunchiere

def eroare_trunchiere(x_grafic, y_grafic, y_aprox, mrg_inf, mrg_sup):
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



ex3()