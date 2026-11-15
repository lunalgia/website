module Set ( 
      Set
    , emptySet
    , createSet
    , insertInto
    , deleteFrom
    , search
    , setUnion
    , setIntersect
    , setDiff 
    ) where 

import AVL ( 
      AVL
    , emptyAVL
    , insertAVL
    , deleteAVL
    , searchAVL
    , createAVL
    , inorder
    , inorderTree 
    ) 

data Set a                  = Set (AVL a)
instance Show a => Show (Set a) where 
    show :: Show a => Set a -> String
    show (Set t)            = show (inorder t) 
instance Eq a => Eq (Set a) where 
    (==) :: Eq a => Set a -> Set a -> Bool
    Set s == Set t          = inorder s == inorder t
instance Ord a => Ord (Set a) where 
    compare :: Ord a => Set a -> Set a -> Ordering
    compare (Set s) (Set t) = compare (inorder s) (inorder t) 

emptySet :: Set a 
emptySet                    = Set emptyAVL 

createSet :: Ord a => [a] -> Set a
createSet                   = Set . createAVL  

search :: Ord a => a -> Set a -> Bool 
search v (Set t)            = searchAVL v t 

insertInto :: Ord a => a -> Set a -> Set a 
insertInto v (Set t)        = Set $ insertAVL v t 

deleteFrom :: Ord a => a -> Set a -> Set a 
deleteFrom v (Set t)        = Set $ deleteAVL v t

mergeBy :: Ord a => ([a] -> [a] -> [a]) -> Set a -> Set a -> Set a 
mergeBy f (Set t1) (Set t2) = Set $ inorderTree $ f (inorder t1) (inorder t2)

setUnion, setIntersect, setDiff :: Ord a => Set a -> Set a -> Set a 

setUnion                    = mergeBy unionMerge 
setIntersect                = mergeBy intersectMerge 
setDiff                     = mergeBy diffMerge 

unionMerge, intersectMerge, diffMerge :: Ord a => [a] -> [a] -> [a] 

unionMerge [] ys            = ys 
unionMerge xs []            = xs 
unionMerge (x:xs) (y:ys)    
    | x < y                 = x:unionMerge xs (y:ys)
    | y < x                 = y:unionMerge (x:xs) ys 
    | x == y                = x:unionMerge xs ys 

intersectMerge [] ys        = []
intersectMerge xs []        = [] 
intersectMerge (x:xs) (y:ys)    
    | x < y                 = intersectMerge xs (y:ys)
    | y < x                 = intersectMerge (x:xs) ys 
    | x == y                = x:intersectMerge xs ys 

diffMerge [] ys            = []
diffMerge xs []            = xs 
diffMerge (x:xs) (y:ys)    
    | x < y                 = x:diffMerge xs (y:ys)
    | y < x                 = diffMerge (x:xs) ys 
    | x == y                = diffMerge xs ys 