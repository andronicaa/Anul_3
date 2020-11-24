data Piece = One | Two | Empty deriving(Show, Eq)
data Table = Table [Piece] [Piece] [Piece] deriving(Show, Eq)

table1 :: Table
table1 = Table [Empty, One, Two, One, Empty, Empty, Two, One]
               [Two, Empty, One, Two, One, Two, One, Two]
               [Two, Two, One, Empty, Empty, One, Two, One]

table2 :: Table
table2 = Table [Two, One, Two, One, Empty, Empty, Two, One]
               [Two, Empty, One, Two, One, Two, One, Two]
               [Two, Two, One, Empty, Empty, One, Two, One]

table3 :: Table
table3 = Table [Empty, One, Empty, Empty, Empty, Empty, Two, One]
               [Two, Empty, One, Two, One, Two, One, Two]
               [Two, Empty, One, Empty, Empty, One, Two, One]

table4 :: Table
table4 = Table [Empty,Empty,Two,One,Empty,Empty,Two,One]
               [Two,One,One,Two,One,Two,One,Two]
               [Two,Two,One,Empty,Empty,One,Two,One]

-- 1
nrPiese :: [Piece] -> Piece -> Integer
nrPiese [] _ = 0
nrPiese (x:xs) j
  | j == x = 1 + nrPiese xs j
  | otherwise = nrPiese xs j


validTable :: Table -> Bool
validTable (Table (a) (b) (c))
    | length a == 8 && length b == 8 && length c == 8 && (nrPiese a One + nrPiese b One + nrPiese c One) <= 9 && (nrPiese a Two + nrPiese b Two + nrPiese c Two) <= 9 = True
    | otherwise = False

test11 = validTable table1 == True
test12 = validTable table2 == False
test13 = validTable table3 == True


-- 2
data Position = P (Int, Int) deriving (Show, Eq)
-- functie care verifica daca o pozitie este valida
pozValida :: Position -> Bool
pozValida (P (x, y)) = x >=1 && x <= 3 && y >= 0 && y <= 7
-- trebuie sa verificam daca doua pozitii sunt conectate direct
-- fac un vector cu toate mutarile posibile din (a, b)
-- verific daca o valorea din el este egala cu punctul (c, d)
conectD :: Position -> Position -> Bool
conectD (P (a, b)) (P (c, d)) = let listMutari = filter pozValida [P (a + 1, b), P (a - 1, b), P(a, b + 1), P (a, b - 1)]
                                  in (P(c, d)) `elem` listMutari

move :: Table -> Position -> Position -> Maybe Table
move (Table (a) (b) (c)) (P (a, b)) (P (c, d))
  | conectD (P (a, b)) (P (c, d)) == False = Nothing
  |


formListaMutari :: Position -> [Position]
formListaMutari (P (a, b)) = filter pozValida [P (a + 1, b), P (a - 1, b), P(a, b + 1), P (a, b - 1)]



-- 3
-- data EitherWriter a = EW {getValue :: Wither String (a, String)}
