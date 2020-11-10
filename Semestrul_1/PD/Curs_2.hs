-- Operatorul ($) are precedenta 0 si este asociativ la dreapta
-- Definirea functiile
-- 1. Definirea functiilor folosind if
-- a. analiza cazurilor folosind expresia if

semn :: Integer -> Integer
semn n = if n < 0 then (-1)
        else if n == 0 then 0
             else 1

-- b. in definitia recursiva
fact :: Integer -> Integer
fact n = if n == 0 then 1
         else n * fact(n-1)

-- 2. Definirea functiilor folosind garzi
semn1 :: Integer -> Integer
semn1 n
    | n < 0 = -1
    | n == 0 = 0
    | otherwise = 1

fact1 :: Integer -> Integer
fact1 n
    | n == 0 = 1
    | otherwise = n * fact1(n-1)

-- Definirea functiilor folosind sabloane si ecuatii
-- Variabilele/valorile din partea stanga => sabloane
-- ECUATIILE SUNT INCERCATE IN ORDINEA SCRIERII

semn2 :: Integer -> Integer
semn2 0 = 0
semn2 n
    | n > 0 = 1
    | otherwise = -1

fact2 :: Integer -> Integer
fact2 0 = 1
fact2 n = n * fact2(n-1)

-- Sabloane (patterns) pentru liste
-- x:y este un sablon pentru liste

-- Sabloane pentru tupluri
selectie :: Integer -> String -> String
selectie x s =
    case (x, s) of
        (0, _) -> s
        (1, z: zs) -> zs
        (1, []) -> []
        _ -> (s ++ s)

-- FUNCTII DE ORDIN INALT--
-- flip
-- map functie lista -> aplica functia pe toate elementele din lista
-- filter

-- suma patratelor elementelor pozitive
-- 1. Folosind descrieri de liste si functii de agregare standard
f :: [Int] -> Int
f list = sum [x * x | x <- list, x > 0]

-- 2. Folosind functii auxiliare
f1 :: [Int] -> Int
f1 xs = foldr (+) 0 (map patrat (filter pos xs))
  where
    patrat x = x * x
    pos x = x > 0


-- 3. Folosind functii anonime
f3 :: [Int] -> Int
f3 xs = foldr (+) 0 (map (\x -> x * x) (filter(\x -> x > 0) xs))


-- 4. Folosind sectiuni si operatorul $
f4 :: [Int] -> Int
f4 xs = foldr (+) 0 $ map (^2) $ filter (> 0) xs
