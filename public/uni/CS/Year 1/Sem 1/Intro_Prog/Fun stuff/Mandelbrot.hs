{-# OPTIONS_GHC -Wno-unused-top-binds #-}
{-# OPTIONS_GHC -Wno-type-defaults #-}

import Data.List ( intercalate )
import Data.Maybe ( isNothing )
import Control.Monad ( replicateM_ )

-- Zoom out fully in CMD, press F11 for fullscreen, run `main`

side :: [Bool] -> [[Bool]]
side l = zipWith (\ x y -> [x, y]) (False : l) (l ++ [False])

vert :: [[[Bool]]] -> [[[Bool]]]
vert l = zipWith (zipWith (++)) (f : l) (l ++ [f])
    where f = repeat [False, False]

newtype Disp = Wrap [[String]]

instance Show Disp where
    show :: Disp -> String
    show (Wrap l) = intercalate "\n" $ map concat l

conv :: [[Bool]] -> [[String]]
conv = map (map go) . vert . map side where
    go :: [Bool] -> String
    go [False, False, False, False] = "  "
    go [False, False, False, True ] = "┌─"
    go [False, False, True , False] = "┐ "
    go [False, False, True , True ] = "──"
    go [False, True , False, False] = "└─"
    go [False, True , False, True ] = "│ "
    go [False, True , True , False] = "┼─"
    go [False, True , True , True ] = "┘ "
    go (True : l)                   = go $ False : map not l
    go _ = undefined

mandelbrot :: Int -> Float -> [[Maybe Int]]
mandelbrot iter zoom = map (map (go2 0 . go1)) grid where
    go1 :: (Float, Float) -> [(Float, Float)]
    go1 (a, b) = iterate (\ (x, y) -> (x * x - y * y + a, 2 * x * y + b)) (0, 0)

    go2 :: Int ->  [(Float, Float)] -> Maybe Int
    go2 _ [] = undefined
    go2 n ((x, y) : ps)
      | n > iter = Nothing
      | x * x + y * y > 4 = Just n
      | otherwise = go2 (n + 1) ps

    grid :: [[(Float, Float)]]
    grid = [[(x / zoom, y / zoom) | x <- [(- 2) * zoom .. 1.1 * zoom]] | y <- [(- 1.15) * zoom .. 1.15 * zoom]]


display0 :: Int -> Float -> Disp
display0 iter zoom = Wrap . map (map . maybe "██" $ const "  ") $ mandelbrot iter zoom

display0' :: Int -> Float -> Disp
display0' iter zoom = Wrap . map (map . maybe "  " $ const "██") $ mandelbrot iter zoom

display1 :: Int -> Float -> Disp
display1 iter zoom = Wrap . conv . map (map isNothing) $ mandelbrot iter zoom

display2 :: Int -> Float -> Disp
display2 iter zoom = Wrap . drop 2 . conv. map (map $ maybe False even) $ mandelbrot iter zoom

display3 :: Int -> Float -> Disp
display3 iter zoom = Wrap . map (map . maybe "  " $ f) $ mandelbrot iter zoom where
    l = ["██", "▓▓", "▒▒", "░░"]
    f x = l !! (3 - (141 * (x - iter - 1)) ^ 4 `div` ((100 * (iter + 1)) ^ 4))

displayLoop :: IO ()
displayLoop = sequence_ [print $ display1 n 100 | n <- [1..]]

main :: IO ()
main = do
    print $ display0 30 100 `beside` display1 30 100 `beside` display0' 30 100
    replicateM_ 2 $ print "\n"
    print $ display2 30 150 `beside` display3 30 150
        where
            beside :: Disp -> Disp -> Disp
            beside (Wrap l1) (Wrap l2) = Wrap $ zipWith (++) l1 l2
