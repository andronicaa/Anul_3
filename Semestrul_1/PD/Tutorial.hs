-- Pattern matching
-- de la cel mai particular la cel mai general
lucky :: (Integral a) => a -> String
lucky 7 = "felicitari"
lucky x = "imi pare rau"
