-- ARBORI
data BinaryTree a = Empty
                  | Node (BinaryTree a) a (BinaryTree a)
                  | deriving Show

-- Scrieti o functie care determina inaltimea unui arbore
height :: BinaryTree a -> Int
height Empty = 0
height (Node l _ r) = 1 + max (height l) (height r)
