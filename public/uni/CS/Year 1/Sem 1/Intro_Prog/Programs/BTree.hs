import Queue ( Queue, empty, isEmpty, enqueue, dequeue )
import Control.Monad ( replicateM )
import System.Random ( randomRIO )
import Data.List ( intercalate )

randInts :: Int -> IO [Int]
randInts sz = replicateM sz (randomRIO (-200, 199)) 

data BTree a = Nil | Node (BTree a) a (BTree a) 

tree1, tree2 :: BTree Integer
tree1 = Node (Node Nil 2 Nil) 3 (Node Nil 5 Nil) 
tree2 = Node (Node Nil 4 Nil) 6 tree1

isNil :: BTree a -> Bool 
isNil Nil   = True 
isNil _     = False 

size :: BTree a -> Integer 
size Nil            = 0
size (Node tl _ tr) = 1 + size tl + size tr 

rightSkewTree :: [a] -> BTree a
rightSkewTree       = foldr (Node Nil) Nil 

leftSkewTree :: [a] -> BTree a 
leftSkewTree        = foldr (\v t -> Node t v Nil) Nil

reflect :: BTree a -> BTree a
reflect Nil             = Nil 
reflect (Node tl x tr)  = Node (reflect tr) x (reflect tl) 

height :: BTree a -> Integer 
height Nil              = 0 
height (Node tl _ tr)   = 1 + max (height tl) (height tr)

bflist :: BTree a -> [a]
bflist t    = go (empty +: t) where 
    (+:) :: Queue (BTree a) -> BTree a -> Queue (BTree a)
    q +: t  = if isNil t then q else enqueue t q
    go :: Queue (BTree a) -> [a]
    go q    = if isEmpty q then [] else x: go (q' +: tl +: tr) where 
        (Node tl x tr, q')  = dequeue q

dflist :: BTree a -> [a]
dflist t                = go t [] where 
    go Nil l            = l 
    go (Node tl x tr) l = x: go tl (go tr l)

inorder :: BTree a -> [a]
-- inorder Nil             = []
-- inorder (Node tl x tr)  = inorder tl ++ [x] ++ inorder tr
inorder t               = go t [] where 
    go Nil l            = l
    go (Node tl x tr) l = go tl (x: go tr l) 

createTree :: [a] -> BTree a 
-- createTree []       = Nil 
-- createTree l        = Node (createTree front) x (createTree back) where 
--     (front, x:back) = splitAt (length l `div` 2) l 
createTree l        = fst $ go (length l) l where 
    go 0 xs         = (Nil, xs)
    go n xs         = (Node tl y tr, zs) where 
        m           = n `div` 2 
        (tl, y:ys)  = go m xs 
        (tr, zs)    = go (n-m-1) ys

instance Show a => Show (BTree a) where
    show :: Show a => BTree a -> String
    show    = draw

colorify :: String -> String 
colorify s = "\ESC[92m" ++ s ++ "\ESC[0m" 

draw :: Show a => BTree a -> String 
draw t              = "\n" ++ intercalate "\n" lines ++ "\n" where 
    (lines,_,_)     = go t 

go :: Show a => BTree a -> ([String], Int,Int)
go Nil                  = ([colorify "*"],0,0)
go (Node Nil x Nil)     = ([colorify sx],p,q) where 
    (sx,lenx,p,q)       = (show x, length sx, lenx `div` 2, lenx-p-1)
go (Node tl x tr)       = (line1:line2:rest, m, n) where 
    (sx,lenx,p,q)   = (show x, length sx + 6, lenx `div` 2, lenx-p-1)
    (linesl,ml,nl)  = go tl  
    (linesr,mr,nr)  = go tr 
    (arml,padl)     = if nl >= p+1 then (nl-p,0) else (1,p+1-nl) 
    (armr,padr)     = if mr >= q+1 then (mr-q,0) else (1,q+1-mr)
    (m,n)           = (ml+1+arml+p, q+armr+1+nr)
    line1           =   replicate ml ' ' ++ "+" ++ replicate arml '-' 
                        ++ "-< " ++ colorify sx ++ " >-" ++ 
                        replicate armr '-' ++ "+" ++ replicate nr ' '
    line2           =   replicate ml ' ' ++ "|" ++ 
                        replicate (arml+armr+lenx) ' ' ++
                        "|" ++ replicate nr ' '
    (hl,hr,h)       = (length linesl, length linesr, max hl hr)
    linesl'         = linesl ++ replicate (h-hl) (replicate (ml+1+nl) ' ')
    linesr'         = linesr ++ replicate (h-hr) (replicate (mr+1+nr) ' ')
    rest            = zipWith (\sl sr -> sl ++ replicate (padl+1+padr) ' ' ++ sr) linesl' linesr'

