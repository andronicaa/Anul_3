
# ----------------- Exercitiul 3-----------------------
def call_false_position_method():
    # Valorile lui a si b vor fi alese ca perechi de pe aceeasi pozitie din vectorii a respectiv b
    # Acestea sunt alese astfel incat f(a) * f(b) < 0, iar in intervalele unde capatul este deja solutie se face verificare in functie si se returneaza capatul de interval care este solutie
    a = [-5.0, -4.5, -3.4]
    b = [-4.9, -3.5, -2.9]
    f = lambda x: x ** 3 + 12 * x ** 2 + 47 * x + 60
    # toleranta
    eps = 1e-5
    # vectorul cu solutii
    sol = []
    # Numarul de iteratii pentru aflarea fiecarei solutii
    Nr_iteratii = []
    # Apelam functia pentru fiecare subinterval
    for i in range(3):
        result = false_position_method(a[i], b[i], f, eps)
        sol.append(result[0])
        Nr_iteratii.append(result[1])

    for i in range(3):
        print(f"Pentru al {i+1}-lea subinterval s-a gasit solutia {sol[i]} dupa {Nr_iteratii[i]} iteratii")

    # Afisam graficul cu solutiile aflate cu metoda pozitiei false
    plot_function(-5, 5, f, sol, "Grafic ex3.b")


def false_position_method(a, b, f, eps):
    # Numarul de iteratii
    N = 0
    # Ne definim doua siruri ak si bk ca la metoda bisectiei
    a_k = a
    b_k = b
    # Calculam solutia initiala
    x_prec = (a_k * f(b_k) - b_k * f(a_k)) / (f(b_k) - f(a_k))
    # La fiecare iteratie se calculeaza intersectia dintre dreapta determinata de capetele intervalului A(a_k, f(a_k)), B(b_k, f(b_k)) si axa Ox(acest punct este x_aprox)
    while True:
        N = N + 1
        # Verificam daca unul din capete este solutie
        if f(x_prec) == 0:
            x_aprox = x_prec
            break
        if f(a_k) == 0:
            return [a_k, N]
        if f(b_k) == 0:
            return [b_k, N]
        # Daca solutia se afla in intervalul [a_k, x_prec] => restrangem intervalul cu capetele in [a_k, (b_k = x_prev)]
        elif f(a_k) * f(x_prec) < 0:
            a_k = a_k
            b_k = x_prec
            x_aprox = (a_k * f(b_k) - b_k * f(a_k)) / (f(b_k) - f(a_k))
        # Daca solutia se afla in intervalul [b_k, x_prec] -> restrangem intervalul cu capetele in [(a_k = x_prec), b_k]
        elif f(a_k) * f(x_prec) > 0:
            a_k = x_prec
            b_k = b_k
            x_aprox = (a_k * f(b_k) - b_k * f(a_k)) / (f(b_k) - f(a_k))

        # Conditie de oprire
        # Daca eroarea relativa este mai mica decat eps(o toleranta definita de noi), inseamna ca am ajuns la o solutie aproximativa ce indeplineste conditiile 
        if abs(x_aprox - x_prec) / abs(x_prec) < eps:
            break
        x_prec = x_aprox
    
    # Returnez un vector ce contine solutia determinata si numarul de iteratii in care s-a aflat solutia aproximativa
    return [x_aprox, N]


if __name__ == "__main__":
    call_false_position_method()