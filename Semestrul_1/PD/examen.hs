
-- am importat Data.Char pentru a folosi functia toLower in prelucrarea sirului
import Data.Char
transfSir :: [String] -> [String]
transfSir sir = [sir_modificat | l1 <- sir, contineLitSiCifre l1, let sir_modificat = prelSir l1]

-- functie auxiliara pentru a determina daca un sir contine doar litere si cifre
contineLitSiCifre :: String -> Bool
contineLitSiCifre list = and [x `elem` litere || x `elem` cifre | x <- list]
litere = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
cifre = "0123456789"

-- functie auxiliara care prelucreaza un sir de caractere dupa regula data
prelSir :: String -> String -- pa
prelSir list = [prel c | c <- list]
prel :: Char -> Char
prel c
  | c `elem` ['A'..'Z'] =  toLower c
  | c `elem` ['a'..'z'] = '#'
  | c `elem` ['0'..'9'] = '*'
-- literele mari se transforma in litere mici
--litere mici se transforma in #
--cifrele se transforma in *


functFormula :: [Int] -> [Int] -> Int
functFormula list1 list2 =
    if (length list1) == (length list2) then
      let
        prelList1 list1 = map (^2) list1
        prelList2 list2 = map (^2) list2
        prelListe list1 list2 = map (\(x, y) -> 2 * x * y) (zip list1 list2)
        difPatrare = map (\(x, y) -> x - y) (zip (prelList1 list1) (prelList2 list2))
        result = map (\(a, b) -> a + b) (zip (prelListe list1 list2) (difPatrare))
      in

        foldr (*) 1 result

    else
      error "Listele nu au aceeasi lungime"





data MyPair a b = P a b deriving Show
data MyList a = L [a] deriving Show

class MyZip lp where
  zipL :: lp a -> lp b -> lp (MyPair a b)
  unZipL :: lp (MyPair a b) -> MyPair (lp a) (lp b)

instance MyZip MyList where
  -- daca cele doua liste sunt vide => nu avem pe ce sa facem perechi
  zipL (L []) (L []) = L []
  -- in rezultat trebuie sa apara constructorul L deoarece asa cere prototipul functiei
  zipL (L list1) (L list2) = L (prelucreaza list1 list2)
        where
          -- prelucrez doar lista fara construtorul pentru lista L
          prelucreaza [] [] = []
          prelucreaza (x:xs) (y:ys) = P x y : (prelucreaza xs ys)

  unZipL (L list) = P (L (prelucreazaList1 list)) (L (prelucreazaList2 list))
        where
          -- construiesc lista corespunzatoare coordonatei a din punct
          prelucreazaList1 [] = []
          prelucreazaList1 ((P x y):xs) = (x : prelucreazaList1 xs)
          -- construiesc lista corespunzatoare coordonatei b din punct
          prelucreazaList2 [] = []
          prelucreazaList2 ((P x y):xs) = (y : prelucreazaList2 xs)
