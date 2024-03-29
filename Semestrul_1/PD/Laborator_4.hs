import Numeric.Natural
-- 1.a
produsRec :: [Integer] -> Integer
produsRec [] = 1
produsRec (h:t) = h * (produsRec t)

-- 1.b
produsFold :: [Integer] -> Integer
produsFold  = foldr (*) 1

-- 2.a
andRec :: [Bool] -> Bool
andRec (x:xs) = x && (andRec xs)

-- 2.b
andFold :: [Bool] -> Bool
andFold = foldr (&&) True

-- 3.a
concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (x:xs) = x ++ (concatRec xs)
-- 3.b
concatFold :: [[a]] -> [a]
concatFold = foldr (++) []


-- 4.a
rmChar :: Char -> String -> String
rmChar c = filter (/=c)

-- 4.b
rmCharsRec :: String -> String -> String
rmCharsRec "" = id
rmCharsRec (x:xs) = rmChar x . rmCharsRec xs



test_rmchars :: Bool
test_rmchars = rmCharsRec ['a'..'l'] "fotbal" == "ot"

 -- 4.c ??
rmCharsFold :: String -> String -> String
rmCharsFold ch x = foldr rmChar ch x
--
--
--
-- logistic :: Num a => a -> a -> Natural -> a
-- logistic rate start = f
--   where
--     f 0 = start
--     f n = rate * f (n - 1) * (1 - f (n - 1))
--
--
--
--
-- logistic0 :: Fractional a => Natural -> a
-- logistic0 = logistic 3.741 0.00079
-- ex1 :: Natural
-- ex1 = undefined
--
--
-- ex20 :: Fractional a => [a]
-- ex20 = [1, logistic0 ex1, 3]
--
-- ex21 :: Fractional a => a
-- ex21 = head ex20
--
-- ex22 :: Fractional a => a
-- ex22 = ex20 !! 2
--
-- ex23 :: Fractional a => [a]
-- ex23 = drop 2 ex20
--
-- ex24 :: Fractional a => [a]
-- ex24 = tail ex20
--
--
-- ex31 :: Natural -> Bool
-- ex31 x = x < 7 || logistic0 (ex1 + x) > 2
--
-- ex32 :: Natural -> Bool
-- ex32 x = logistic0 (ex1 + x) > 2 || x < 7
-- ex33 :: Bool
-- ex33 = ex31 5
--
-- ex34 :: Bool
-- ex34 = ex31 7
--
-- ex35 :: Bool
-- ex35 = ex32 5
--
-- ex36 :: Bool
-- ex36 = ex32 7
