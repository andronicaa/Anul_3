import Data.Char
import Data.List
-- Fibonacci cazuri
fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n
    | n < 2 = n
    | otherwise = fibonacciCazuri(n - 1) + fibonacciCazuri(n - 2)

-- Fibonacci ecuational
fibonacciEcuational :: Integer -> Integer
fibonacciEcuational 0 = 0
fibonacciEcuational 1 = 1
fibonacciEcuational n = fibonacciEcuational(n - 1) + fibonacciEcuational(n - 2)

-- Fibonacci Liniar
fibonacciLiniar :: Integer -> Integer
fibonacciLiniar 0 = 0
fibonacciLiniar n = snd (fibonacciPereche n)
  where
    fibonacciPereche :: Integer -> (Integer,  Integer)
    fibonacciPereche 1 = (0, 1)
    fibonacciPereche n = let (a, b) = fibonacciPereche(n - 1) in (b, a + b)


-- Recursie pe Liste
semiPareRecDestr :: [Int] -> [Int]
semiPareRecDestr l
  | null l    = l
  | even h    = h `div` 2 : t'
  | otherwise = t'
  where
    h = head l
    t = tail l
    t' = semiPareRecDestr t

semiPareEq :: [Int] -> [Int]
semiPareEq [] = []
semiPareEq (h : t)
  | even h = h `div` 2 : t'
  | otherwise = t'
  where t' = semiPareEq t

-- Liste definite prin comprehensiune
semiPareComp :: [Int] -> [Int]
semiPareComp l = [x `div` 2 | x <- l, even x]

-- Exercitii
--L2.2
-- cu sabloane de liste
inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec _ _ [] = []
inIntervalRec a b (x:xs)
    | a <= x && x <= b = x: (inIntervalRec a b xs)
    | otherwise = inIntervalRec a b xs

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b l = [x | x <- l, a <= x && x <= b]

-- L2.3
pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (h:t)
    | h > 0 = 1 + pozitiveRec t
    | otherwise = pozitiveRec t

pozitiveComp :: [Int] -> Int
pozitiveComp l = length[1 | x <- l , x > 0]

--L2.4
pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRec l = pozitiiImpareAux l 0

pozitiiImpareAux [] _ = []
pozitiiImpareAux (h : t) a
    | odd h = a : (pozitiiImpareAux t (a + 1))
    | otherwise = pozitiiImpareAux t (a + 1)

pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l = [b | (a, b) <- zip l [0..], odd a]


--L2.5
multDigitsRec :: String -> Int
multDigitsRec "" = 1
multDigitsRec (h : t)
    | isDigit h = (digitToInt h) * multDigitsRec t
    | otherwise = multDigitsRec t

multDigitsComp :: String -> Int
multDigitsComp sir = product[digitToInt ch | ch <- sir, isDigit ch]


-- L2.6
discountRec :: [Float] -> [Float]
discountRec [] = []
discountRec (h:t)
    | discount h < 200 = discount h : discountRec t
    | otherwise = discountRec t

discount :: Float -> Float
discount x = x - 0.25 * x

discountComp :: [Float] -> [Float]
discountComp l = [y | x <- l, let y = discount x, y < 200]
