import Control.Monad ( replicateM )
import System.Random ( randomRIO )
import System.IO ( hFlush, stdout, hSetBuffering, stdin, BufferMode(LineBuffering) )
import Text.Read ( readMaybe )
import AVL ( AVL, emptyAVL, createAVL, insertAVL, deleteAVL, searchAVL, inorder )

testAVL :: IO ()
testAVL = do 
    hSetBuffering stdin LineBuffering
    putStrLn "Test AVL tree operations!"
    putStrLn "We start with the empty tree." 
    putStrLn "Your commands are C / I num / D num / S num / O / P / X." 
    putStrLn "C will create a random AVL of size 20, values in [0..999]."
    putStrLn "I num will insert num :: Int into the tree."
    putStrLn "D num and S num stand for Delete and Search."
    putStrLn "O will print the inorder listing, and P will print the tree."
    putStrLn "X will exit the app."
    go emptyAVL where 

    go :: AVL Int -> IO ()
    go t   = do 
        putStr "Your wish is my command: "
        hFlush stdout
        inp <- getLine
        let (cmd:args) = words inp
        if cmd `elem` ["C", "P", "O", "X"] 
        then if length args /= 0
            then do
                putStrLn $ cmd ++ " cannot have arguments. Try again." 
                go t
            else case cmd of
                "C" -> do  
                    xs <- replicateM 20 (randomRIO (0, 999))
                    let t0 = createAVL xs
                    putStrLn "Your new tree is the following."
                    print t0
                    go t0
                "P" -> do
                    putStrLn "Here is your current tree."
                    print t
                    go t 
                "O" -> do 
                    putStrLn "Here is the inorder listing of the tree."
                    print (inorder t)
                    go t 
                "X" -> putStrLn "Exiting ... goodbye!"
        else if cmd `elem` ["I", "D", "S"]
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
                            "I" -> go (insertAVL v t)
                            "D" -> go (deleteAVL v t)
                            "S" -> if searchAVL v t
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
main = testAVL
