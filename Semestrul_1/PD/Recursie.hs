-- Maximul dintr-o lista
maxim :: (Ord a) => [a] -> a
maxim [] = error "nu se poate face maxim pe lista vida"
maxim [x] = x
maxim (x:xs)
  | x > maxTail = x
  | otherwise = maxTail
  where
    maxTail = maxim xs

maxim' :: (Ord a) => [a] -> a
maxim' [] = error "nu se poate face maxim pe lista vida"
maxim' [x] = x
maxim' (x:xs) = max x $ maxim' xs

-- Replicate
replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n x
    | n <= 0 = []
    | otherwise = x : replicate' (n-1) x

-- Implementarea lui take
take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n _
    | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x : take' (n-1) xs


-- Implementarea lui reverse
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]
