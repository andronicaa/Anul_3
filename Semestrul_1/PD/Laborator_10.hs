import Control.Monad((<=<))

-- exercitiul 2
pos :: Int -> Bool
pos x = if (x >= 0) then True else False

foo :: Maybe Int -> Maybe Bool
foo mx = mx >>= (\x -> Just (pos x))

-- transformare in notatia do
foo1 :: Maybe Int -> Maybe Bool
foo1 mx = do
  x <- mx
  return $ pos x


-- exerctiul 3
-- definim o functie care aduna doua valori de tip maybe int
addM :: Maybe Int -> Maybe Int -> Maybe Int
addM mx my = do
  x <- mx
  y <- my
  return (x + y)


addSabl :: Maybe Int -> Maybe Int -> Maybe Int
addSabl (Just x) (Just y) = Just (x + y)
addSabl _ _ = Nothing



-- NOTATIA DO SI SECVENTIERE
-- sa se treaca in notatia do urmatoarele functii
cartesian_product xs ys = xs >>= (\x -> (ys >>= \y -> return (x, y)))

cartesian_product1 :: Maybe Int -> Maybe Int -> Maybe (Int, Int)
cartesian_product1 xs ys = do
  x <- xs
  y <- ys
  return (x, y)
