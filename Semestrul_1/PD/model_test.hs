-- exercitiul 1
-- recursivitate
sfPropChar = ['.', '?', '!', ':']
sfChr :: Char -> [Char] -> Bool
sfChr ch sfPropChar = ch `elem` sfPropChar

sfProp :: [Char] -> Integer
sfProp [] = 0
sfProp (x:xs) = if (sfChr x sfPropChar) == True then 1 + sfProp xs else sfProp xs

-- descrieri de liste
sfPropComp :: [Char] -> Integer
sfPropComp list = sum [1 | x <- list , sfChr x sfPropChar]

-- exercitiul 2
liniiN :: [[Int]] -> Int -> Bool
liniiN matrix n = foldr (&&) True (map suntPozitiveToate lgN)
                  where
                    lgN :: [[Int]]
                    lgN = fst(filter ((snd== n) ) lgForEachList)
                    suntPozitiveToate :: [Int] -> Bool
                    suntPozitiveToate linie = foldr (&&) True (map (>0) linie)
                    where
                      lgListe :: [Int]
                      lgListe = map length matrix
                      lgForEachList :: [([Int], Int)]
                      lgForEachList = zip matrix lgListe


test = liniiN [[1, -2], [3, 5, 2], [1, 4, 1]] 3 == True


-- exercitiul 3
data Punct = Pt [Int]
             deriving Show

data Arb = Vid | F Int | N Arb Arb
            deriving Show

class ToFromArb a where
  toArb :: a -> Arb
  fromArb :: Arb -> a

instance ToFromArb Punct where
  toArb (Pt pct) = pointToArb pct
      where
        pointToArb [] = Vid
        pointToArb (x:xs) = N (F x) (pointToArb xs)

  fromArb arb = Pt (arbToPoint arb)
      where
        arbToPoint Vid = []
        arbToPoint (N (F x) subArb) = x : arbToPoint subArb
