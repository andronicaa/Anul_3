import Test.QuickCheck
myreverse :: [Int] -> [Int]
myreverse [] = []
myreverse (x:xs) = (myreverse xs) ++ [x]

prdef :: [Int] -> Bool
prdef xs = (myreverse xs == reverse xs)

wrongpr :: [Int] -> Bool
wrongpr xs = (myreverse xs == xs)

-- daca definim gresit functia de reverse
myreverseW :: [Int] -> [Int]
myreverseW [] = []
myreverseW (x:xs) = x : (myreverseW xs)

predefW :: [Int] -> Bool
predefW xs = (myreverseW xs == reverse xs)


-- clasa tipurilor mici
class MySmall a where
  smallValues :: [a]

instance MySmall Bool where
  smallValues = [True, False]

data Season = Spring | Summer | Autumn | Winter
              deriving Show

instance MySmall Season where
  smallValues = [Spring, Summer, Autumn, Winter]

instance MySmall Int where
  smallValues = [0, 12, 3, 45, 91, 100]

instance (MySmall s) => MySmall (a -> s) where
  smallValues = [const v | v <- smallValues]



-- clasa care contine o functie asemanatoare cu QuickCheck care testeaza daca o proprietate este adevarata pentru toate valorile unui tip "mic"

-- class MySmallcheck a where
--   smallValues1 :: [a]
--   smallCheck :: (a -> Bool) -> Bool
--   smallCheck prop = and [prop x | x <- smallValues1]
--   -- definitia minimala este cea pentru smallValues
--
-- instance MySmallcheck Int where
--   smallValues1 = [0, 12, 3, 45, 91, 100]
--



-- functia care gaseste valoarea la care se opreste testarea

class MySmallcheck a where
  smallValues1 :: [a]
  smallCheck :: (a -> Bool) -> Bool
  smallCheck prop = sc smallValues1
                        where
                          sc [] = True
                          sc (x:xs) = if (prop x) then (sc xs) else error ("s-a oprit la valoarea")


propInt :: Int -> Bool
propInt x = x < 90

propInt1 :: Int -> Bool
propInt1 x = x < 101

instance MySmallcheck Int where
  smallValues1 = [0, 12, 3, 45, 91, 100]



rval i = (7 * i + 3) `mod` 11

-- generarea unei secvente de numere aleatoare
genRandSeq 0 _ = []
genRandSeq n s = let news = rval s
                 in news : (genRandSeq (n-1) news)

-- secventa aleatoare este predictibila
