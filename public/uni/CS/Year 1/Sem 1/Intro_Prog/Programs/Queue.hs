module Queue(Queue, enqueue, dequeue, empty, isEmpty, fromList, toList) where 
import Data.List ( intercalate )
newtype Queue a = Queue ([a], [a])

enqueue :: a -> Queue a -> Queue a 
dequeue :: Queue a -> (a, Queue a)
empty :: Queue a 
isEmpty :: Queue a -> Bool
fromList :: [a] -> Queue a
toList :: Queue a -> [a]

enqueue x (Queue (f, b))    = Queue (f, x:b)
dequeue (Queue (x:f, b))    = (x, Queue (f, b))
dequeue (Queue ([], []))    = error "Empty queue"
dequeue (Queue ([], b))     = dequeue (Queue (reverse b, []))
empty                       = Queue ([], [])
isEmpty (Queue (f,b))       = null f && null b 
fromList xs                 = Queue (xs, [])
toList (Queue (f,b))        = f ++ reverse b 

instance Show a => Show (Queue a) where 
    show :: Show a => Queue a -> String
    show q                  = intercalate " |-> " (map show (toList q))