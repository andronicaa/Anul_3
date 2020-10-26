import   Data.List

-- L3.1 Încercati sa gasiti valoarea expresiilor de mai jos si
-- verificati raspunsul gasit de voi în interpretor:
{-
[x^2 | x <- [1 .. 10], x `rem` 3 == 2] - R: [4, 25, 64]
[(x, y) | x <- [1 .. 5], y <- [x .. (x+2)]] - R: [(1,1),(1,2),(1,3),(2,2),(2,3),(2,4),(3,3),(3,4),(3,5),(4,4),(4,5),(4,6),(5,5),(5,6),(5,7)]
[(x, y) | x <- [1 .. 3], let k = x^2, y <- [1 .. k]] R: [(1,1),(2,1),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8),(3,9)]
[x | x <- "Facultatea de Matematica si Informatica", elem x ['A' .. 'Z']] R: FMI
[[x .. y] | x <- [1 .. 5], y <- [1 .. 5], x < y ]

-}

factori :: Int -> [Int]
factori x = [factor | factor <- [1..x], x `mod` factor == 0 ]

prim :: Int -> Bool
prim x = factori x == [1, x]

numerePrime :: Int -> [Int]
numerePrime x = [nr | nr <- [2..x], prim nr == True]

-- L3.2 Testati si sesizati diferenta:
-- [(x,y) | x <- [1..5], y <- [1..3]]
-- zip [1..5] [1..3]

myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
myzip3 [] _ _ = []
myzip3 _ [] _ = []
myzip3 _ _ [] = []
myzip3 (x:xs) (y:ys) (z:zs) = (x, y, z) : (myzip3 xs ys zs)

--------------------------------------------------------
----------FUNCTII DE NIVEL INALT -----------------------
--------------------------------------------------------
-- In haskell, functiile sunt valori. Putem sa trimitem functii
-- ca argumente si sa le intoarcem ca rezultat
aplica2 :: (a -> a) -> a -> a
--aplica2 f x = f (f x)
--aplica2 f = f.f
--aplica2 f = \x -> f (f x)
aplica2  = \f x -> f (f x)

-- L3.3
{-

map (\ x -> 2 * x) [1 .. 10]
map (1 `elem` ) [[2, 3], [1, 2]]
map ( `elem` [2, 3] ) [1, 3, 4, 5]

-}
-- L3.1
firstEl :: [(a, b)] -> [a]
-- firstEl = map fst
firstEl xs = map (\x -> fst x) xs
-- L3.2
sumList :: [[Integer]] -> [Integer]
sumList = map sum

-- L3.3
prel2 :: [Integer] -> [Integer]
prel2 = map prelucreaza
    where
      prelucreaza x =
            if x `mod` 2 == 0
              then x `div` 2
              else x * 2


-- prel2 xs = map (\x -> if x `mod` 2 == 0 then x/2 else x*2) xs

-- L3.4.1
contineElem :: Char -> [String] -> [String]
contineElem c arrayWord = filter (c `elem`) arrayWord

-- L3.4.2
oddSquare :: [Integer] -> [Integer]
oddSquare list = map (^2) (filter odd list)

-- L3.4.3
-- listaPatrate :: [Integer] -> [Integer]
-- listaPatrate xs = map (^2) (filter(\x -> snd x `mod` 2 == 1) (zip xs [0 .. ]))

-- L3.4.4
stringList :: [String] -> [String]
stringList l = [l2 | l1 <- l, let l2 = filter (`elem` "aeiouAEIOU") l1]


-- L3.5
mymap f [] = []
mymap f (h:t) = f h : mymap f t

myFilter f (x:xs)
    | f x == True = x : myFilter f xs
    | otherwise = myFilter f xs


-- MATERIAL SUPLIMENTAT
-- Ciurul lui Eratostene
numerePrimeCiur :: Int -> [Int]
numerePrimeCiur n  = ciurAux [2..n]
    where
      ciurAux [] = []
      ciurAux (h:t) = h : (ciurAux (filter(\n -> n `rem` h /= 0) t))

-- Ordonare prin Cemprehensiune
ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [h] = True
ordonataNat list = and [a <= b | (a, b) <- zip list (tail list)]


ordonataNat2 :: [Int] -> Bool
ordonataNat2 [] = True
ordonataNat2 [h] = True
ordonataNat2 (h:t)
      | h < head t = True && ordonataNat2 t
      | otherwise = False && ordonataNat2 t

ordonata :: [a] -> (a -> a -> Bool) -> Bool
ordonata list binRel = and [binRel a b | (a, b) <- zip list (tail list)]

--
-- (*<*) :: (Integer, Integer) -> (Integer, Integer) -> Bool
-- (a, b) *<* (c, d) = a < c && b > d


computeList :: (b -> c) -> [(a -> b)] -> [(a -> c)]
computeList f fList = map (f .) fList


aplicaList :: a -> [(a -> b)] -> [b]
aplicaList arg fList = map (\f -> f arg) fList
