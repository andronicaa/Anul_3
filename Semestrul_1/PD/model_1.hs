import Data.List
type Linie = Integer
type Coloana = Integer

type Partida = [(Linie, Coloana)]

exemplu1 :: Partida
exemplu1 = [ (2, 2), (1, 3), (2, 3), (2, 4), (3, 5), (0, 2), (2, 1), (1, 4), (2, 0), (1, 2), (3, 1), (1, 0)]

-- 1.1
test11 :: Bool
test11 = separaX0 exemplu1 == ( [(2,2),(2,3),(3,5),(2,1),(2,0),(3,1)], [(1,3),(2,4),(0,2),(1,4),(1,2),(1,0)])
separaX0 :: [a] -> ([a], [a])
separaX0 [] = ([], [])
separaX0 (a:as) = (a:as2, as1)
  where
    (as1, as2) = separaX0 as


-- 1.2
-- maxList :: [[a]] -> [a]
maxList list = list !! pozMax
  where
    lungimiPozitii = [(length x, px) | (x, px) <- list `zip` [0..]]
    (_, pozMax) = maximum lungimiPozitii

-- Subiectul 2
data Binar a = Gol | Nod (Binar a) a (Binar a)
exemplu2 :: Binar (Int, Float)
exemplu2 = Nod (Nod (Nod Gol (2, 3.5) Gol) (4, 1.2) (Nod Gol (5, 2.4) Gol))(7, 1.9)(Nod Gol (9, 0.0) Gol)

data Directie = Stanga | Dreapta
type Drum = [Directie]

test211, test212 :: Bool
test211 = plimbare [Stanga, Dreapta] exemplu2 == Just (5, 2.4)
test212 = plimbare [Dreapta, Stanga] exemplu2 == Nothing

plimbare :: Drum -> Binar a -> Maybe a
plimbare _ Gol = Nothing
plimbare [] (Nod _ x _) = Just x
plimbare (Stanga:xs) (Nod arbL _ _) = plimbare xs arbL
plimbare (Dreapta:xs) (Nod _ _ arbR) = plimbare xs arbR
