cmp :: Ord a => a -> a -> Ordering 
cmp x y 
    | x < y = LT
    | x == y = EQ
    | x > y = GT 

le, eq :: Ord a => a -> a -> Bool 
le x y = compare x y /= GT 
eq x y = compare x y == EQ 
