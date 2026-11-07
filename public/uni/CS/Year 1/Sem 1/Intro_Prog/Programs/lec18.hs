import System.Random ( randomIO, randomRIO )
import Control.Monad ( forM, forM_, replicateM, replicateM_ )

strings :: [String]
strings = ["Kavya", "Ved", "Juan", "Shriram"]

revStrings :: [String] -> [String]
revStrings = map reverse 

randInts :: IO [Integer]
randInts = replicateM 100 (randomRIO (-500, 499))

randString :: IO String 
randString = replicateM 100 (randomRIO ('a', 'z'))
