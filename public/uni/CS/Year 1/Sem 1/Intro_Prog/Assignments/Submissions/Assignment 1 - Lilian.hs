-- Intro to Programming, Assignment 1, Lilian

{- 1.
   An element of a list is said to be a middle element if there are equal
   number of elements to its left and right. Write a function getMiddle :: [a]
   -> Maybe a which takes an input list and returns Just x if x is a middle
   element, and returns Nothing if the list does not have a middle element.
   getMiddle [1, 2, 3] = Just getMiddle [1, 2, 3, = Nothing getMiddle ['a'] =
   Just getMiddle [] = Nothing getMiddle [1.0, = Just 4] 2.0, 3.0, 4.0, 5.0] 2
   'a' 3.0
-}
-- Question 1
getMiddle :: [a] -> Maybe a
getMiddle = undefined

{- 2.
   Write a function isPal :: String -> Bool which checks whether an input
   string is a palindrome. isPal "racecar" = True isPal "hello" = False isPal
   "" = True isPal "a" = True isPal "abba" = True
-}
-- Question 2
isPal :: String -> Bool
isPal = undefined

{- 3.
   Define a function runs :: (a -> a -> Bool) -> [a] -> [[a]] where runs p xs
   the list of maximal segments [xs!!i, xs!!i+1, ..., xs!!j] s.t. p xs!!k
   xs!!k+1 is True for all k ∈ {i, … , j − 1}. runs (<) [1, 2, runs (==)
   runs (>) [5, runs (\_ _ -> False) runs (\_ _ -> True) [1, 3, 1, 4, 1, 2, 3,
   2] 2, 6, 2, 3] 5] [1, [1, 2, 2, 3] 3] = [[1,2,3],[1,2]] =
   [[1,1],[2,2,2],[3]] = [[5,4,3],[6,5]] = [[1],[2],[3]] = [[1,2,3]]
-}
-- Question 3
runs :: (a -> a -> Bool) -> [a] -> [[a]]
runs = undefined

{- 4.
   Define a function sortWords :: [String] -> [String] which sorts a list of
   words in dictionary order. Do not use the built-in sort function. You can
   use < to compare two strings according to dictionary order. sortWords
   ["banana", sortWords ["Zebra", sortWords "apple", "cherry"] =
   ["apple","banana","cherry"] = ["Zebra","apple"] [] = [] sortWords ["a"] =
   ["a"] sortWords ["b", = ["a","b","c"] "apple"] "a", "c"]
-}
-- Question 4
sortWords :: [String] -> [String]
sortWords = undefined

{- 5.
   A matrix can be represented as a list of lists (assume the elements are of
   type Int). Write a function isMatrix which checks whether a list of lists
   represents a matrix. Write another function myTranspose which computes the
   transpose of a matrix. isMatrix :: [[Int]] -> isMatrix [[1,2],[3,4]] = True
   isMatrix [[1,2],[3]] = False isMatrix [[],[]] = True isMatrix [[1]] = True
   isMatrix [[1,2,3],[4,5,6]] = True [[Int]] Bool myTranspose :: -> [[Int]]
   myTranspose [[1,2],[3,4]] = [[1,3],[2,4]] myTranspose [[1,2,3]] =
   [[1],[2],[3]] myTranspose [[1],[2],[3]] = [[1,2,3]] myTranspose
   [[1,2],[3,4],[5,6]] = [[1,3,5],[2,4,6]] myTranspose [[1]] = [[1]]
-}
-- Question 5a 
isMatrix :: [[Int]] -> Bool
isMatrix = undefined

-- Question 5b
myTranspose :: [[Int]] -> [[Int]]
myTranspose = undefined
