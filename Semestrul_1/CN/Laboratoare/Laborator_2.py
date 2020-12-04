def newton_method(f, df, x0, eps):
    iteratii = 0
    x_prec = x0 - f(x0) / df(x0) 
    x_curr = x_prec - f(x_prec) / df(x_prec)
    while abs(x_curr - x_prec) / abs(x_prec) >= eps:
        x_prec = x_curr
        x_curr = x_curr - f(x_prec) / df(x_prec)
        iteratii = iteratii + 1
    
    print(iteratii)
    print(x_curr)


if __name__ == "__main__":
    # functia
    f = lambda x: x**3 - 7 * x**2 + 14 * x - 6
    # derivata
    df = lambda x: 3 * x**2 - 14 * x + 14
    # epsilon 
    eps = 0.00001
    # si x0
    x0 = 2.5
    newton_method(f, df, x0, eps)
