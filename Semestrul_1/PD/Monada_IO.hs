type Input = String
type Output = String
newType MyIO a = MyIO { runMyIO :: Input -> (a, Input, Output) }
