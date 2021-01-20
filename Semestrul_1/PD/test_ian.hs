import Control.Monad

data Arb a = Leaf a | Node (Arb a) (Arb a) (Arb a)
    deriving (Show)

data Direction = L | M | R

tree = Node (Node (Leaf 1) (Leaf 3) (Leaf 4)) (Node (Leaf 1) (Leaf 2) (Leaf 4)) (Leaf 4)

data WriterArbore a = Writer { output :: [(Integer,[Direction])], value :: a }


instance  Monad WriterArbore where
  return (Leaf fr) (Direction dr) = Writer ([Leaf fr, [Direction dr]])
  ma >>= k = let (va, log1) = output ma
                 (vb, log2) = output (k va)
             in  Writer (vb, log1 ++ log2)


-- instanta pentru monada Applicative
instance  Applicative WriterArbore where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)

instance  Functor WriterArbore where
  fmap f ma = pure f <*> ma
