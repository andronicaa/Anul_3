import matplotlib.pyplot as plt
import numpy as np
import math

# EXERCITIUL 1 - functia pentru care vreau sa calculez punctul de minim
def f(x, y):
    return 0.5 * x ** 2 - 8.0 * x * y - 7.0 * x + 82.0 * y ** 2 + 2 * y



# functie care verifica daca o metrice este simetrica si pozitiv definita
def verif_sim_poz_def(A):
    # verific daca matricea este simetrica
    transpusa = A.transpose()
    este_simetrica = np.all(A == transpusa)

    # daca matricea nu este simetrica se va returna False
    if este_simetrica == False:
        return False
    
    # verific daca este pozitiv definita cu metoda lui Sylvester
    for i in range(A.shape[0]):
        # daca unul din minori este <= 0 => se va returna False
        if np.linalg.det(A[:i, :i]) <= 0:
            return False
    
    # daca niciuna din verificarile de mai sus nu a returnat False =>
    # matricea este simetrica si pozitiv definita
    return True
    
def grid_discret(A, b):
    """
    Construieste un grid discret si evaleaza f in fiecare punct al gridului
    """
    
    size = 100 # Numar de puncte pe fiecare axa
    x1 = np.linspace(-25, 20, size) # Axa x1
    x2 = np.linspace(-5, 5, size) # Axa x2
    X1, X2 = np.meshgrid(x1, x2) # Creeaza un grid pe planul determinat de axele x1 si x2

    X3 = np.zeros((size, size))
    for i in range(size):
        for j in range(size):
            x = np.array([X1[i,j], X2[i,j]]) # x e vectorul ce contine coordonatele unui punct din gridul definit mai sus
            X3[i,j] = .5 * x @ A @ x - x @ b # Evaluam functia in punctul x
            
    return X1, X2, X3



def grafic_f(A,b):
    """
    Construieste graficul functiei f
    """
    
    # Construieste gridul asociat functiei
    (X1, X2, X3) = grid_discret(A, b)

    # Defineste o figura 3D
    fig1 = plt.figure()
    ax = plt.axes(projection="3d")

    # Construieste graficul functiei f folosind gridul discret X1, X2, X3=f(X1,X2)
    ax.plot_surface(X1, X2, X3, rstride=1, cstride=1, cmap='winter', edgecolor='none')

    # Etichete pe axe
    ax.set_xlabel('x1')
    ax.set_ylabel('x2')
    ax.set_zlabel('f(x1,x2)')

    # Titlu
    ax.set_title('Graficul functiei f')

    # Afiseaza figura
    plt.show()

def linii_nivel(A,b, steps_pas_desc, steps_grd_conj):
    """
    Construieste liniile de nivel ale functiei f
    """
    
    # Construieste gridul asociat functiei
    (X1, X2, X3) = grid_discret(A, b)
    
    # Ploteaza liniile de nivel ale functiei f
    fig2 = plt.figure()
    plt.contour(X1, X2, X3, levels = 10) # levels = numarul de linii de nivel
    

    # ------------- PLOTEAZA TOTI PASII ALGORITMULUI ---------------
    for i in range(len(steps_pas_desc)-1):
        plt.plot([steps_pas_desc[i][0][0], steps_pas_desc[i+1][0][0]], [steps_pas_desc[i][1][0], steps_pas_desc[i+1][1][0]], linestyle='-', linewidth=3)
    
    for i in range(len(steps_grd_conj)-1):
        plt.plot([steps_grd_conj[i][0][0], steps_grd_conj[i+1][0][0]], [steps_grd_conj[i][1][0], steps_grd_conj[i+1][1][0]], linestyle='-', linewidth=3)
    # Etichete pe axe
    plt.xlabel('x1')
    plt.ylabel('x2')
    
    # Titlu
    plt.title('Liniile de nivel ale functiei f')
    
    # Afiseaza figura
    plt.show()


# ----------- METODA PASULUI DESCENDENT ---------------------
def pas_descendent(A, b):
    # pentru a aplica acest algoritm matricea trebuie sa fie simetrica si pozitiv definita
    # aleg punctul initial
    x_k = np.array([[-10], [1]]).astype(float)

    # trebuie sa retin punctele prin care trec
    x_puncte_grafic = [x_k]

    # reziduu
    reziduu = b - A @ x_k
    # punctul de oprire
    eps = 1e-8

    # folosesc norma 2
    norma = lambda x: np.linalg.norm(x, ord = 2)
    iteratii = 0
    while norma(reziduu) > eps:
        print(x_k)
        iteratii += 1
        learning_rate = (reziduu.T @ reziduu) / (reziduu.T @ A @ reziduu)
        x_k = x_k + learning_rate * reziduu

        # adaug punctul la pasi
        x_puncte_grafic.append(x_k)
        reziduu = b - A @ x_k

    print(f"Numarul de iteratii este {iteratii}")
    print(f"Punctul de minim este {x_k}")
    return [x_k, x_puncte_grafic]
    

def gradient_conjugat(A, b):
    x_k = np.array([[-10], [1]]).astype(float)
    x_puncte_grafic = [x_k]

    reziduu = b - A @ x_k
    directie = reziduu
    norma = lambda x: np.linalg.norm(x, ord = 2)
    iteratii = 0
    eps = 1e-8
    while norma(reziduu) > eps:
        iteratii += 1
        learning_rate = (directie.T @ reziduu) / (directie.T @ A @ directie)
        x_k = x_k + learning_rate * directie
        next_reziduu = reziduu - learning_rate * A @ directie
        direction_rate = (next_reziduu.T @ next_reziduu) / (reziduu.T @ reziduu)
        directie = next_reziduu + direction_rate * directie

        reziduu = next_reziduu
        x_puncte_grafic.append(x_k)

    print(f"Numarul de iteratii este {iteratii}")
    print(f"Punctul de minim este {x_k}")
    return [x_k, x_puncte_grafic]



def aplica_pas_desc():
    # Definire functie f prin matricea A si vectorul b
    A = np.array([[1, -8],[-8, 164]]).astype(float) # Matrice pozitiv definita
    b = np.array([[-7],[2]]).astype(float)
    if verif_sim_poz_def(A):
        # doar daca matricea este simetrica si pozitiv definita pot aplica algoritmul
        # grafic_f(A, b)
        p_minim, steps_pas_desc = pas_descendent(A, b)
        p_minim, steps_grd_conj = gradient_conjugat(A, b)
        linii_nivel(A, b, steps_pas_desc, steps_grd_conj)



if __name__ == "__main__":
    aplica_pas_desc()