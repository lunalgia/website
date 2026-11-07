{- HLINT ignore "Use pure" -}
{- HLINT ignore "Use head" -}
import Prelude
import System.IO (hFlush, stdout)

-- This file is a tic-tac-toe game, but with an opponent bot.
-- The bot does not play perfectly, due to a bug. Feel free to figure out why, and how to fix it to play perfectly.

newtype Board = Board [Integer] -- Will have only 9 elements
instance Show Board where
    show (Board l) = row1 ++ "\n" ++ row2 ++ "\n" ++ row3 where
        row1 = xor0 (l!!0) ++ "|" ++ xor0 (l!!1) ++ "|" ++ xor0 (l!!2)
        row2 = xor0 (l!!3) ++ "|" ++ xor0 (l!!4) ++ "|" ++ xor0 (l!!5)
        row3 = xor0 (l!!6) ++ "|" ++ xor0 (l!!7) ++ "|" ++ xor0 (l!!8)

xor0 :: Integer -> String
xor0 1 = "X"
xor0 0 = "O"
xor0 _ = "_"

main :: IO ()
main = do
    -- We start with a board with all distinct negative entries. Negative entries denote that no move at that spot has been played.
    whoWon<-gameManager (Board [(-1),(-2)..(-9)]) True
    if whoWon=="True" then putStr "X won\n" else (
        if whoWon == "draw" then putStr "Better Luck next time\n" else putStr "Y won\n"
        )
    hFlush stdout


-- It takes the board, and the state(True: x is playing, False if o is playing)
-- It outputs at end "True" or "False" or "draw", signifying if x won or o won or if it was a draw.
gameManager :: Board -> Bool ->IO String
gameManager b state = do
    print b;hFlush stdout
    putStr ("Enter your move, "++(if state then "x" else "o")++": ");hFlush stdout
    -- The line below gets users move as x, and if its o's turn, it gets the bot's move
    currentMove <- if state then do {move <- readLn::IO Int;hFlush stdout; return move} else do {let move = botMoves b state in do {putStrLn ("Bot plays: " ++ show (move+1)); return (move+1)}}
    -- The moves user enters are from 1 to 9, however the board's array indexing is from 0 to 8, so I subtract by 1.
    let move = currentMove - 1 in
        -- Invalid move detection. We call gameManager again, to go to next round/to repeat the round on invalid move.
        if not (moveVerifier move b) then (do {putStr "You are a failure.\n";hFlush stdout; gameManager b state}) else (do
            -- This below gives us the new board with the move entered.
            let l = editor b move state in (do
                if winChecker l then (do {print l;hFlush stdout;return (show state)}) else (
                    if drawVerifier l then (do {print l;hFlush stdout;return "draw"}) else gameManager l (not state)

                    )
                )
            )

-- Takes in a position and the board, and checks if the move is valid or now
moveVerifier :: Int -> Board-> Bool
moveVerifier n (Board a)
    | n<=8 && n>=0 = (a!!n) < 0 -- Only allowed to put a move there if the slot is negative, If occupied spot, then it would have 0 or 1 in it.
    | otherwise = False

-- Returns a new board with the inputted move.
editor :: Board -> Int -> Bool -> Board
editor (Board a) n True = Board (firstPart ++ (1:remaining)) where
    firstPart = take n a
    end = drop n a
    remaining = tail end

editor (Board a) n False = Board (firstPart++(0:remaining)) where
    firstPart = take n a
    end = drop n a
    remaining = tail end

-- If someone wins then True, else False
-- This is why we start with all distinct negative values. 
-- Since I am checking equality wise, if they were all same, it would already detect as a win.
winChecker :: Board -> Bool
winChecker (Board l)
    | ((l!!0) == (l!!4)) && ((l!!4) == (l!!8)) = True
    | ((l!!2) == (l!!4)) && ((l!!4) == (l!!6)) = True
    | ((l!!0) == (l!!1)) && ((l!!0) == (l!!2)) = True
    | ((l!!3) == (l!!4)) && ((l!!4) == (l!!5)) = True
    | ((l!!6) == (l!!7)) && ((l!!7) == (l!!8)) = True
    | ((l!!0) == (l!!3)) && ((l!!3) == (l!!6)) = True
    | ((l!!1) == (l!!4)) && ((l!!4) == (l!!7)) = True
    | ((l!!2) == (l!!5)) && ((l!!5) == (l!!8)) = True
    | otherwise = False

drawVerifier :: Board -> Bool
drawVerifier (Board l) = not (any (<0) l) -- If every slot is filled up, ie no negative slots



-------------- BOT -------------------------

-- Returns list of valid moves that the bot can do
moveGiver :: Board -> [Int]
moveGiver a  = [n | n<-[0..8], moveVerifier n a]


-- Should return the best possible move for the bot
-- Idea is for all valid moves the bot can do, we check if bot will win if it does that move. Hence the nicely named function willwewinifwedothismove (we refers to the bot here).
-- willwewinifwedothismove returns 1 if that move leads the bot to a board where it can win, 0 if at best its drawable, and -1 if its a guaranteed loss
-- We get this for all moves, and choose any which leads to a winning valuation if possible, else a drawing valuation, else losing evaluation.
botMoves :: Board -> Bool -> Int
botMoves b state = possible_moves !! move_to_return where
    possible_moves = moveGiver b
    all_valuations = map (willwewinifwedothismove b state) possible_moves
    move_to_return
      | 1 `elem` all_valuations = firstOne all_valuations
      | 0 `elem` all_valuations = firstZero all_valuations
      | otherwise = 0

-- Gives the first 1 in the list
firstOne :: [Integer] -> Int
firstOne [] = -1
firstOne (x:xs) = if x == 1 then 0 else 1+firstOne xs
-- Gives the first 0 in the list
firstZero :: [Integer] -> Int
firstZero [] = -1
firstZero (x:xs) = if x == 0 then 0 else 1+firstOne xs


-- Do not look up to me for naming conventions
-- Returns true if doing this moves leads us to guaranteed victory if we play well
-- The way it does that, is after doing the move, 
-- it emulates the opponent, and sees what their best move(given by botMoves), and see if they win or not if they do that move.
-- If the opponent wins, then it loses, and if they lose, it wins, so we take the negative of the opponents winning chances, and return that.
willwewinifwedothismove :: Board -> Bool -> Int -> Integer
willwewinifwedothismove b state m
    | winChecker b = -1
    | drawVerifier b = 0
    | winChecker changed_board = 1
    | drawVerifier changed_board = 0
    | otherwise = - (willwewinifwedothismove changed_board (not state) (botMoves changed_board (not state)))
    where
        changed_board = editor b m state

