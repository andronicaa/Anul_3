import Data.Char
import Data.List
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



-- Date personale ca inregistrari (record syntax)
data Persoana = Persoana { prenume :: String,
                           nume :: String,
                           varsta :: Int,
                           inaltime :: Float,
                           telefon :: String
}

-- prin sintaxa de acest tip haskell face automat functii din campurile inregistrarii

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


-- CURS 5
myList :: [Either Int String]
myList = [Left 4, Left 1, Right "hello", Left 2, Right " ", Right "world", Left 17]

-- facem suma intregilor din lista
addInts :: [Either Int String] -> Int
addInts [] = 0
addInts (Left n : xs) = n + addInts xs
addInts (Right s : xs) = addInts xs

addInts' :: [Either Int String] -> Int
addInts' list = sum [x | Left x <- list]

-- concatenam stringurile din lista
addStr :: [Either Int String] -> String
addStr [] = ""
addStr (Left x : xs) = addStr xs
addStr (Right s : xs) = s ++ addStr xs

addStr' :: [Either Int String] -> String
addStr' list = concat [s | Right s <- list]

-- logica propozitionala
type Name = String
data Prop = Var Name
          | F
          | T
          | Not Prop
          | Prop :|: Prop
          | Prop :&: Prop
          deriving (Eq, Ord)
type Names = [Name]
-- evaluarea variabilelor
type Env = [(Name, Bool)]

-- afisarea unei propozitii
showProp :: Prop -> String
showProp (Var x) = x
showProp F = "False"
showProp T = "True"
showProp (Not p) = par ("~" ++ showProp p)
showProp (p :|: q) = par (showProp p ++ "|" ++ showProp q)
showProp (p :&: q) = par (showProp p ++ "&" ++ showProp q)

par :: String -> String
par s = "(" ++ s ++ ")"

instance Show Prop where
  show = showProp

names :: Prop -> Names
names (Var x) = [x]
names F = []
names T = []
names (Not p) = names p
names (p :|: q) = nub (names p ++ names q)
names (p :&: q) = nub (names p ++ names q)

prop :: Prop
prop = (Var "a" :&: Not(Var "b"))

-- EVALUAREA UNEI propozitii
lookUp :: Eq a => [(a, b)] -> a -> b
lookUp env x = head [y | (x', y) <- env, x == x']

eval :: Env -> Prop -> Bool
eval e (Var x) = lookUp e x
eval e F = False
eval e T = True
eval e (Not p) = not (eval e p)
eval e (p :|: q) = eval e p || eval e q
eval e (p :&: q) = eval e q && eval e q

p0 :: Prop
p0 = (Var "a" :&: Not (Var "a"))
e0 :: Env
e0 = [("a", True)]


-- GENERAREA TUTUROR EVALUARILOR
envs :: Names -> [Env]
envs [] = []
envs (x:xs) = [(x, False) : e | e <- envs xs] ++
              [(x, True) : e | e <- envs xs]



-- Expresii
data Exp = Lit Int
          | Add Exp Exp
          | Mul Exp Exp

showExp :: Exp -> String
showExp (Lit n) = show n
showExp (Add e1 e2) = par (showExp e1 ++ "+" ++ showExp e2)
showExp (Mul e1 e2) = par (showExp e1 ++ "*" ++ showExp e2)

exp1 :: Exp
exp1 = Add (Lit 2) (Mul (Lit 3) (Lit 3))
instance Show Exp where
  show = showExp

-- evaluarea expresiilor
evalExp :: Exp -> Int
evalExp (Lit n) = n
evalExp (Add e1 e2) = evalExp e1 + evalExp e2
evalExp (Mul e1 e2) = evalExp e1 * evalExp e2


-- Laborator 5
-- 1
rotate :: Int -> [Char] -> [Char]
rotate n list = drop n list ++ take n list

-- 3
makeKey :: Int -> [(Char, Char)]
makeKey nr = zip alfabet (rotate nr alfabet)
            where
              alfabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- 4
lookUp1 :: Char -> [(Char, Char)] -> Char
lookUp1 ch [] = ch
lookUp1 ch (x:xs) = if fst x == ch then snd x else lookUp1 ch xs


-- 5
encipher :: Int -> Char -> Char
encipher nr ch = lookUp1 ch (makeKey nr)

-- 6
normalize :: String -> String
normalize "" = ""
normalize (x:xs) = if x `elem` caractere then toUpper(x) : normalize xs else normalize xs
                  where
                    caractere = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"


-- 7
encipherStr :: Int -> String -> String
encipherStr nr list = [encipher nr ch| ch <- normalize list]



-- decodarea unui mesaj
-- 8
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey = map(\(a, b) -> (b, a))

-- 9
decipher :: Int -> Char -> Char
decipher nr c = lookUp1 c (reverseKey (makeKey nr))


-- 10
decipherStr :: Int -> String -> String
decipherStr nr_rot l = [decipher nr_rot ch | ch <- normalize l]





-- LABORATOR 6
data Fruct = Mar String Bool
            | Portocala String Int

ionatanFaraVierme = Mar "Ionatan" False
goldenCuVierme = Mar "Golden Delicious" True
portocalaSicilia10 = Portocala "Sanguinello" 10
listaFructe = [Mar "Ionatan" False,
              Portocala "Sanguinello" 10,
              Portocala "Valencia" 22,
              Mar "Golden Delicious" True,
              Portocala "Sanguinello" 15,
              Portocala "Moro" 12,
              Portocala "Tarocco" 3,
              Portocala "Moro" 12,
              Portocala "Valencia" 2,
              Mar "Golden Delicious" False,
              Mar "Golden" False,
              Mar "Golden" True]

-- 1
-- a
portocaleSicilia = ["Tarocco", "Moro", "Sanguinello"]
ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Mar _ _) = False
ePortocalaDeSicilia (Portocala soi felii) = if soi `elem` portocaleSicilia then True else False

test_ePortocalaDeSicilia1 = ePortocalaDeSicilia (Portocala "Moro" 12) == True

test_ePortocalaDeSicilia2 = ePortocalaDeSicilia (Mar "Ionatan" True) == False


-- b
nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia [] = 0
nrFeliiSicilia (x@(Portocala s f):xs) = (if ePortocalaDeSicilia x then f else 0) + nrFeliiSicilia xs
nrFeliiSicilia (_:xs) = nrFeliiSicilia xs


test_nrFeliiSicilia = nrFeliiSicilia listaFructe == 52

nrFeliiSiciliaComp :: [Fruct] -> Int
nrFeliiSiciliaComp list = sum[f | x@(Portocala s f ) <- list, ePortocalaDeSicilia x]

nrFeliiSiciliaHof :: [Fruct] -> Int
nrFeliiSiciliaHof list = foldr (+) 0 (map(\(Portocala s i) -> i)(filter ePortocalaDeSicilia list))
-- c
nrMereViermi :: [Fruct] -> Int
nrMereViermi list = sum[1 | (Mar s v) <- list, v /= False]


-- Exercitiul 2
type NumeA = String
type Rasa = String
data Animal = Pisica NumeA | Caine NumeA Rasa

vorbeste :: Animal -> String
vorbeste (Pisica _) = "Miau"
vorbeste (Caine _ _) = "Ham"


pisica = Pisica "Mona"
caine = Caine "Bisu" "Bichon"

-- b
rasa :: Animal -> Maybe String
rasa (Pisica _) = Nothing
rasa (Caine n r) = Just r



-- ALTE EXEMPLE
-- adaugam derivare automata a functiei show
-- data Shape = Circle Float Float Float | Rectangle Float Float Float Float
--             deriving (Show)

-- surface :: Shape -> Float
-- surface (Circle _ _ r) = pi * r ^ 2
-- surface (Rectangle x1 y1 x2 y2) = (abs(x2 - x1)) * (abs(y2 - y1))

-- nu are instanta a functiei show
data Point1 = Point1 Float Float deriving(Show)
data Shape = Circle Point1 Float | Rectangle Point1 Point1 deriving(Show)

surface :: Shape -> Float
surface (Circle _ r) = pi * r ^ 2
surface (Rectangle (Point1 x1 y1) (Point1 x2 y2)) = (abs(x2 - x1)) * (abs(y2 - y1))

nudge :: Shape -> Float -> Float -> Shape
nudge (Circle (Point1 x y) r) a b = Circle (Point1 (x + a) (y + a)) r
nudge (Rectangle (Point1 x1 y1) (Point1 x2 y2)) a b = Rectangle (Point1 (x1 + a) (y1 + b)) (Point1 (x2 + a) (y2 + b))



-- TYPE PARAMETERS
-- You might not know it, but we used a type that has a type parameter before we used Maybe. That type is the list type. Although there's some syntactic sugar in play, the list type takes a parameter to produce a concrete type. Values can have an [Int] type, a [Char] type, a [[String]] type, but you can't have a value that just has a type of [].
data Car = Car { company :: String,
                 model :: String,
                 year :: Int} deriving (Show)

tellCar :: Car -> String
tellCar (Car {company = c, model = m, year = y}) = "This " ++ c ++ " " ++ m ++ " was made in " ++ show y



data Vector a = Vector a a a deriving (Show)

vplus :: (Num t) => Vector t -> Vector t -> Vector t
(Vector i j k) `vplus` (Vector l m n) = Vector (i+l) (j+m) (k+n)

vectMult :: (Num t) => Vector t -> t -> Vector t
(Vector i j k) `vectMult` m = Vector (i*m) (j*m) (k*m)

scalarMult :: (Num t) => Vector t -> Vector t -> t
(Vector i j k) `scalarMult` (Vector l m n) = i*l + j*m + k*n

-- data Bool = False | True deriving(Ord)
-- deoarece constructorul de date False este specificat primul
-- si True dupa el => True is GT False


-- a value or Nothing is always smaller than a value of Just smt
-- daca comparam 2 Just => se va compara ce este in interiorul lor

data Day = Luni | Marti | Miercuri | Joi | Vineri | Sambata | Duminica
          deriving(Eq, Ord, Show, Read, Bounded, Enum)


-- data List a = Empty | Cons {listHead :: a, listTail :: List a} deriving(Show, Read, Eq, Ord)
infixr 5 :-:
data List a = Empty | a :-: (List a) deriving (Show, Read, Eq, Ord)

-- ne definim o noua concatenare pe 2 liste
infixr 5 .++
(.++) :: List a -> List a -> List a
Empty .++ ys = ys
(x :-: xs) .++ ys = x :-: (xs .++ ys)



--  ARBORI
data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

singleton :: a -> Tree a
singleton x = Node x EmptyTree EmptyTree

treeInsert :: (Ord a) => a -> Tree a -> Tree a
treeInsert x EmptyTree = singleton x
treeInsert x (Node a left right)
    | x == a = Node x left right
    | x < a = Node a (treeInsert x left) right
    | x > a = Node a left (treeInsert x right)


-- verificam daca exista un element intr-un arbore
treeElem :: (Ord a) => a -> Tree a -> Bool
treeElem x EmptyTree = False
treeElem x (Node a left right)
    | x == a = True
    | x < a = treeElem x left
    | x > a = treeElem x right


----------------------------------------------------
-- Because == was defined in terms of /= and vice versa in the class declaration, we only had to overwrite one of them in the instance declaration. That's called the minimal complete definition for the typeclass — the minimum of functions that we have to implement so that our type can behave like the class advertises. To fulfill the minimal complete definition for Eq, we have to overwrite either one of == or /=. If Eq was defined simply like this:
data TrafficLight = Red | Yellow | Green

instance Eq TrafficLight where
  Red == Red = True
  Green == Green = True
  Yellow == Yellow = True
  _ == _ = False



instance Show TrafficLight where
  show Red = "Red light"
  show Yellow = "Yellow light"
  show Green = "Green light"
