import Stack ( Stack, push, pop, empty, isEmpty, fromList ) 

-- This feature can be added by a user of Stack, 
-- but we do not want to make it part of the Stack API.
instance Foldable Stack where 
    foldr :: (a -> b -> b) -> b -> Stack a -> b 
    foldr f v st    = if isEmpty st then v else 
        let (x,st') = pop st in f x (foldr f v st')   

st0 :: Stack String 
st0 = foldr push empty $ map (:[]) ['A'..'Z'] -- This is the foldr on Lists

st1, st2, st3 :: Stack Int
st1 = fromList [1..10]
st2 = fromList $ reverse [0..99]
st3 = foldr push st2 st1   -- This is the foldr on Stack

          

