import Data.Char
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
verifMatrix matrix n = (gtN matrix) == (f matrix)
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



ex1 :: [Int] -> Int -> Int -> [[Int]]
ex1 list x y = [listDiv | (el, poz) <- zip list [0..], let listDiv = findDivizor poz, el >= x && el <= y ]

findDivizor :: Int -> [Int]
findDivizor n = [x | x <- [1..n], n `mod` x == 0]



-- !!!!
ex2Rec :: String -> String -> String
ex2Rec ""  "" = ""
ex2Rec "" _ = ""
ex2Rec _ "" = ""
ex2Rec (s:s1) (t:t1) = if s == t then s : (ex2Rec s1 t1) else ""


ex2 :: [Char] -> [Char] -> [Char]
ex2 sir1 sir2 = last [(take i sir1) | let len = length (zip sir1 sir2), i <- [1..len], (take i sir1) == (take i sir2)]


-- determinarea suficelor unui cuvant
ex3 :: String -> [String]
ex3 str = [strCut | poz <- [0..length str], let strCut = drop poz str]

-- ex4
sumPatrate :: [Int] -> [Int] -> Int
sumPatrate list1 list2 =
      if (length list1) == (length list2) then
        let
           x1 = map (^2) list1
           y1 = map (^2) list2
           perechi = zip x1 y1
           produse = map (\(a, b) -> a * b) perechi
        in
           foldr (+) 0 produse
      else
        error "Listele trebuie sa aiba aceeasi lungime"


-- ex5
lVocale = "aeiouAEIOU"
lCifre = "0123456789"
lConsoane = "bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXY"
ex5 :: String -> Int
ex5 list = sum[cod | x <- list, let cod = verifCodif x]

verifCodif c
  | c `elem` lVocale = 1
  | c `elem` lCifre = 3
  | c `elem` lConsoane = 2
  | otherwise = -1



data Enciclopedie = Intrare String String | Lista String [Enciclopedie] deriving Show

enc1 = Lista "animal"[Lista "mamifer"[Intrare "elefant" "acesta e un elefant", Intrare "caine" "acesta este un caine", Intrare "pisica" "aceasta este o pisica"], Intrare "animale domestice" "definitie"]

enc2 = Lista "Animal"[Lista "Mamifer"[Intrare "Elefant" "acesta e un elefant",Intrare "caIne" "acesta este un caine",Intrare "piSIca" "aceasta este o pisica"],Intrare "animale domestice" "definitie"]

enc3 = Lista "animal"[Lista "mamifer"[Intrare "elefant" "Acesta e un Elefant", Intrare "caine" "acesta este un caine", Intrare "pisica" "aceasta este o pisica"], Intrare "animale domestice" "definitie"]

enc4 = Lista "animal"[Lista "mamifer"[Intrare "pisica" "aceasta este o pisica",Intrare "elefant" "acesta e un elefant", Intrare "caine" "acesta este un caine"], Intrare "animale domestice" "definitie"]


-- a
nrIntrari :: Enciclopedie -> Int
nrIntrari (Intrare _ _) = 1
nrIntrari (Lista _ l) = sum [nrIntrari en | en <- l]

-- b
tolower :: String -> String
tolower list = map (toLower) list
instance Eq Enciclopedie where
  (Intrare tl1 def1) == (Intrare tl2 def2) = tL1 == tL2 && def1 == def2
      where
        tL1 = tolower tl1
        tL2 = tolower tl2
  (Lista tl1 enc1) == (Lista tl2 enc2) = (tl1 == tl2) && (length enc1 == length enc2) && (and [e1 == e2 | (e1, e2) <- zip enc1 enc2])
      where
        tl1 = tolower tl1
        tl2 = tolower tl2


data Pereche a b = MyP a b
                  deriving (Show)

data ListaP a = MyL [a]
                deriving (Show)

class MyMapping m where
  mymap :: (Pereche a b -> Pereche b a) -> m (Pereche a b) -> m (Pereche b a)
  myfilter :: (Pereche a b -> Bool) -> m (Pereche a b) -> m (Pereche a b)

lp :: ListaP (Pereche Int Char)
lp = MyL [MyP 96 'a', MyP 3 'b', MyP 100 'd']

functSwap :: Pereche a b -> Pereche b a
functSwap (MyP a b) = MyP b a


--  AICI TREBUIE SA PUNEM NEAPARAT TIPUL??
funcFilter :: (Eq a, Ord a, Eq b, Ord b) => Pereche a b -> Bool
funcFilter (MyP x y) = (x `mod` 2 == 0) && (y `elem` "aeiouAEIOU")

instance MyMapping ListaP where
  mymap functSwap (MyL list) = MyL[functSwap el | el <- list]
  myfilter funcFilter (MyL list) = MyL[el | el <- list, funcFilter el == True]
