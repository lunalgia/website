import Queue ( Queue, enqueue, dequeue, empty, fromList, toList )
import Data.List(sort)

{-
Assume m >= 2, r < n, r >= 0.  
There are n people in a circle, numbered 1 to n. 
Kill every mth person starting from 1, for r rounds.
Compute who survive and who get killed.  
-}

vanadurga :: Int -> Int -> Int -> ([Int], [Int])
vanadurga m r n     = (sort $ toList surv, sort $ toList dead) where 
    (surv, dead)    = kill m r n (fromList [1..n], empty)

kill :: Int -> Int -> Int -> (Queue Int, Queue Int) -> (Queue Int, Queue Int)
kill m r n (surv, dead)
  | r == 0 = (surv, dead)
  | otherwise = kill m (r-1) (n-1) $ 
                shift (m-1 `mod` n) (surv, dead)
  
shift :: Int -> (Queue Int, Queue Int) -> (Queue Int, Queue Int)
shift k (surv, dead)
  | k == 0 = (surv', enqueue x dead)
  | otherwise = shift (k-1) (enqueue x surv', dead) where
    (x, surv') = dequeue surv
 
processLine :: String -> IO () 
processLine line = do 
    let [m, r, n] = map read (words line) :: [Int]
    let (surv, dead) = vanadurga m r n
    putStrLn $ "The survivors are: " ++ show surv ++ "\n" ++ 
                    "The dead ones are: " ++ show dead
                    