import Data.Char
-- Scrieti o functie care scrie un sir de caractere cu litere mari
scrieLitereMari :: String -> String
scrieLitereMari s = map toUpper s

-- functie care selecteaza dintr-o lista de cuvinte pe cele care incep cu litera mare
incepeLM :: [String] -> [String]
incepeLM xs = filter (\x -> isUpper (head x)) xs


-- secventa lui Collatz
collatz :: Integer -> [Integer]
collatz n = let
  next x = if (even x) then (div x 2)
                       else (3*x + 1)
  in if (n==1) then [1]
               else n:(collatz (next n))

-- filter (\x -> length x <= 5) (map collatz [1..100])


-- FOLDR & FOLDL
-- Sunt date:
-- -> o functie de actualizare a valorii calculate
-- -> o valoare initiala
-- -> si o lista

-- FUNCTIA FOLDR

maxLengthFn :: [String] -> Int
maxLengthFn xs = foldr max 0 (map length(filter text xs))
                 where text = \x -> head x == 'c'


-- Proprietatea de universalitate
-- foldr :: (a -> b -> b) -> b -> [a] -> b
-- foldr f i :: [a] -> b
-- g [] = i avem lista, nicio functie si valoarea initiala => se returneaza doar
-- valoarea initiala
-- g(x:xs) = f x (g xs)

-- Definiti o functie care data fiind o lista de numere intregi
-- calculeaza suma elementelor din lista
summ :: [Integer] -> Integer
summ xs = foldr (+) 0 xs

-- Scrieti o definitie a sumei folosind foldr astfel incat
-- elementele sa fie procesate de la stanga la dreapta

sum2 :: [Integer] -> Integer
sum2 xs = suml xs 0
          where
            suml [] n = n
            suml (x:xs) n = suml xs (n + x)


-- expresiile sunt evaluate numai cand este nevoie de valoarea lor
-- elementele care nu sunt folosite raman neevaluate
-- o expresie este evaluata o singura Data
