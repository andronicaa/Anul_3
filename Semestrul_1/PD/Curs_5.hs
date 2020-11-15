-- EXPRESII
-- data Exp = Lit Int
--           | Add Exp Exp
--           | Mul Exp Exp
--
-- showExp :: Exp -> String
-- showExp (Lit n) = show n
-- showExp (Add e1 e2) = par (showExp e1 ++ "+" ++ showExp e2)
-- showExp (Mul e1 e2) = par (showExp e1 ++ "*" ++ showExp e2)
--

--
-- instance Show Exp where
--   show = showExp
--
-- evalExp :: Exp -> Int
-- evalExp (Lit n) = n
-- evalExp (Add e1 e2) = evalExp e1 + evalExp e2
-- evalExp (Mul e1 e2) = evalExp e1 * evalExp e2
--
-- ex0 :: Exp
-- ex0 = Add (Lit 2) (Mul (Lit 3) (Lit 3))

-- EXPRESII CU OPERATORI
data Exp1 = Lit Int
          | Exp1 :+: Exp1
          | Exp1 :*: Exp1

showExp1 :: Exp1 -> String
showExp1 (Lit n) = show n
showExp1 (e1 :+: e2) = par (showExp1 e1 ++ "+" ++ showExp1 e2)
showExp1 (e1 :*: e2) = par (showExp1 e1 ++ "*" ++ showExp1 e2)

evalExp1 :: Exp1 -> Int
evalExp1 (Lit n) = n
evalExp1 (e1 :+: e2) = evalExp1 e1 + evalExp1 e2
evalExp1 (e1 :*: e2) = evalExp1 e1 * evalExp1 e2

ex1 :: Exp1
ex1 = Lit 2 :+: (Lit 3 :*: Lit 3)

par :: String -> String
par s = "(" ++ s ++ ")"
