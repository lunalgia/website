import Control.Monad ( forever, when )
import System.Exit ( exitSuccess )
import System.IO ( hFlush, stdout, isEOF )

myGetLine :: IO String 
myGetLine = do 
    c <- getChar 
    if (c == '\n') then return ""
    else do 
        cs <- myGetLine 
        return (c:cs)

ping :: Int -> Integer
ping n = go !! n where 
    go = 0:1:zipWith (+) go (drop 1 go)

main1 :: IO ()
main1 = do 
    putStr "Enter a number: "; hFlush stdout 
    n <- readLn :: IO Int 
    if (n < 0) then  
        putStrLn "Exiting. Good bye!"
    else do 
        putStrLn $ "The Pingala number at position " ++ 
                        show n ++ " is " ++ show (ping n)
        main1 

main2 :: IO ()
main2 = do 
    xs <- readIntList 
    print xs 

readIntList :: IO [Int]
readIntList = do 
    x <- readLn :: IO Int 
    if x < 0 then return [] else do 
        xs <- readIntList 
        return (x:xs)

main3 :: IO () 
main3 = go >>= print where 
    go :: IO [Int]
    go = do
        exitCond <- isEOF 
        if exitCond then return [] else do 
            x <- readLn :: IO Int 
            xs <- go 
            return (x:xs)

main4 :: IO () 
main4 = forever $ do 
    exitCond <- isEOF
    when exitCond exitSuccess  
    xs <- readLn :: IO [Int]
    print (reverse xs)

main :: IO ()
main = main4