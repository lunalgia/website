import Data.List (intercalate)

-- Start with printBoard startBoard
-- Then you can do your drawing like
-- printBoard (putPixel it (4,5) red)
-- printBoard (putCircle2 it (10,10) 8 green)
-- printBoard (putLine it (1,2) (5,28) magenta)



red, green, yellow, blue, magenta, cyan, black, white :: String
-- Ansi codes for coloured text
red  = "\ESC[31m"
green  = "\ESC[32m"
yellow  = "\ESC[33m"
blue  = "\ESC[34m"
magenta  = "\ESC[35m"
cyan  = "\ESC[36m"
black  = "\ESC[30m"
white  = "\ESC[37m"

block :: String
block = "██" --  2 blocks look good!
-- Therefore each pixel in my string is 8+2 = 10 characters!

-- Write-Host "`e[31mhello"

-- gridSize :: (Int,Int)
-- gridSize = (10,10)

newtype Board = Wrap [[String]]

instance Show Board where
    show :: Board -> String
    show = const ""

printBoard :: Board -> IO Board
printBoard (Wrap b) = do
    putStrLn (intercalate "\n" (map concat b)++white) -- Using putStrLn as it supports escape codes and ansi
    pure $ Wrap b

startBoard :: Board
startBoard = Wrap . concat $ replicate 30 [concat $ replicate 30 [white ++ block]]


putPixel :: Board -> (Int, Int) -> String -> Board
putPixel (Wrap b) (x,y) color = Wrap
    [[if (i,j)==(x,y) then color++block else b !! j !! i
        | i<-[0 .. length (head b) - 1]]
            |j<-[0..length b - 1]]


putCircle :: Board -> (Int,Int) -> Int -> String -> Board
putCircle b (x, y) r color = foldl f b ang where
    ang = map (/ 1000) [0 .. 3141 * 2] :: [Float]
    f b' theta = 
        putPixel b' 
            (round $ fromIntegral x + fromIntegral r * cos theta, 
            round $ fromIntegral y + fromIntegral r * sin theta) 
        color   


putCircle2 :: Board -> (Int, Int) -> Int -> String -> Board
putCircle2 (Wrap b) (x0,y0) r color = foldr (\(x,y) b' -> putPixel b' (x,y) color) (Wrap b) points where
    -- For every pixel, check if within radius, and error bound
    (gridSizeX,gridSizeY) = (length b, length $ head b)
    points = [(x,y) | x <- [0..(gridSizeX-1)], y <- [0..(gridSizeY-1)], abs((x - x0)^(2::Int) + (y - y0)^(2::Int) - r^(2::Int)) <= r ]


-- The algorithm used to generate points
bresenham :: (Int, Int) -> (Int, Int) -> [(Int, Int)]
bresenham (x1,y1) (x2,y2) = iteration x1 y1 initialError where
    dx = abs (x2 - x1)
    sx = if x1 < x2 then 1 else -1
    dy = -abs (y2 - y1)
    sy = if y1 < y2 then 1 else -1
    initialError = dx + dy

    iteration x y err = (x, y) : next where
        e2 = 2 * err
        (xNew, err')  = if e2 >= dy then (x + sx, err + dy) else (x, err)
        (yNew, err'') = if e2 <= dx then (y + sy, err' + dx) else (y, err')
        next = if (e2 >= dy && x == x2) || (e2 <= dx && y == y2) then [] else iteration xNew yNew err''


putLine :: Board -> (Int,Int) -> (Int,Int) -> String -> Board
putLine b (x1,y1) (x2,y2) color = foldr (\(x,y) b' -> putPixel b' (x, y) color) b (bresenham (x1,y1) (x2,y2))

-- main :: IO ()
-- main = putStrLn "messagr"
