import Control.Monad (forM, forM_)
import Data.Char

-- Exemplul 1
-- citirea de la tastatura a unui sir si afisarea rezultatului obtinut dupa prelucrare
-- prelStr str = map toUpper str
-- main = do
--   str <- getLine
--   putStrLn $ "Intrare\n" ++ str
--   let strout = prelStr str
--   putStrLn $ "Iesire\n" ++ strout


-- Exemplul 2
-- citirea de la tastatura a unui numar si afisarea rezultatului obtinut dupa prelucare
-- prelNo noin = sqrt noin
-- ioNumber = do
--   noin <- readLn :: IO Double
--   putStrLn $ "Intrare\n" ++ (show noin)
--   let noout = prelNo noin
--   putStrLn $ "Iesire"
--   print noout


-- Exercitiul 1
type Nume = String
type Varsta = Int

data Persoana = Persoana Nume Varsta
  deriving Eq

instance Ord Persoana where
  (Persoana _ v1) = (Persoana _ v2) = v1 <= v2

-- citesc persoane de la tastatura
citestePersoana :: Io Persoana
citestePersoana = do
  putStr "Nume: "
  nume <- getLine
  putStr "Varsta: "
  varsta <- readLn :: IO Int
  return $ Persoana nume varsta


-- citest n persoane de la tastatura
citesteNPersoane :: IO [Persoana]
citesteNPersoane = do
  putStr "n = "
  n <- readLn :: IO Int
  -- trebuie sa citim cate o persoana
  forM [1..nr] $ \_ -> do
    citestePersoana

persB :: [Persoana] -> IO ()
persB persoane = do
  let ceamaiBatrana = maximum persoane
  let (Persoana nume varsta) = ceamaiBatrana
  -- afisare
  putStr $ "Cel mai in varsta este " ++ nume
  putStr $ " ( " ++ show varsta ++ " ani."


rezEx1 :: IO()
rezEx1 = do
  persoane <- citestePersoana
  persB persoane
