main1, main2, main3, main4, main5, main6, main7 :: IO () 

main1 = putStr "Hello, world!\n"

main2 = do 
    putStrLn "Hello!"
    putStrLn "What's your name?"

main3 = let fibs = 0:1:zipWith (+) fibs (drop 1 fibs) in do 
    putStrLn $ show (fibs!!5)
    putStrLn $ show (fibs!!10)

main4 = do 
    act1; act2 where
    act1 = putStr "Hello, "
    act2 = putStrLn "world!"

main5 = do 
    putStrLn "Enter your name!"
    n <- getLine 
    m <- getLine
    putStrLn $ "Hello, "++ n ++ " and " ++ m ++ "!"
    getLine 
    putStrLn "Done!"

main6 = 
    putStrLn "Enter your name!" >> 
    getLine >>= \n -> 
        getLine >>= \m -> 
            putStrLn $ "Hello, " ++ n ++ " and " ++ m ++ "!"

doOften :: Int -> IO a -> IO () 
doOften n a 
    | n == 0    = return ()
    | otherwise = do {a; doOften (n-1) a}

printOften :: Int -> String -> IO () 
printOften n str = doOften n (putStrLn str)

main7 = do 
    n <- getLine 
    printOften 10 n