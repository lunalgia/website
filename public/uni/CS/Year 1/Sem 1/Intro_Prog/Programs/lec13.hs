data Day = Sun | Mon | Tue | Wed | Thu | Fri | Sat 
    deriving (Eq, Ord, Show, Enum)

data Shape = Circle Double | Square Double | Rectangle Double Double 
    deriving (Eq)

instance Show Shape where 
    show :: Shape -> String
    show (Circle r) = "Circle with radius " ++ show r
    show (Square s) = "Square with side " ++ show s
    show (Rectangle l b) = "Rectangle with length " ++ show l ++ " breadth " ++ show b

shapes :: [Shape]
shapes = [Circle 3.0, Square 4.0, Rectangle 3.0 4.0]

weekend :: Day -> Bool 
weekend Sat = True 
weekend Sun = True
weekend _   = False 

weekend2 :: Day -> Bool
weekend2 d = d == Sat || d == Sun 

area :: Shape -> Double 
area (Circle r)         = pi * r * r 
area (Square s)         = s * s 
area (Rectangle l b)    = l * b  

-- instance Eq Shape where 
--     (==) :: Shape -> Shape -> Bool
    -- shape1 == shape2 = area shape1 == area shape2
    -- sh1@(Circle _)      == sh2@(Circle _)       = area sh1 == area sh2 
    -- sh1@(Square _)      == sh2@(Square _)       = area sh1 == area sh2 
    -- sh1@(Rectangle _ _) == sh2@(Rectangle _ _)  = area sh1 == area sh2 
    -- _                   == _                    = False 
    -- sh1 == sh2 = words (show sh1)!!0 == words (show sh2)!!0 && area sh1 == area sh2 

-- instance Ord Shape where 
--     compare :: Shape -> Shape -> Ordering
--     compare shape1 shape2 = compare (area shape1) (area shape2)

data ML a = Nil | Cons a (ML a) 
    deriving (Eq, Ord)

fromList :: [a] -> ML a 
fromList = foldr Cons Nil

toList :: ML a -> [a]
toList Nil = []
toList (Cons x xs) = x : toList xs 

instance Show a => Show (ML a) where 
    show :: Show a => ML a -> String
    show = show . toList 
