import Control.Monad (when)
import Control.Arrow ((>>>))
import Control.Exception (evaluate, handle, SomeException (SomeException))

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- Q1
-- Making a Number Guesser
--
-- The user first chooses a number between 1 and 100 (which they don't tell the program), 
-- and the program will have to try to guess the number.
--
-- The IO loop will work as follows:
-- The program will give a guess, and the user will input "HIGHER", "LOWER" or "CORRECT", 
-- based on whether their secret number is higher, lower or exacly equal to the number 
-- guessed by the program. The program will use this knowledge to make a better guess, and 
-- the loop repeats till the user replies "CORRECT". 
--
-- Make this game in a separate file. You can use IO functions to take in user input, and 
-- print stuff to the terminal.

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- Q2
-- Implementing the `iterate` function.
--
-- Given a function `f` and a starting value `a`, `iterate f a` will return the infinite list 
-- [a, f a, f (f a), f (f (f a)), ...]
--
-- Do _not_ use the in-built iterate function.

myIterate :: (a -> a) -> a -> [a]
myIterate = undefined

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- Q3
--
-- We define `Nat` as below, representing the set of natural numbers, and we define an 
-- `Ord` instance for it, using the natural ordering on natural numbers.
--
-- Create an object `infinity :: Nat`, such that it is greater than `Succ^n Zero` for
-- every `n >= 0`, where `Succ^n` represents composing `Succ` with itself `n` many times.

data Nat = Zero | Succ Nat deriving (Eq, Show)

instance Ord Nat where
    (<=) :: Nat -> Nat -> Bool
    (<=) Zero _             = True
    (<=) (Succ _) Zero      = False
    (<=) (Succ m) (Succ n)  = m <= n

-- Define the `infinity` object here.
infinity :: Nat
infinity = undefined

-- This is [Succ^n (Zero) | n <- [1..]].
infList :: [Nat]
infList = Zero : map Succ infList

-- This should be equal to `repeat True`.
check :: [Bool]
check = map (infinity >) infList

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- Q4
-- Making tic-tac-toe (pass and play variant)
--
-- Make the game of tic-tac-toe, where the user inputs the moves for both X and O (we are
-- thinking of there being two users, alternatively putting in their X and O turns)
-- 
-- Make this game in a new file
-- You can use IO functions to take input from the user about where they want to place their 
-- turn on the board. After every term, the board should be "displayed" (read "printed") in 
-- the terminal itself.


-- Some general tips on how to approach making something like this:
-- 1. Try listing down what kind of things a tic-tac-toe program needs to be able to do.
-- 2. Do things incrementally (modularly), try solving one small part at a time instead of a 
--    large part at once.


-- SPOILERS AHEAD!!!
-- TRY MAKING THE GAME ON YOUR OWN BEFORE YOU SEE THE NEXT HINTS

-- Some hints on specific parts of the game:
-- 1. Try making a custom datatype for the board, and make a `Show` instance for it.
--    This will make printing the board much easier for you.
-- 2. Make a function to "edit" the board, i.e., given a board, a valid position, and whose 
--    turn it is, it will places the mark, and returns a new board with the mark at that 
--    position.
-- 3. Make a win/draw checker, which, when given a board, tells if X won, or O won, or if 
--    it's a draw, or if the game can continue.
-- 4. Store whose turn it is somehow, and use it to determine whether to place an "X" or an 
--    "O".

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
    testAtomic (take 10 . myIterate (\x -> if even x then div x 2 else 3*x+1) , 
        "take 10 . myIterate (\\x -> if even x then div x 2 else 3*x+1)") (10 :: Int, [10,5,16,8,4,2,1,4,2,1]) >>>
    testAtomic ((`take` check), "(`take` check)") (11, replicate 11 True) >>>
    testAtomic ((infinity >=), "infinity >=") (iterate Succ Zero !! 10000, True)

main :: IO ()
main = do
    noErr <- testAll $ pure True
    when noErr $ putStrLn "Nice! All test cases passed."

