-- Variabilele pot fi legate print "pattern matching"
h x | x == 0 = 0
    | x == 1 = y + 1
    | x == 2 = y * y
    | otherwise = y
  where y = x * x

-- sau prin "Expresii case"

f x = case x of
             0 -> 0
             1 -> y + 1
             2 -> y * y
             _ -> y
  where y = x * x


-- RECURSIVITATE
-- Fibonacci
fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n
    | n < 2 = n
    | otherwise = fibonacciCazuri(n-1) + fibonacciCazuri(n-2)

-- Fibonacci in stil ecuational
fibonacciEcuational :: Integer -> Integer
fibonacciEcuational 0 = 0
fibonacciEcuational 1 = 1
fibonacciEcuational n =
    fibonacciEcuational(n-1) + fibonacciEcuational(n-2)


-- Fibonacci pereche
fibonacciLiniar :: Integer -> Integer
fibonacciLiniar 0 = 0
fibonacciLiniar n = snd (fibonacciPereche n)
  where
    fibonacciPereche :: Integer -> (Integer -> Integer)
    fibonacciPereche 1 = (0, 1)
    fibonacciPereche n = let (a, b) = fibonacciPereche(n - 1) in (b , a + b)
