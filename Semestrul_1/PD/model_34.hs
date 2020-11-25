


-- pentru doua liste date calculeaza suma produselor de forma
-- xi^2 * yi^2
-- pentru listele de lungimi diferite se arunca o eroare
-- se folosesc doar functii de nivel inalt
sumPatrate :: [Int] -> [Int] -> Int
sumPatrate list1 list2 =
      if (length list1) == (length list2) then
        let
           x1 = map (^2) list1
           y1 = map (^2) list2
           perechi = zip x1 y1
           produse = map (\(a, b) -> a * b) perechi
        in
           foldr (+) 0 produse
      else
        error "Listele trebuie sa aiba aceeasi lungime"
