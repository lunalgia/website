module Stack( Stack, push, pop, top, empty, isEmpty, fromList, toList ) where 
import Data.List ( intercalate )
data Stack a = Stack [a]
push        :: a -> Stack a -> Stack a 
pop         :: Stack a -> (a, Stack a)
top         :: Stack a -> a       
empty       :: Stack a 
isEmpty     :: Stack a -> Bool 
fromList    :: [a] -> Stack a
toList      :: Stack a -> [a]

push x (Stack xs)   = Stack (x:xs)
pop (Stack [])      = error "Cannot pop the empty stack!"
pop (Stack (x:xs))  = (x, Stack xs)
top                 = fst . pop 
empty               = Stack []
isEmpty (Stack l)   = null l 
fromList            = Stack
toList (Stack xs)   = xs 

instance Show a => Show (Stack a) where 
    show :: Stack a -> String 
    show st         = intercalate " | " (map show (toList st))