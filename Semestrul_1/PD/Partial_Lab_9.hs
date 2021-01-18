import Data.Char
import Control.Monad (forM, forM_)


prelStr strin = map toUpper strin
ioString = do
  strin <- getLine
  putStrLn $ "Intrare\n" ++ strin
  let strout = prelStr strin
  putStrLn $ "Iesire\n" ++ strout


prelNo noin = sqrt noin
ioNumber = do
  noin <- readLn :: IO Double
  putStrLn $ "Intrare\n" ++ (show noin)
  let noout = prelNo noin
  putStrLn $ "Iesire"
  print noout




type Nume = String
type Varsta = Int

-- retinem o persoana
data Persoana = Persoana Nume Varsta
  deriving Eq

instance Ord Persoana where
  -- compararea a doua persoane se face prin compararea varstelor
  (Persoana _ v1) <= (Persoana _ v2) = v1 <= v2


-- citest datele despre persoane de la tastatura

citestePersoana :: IO Persoana
citestePersoana = do
  putStr "Nume: "
  nume <- getLine
  putStr "Varsta: "
  varsta <- readLn :: IO Int
  return $ Persoana nume varsta



citesteNrPersoane :: Int -> IO()
citesteNrPersoane n =
  forM_ [1..n] $ \_ -> do
    citestePersoana


maxVarstaPersoane :: [Persoana] -> IO()
maxVarstaPersoane persoane = do
  let maxPersoana = maximum persoane
  -- ii extrag numele si Varsta
  let (Persoana nume varsta) = maxPersoana
  -- afisare
  putStr $ "Cel mai in varsta este " ++ nume
  putStrLn $ "(" ++ show varsta ++ " de ani)"



-- Exercitiul 3
estePalindrom :: Int -> Bool
estePalindrom n =
    let
      sir = show n
    in
      sir == reverse sir

citesteNumar :: IO()
citesteNumar = do
  nr <- readLn
  if estePalindrom nr then
    putStrLn $ show nr ++ " este palindrom"
  else
    putStrLn $ show nr ++ " nu este palindrom"


suntPalindroame :: Int -> IO()
suntPalindroame n =
  forM_ [1..n] $ \_ -> do
    citesteNumar
