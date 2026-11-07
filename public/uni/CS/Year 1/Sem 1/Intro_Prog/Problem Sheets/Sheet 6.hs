import Data.List (intercalate)

-- Q1 Concat in O(n + m) time

-- Make a function which behaves the same as `concat` function
-- and works in O(n + m) time, where `n` is the total length of all
-- of the lists passed as input, and `m` is the number of lists.
myConcat :: [[a]] -> [a]
myConcat = undefined

------------------------------------------------------------------------------------------------

-- Q2 List of edges to adjacency list

type Vertex = Int

-- Given a directed graph given as a list of edges (the element (i,j) in the list denotes
-- an edge from i to j in the graph), convert it to an "adjacency list", that is:
-- For every vertex `v`, store all the outgoing neighbors of that vertex in a list `l_v`.
-- Make a list `[(v, l_v) | v in set of all vertices]`, and that should be your output.
-- If there are no outgoing neighbors of v, then store it as (v, [])
edgesToAdj :: [(Vertex, Vertex)] -> [(Vertex,[Vertex])]
edgesToAdj = undefined

------------------------------------------------------------------------------------------------

-- Q3 Adjacency list to query function

-- Given an adjacency list (described above in Q2), create a function which takes in vertices
-- `i` and `j` and returns `True` if there is an edge from `i` to `j` and `False` otherwise.
adjToQuery :: [(Vertex,[Vertex])] -> (Vertex -> Vertex -> Bool)
adjToQuery = undefined

------------------------------------------------------------------------------------------------

-- Q4 Transpose of a graph

-- A graph is given to you as an adjacency list (see Q2 above). Return the adjacency list of the
-- "transpose" of the graph.
-- Given a graph (V,E), the "transpose" of that graph is defined as (V,{(a,b) : (b,a) in E})

dualify :: [(Vertex, [Vertex])] -> [(Vertex, [Vertex])]
dualify = undefined

------------------------------------------------------------------------------------------------

-- Q5 Event-driven mail delivery

-- A very nice and useful place for usage of queues is event-driven programming.
-- Suppose you are a one-person mail delivery service.
-- You start with an initial list of letters to deliver, called `initial`.
-- Each time you finish delivering a single letter and check your stockpile, 
-- a new batch of letters may have arrived. 
--
-- For that, there is a function `newArrivals`, which given the number i-1, 
-- returns the batch of new letters you find waiting after making your i-th delivery.
-- (deliveries are stored 0 indexed, 
-- so the additional stockpile after the first delivery is obtained from newArrivals 0)
--
-- So given an initial letter stockpile, 
-- and a function that returns additional stockpile after i-th delivery, 
-- return the complete list of delivered letters in the exact order they were received and sent.
-- You finish delivering when you deliver the final item, and there is nothing in the newArrivals just after doing that delivery.  

newtype Queue a = Queue ([a], [a])

enqueue :: a -> Queue a -> Queue a 
dequeue :: Queue a -> Maybe (a, Queue a)
empty :: Queue a 
isEmpty :: Queue a -> Bool
fromList :: [a] -> Queue a
toList :: Queue a -> [a]

enqueue x (Queue (f, b))    = Queue (f, x:b)
dequeue (Queue (x:f, b))    = Just (x, Queue (f, b))
dequeue (Queue ([], []))    = Nothing
dequeue (Queue ([], b))     = dequeue (Queue (reverse b, []))
empty                       = Queue ([], [])
isEmpty (Queue (f,b))       = null f && null b 
fromList xs                 = Queue (xs, [])
toList (Queue (f,b))        = f ++ reverse b 

instance Show a => Show (Queue a) where 
    show :: Show a => Queue a -> String
    show q                  = intercalate " |-> " (map show (toList q))

type Letter = Integer

deliverMail :: Queue Letter -> (Int -> [Letter]) -> [Letter]
deliverMail initial newArrivals = undefined

-- Test cases for question 5

pile1 :: Queue Letter
pile1 = fromList [3,1,4]

newArrivals1 :: Int -> [Letter]
newArrivals1 i = latestBatch where
    batches = [[1,5],[],[],[],[9::Letter,2,6,5],[3,5,8,9]]
    latestBatch = if i >= length batches then [] else batches !! i


checker :: Bool
checker = deliverMail pile1 newArrivals1 == [3,1,4,1,5,9,2,6,5,3,5,8,9]

checker2 :: Bool
checker2 = deliverMail (fromList [1]) (\i -> if i == 1 then [5] else []) == [1]