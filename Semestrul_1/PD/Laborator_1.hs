maxim :: Integer -> Integer -> Integer
maxim x y =
  if (x > y)
    then x
    else y
maxim3 :: Integer -> Integer -> Integer ->Integer
maxim3 x y z = maxim x (maxim y z)

-- 1. Functie cu 2 parametri care calculeaza suma patratelor celor 2 numere

sumaPatrate :: Integer -> Integer -> Integer
sumaPatrate x y = x^2 + y^2


-- 2. Afiseaza daca un numar este par sau nu
isEvenOrOdd :: Integer -> String
isEvenOrOdd x = if x `mod` 2 == 0 then "Par" else "Impar"

-- 3. Factorialul unui numar
-- Varianta 1 -> folosind IF
factorial :: Integer -> Integer
factorial n = if n == 0 then 1 else n * factorial(n-1)

-- Varianta 2 -> folosint ecutatii
fact 0 = 1
fact n = n * fact(n-1)

-- Varianta 3 -> folosind cazuri
fact' n
  | n == 0 = 1
  | otherwise = n * fact'(n-1)

-- 4. Verifica daca primul parametru este mai mare decat dublul celui de-al doilea
check :: Integer -> Integer -> String
check x y = if x > 2 * y then "Da" else "Nu"
