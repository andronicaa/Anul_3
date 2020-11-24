import Data.Char
import Data.List.Split
-- 1. scrieti un predicat care verifica ca un sir de caractere este format doar din cifre
onlyDigit :: String -> Bool
onlyDigit x = x == (filter isDigit x)

-- 2. scrieti o functie care are ca argument un sir de caractere si intoarce cel mai
-- lung prefix format doar din cifre
-- cu recursivitate
prefDigit :: String -> String
prefDigit "" = ""
prefDigit (x:xs) = if isDigit x then (x : prefDigit xs) else ""


-- 3. functie care are ca argument un sir de caractere format numai din cifre si intoarce numarul coresp
-- intoarce 0 pt sirul vid
-- fara recursie
digitToNumber :: String -> Int
digitToNumber chr = addDigit list
                    where
                      list = map digitToInt chr
                      addDigit [] = 0
                      addDigit (x:xs) = x * nrCifre + addDigit xs
                                        where
                                           nrCifre = 10 ^ (length xs)


-- 4 functie care are ca argument un sir de caractere si intoarce
-- subsirul obtinut prin eliminarea tuturor caracterelor care nu sunt cifre
-- fara recursivitate sau descrieri de liste
elimCifre :: String -> String
elimCifre chr = filter isAlpha chr

numarMinus :: String -> Int
numarMinus [] = 0
numarMinus (x:xs) = if x == '-' then 1 + numarMinus xs else 0

verifSemn :: Int -> Int
verifSemn nr
  | nr == 0 = 1
  | even nr = 1
  | otherwise = 0

elimMinus :: String -> String
elimMinus [] = ""
elimMinus (x:xs) = if x == '-' then elimMinus xs else (x:xs)


-- 5
parseTerm :: String -> Int
parseTerm exp1 = if (verifSemn (numarMinus exp1)) == 1 then digitToNumber (prefDigit (elimMinus exp1)) else digitToNumber (prefDigit (elimMinus exp1)) * (-1)


-- 6
-- scrieti o functie care are ca argument o expresie si intoarce
-- lista termenilor
-- termenii sunt delimitati prin +

splitWhenPlus :: String -> [String]
splitWhenPlus = splitWhen isPlus

isPlus :: Char -> Bool
isPlus ch = if ch == '+' then True else False


-- functie care primeste ca argument o expresie si o evalueaza
eval :: String -> Int
eval expr = sum listT
        where
          listT = map parseTerm (splitWhenPlus expr)
