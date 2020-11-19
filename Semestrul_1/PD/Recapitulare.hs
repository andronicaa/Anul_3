import Data.Char

-- Laborator 2
-- Recursie pe liste
-- functie care elimina numerele impare si le injumatateste pe cele pare
semiPareRec :: [Int] -> [Int]
semiPareRec [] = []
semiPareRec (x:xs)
  | even x = (x `div` 2) : semiPareRec xs
  | otherwise = semiPareRec xs

-- descrieri de liste
-- aceeasi cerinta de mai sus, dar implementata cu descrieri de Liste
semiPareDesc :: [Int] -> [Int]
semiPareDesc list = [x `div` 2 | x <- list, even x]

-- in interval
inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec _ _ [] = []
inIntervalRec a b (x:xs)
  | a <= x && x <= b = x : (inIntervalRec a b xs)
  | otherwise = inIntervalRec a b xs

inIntervalDesc :: Int -> Int -> [Int] -> [Int]
inIntervalDesc a b list = [x | x <- list, a <= x && x <= b]

-- numara cate numere strict pozitive sunt intr-o lista data ca argument
pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (x:xs)
  | x > 0 = 1 + pozitiveRec xs
  | otherwise = pozitiveRec xs


pozitiveDesc :: [Int] -> Int
pozitiveDesc list = length[x | x <- list, x > 0]


-- calculeaza lista pozitiile elementelor impare din lista originala
pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec l = pozitiiImpareAux l 0

pozitiiImpareAux [] _ = []
pozitiiImpareAux (h : t) a
    | odd h = a : (pozitiiImpareAux t (a + 1))
    | otherwise = pozitiiImpareAux t (a + 1)


pozitiiImpareDesc :: [Int] -> [Int]
pozitiiImpareDesc list = [poz | (poz, nr) <- zip [0..] list, odd nr]

-- calc produsul cifrelor care apar intr-un sir de caractere
multDigitRec :: String -> Int
multDigitRec "" = 1
multDigitRec (x:xs)
  | isDigit x = digitToInt x * multDigitRec xs
  | otherwise = multDigitRec xs


multDigitDesc :: String -> Int
multDigitDesc list = product[digitToInt x | x <- list, isDigit x]


discountRec :: [Float] -> [Float]
discountRec [] = []
discountRec (x:xs)
  | (x - x*0.25) < 200 =  (x - x*0.25) : discountRec xs
  | otherwise = discountRec xs


discountComp :: [Float] -> [Float]
discountComp list = [b | x <- list, let b = x - x*0.25, b < 200]



-- Curs 3 -> functii de nivel inalt
-- FUNCTIILE SUNT VALORI
-- functie care selecteaza dintr-o lista de cuvinte pe cele care incep cu
-- litera mare
incepeLM :: [String] -> [String]
incepeLM list = filter (\x -> isUpper(head x)) list


-- aflati lungimea celui mai lung cuvant care incepe cu litera 'c' dintr-o lista Data
maxLengthFn list = foldr max 0 (map length (filter (\x -> head x == 'c') list))


-- Laborator 3
-- definirea listelor prin descrieri de liste

-- 1
factori :: Int -> [Int]
factori n = [x | x <- [1..n], n `rem` x == 0]

-- 2
prim :: Int -> Bool
prim 2 = True
prim n
  | length(factori n) == 2 = True
  | otherwise = False

-- 3
numerePrime :: Int -> [Int]
numerePrime n = [x | x <- [2..n], prim x == True]

-- Functia zip
myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
myzip3 [] _ _ = []
myzip3 _ [] _ = []
myzip3 _ _ [] = []
myzip3 (x:xs) (y:ys) (z:zs) = (x, y, z) : (myzip3 xs ys zs)

-- Functii de nivel inalt
-- 1
firstEl :: [(a, b)] -> [a]
firstEl = map (fst)

-- 2
sumList :: [[Integer]] -> [Integer]
sumList list = map (sum) list


-- 3
prel2 :: [Integer] -> [Integer]
prel2 list = map f list
    where f x = if x `rem` 2 == 0 then x `div` 2 else x * 2


-- map si filter
-- 1
contineChar :: [String] -> Char -> [String]
contineChar list ch = filter (elem ch) list

-- 2
listP :: [Int] -> [Int]
listP list = map (^2) (filter (\x -> x `rem` 2 == 1) list)


-- 3
listPozImp :: [Int] -> [Int]
listPozImp list = map (^2)(map (fst) (filter(\(x, y) -> y `rem` 2 == 1) (zip list [1..])))

-- 4
stringList :: [String] -> [String]
stringList l = [l2 | l1 <- l, let l2 = filter (`elem` "aeiouAEIOU") l1]


-- Exercitii cu definirea operatorilor binari
ordonata :: [a] -> (a -> a -> Bool) -> Bool
ordonata list binRel = and [binRel a b | (a, b) <- zip list (tail list)]


-- pentru a defini un operator nou acesta trebuie introdus neaparat intre paranteze
(*<*) :: (Integer, Integer) -> (Integer, Integer) -> Bool
-- defineste o relatie pe perechi de numere
(a, b) *<* (c, d) = a < c && b < d


-- 4
-- daca o functie returneaza o alta functie =>
-- trebuie sa ii dam un parametru pe care sa aplice acea functie !!
computeList :: (b -> c) -> [(a -> b)] -> [(a -> c)]
computeList f list = [f.g | g <- list]
-- computeList f fList = map (f.) fList


aplicaList :: a -> [(a -> b)] -> [b]
aplicaList a fList = [f a | f <- fList]



-- CURS 4
data Point a b = Pt a b
pr1 :: Point a b -> a
pr1 (Pt x _) = x

pr2 :: Point a b -> b
pr2 (Pt _ y) = y


-- cu TYPE se pot redenumi tipuri deja existente
type FirstName = String
type LastName = String
type Age = Int
type Height = Float
type Phone = String
data Person = Person FirstName LastName Age Height Phone

-- Proiectii
firstName :: Person -> String
firstName (Person firstName _ _ _ _) = firstName

lastName :: Person -> String
lastName (Person _ lastName _ _ _) = lastName

age :: Person -> Int
age (Person _ _ age _ _) = age

height :: Person -> Float
height (Person _ _ _ height _ ) = height

phone :: Person -> String
phone (Person _ _ _ _ phone) = phone



-- Date personale ca inregistrari
data Persoana = Persoana { prenume :: String,
                           nume :: String,
                           varsta :: Int,
                           inaltime :: Float,
                           telefon :: String
}


gigel = Persoana "Gigel" "Ionescu" 20 175.3 "0740159113"


-- proiectiile sunt definite automat
-- exista sintaxa speciala pentru actualizari
updateVarsta :: Persoana -> Persoana
updateVarsta person = person {varsta = varsta person + 1}

-- nu exista instanta a clasei show pentru tipul de date Persoana
instance Show Persoana where
  show (Persoana p n v i t) = "Persoana este " ++ n ++ " " ++ " " ++ p ++ " si are varsta " ++ show v ++ " inaltimea " ++ show i ++ " si numarul de telefon " ++ show t





-- Instantiere explicita - exemplu
data Season = Spring | Summer | Autumn | Winter
eqSeason :: Season -> Season -> Bool
eqSeason Spring Spring = True
eqSeason Summer Summer = True
eqSeason Autumn Autumn = True
eqSeason Winter Winter = True
eqSeason _ _ = False

showSeason :: Season -> String
showSeason Spring = "Primavara"
showSeason Summer = "Vara"
showSeason Autumn = "Toamna"
showSeason Winter = "Iarna"

instance Eq Season where
  (==) = eqSeason
instance Show Season where
  show = showSeason



-- Numere naturale
-- declaratie ca tip de date algebric folosind sabloane
-- LA INSTANTA SE PUNE CONSTRUCTORUL DE DATE!!
data Nat = Zero | Succ Nat
instance Show Nat where
  show (Zero) = "Numarul este 0"
  show (Succ n) = "Numarul este " ++ show (natToInt (Succ n))

(^^^) :: Float -> Nat -> Float
x ^^^ Zero = 1.0
x ^^^ (Succ n) = x * x ^^^ n

(+++) :: Nat -> Nat -> Nat
m +++ Zero = m
m +++ (Succ n) = Succ (m +++ n)

natToInt :: Nat -> Int
natToInt Zero = 0
natToInt (Succ n) = 1 + natToInt n

cinci = Succ (Succ (Succ (Succ (Succ Zero))))
patru = Succ (Succ (Succ (Succ Zero)))
zero = Zero


-- LISTE
data List a = Nil
            | a ::: List a
            deriving (Show)
infixr 5 :::

(++++) :: List a -> List a -> List a
infixr 5 ++++
Nil ++++ ys = ys
(x ::: xs) ++++ ys = x ::: (xs ++++ ys)



-- Laborator 4
-- 1.a
produsRec :: [Integer] -> Integer
produsRec [] = 1
produsRec (x:xs) = x * produsRec xs


-- 1.b
produsFold :: [Integer] -> Integer
produsFold = foldr (*) 1

-- 2.a
andRec :: [Bool] -> Bool
andRec list = and list

andRec' :: [Bool] -> Bool
andRec' [] = True
andRec' (x:xs) = x && (andRec' xs)

-- 2.b
andFold :: [Bool] -> Bool
andFold = foldr (&&) True


-- 3.a
concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (x:xs) = x ++ concatRec xs

-- 3.b
concatFold :: [[a]] -> [a]
concatFold = foldr (++) []


-- 4.a
rmChar :: Char -> String -> String
rmChar ch list = filter (/=ch) list

-- 4.b
rmCharsRec :: String -> String -> String
rmCharsRec "" = id
rmCharsRec (x:xs) = rmChar x . rmCharsRec xs

test_rmchars :: Bool
test_rmchars = rmCharsRec ['a'..'l'] "fotbal" == "ot"

-- 4.c
rmCharsFold :: String -> String -> String
rmCharsFold ch x = foldr rmChar x ch

test_rmFold :: Bool
test_rmFold = rmCharsFold ['a'..'l'] "fotbal" == "ot"
