module AVL ( 
      AVL
    , emptyAVL
    , isEmpty
    , insertAVL
    , deleteAVL
    , searchAVL
    , createAVL
    , inorder
    , inorderTree
    ) where

import Data.List ( intercalate )

data AVL a = Nil | Node Int (AVL a) a (AVL a) deriving Eq

emptyAVL :: AVL a 
emptyAVL    = Nil 

isEmpty :: AVL a -> Bool 
isEmpty Nil = True 
isEmpty _   = False 

height :: AVL a -> Int 
height Nil              = 0 
height (Node h _ _ _)   = h 

slope :: AVL a -> Int 
slope Nil               = 0 
slope (Node _ tl _ tr)  = height tl - height tr 

rotateRight :: AVL a -> AVL a 
rotateRight (Node h (Node hl tll y tlr) x tr) 
        = Node nh tll y (Node nhr tlr x tr) where 
    nh  = 1 + max (height tll) nhr 
    nhr = 1 + max (height tlr) (height tr) 

rotateLeft :: AVL a -> AVL a 
rotateLeft (Node h tl x (Node hr trl y trr)) 
        = Node nh (Node nhl tl x trl) y trr where 
    nh  = 1 + max nhl (height trr)
    nhl = 1 + max (height tl) (height trl)

rebalance :: AVL a -> AVL a 
rebalance t@(Node h tl x tr) = case (slope t, slope tl, slope tr) of 
        (2, -1, _)  -> rotateRight (Node h (rotateLeft tl) x tr)
        (2, _, _)   -> rotateRight t
        (-2, _, 1)  -> rotateLeft (Node h tl x (rotateRight tr))
        (-2, _, _)  -> rotateLeft t 
        _           -> t 

insertAVL :: Ord a => a -> AVL a -> AVL a 
insertAVL v Nil                 = Node 1 Nil v Nil 
insertAVL v t@(Node h tl x tr)  = let 
    (ntl, ntr)      = (insertAVL v tl, insertAVL v tr) 
    nhl             = 1 + max (height ntl) (height tr)
    nhr             = 1 + max (height tl) (height ntr) 
        in case compare v x of 
        LT  -> rebalance (Node nhl ntl x tr) 
        GT  -> rebalance (Node nhr tl x ntr) 
        EQ  -> t

deleteMax :: AVL a -> (a,AVL a)
deleteMax (Node _ tl x Nil) = (x, tl)
deleteMax (Node h tl x tr)  = (y, rebalance (Node nh tl x ty)) where 
    (y,ty)                  = deleteMax tr 
    nh                      = 1 + max (height tl) (height ty)

deleteAVL :: Ord a => a -> AVL a -> AVL a 
deleteAVL v Nil         = Nil 
deleteAVL v t@(Node h tl x tr)  = let  
    (y,ty)      = deleteMax tl 
    (ntl, ntr)  = (deleteAVL v tl, deleteAVL v tr)
    nhy         = 1 + max (height ty) (height tr)
    nhl         = 1 + max (height ntl) (height tr) 
    nhr         = 1 + max (height tl) (height ntr)
        in case compare v x of  
        LT  -> rebalance (Node nhl ntl x tr) 
        GT  -> rebalance (Node nhr tl x ntr) 
        EQ  -> if isEmpty tl then tr 
                else rebalance (Node nhy ty y tr)

searchAVL :: Ord a => a -> AVL a -> Bool  
searchAVL v Nil                 = False 
searchAVL v (Node _ tl x tr)    = case compare v x of 
    LT  -> searchAVL v tl 
    GT  -> searchAVL v tr 
    EQ  -> True 

createAVL :: Ord a => [a] -> AVL a 
createAVL   = foldr insertAVL emptyAVL

inorder :: AVL a -> [a] 
inorder t                   = t +: [] where 
    Nil             +:  xs  = xs 
    Node _ tl x tr  +:  xs  = tl +: (x: (tr +: xs))

inorderTree :: [a] -> AVL a 
inorderTree l       = fst (go (length l) l) where 
    go 0 xs         = (Nil, xs)
    go n xs         = (Node h tl y tr, zs) where 
        m           = n `div` 2 
        (tl,y:ys)   = go m xs 
        (tr,zs)     = go (n-m-1) ys 
        h           = 1 + max (height tl) (height tr)

instance Show a => Show (AVL a) where
    show :: Show a => AVL a -> String
    show    = draw

colorify :: String -> String 
colorify s = "\ESC[92m" ++ s ++ "\ESC[0m" 

draw :: Show a => AVL a -> String 
draw t              = "\n" ++ intercalate "\n" lines ++ "\n" where 
    (lines,_,_)     = go t 
go :: Show a => AVL a -> ([String], Int,Int)
go Nil                  = ([colorify "*"],0,0)
go (Node _ Nil x Nil)   = ([colorify sx],p,q) where 
    (sx,lenx,p,q)       = (show x, length sx, lenx `div` 2, lenx-p-1)
go (Node _ tl x tr)     = (line1:line2:rest, m, n) where 
    (sx,lenx,p,q)   = (show x, length sx + 4, lenx `div` 2, lenx-p-1)
    (linesl,ml,nl)  = go tl  
    (linesr,mr,nr)  = go tr 
    (arml,padl)     = if nl >= p+1 then (nl-p,0) else (1,p+1-nl) 
    (armr,padr)     = if mr >= q+1 then (mr-q,0) else (1,q+1-mr)
    (m,n)           = (ml+1+arml+p, q+armr+1+nr)
    line1           =   replicate ml ' ' ++ "+" ++ replicate arml '-' 
                        ++ "-<" ++ colorify sx ++ ">-" ++ 
                        replicate armr '-' ++ "+" ++ replicate nr ' '
    line2           =   replicate ml ' ' ++ "|" ++ 
                        replicate (arml+armr+lenx) ' ' ++
                        "|" ++ replicate nr ' '
    (hl,hr,h)       = (length linesl, length linesr, max hl hr)
    linesl'         = linesl ++ replicate (h-hl) (replicate (ml+1+nl) ' ')
    linesr'         = linesr ++ replicate (h-hr) (replicate (mr+1+nr) ' ')
    rest            = zipWith (\sl sr -> sl ++ replicate (padl+1+padr) ' ' ++ sr) linesl' linesr'
