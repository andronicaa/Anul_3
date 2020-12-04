import Test.QuickCheck


double :: Int -> Int
double = (*2)
triple :: Int -> Int
triple = (*3)
penta :: Int -> Int
penta = (*5)

test x = (double x + triple x) == (penta x)
testW x = (double x + triple x) == (double x)

myLookUp :: Int -> [(Int,String)]-> Maybe String
myLookUp el [] = Nothing
myLookUp el (x:xs)
  | el == fst x = Just (snd x)
  | otherwise = myLookUp el xs

testLookUp :: Int -> [(Int,String)] -> Bool
testLookUp val list = lookup val list == myLookUp val list

testLookUpCond :: Int -> [(Int,String)] -> Property
testLookUpCond n list = n > 0 && n `div` 5 == 0 ==> testLookUp n list

quicksort :: Ord a => [a] -> [a]
quicksort []     = []
quicksort (x:xs) = smalls ++ [x] ++ bigs
                 where smalls = quicksort [n | n <- xs, n <= x]
                       bigs   = quicksort [n | n <- xs, n > x]


quicksortBuggy :: Ord a => [a] -> [a]
quicksortBuggy []     = []
quicksortBuggy (x:xs) = smalls ++ [x] ++ bigs
                where smalls = quicksortBuggy [n | n <- xs, n < x] -- oops
                      bigs   = quicksortBuggy [n | n <- xs, n > x]

data ElemIS = I Int | S String
     deriving (Show,Eq)

myLookUpElem :: Int -> [(Int,ElemIS)]-> Maybe ElemIS
myLookUpElem = undefined

testLookUpElem :: Int -> [(Int,ElemIS)] -> Bool
testLookUpElem = undefined
