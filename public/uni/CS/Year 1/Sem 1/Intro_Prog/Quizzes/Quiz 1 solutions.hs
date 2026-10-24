-- Q1) make a function that drops the odd index elements of a list, recursively
-- >>> dropOdds [1,2,3,4,5]
-- [1,3,5]

-- A1)
dropOdds :: [a] -> [a]
dropOdds [] = []
dropOdds [x] = [x]
dropOdds (x:y:ys) = x:dropOdds ys


-- Q2) make a function that takes xs (a list of lists of numbers) 
-- and returns the list of sums of the members of the nonempty lists in xs 
-- >>> sums [[1..5], [], [2,6]] 
-- [15,8]

-- A2) 
sums :: Num a => [[a]] -> [a]
sums ls = [ sum l | l@(_:_) <- ls ]

-- Q3)
f xs = foldr (/=) False xs
-- find the type of f 
-- Compute f on two example inputs

-- A3)
-- >>> :t f 
-- f :: Foldable t => t Bool -> Bool
-- >>> f [False, False, False, False] 
-- False
-- >>> f [True, False, False, False]
-- True

-- Q4) Given the decimal expansions of two numbers, compute the decimal expansion of their sum
-- >>> add [0,8,5,3,3] [0,2,8,6,8]
-- [1,1,4,0,1]

-- A4)
addWithCarry :: [Int] -> [Int] -> ([Int], Int)
addWithCarry [] [] = ([], 0)
addWithCarry (x:xs) (y:ys) = let 
    (prevSum, prevCarry) = addWithCarry xs ys
    (newCarry, newDigit) = (x+y+prevCarry) `divMod` 10 
    in (newDigit : prevSum, newCarry)

add :: [Int] -> [Int] -> [Int]
add xs ys = fst $ addWithCarry xs ys
