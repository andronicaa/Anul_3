import Data.Char
import Data.List


-- 1.
rotate :: Int -> [Char] -> [Char]
rotate nr_rot str
    | nr_rot < 0 = error "Numarul este negativ"
    | nr_rot > length(str) = error "Numarul este strict mai mare decat lungimea cuvantului"
    | otherwise = drop nr_rot str ++ take nr_rot str

-- drop - returneaza sirul fara primele nr_rot caractere - returneaza sufixul
-- take - ia primele nr_rot caractere din string - returneaza prefixul format fin primele n litere
-- 2.
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l - m) (rotate m str) == str
                        where l = length str
                              m = if l == 0 then 0 else k `mod` l
-- 3.
makeKey :: Int -> [(Char, Char)]
makeKey nr_rot = zip alfabet (rotate nr_rot alfabet)
      where
        alfabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- 4.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp ch list_p
    | length l == 0 = ch
    | otherwise = head l
    where
      l = map snd (filter (\(a, b) -> ch == a) list_p)

lookUp1 :: Char -> [(Char, Char)] -> Char
lookUp1 ch [] = ch
lookUp1 ch (x:xs) = if ch == fst x then snd x else lookUp1 ch xs

-- 5.
encipher :: Int -> Char -> Char
encipher nr_rot ch = lookUp ch (makeKey nr_rot)

-- 6.
normalize :: String -> String
normalize "" = ""
normalize (x:xs)
    | elem x alfabet_mare || elem x cifre = [x] ++ normalize xs
    | elem x alfabet_mic = [toUpper(x)] ++ normalize xs
    | otherwise = normalize xs
    where
      alfabet_mic = "abcdefghijklmnopqrstuvwxyz"
      alfabet_mare = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      cifre = "0123456789"

-- 7.
encipherStr :: Int -> String -> String
encipherStr nr_rot str = [encipher nr_rot ch | ch <- normalize str]

-- 8.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey l = map(\(a, b) -> (b, a)) l

-- 9.
decipher :: Int -> Char -> Char
decipher nr_rot ch = lookUp ch (reverseKey(makeKey nr_rot))

decipherStr :: Int -> String -> String
decipherStr nr_rot l = [decipher nr_rot ch | ch <- normalize l]
