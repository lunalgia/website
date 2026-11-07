import Text.Read (readMaybe)

main :: IO ()
main = deltaToIO ticTacToeDelta ticTacToeShowState ticTacToeInitialWinAndState

type Win = Bool

deltaToIO :: (state -> String -> (Win, state)) -> ((Win, state) -> String) -> (Win, state) -> IO ()
deltaToIO delta showState initialWinAndState = 
    interact . (.buffer "") . (concat.) . (.lines) $ \ moves -> let
        (ends, states) = unzip . scanl (delta . snd) initialWinAndState $ moves
        in zipWith (const id) (takeWhile not (False:ends)) . 
        zipWith (seq . length) ("":moves) $
        zipWith (curry showState) ends states

buffer a ""        = reverse a
buffer a ('\n':cs) = reverse ('\n':a) ++ buffer "" cs
buffer a (c   :cs) = buffer (c:a) cs

type Board = String
type Dialogue = String
type State = (Dialogue, Board)

ticTacToeDelta :: State -> String -> (Win, State)
ticTacToeDelta (_, b) move = let

    (i,j) = case readMaybe move of Nothing -> (4,4) ; Just x -> x
    inValid = not (0<=i && i<3 && 0<=j && j<3 && b!!(2*i+6*j)=='?')

    b' = if inValid then b else let (xs,ys) = splitAt (2*i+6*j) b
        in xs ++ (newSymbol b:tail ys)

    aps = [0,1,2] : [2,1,0] : map (replicate 3) [0,1,2]
    aps2 = [zip ap ap' | ap <- aps, ap' <- aps]
    inARow = [[b'!!(2*i+6*j) | (i,j) <- l] | l <- aps2, l!!1/=l!!2]

    win | "xxx" `elem`        inARow = 'x' -- x
        | "ooo" `elem`        inARow = 'o' -- o
        | all ('?' `notElem`) inARow = ' ' -- draw
        | otherwise                  = '?' -- not yet determined

    end = win `elem` "xo "

    in (end, 
    (    if inValid         then "\""++move++"\" is an invalid move!!\nmove must be of the form (i,j),\nwhere i, j are in [0..2]"
    else if win `elem` "xo" then win : " wins!!"
    else if win == ' '      then "it's a draw!!"
    else "", b'))

newSymbol :: Board -> Char
newSymbol = ("xo"!!) . (`mod`2) . length . filter (`elem` "xo")

ticTacToeShowState :: (Win, State) -> String
ticTacToeShowState (end, (dialogue, board)) = 
    "\ESC[2J\ESC[1;1H\n"                             ++ 
    (if null dialogue then "" else dialogue++"\n\n") ++ 
    board ++ "\n\n"                                  ++
    if end then "" else newSymbol board:"'s move : "

ticTacToeInitialWinAndState :: (Win, State)
ticTacToeInitialWinAndState = (False, ("", "? ? ?\n? ? ?\n? ? ?"))
