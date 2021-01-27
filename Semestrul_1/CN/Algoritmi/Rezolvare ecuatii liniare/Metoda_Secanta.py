


# ----------------- Exercitiul 4-----------------------
def call_secant_method():

    # Functia data ca parametru
    f1 = lambda x: x ** 3 - 3 * x ** 2 + 2 * x
    # O solutie este 0 => trebuie sa dam factor comun un x pentru a putea aplica algoritmul(altfel ar fi la un moment dat impartire la 0)
    f = lambda x: x ** 2 - 3 * x + 2
    # In urma aflarii solutiilor functiei f si  derivatei(am aflat subintervalele de monotonie si cele pe care solutia este unica)
    a = [0.5, 1.6] # f(0.5) > 0, f(1.6) < 0
    b = [1.5, 2.5] # f(1,5) < 0, f(2.5) > 0 
    # Am ales x0 si x1 intre intervalele corespunzatoare fiecarei perechi din vectorii a si b
    x0 = [0.95, 2.1]
    x1 = [0.90, 2.2]
    eps = 1e-5
    sol = []
    Nr_iteratii = []
    # 0 este solutie, o adaugam la vectorul de solutii
    sol.append(0.)
    Nr_iteratii.append(1)
    for i in range(2):
        result = secant_method(f, a[i], b[i], x0[i], x1[i], eps)
        sol.append(result[0])
        Nr_iteratii.append(result[1])
    for i in range(len(sol)):
        print(f"Pentru al {i+1}-lea subinterval s-a gasit solutia {sol[i]} dupa {Nr_iteratii[i]} iteratii")

    # Afisam graficul functiei
    plot_function(-3, 3, f1, sol, "Grafic ex4.b")


def secant_method(f, a, b, x0, x1, eps):
    # numarul de iteratii 
    N = 1
    x_aprox = x1
    x_prec = x0
    # La pasul curent aproximarea solutiei se face intersectand dreapta determinata de capatul intervalului corespunzator lui a la pasul precedent(k-1) si capatul corespunzator lui b la pasul k-2 cu axa Ox. Astfel nu mai este nevoie de derivata ca la metoda lui Newton deoarece nu se mai intersecteaza tangenta la grafic intr-un punct x0 cu asa Ox
    while abs(x_aprox - x_prec) / abs(x_prec) >= eps:

        N = N + 1
        x_aux = (x_prec * f(x_aprox) - x_aprox * f(x_prec)) / (f(x_aprox) - f(x_prec))
        x_prec = x_aprox
        x_aprox = x_aux
        # Daca solutia aproximata la pasul curent iese din interval oprim algoritmul
        # Valorile date pentru x1 si x0 nu au fost alese corespunzator
        if x_aprox < a or x_aprox > b:
            print(f"Introduceti alte valori pentru x0 si x1 pentru {a} si {b}")
            break
        
        
        
    return [x_aprox, N]


if __name__ == "__main__":
    call_secant_method()