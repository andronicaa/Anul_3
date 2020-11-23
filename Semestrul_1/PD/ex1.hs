data Pereche a b = MyP a b
                  deriving (Show)

data ListaP a = MyL [a]
                deriving (Show)

class MyMapping m where
  mymap :: m (Pereche a b) -> m (Pereche b a)
  -- myfilter :: (Pereche a b -> Bool) -> m (Pereche a b) -> m (Pereche a b)

lp :: ListaP (Pereche Int Char)
lp = MyL [MyP 97 'a', MyP 3 'b', MyP 100 'd']


instance MyMapping ListaP where
  mymap (MyL ((MyP a b):xs)) = MyL ((MyP b a) : (mymap xs))
