-- functii de nivel inalt
compareWithHundred :: (Num a, Ord a) => a -> Ordering
compareWithHundred = compare 100

divideByTen :: (Floating a) => a -> a
divideByTen = (/10)

isUpperAlpha :: Char -> Bool
isUpperAlpha = (`elem` ['A'..'Z'])

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

-- Implementarea lui flip
flip' :: (a -> b -> c) -> (b -> a -> c)
flip' f = g
    where
      g x y = f y x


-- Map and filters
largestDivisible :: (Integral a) => a
largestDivisible = head (filter p [100000,99999..])
    where
      p x = x `mod` 3829 == 0
