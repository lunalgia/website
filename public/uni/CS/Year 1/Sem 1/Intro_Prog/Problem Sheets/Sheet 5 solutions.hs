import Control.Monad (when)
import Control.Arrow ((>>>))
import Control.Exception (evaluate, handle, SomeException (SomeException))

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- Q1
-- Make a number guesser program
-- The user chooses a number between 1 and 100 mentally, and the program will try to guess the number
-- The program will give a guess, and the user will input higher or lower, after which the program will make another guess
-- Make this game in a new file. Use some IO function to take in user input.

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- Q2
-- Make an implementation of the iterate function
-- given a function f and a starting value a, the iterate function will return the infinite list
-- [a, f a, f (f a), f (f (f a)), ...]


myIterate :: (a -> a) -> a -> [a]
myIterate f a = a : myIterate f (f a) 

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- Q3
-- We define `Nat` as below, representing Natural Numbers, and we define an instance of `Ord` for it.
-- create an object `infinity` of the type `Nat`, such that it is greater than all Natural numbers
-- Ie, for all x of type Nat, (infinity >= x) evaluates to True.

data Nat = Zero | Succ Nat deriving (Eq, Show)

instance Ord Nat where
    (<=) :: Nat -> Nat -> Bool
    (<=) Zero _ = True
    (<=) (Succ _) Zero = False
    (<=) (Succ m) (Succ n) = m <= n

infinity :: Nat
infinity = Succ infinity

infList :: [Nat]
infList = Zero : map Succ infList

-- This should be equal to `repeat True`
check :: [Bool]
check = map (infinity >=) infList

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- Q4
-- Make the game of tic-tac-toe, where the user inputs the moves for both X and O
-- (Ie, make a pass and play version of the game)
-- Make this game in a new file, and use some IO function to take input from user on where they want to place their mark on the board.
-- It should display the board in text after every move.



-- Some general tips on how to approach making something like this:
-- 1. Try listing down what kind of things a tic-tac-toe program needs to be able to do
-- 2. Do things incrementally, try solving one small part at a time instead of a large part at once.


-- Some hints on specific parts, give a try on making the game before seeing these hints.
-- 1. Try making a custom datatype for the board, and make a show instance for it
-- 2. Make a function to "edit" the board, ie given a board, a valid position, and whose turn it is, 
--    it will places the mark, and returns a new board with the mark at that position.
-- 3. Make a win/draw checker, which, when given a board, tells if X won, or O won, or if it's a draw, or if the game can continue.
-- 4. Store whose turn it is somehow, and use it to determine whether to place an "X" or an "O"

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------



-- The following functions are not part of the problem sheet.
-- These are test cases we have provided so that you can self-check the functions you have 
-- written.
-- Run the `main` function to see a summary of how your functions fare on the test cases.
-- Note that successfully passing all test cases is _not_ a guarantee that your program
-- is correct, it merely shows that it passes all the tests that we have designed.

testAtomic :: (Eq b, Show a, Show b) => (a -> b, String) -> (a, b) -> IO Bool -> IO Bool
testAtomic = (.) (=<<) . checker
    where
        checker :: (Eq b, Show a, Show b) => (a -> b, String) -> (a, b) -> Bool -> IO Bool
        checker (f, s) (a, b) ok = handle (\(SomeException _) -> bad "<crashed/undefined>") $ do
            eq <- evaluate (f a == b)
            if eq then pure ok else bad (show (f a))
            where
                bad msg =
                    False <$ putStrLn ("Your code for `" ++ s ++ "` failed on `" ++
                        show a ++ "`.\n\tExpected `" ++ show b ++ "`, but got `" ++
                        msg ++ "`.\n")

testAll :: IO Bool -> IO Bool
testAll =
    testAtomic (take 5 . myIterate (+2), "take 5 . myIterate (+2)") (7 :: Int, [7,9,11,13,15]) >>>
    testAtomic (take 10 . myIterate (\x -> if even x then div x 2 else 3*x+1) , "take 10 . myIterate (\\x -> if even x then div x 2 else 3*x+1)") (10 :: Int, [10,5,16,8,4,2,1,4,2,1]) >>>
    testAtomic ((`take` check), "(`take` check)") (11, replicate 11 True) >>>
    testAtomic ((infinity >=), "infinity >=") (iterate Succ Zero !! 10000, True)

main :: IO ()
main = do
    noErr <- testAll $ pure True
    when noErr $ putStrLn "Nice! All test cases passed."