main :: IO ()
main = do
    putStrLn "I will guess your number! Choose an integer from 1 to 100"
    guessNumber 1 100


guessNumber :: Integer -> Integer -> IO ()
guessNumber l h
    | l >= h = putStrLn ("Your number is " ++ show l ++ "!")
    | otherwise = 
        do
            putStrLn ("Is it " ++ show midPoint ++ "? (Enter l if your number is lower, h if its higher, and e if its equal)")
            putStr "Your input: "
            inp <- getLine
            case inp of
                "e" -> putStrLn "Found it!"
                "l" -> guessNumber l (midPoint - 1)
                "h" -> guessNumber (midPoint + 1) h
                _ -> do
                    putStrLn "Invalid input!"
                    guessNumber l h
    where
        midPoint = (l + h) `div` 2

