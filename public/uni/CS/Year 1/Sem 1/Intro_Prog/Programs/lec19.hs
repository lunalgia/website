import System.Random ( randomRIO )
import Control.Monad ( replicateM )
import System.IO ( hFlush, stdout, isEOF )

-- Merge sort, simple version

merge :: Ord a => [a] -> [a] -> [a]
merge []        ys      = ys
merge xs        []      = xs 
merge (x:xs)    (y:ys)  = case compare x y of 
    LT -> x : merge xs (y:ys)
    EQ -> x : merge xs (y:ys)
    GT -> y : merge (x:xs) ys

mSort :: Ord a => [a] -> [a]
mSort []    = []
mSort [x]   = [x]
mSort l     = merge (mSort f) (mSort b) where 
    n       = length l `div` 2
    (f,b)   = splitAt n l

-- Merge sort, library version

runs :: Ord a => [a] -> [[a]]
runs []         = [[]]
runs [x]        = [[x]]
runs (x:y:ys) = if x > y
    then descending y [x] ys
    else ascending  y (x:) ys

-- Strictly decreasing run, built up reversed in an accumulator
descending :: Ord a => a -> [a] -> [a] -> [[a]]
descending x xs []          = [x:xs]
descending x xs l@(y:ys)    = if x > y 
    then descending y (x:xs) ys
    else (x:xs) : runs l

-- Non-decreasing run, built up with a function argument that prepends elements in order
ascending :: Ord a => a -> ([a] -> [a]) -> [a] -> [[a]]
ascending x f []            = [f [x]]
ascending x f l@(y:ys)      = if x <= y 
    then ascending y (f . (x:)) ys
    else f [x] : runs l

mergePairs :: Ord a => [[a]] -> [[a]]
mergePairs []           = []
mergePairs [l]          = [l]
mergePairs (l1:l2:ls)   = merge l1 l2: mergePairs ls 

mergeAll :: Ord a => [[a]] -> [a]
mergeAll []         = []
mergeAll [l]        = l 
mergeAll xs         = mergeAll (mergePairs xs)

mSort' :: Ord a => [a] -> [a]
mSort' = mergeAll . runs

-- Quick sort, avoids merge

partition :: (a -> Bool) -> [a] -> ([a], [a])
partition p xs  = go xs where 
    go []       = ([], [])
    go (x:xs)   = let (f,b) = go xs in if p x then (x:f,b) else (f,x:b)

qSort :: Ord a => [a] -> [a]
qSort []        = []
qSort (x:xs)    = qSort f ++ [x] ++ qSort b where
    (f,b)       = partition (<= x) xs

-- Interface to test sorting. Change the call to mSort' to mSort or qSort, as you wish.

randInts :: IO [Integer]
randInts = randomRIO (0, 500) >>= \n -> 
    replicateM n (randomRIO (-500, 499))

randStrings :: IO [String] 
randStrings = do 
    n <- randomRIO (0,500)
    replicateM n go where 
    go = replicateM 8 (randomRIO ('a', 'z'))

testSort :: IO ()
testSort = do 
    putStr "Test sort with Integers or Strings, or exit (I/S/X): "
    hFlush stdout 
    go1 where 

    go1 :: IO ()
    go1 = do 
        resp1 <- getChar 
        putStrLn ""
        case resp1 of 
            'I' -> do {xs <- randInts; go2 xs}
            'S' -> do {xs <- randStrings; go2 xs} 
            'X' -> putStrLn "\nExiting!" 
            _ -> do {putStr "\nExpecting I or S or X. Re-enter! "; go1}

    go2 :: (Ord a, Show a) => [a] -> IO ()
    go2 xs = do 
        putStrLn "\nThe original list is:"
        print xs
        putStrLn "\nThe sorted list is:"
        print (mSort' xs)
        putStrLn ""
        testSort
