--functie care elimina duplicatele consecutive din sir
-- recursivitate si functii din categoria A
elimDuplicate :: String -> String
elimDuplicate "" = ""
elimDuplicate [x] = [x]
elimDuplicate (x:y:xs)
    | x == y = elimDuplicate (y:xs)
    | otherwise = x : elimDuplicate (y : xs)


-- functie care primeste un par matrice si un numar intreg n
-- verifMatrix :: [[Int]] -> Bool
verifMatrix matrix n = gtN matrix
                      where
                        -- filtrez elementele din matrice care au elemente pare si lungimea lor este mai mare decat n
                        gtN matrix = filter (\x -> length x >= n) (f matrix)
                        -- filtrez liniile din matrice care au doar elemente pare
                        f matrix = filter (\x -> doarPare x) matrix
                        -- verific daca o lista are doar elemente pare
                        doarPare list = foldr (&&) True (map even list)

verifMatrix1 :: [[Int]] -> Int -> Bool
verifMatrix1 matrix n = ver == filtrare
                        where

                          ver = filter (\x -> snd x == True) per
                          -- filtrez elementele care au doar elemente mai mari decat n si lungime para
                          filtrare = filter (\x -> snd x == True && length(fst x) `mod` 2 == 0) per
                          -- fac pereche de (lista, True/False daca indeplineste conditia ca fiecare element sa fie mai mare decat n)
                          per = zip matrix (verifGtN matrix)
                          -- aplic functia gt pe toate listele din matrice
                          verifGtN matrix = map gt matrix
                          -- verifica intr-o lista care element este mai mare decat n si dupa verifica cu foldr daca toate sunt mai mari decat n
                          gt list = foldr (&&) True (map (>n) list)
