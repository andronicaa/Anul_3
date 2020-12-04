import math

def bisection_method(a, b, N, f):
    # se primesc ca param capetele de interval: a si b
    # N -> dupa cate repetari trebuie sa se opreasca algoritmul - precizia
    # f -> functia pentru care se cere determinarea solutiilor

    # mai intai verificam daca se poate aplica aceasta metoda
    if f(a) * f(b) >= 0:
        print("Nu se poate aplica metoda bisectiei deoarece f(a) * f(b) >= 0")
        return None
    ak = a
    bk = b
    for i in range(0, N):
        # calculam mijlocul intervalului
        xk = (ak + bk) / 2
        if f(ak) * f(xk) < 0:
            ak = ak
            bk = xk
        elif f(bk) * f(xk) < 0:
            ak = xk
            bk = bk
        elif f(xk) == 0:
            print("Am gasit solutia exacta: ")
            return xk
        else:
            print("Nu s-a gasit nicio solutie")
            return None
    return (ak + bk) / 2


if __name__ == "__main__":
    # definim functia pentru care dorim sa calculam solutiile
    f = lambda x: x**2
    # dam capetele de interval
    a = float(input("Dati capatul de interval pentru a = "))
    b = float(input("Dati capatul de interval pentru b = "))
    # dam epsilon
    eps = float(input("Dati epsilon: "))
    # calculam N
    N = int(math.log((b - a) / eps, 2))
    print("Solutiile ecuatiei sunt: ")
    print(bisection_method(a, b, N, f))

