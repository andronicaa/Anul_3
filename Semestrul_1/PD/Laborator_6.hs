import Data.List (nub)
import Data.Maybe (fromJust)

data Fruct
    = Mar String Bool
    | Portocala String Int
      deriving(Show)
-- instance Show Fruct where
--   show (Mar s b) = "Marul " ++ s ++ (if b then " are vierme " else " nu are vierme ")
--   show (Portocala s i) = "Portocala " ++ s ++ " are " ++ show i ++ " felii"

ionatanFaraVierme = Mar "Ionatan" False
goldenCuVierme = Mar "Golden Delicious" True
portocalaSicilia10 = Portocala "Sanguinello" 10
listaFructe = [Mar "Ionatan" False, Portocala "Sanguinello" 10, Portocala "Valencia" 22, Mar "Golden Delicious" True, Portocala "Sanguinello" 15, Portocala "Moro" 12, Portocala "Tarocco" 3, Portocala "Moro" 12, Portocala "Valencia" 2, Mar "Golden Delicious" False, Mar "Golden" False, Mar "Golden" True]

-- 1.a
soiuriSicilia = ["Tarocco", "Moro", "Sanguinello"]
ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala soi f) = elem soi soiuriSicilia
ePortocalaDeSicilia (Mar soi v) = False

test_ePortocalaDeSicilia1 = ePortocalaDeSicilia (Portocala "Moro" 12) == True
test_ePortocalaDeSicilia2 = ePortocalaDeSicilia (Mar "Ionatan" True) == True

-- 1b
nrFeliiSicilia :: [Fruct] -> Int
-- varianta 1
-- nrFeliiSicilia [] = 0
-- nrFeliiSicilia (Mar _ _ : xs) = nrFeliiSicilia xs
-- nrFeliiSicilia (Portocala soi felii:xs) =
--   (if elem soi soiuriSicilia then
--     felii
--     else
--     0) + nrFeliiSicilia xs

-- varianta 2
nrFeliiSicilia [] = 0
nrFeliiSicilia(x@(Portocala s i):xs) =
  (if ePortocalaDeSicilia x then i else 0) + nrFeliiSicilia xs
nrFeliiSicilia (_:xs) = nrFeliiSicilia xs

-- varianca 3
nrFeliiSiciliaComp :: [Fruct] -> Int
nrFeliiSiciliaComp list = sum[i | x@(Portocala s i) <- list, ePortocalaDeSicilia x]

-- varianta 4
nrFeliiSiciliaHof :: [Fruct] -> Int
nrFeliiSiciliaHof list = foldr (+) 0 $ map(\(Portocala s i) -> i)(filter ePortocalaDeSicilia list)

-- test_nrFeliiSicilia = nrFeliiSicilia1 listaFructe == 52

--1.c
nrMereViermi :: [Fruct] -> Int
nrMereViermi l = sum [1 | (Mar soi v) <- l, v /= False]

test_nrMereViermi = nrMereViermi listaFructe == 2

type NumeA = String
type Rasa = String
data Animal = Pisica NumeA | Caine NumeA Rasa

-- 2.a
vorbeste :: Animal -> String
vorbeste (Pisica _) = "Meow!"
vorbeste (Caine _ _) = "Woof";

-- 2.b
rasa :: Animal -> Maybe String
rasa (Pisica _) = Nothing
rasa (Caine _ rasa) = Just rasa

type Nume = String
data Prop
    = Var Nume
    | F
    | T
    | Not Prop
    | Prop :|: Prop
    | Prop :&: Prop
    deriving (Eq, Read)
infixr 2 :|:
infixr 3 :&:

p1 :: Prop
p1 = (Var "P" :|: Var "Q") :&: (Var "P" :&: Var "Q")

p2 :: Prop
p2 = (Var "P" :|: Var "Q") :&: (Not (Var "P") :&: Not (Var "Q"))

p3 :: Prop
p3 = (Var "P" :&: (Var "Q" :|: Var "R")) :&: (Not (Var "P") :&: Not (Var "Q")) :&: (Not (Var "P") :&: Not (Var "R"))

instance Show Prop where
    show(Var n) = n
    show(F) = show "Fals"
    show(T) = show "Adevarat"
    show(Not p) = "(~" ++ show p ++ ")"
    show(p :|: q) = "(" ++ show p ++ "|" ++ show q ++ ")"
    show(p :&: q) = "(" ++ show p ++ "&" ++ show q ++ ")"

test_ShowProp :: Bool
test_ShowProp = show (Not (Var "P") :&: Var "Q") == "((~P)&Q)"

type Env = [(Nume, Bool)]

impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust . lookup a

-- modeleaza echivalenta de la logica
echiv :: Bool -> Bool -> Bool
echiv x y = x == y

-- modeleaza implicatia de la logica
impl :: Bool -> Bool -> Bool
impl False _ = True
impl _ x = x

eval :: Prop -> Env -> Bool
eval (Var x) env = impureLookup x env
eval T _ = True
eval F _ = False
eval (Not p) env = not $ eval p env
eval (p :|: q) env = eval p env || eval q env
eval (p :&: q) env = eval p env && eval q env


test_eval = eval  (Var "P" :|: Var "Q") [("P", True), ("Q", False)] == True


variabile :: Prop -> [Nume]
variabile (Var p) = [p]
variabile F = []
variabile T = []
variabile (Not p) = nub $ variabile p
variabile (p :&: q) = nub $ variabile p ++ variabile q
variabile (p :|: q) = nub $ variabile p ++ variabile q

test_variabile = variabile (Not (Var "P") :&: Var "Q") == ["P", "Q"]

envs :: [Nume] -> [Env]
envs [] = [[]]
envs (x:xs) = [(x, False) : e | e <- envs xs] ++
              [(x, True) : e | e <- envs xs]

test_envs =
      envs ["P", "Q"]
      ==
      [ [ ("P",False)
        , ("Q",False)
        ]
      , [ ("P",False)
        , ("Q",True)
        ]
      , [ ("P",True)
        , ("Q",False)
        ]
      , [ ("P",True)
        , ("Q",True)
        ]
      ]

satisfiabila :: Prop -> Bool
satisfiabila = or $ map(eval p) $ envs $ variabile p

test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q") == True
test_satisfiabila2 = satisfiabila (Not (Var "P") :&: Var "P") == False

valida :: Prop -> Bool
valida = undefined

test_valida1 = valida (Not (Var "P") :&: Var "Q") == False
test_valida2 = valida (Not (Var "P") :|: Var "P") == True
