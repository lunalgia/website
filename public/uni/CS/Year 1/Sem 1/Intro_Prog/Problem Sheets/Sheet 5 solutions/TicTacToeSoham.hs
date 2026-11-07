import Data.List ( intercalate, intersperse, transpose )
import Control.Monad ( (>=>), void )

data Cell = X | O | Empty deriving Eq

instance Show Cell where
    show :: Cell -> String
    show X      = " X "
    show O      = " O "
    show Empty  = "   "

type GameState = Maybe [[Cell]]

type UpdateState = GameState -> IO GameState

conv :: Int -> IO (Int, Int)
conv n = do
    if 0 < n && n < 10
        then let m = n - 1 in pure (m `div` 3, m `mod` 3)
        else do
            putStr "Please enter a number from 1 to 9: "
            turn <- readLn :: IO Int
            conv turn

play :: Cell -> UpdateState
play _ Nothing              = pure Nothing
play t g@(Just grid) = do
    putStr $ "Enter turn (" ++ show t ++ ") : "
    turn <- readLn :: IO Int
    (x, y) <- conv turn
    if grid !! x !! y /= Empty
        then
            play t g
        else
            pure . Just $ [[if (i,j) == (x,y) then t else grid !! i !! j | j <- [0 .. 2]] | i <- [0 .. 2]]

printBoard :: UpdateState
printBoard = maybe (pure Nothing) (\grid -> putStrLn (display grid) >> pure (Just grid))
    where
        display :: [[Cell]] -> String
        display grid = 
            intercalate "\n───┼───┼───\n" $ 
                map (intercalate "│" . map show) grid

checkEnd :: UpdateState
checkEnd Nothing       = pure Nothing
checkEnd g@(Just grid) = 
    ite ([X, X, X] `elem` checks) "X has won." . 
    ite ([O, O, O] `elem` checks) "O has won." .
    ite (Empty `notElem` concat grid) "Match draw." $ 
    pure g
        where
            checks = [grid !! i !! i | i <- [0 .. 2]] : [grid !! i !! (2 - i) | i <- [0 .. 2]] : grid ++ transpose grid
            ite cond msg e = if cond
                then printBoard g >> putStrLn msg >> pure Nothing
                else e

gameLoop :: UpdateState
gameLoop = (>=> checkEnd) . foldl1 (>=>) . intersperse checkEnd . intersperse (printAndPlay O) $ replicate 5 (printAndPlay X)
    where
        printAndPlay :: Cell -> UpdateState
        printAndPlay = (>=>) printBoard . play

main :: IO ()
main = void $ gameLoop initState
    where
        initState :: GameState
        initState = Just . replicate 3 $ replicate 3 Empty
