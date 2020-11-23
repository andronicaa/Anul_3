data Pereche = P Int Int deriving (Show)
data Lista = L [Pereche] deriving (Show)
data Expresie = I Int | Add Expresie Expresie | Mul Expresie Expresie

class ClassExp m where
  toExp :: m -> Expresie

instance ClassExp Lista where
  toExp (L list) = toExp1 (fromLtoList (L list))
                where
                  toExp1 [(P a b)] = Mul (I a) (I b)
                  toExp1 ((P a b):(P c d):xs) = Add (Mul (I a)(I b))(Add (Mul (I c)(I d)) (toExp1 xs))


l1 = L [P 1 2, P 3 4, P 4 5]
fromLtoList :: Lista -> [Pereche]
fromLtoList (L list) = list

l2 = fromLtoList l1

exp2 = toExp l1
instance Show Expresie where
  show = showExp

showExp :: Expresie -> String
showExp (I a) = show a
showExp (Add ex1 ex2) = par(showExp ex1 ++ " + " ++ showExp ex2)
showExp (Mul ex1 ex2) = par(showExp ex1 ++ " * " ++ showExp ex2)

par :: String -> String
par x = "(" ++ x ++ ")"
