import Control.Monad ( replicateM )
import System.Random ( randomRIO )
import System.IO ( hFlush, stdout, hSetBuffering, stdin, BufferMode(LineBuffering) )
import Text.Read ( readMaybe )
import BST ( BST, emptyBST, fromListL, insertBST, deleteBST, searchBST )

testBST :: IO ()
testBST = do 
    hSetBuffering stdin LineBuffering
    putStrLn "Test BST operations!"
    putStrLn "We start with the empty tree." 
    putStrLn "Your commands are C xx / I num / D num / S num / P / X" 
    putStrLn "C xx will create a random BST of size xx in [1..25]. Entries are in the range [0..999]"
    putStrLn "I num will insert num :: Int into the tree"
    putStrLn "D num and S num stand for Delete and Search"
    putStrLn "P will print the tree, and X will exit the app"
    go emptyBST where 

    go :: BST Int -> IO ()
    go t   = do 
        putStr "Your wish is my command: "
        hFlush stdout
        inp <- getLine
        let (cmd:args) = words inp
        if cmd `elem` ["P", "X"] 
        then if length args /= 0
            then do
                putStrLn $ cmd ++ " cannot have arguments. Try again." 
                go t
            else case cmd of
                "P" -> do
                    putStrLn "Here is your current tree."
                    print t
                    go t 
                "X" -> putStrLn "Exiting ... goodbye!"
        else if cmd `elem` ["C", "I", "D", "S"]
            then if length args /= 1
                then do
                    putStrLn $ cmd ++ " has one argument. Try again." 
                    go t  
                else do
                    let (arg:_) = args
                    let mval = readMaybe arg :: Maybe Int
                    case mval of
                        Nothing -> do
                            putStrLn $ cmd ++ " takes an Int argument. Try again."
                            go t
                        Just v -> case cmd of 
                            "C" -> if v <= 0 || v > 25
                                then do
                                    putStrLn "Argument of C should be in [1..25]. Try again."
                                    go t 
                                else do
                                    xs <- replicateM v (randomRIO (0, 999))
                                    let t0 = fromListL xs
                                    putStrLn "Your new tree is the following."
                                    print t0
                                    go t0
                            "I" -> go (insertBST v t)
                            "D" -> go (deleteBST v t)
                            "S" -> if searchBST v t
                                    then do 
                                        putStrLn $ show v ++ " is in the tree."
                                        go t 
                                    else do 
                                        putStrLn $ show v ++ " is not in the tree."
                                        go t
            else do 
                putStrLn "Wrong command chosen. Try again."
                go t 

                                
main :: IO () 
main = testBST
