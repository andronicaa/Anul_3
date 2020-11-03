-- 1. Find the last element of a list
myLast :: [a] -> a
myLast [] = error "No end for empty list"
myLast [x] = x
myLast (_:xs) = myLast xs


-- 2. Find the last but one element of a list
myButLast :: [a] -> a
myButLast [] = error "Nu exista un penultim element"
myButLast [_] = error "Nu exista un penultim element"
myButLast [x, _] = x
myButLast (_: xs) = myButLast xs


-- 3. Find the k'th element of a list. The first element in the list if number 1
elementAt :: [a] -> Int -> a
elementAt list index = list !! (index - 1)

-- 4. Find the number of elements of a list
myLength :: [a] -> Int
myLength [] = 0
myLength (_:xs) = 1 + myLength xs

-- 5. Reverse a list
reverseMyList :: [a] -> [a]
reverseMyList [] = []
reverseMyList (x:xs) = reverseMyList xs ++ [x]


-- 6. Find out whether a list is a palindrom
isPalindrome :: [a] -> Bool
isPalindrome [] = True
isPalindrome [_] = True
isPalindrome (x:xs) = (x == (last xs)) && (isPalindrome $ init xs)
