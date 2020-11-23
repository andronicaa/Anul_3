data List a = Nil | a ::: List a
infixr 5 :::



(+++) :: List a -> List a -> List a
infixr 5 +++
Nil +++ ys = ys
(x ::: xs) +++ ys = x ::: (xs +++ ys)

list1 = 2 :::(3 ::: Nil)
list2 = 2 :::(3 ::: Nil)
-- egalitatea a doua liste
eqList :: Eq a => List a -> List a -> Bool
eqList Nil Nil = True
eqList (x ::: xs) (y ::: ys) = x == y && eqList xs ys
eqList _ _ = False

instance (Eq a) => Eq (List a) where
  (==) = eqList


showListt :: Show a => List a -> String
showListt Nil = "Nil"
showListt (x ::: xs) = show x ++ " , " ++ showListt xs



instance (Show a) => Show (List a) where
  show = showListt
a = 3 ::: (4 ::: 5 ::: Nil)
b = 6 ::: Nil

-- ARBORI DE CAUTARE
-- CLASE DE TIPURI
type Key = Int
type Value = String

newtype PairList = PairList {getPairList :: [(Key, Value)]}

pl = PairList[(1,"l1"),(2,"l2"),(3,"l3")]

class Collection c where
  cEmpty :: c
  cSingleton :: Key -> Value -> c
  cInsert :: Key -> Value -> c -> c
  cDelete :: Key -> c -> c
  cLookUp :: Key -> c -> Maybe Value
  cToList :: c -> [(Key, Value)]
  cKeys :: c -> [Key]
  cValues :: c -> [Value]
  cFromList :: [(Key, Value)] -> c
  cKeys c = [fst p | p <- cToList c]
  cValues c = [snd v | v <- cToList c]
  cFromList [] = cEmpty
  cFromList ((k, v) : es) = cInsert k v (cFromList es)

instance Show PairList where
  show (PairList ps) = "PairList" ++ (show ps)


-- trebuie sa facem Pairlist ca instanca a clasei Collection
instance Collection PairList where
  cEmpty = PairList []
  -- lista formata din cheia si valoarea data
  cSingleton k v = PairList [(k, v)]
  cInsert k v (PairList c) = PairList $ (k, v) : filter((/=k) . fst) c
  cLookUp k = lookup k . getPairList
  cDelete k (PairList c) = PairList $ filter ((/=k) . fst) c
  cToList = getPairList

data SearchTree = Empty | Node SearchTree Key (Maybe Value) SearchTree
                  deriving (Show)

instance Collection SearchTree where
  cEmpty = Empty
  -- arbore cu un singur nod - subarbore stang vid subarbore vid drept
  cSingleton k v = Node Empty k (Just v) Empty
  cInsert k v = go
    where
      -- daca arborele este gol => facem un arbore cu un singur nod
      go Empty = cSingleton k v
      go (Node subL k1 v1 subR)
        | k == k1 = Node subL k1 (Just v) subR
        | k < k1 = Node (go subL) k1 v1 subR
        | otherwise = Node subL k1 v1 (go subR)

  -- nu avem cum sa stergem efectiv un nod din arbore => il marcam nu Nothing si astfel stim ca acesta a fost sters
  cDelete k = go
    where
      go Empty = Empty
      go (Node subL k1 v1 subR)
        | k == k1 = Node subL k1 Nothing subR
        | k < k1 = Node (go subL) k1 v1 subR
        | otherwise = Node subL k1 v1 (go subR)

  -- functie pentru cautarea unei chei
  cLookUp k = go
    where
      go Empty = Nothing
      go (Node subL k1 v1 subR)
        | k == k1 = v1
        | k < k1 = go subL
        | otherwise = go subR

  cToList Empty = []
  cToList (Node subL k v subR) = cToList subL ++ prelc k v ++ cToList subR
      where
        prelc k (Just v) = [(k, v)]
        prelc _ _ = []



-- definirea functiei elem
elem1 x ys = foldr (||) False (map (== x ) ys)

type PunctX = Integer
type PunctY = Integer
data Point = Point PunctX PunctY

instance Show Point where
  show = showPunct
showPunct :: Point -> String
showPunct (Point p1 p2) = "Punctul are coordonatele " ++ show p1 ++ " si " ++ show p2
point1 = Point 1 2



-- tipul maybe
power :: Maybe Int -> Int -> Int
power Nothing n = 2 ^ n
power (Just m) n = m ^ n


-- folosirea unui rezultat optional
divide :: Int -> Int -> Maybe Int
divide n 0 = Nothing
divide n m = Just(n `div` m)

right :: Int -> Int -> Int
right n m = case divide n m of
                  Nothing -> 3
                  Just r -> r + 3
