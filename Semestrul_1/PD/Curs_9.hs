import Data.Char

newtype Writer log a = Writer { runWriter :: (a, log) }
-- newtype se foloseste cand avem un singur parametru
logIncrement :: Int -> Writer String Int
logIncrement x = Writer (x + 1, "Called increment with argument " ++ show x ++ "\n")


showInteger :: Int -> IO()
showInteger n = putStr(show n)
showPlusZece n = showInteger n >> return (n + 10)
