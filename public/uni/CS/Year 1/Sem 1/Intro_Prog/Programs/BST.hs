module BST ( 
      BST
    , emptyBST
    , isEmpty
    , insertBST
    , deleteBST
    , searchBST
    , fromListL
    , fromListR
    , inorder
    ) where

import Data.List ( intercalate )

data BST a = Nil | Node (BST a) a (BST a) deriving Eq

searchBST :: Ord a => a -> BST a -> Bool
searchBST _ Nil             = False
searchBST v (Node tl x tr)  =   case compare v x of 
    LT -> searchBST v tl 
    EQ -> True 
    GT -> searchBST v tr 

emptyBST :: BST a
emptyBST    = Nil

isEmpty :: BST a -> Bool 
isEmpty Nil = True 
isEmpty _   = False 

inorder :: BST a -> [a]
inorder                 = go [] where 
    go l Nil            = l 
    go l (Node tl x tr) = go (x:go l tr) tl

isBST :: Ord a => BST a -> Bool 
isBST = isSorted . inorder where 
    isSorted []         = True 
    isSorted [_]        = True 
    isSorted (x:y:ys)   = x <= y && isSorted (y:ys)

mint :: Ord a => BST a -> a 
mint Nil            = error "No minimum for an empty tree!"
mint (Node tl x tr) = min x (min 
                                (if isEmpty tl then x else mint tl) 
                                (if isEmpty tr then x else mint tr)
                            )

maxt :: Ord a => BST a -> a 
maxt Nil    = error "No maximum for an empty tree!"
maxt (Node tl x tr) = max x (max
                                (if isEmpty tl then x else maxt tl) 
                                (if isEmpty tr then x else maxt tr)
                            )

insertBST :: Ord a => a -> BST a -> BST a 
insertBST v Nil                 = Node Nil v Nil
insertBST v t@(Node tl x tr)    = case compare v x of 
    LT -> Node (insertBST v tl) x tr
    EQ -> t 
    GT -> Node tl x (insertBST v tr)

ct :: [a] -> BST a 
ct l                = fst (go (length l) l) where 
    go 0 xs         = (Nil, xs)
    go n xs         = (Node tl y tr, zs) where 
        m           = n `div` 2
        (tl, y:ys)  = go m xs 
        (tr, zs)    = go (n-m-1) ys

fromListR :: Ord a => [a] -> BST a 
fromListR = foldr insertBST emptyBST

fromListL :: Ord a => [a] -> BST a 
fromListL = foldl' (flip insertBST) emptyBST

treeSort :: Ord a => [a] -> [a]
treeSort = inorder . fromListR 

deleteMax :: Ord a => BST a -> (a, BST a)
deleteMax Nil               = error "No maximum in an empty tree!"
deleteMax (Node tl x Nil)   = (x, tl)
deleteMax (Node tl x tr)    = let (y, ty) = deleteMax tr in (y, Node tl x ty)

deleteBST :: Ord a => a -> BST a -> BST a 
deleteBST _ Nil             = Nil 
deleteBST v (Node tl x tr)  = case compare v x of 
    LT -> Node (deleteBST v tl) x tr 
    EQ -> if isEmpty tl then tr else 
            let (y, ty) = deleteMax tl in Node ty y tr
    GT -> Node tl x (deleteBST v tr)

instance Show a => Show (BST a) where
    show :: Show a => BST a -> String
    show    = draw

colorify :: String -> String 
colorify s = "\ESC[92m" ++ s ++ "\ESC[0m" 

draw :: Show a => BST a -> String 
draw t              = "\n" ++ intercalate "\n" lines ++ "\n" where 
    (lines,_,_)     = go t 

go :: Show a => BST a -> ([String], Int,Int)
go Nil                  = ([colorify "*"],0,0)
go (Node Nil x Nil)     = ([colorify sx],p,q) where 
    (sx,lenx,p,q)       = (show x, length sx, lenx `div` 2, lenx-p-1)
go (Node tl x tr)       = (line1:line2:rest, m, n) where 
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
