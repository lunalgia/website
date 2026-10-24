{-# OPTIONS_GHC -Wno-missing-methods #-}

-- No imports should be required.
-- You can find the laws that a typeclass is required to follow
-- by searching the name of the typeclass on Hoogle.

------------------------------------------------------------------------
-- Problem 1: 2x2 integer matrices as a Num instance
------------------------------------------------------------------------
-- A 2x2 matrix is represented here as `Mat a b c d`, meaning
--
--     | a b |
--     | c d |
--
-- Make this type an instance of Num, using ordinary matrix arithmetic:
--
--   (+) as matrix addition
--   (*) as matrix multiplication
--
-- Do NOT define abs or signum (they have no sensible meaning here)

data Matrix = Mat Integer Integer Integer Integer

instance Num Matrix where
  (+)         = undefined
  (*)         = undefined
  negate      = undefined
  fromInteger = undefined


------------------------------------------------------------------------
-- Problem 2: Complex numbers as Num and Fractional
------------------------------------------------------------------------
-- A complex number a + ib is stored as 'Complex a b'.

data Complex = Complex Double Double
  deriving (Eq, Show)

-- Num: 
--   (+), (*)       standard complex arithmetic
--   abs z          |z|

-- Do NOT define signum for the Num instance below

instance Num Complex where
  (+)         = undefined
  (*)         = undefined
  negate      = undefined
  abs         = undefined
  fromInteger = undefined

-- Dividing by zero may produce NaN/Infinity parts (as Double does);
-- no special handling is required.

instance Fractional Complex where
    recip = undefined


------------------------------------------------------------------------
-- Problem 3: Reduced row echelon form
------------------------------------------------------------------------
-- Given a matrix as a list of rows, return its reduced row echelon form.
--
-- Assume every row has the same length. The empty matrix and matrices
-- with empty rows should be returned unchanged. Use only Eq and
-- Fractional, so it works for Rational (exact) as well as Double.

rref :: (Eq a, Fractional a) => [[a]] -> [[a]]
rref = undefined

------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------

test :: IO ()
test = putStrLn . fst . head . dropWhile snd $ let

    matEq :: Matrix -> Matrix -> Bool
    matEq (Mat a b c d) (Mat e f g h) = a == e && b == f && c == g && d == h

    closeD :: Double -> Double -> Bool
    closeD x y = abs (x - y) < 1e-9

    closeC :: Complex -> Complex -> Bool
    closeC (Complex a b) (Complex c d) = closeD a c && closeD b d

    -- isNaNC :: Complex -> Bool
    -- isNaNC (Complex a b) = isNaN a && isNaN b

    closeRow :: [Double] -> [Double] -> Bool
    closeRow r1 r2 = length r1 == length r2 && and (zipWith closeD r1 r2)

    closeMat :: [[Double]] -> [[Double]] -> Bool
    closeMat m1 m2 = length m1 == length m2 && and (zipWith closeRow m1 m2)

    mX :: Matrix
    mX = Mat 2 3 5 7

    mA, mB :: Matrix
    mA = Mat 1 1 0 1
    mB = Mat 1 0 1 1

    cZ1, cZ2 :: Complex
    cZ1 = Complex 3 4
    cZ2 = Complex 1 (-2)

    in
    [ -- ---------- Problem 1: Matrix as Num ----------

    ("Matrix (+): basic", (Mat 1 2 3 4 + Mat 5 6 7 8) `matEq` Mat 6 8 10 12),
    ("Matrix (+): zero matrix is the identity", (mX + Mat 0 0 0 0) `matEq` mX),
    ("Matrix (+): negatives cancel out",
        (Mat (-1) (-2) (-3) (-4) + Mat 1 2 3 4) `matEq` Mat 0 0 0 0),
    ("Matrix (+): commutative", (mA + mB) `matEq` (mB + mA)),
    ("Matrix (*): basic (catches elementwise-multiply mistake)",
        (Mat 1 2 3 4 * Mat 5 6 7 8) `matEq` Mat 19 22 43 50),
    ("Matrix (*): identity matrix on the right", (mX * Mat 1 0 0 1) `matEq` mX),
    ("Matrix (*): identity matrix on the left", (Mat 1 0 0 1 * mX) `matEq` mX),
    ("Matrix (*): zero matrix absorbs", (mX * Mat 0 0 0 0) `matEq` Mat 0 0 0 0),
    ("Matrix (*): NOT commutative in general (A*B /= B*A)",
        not ((mA * mB) `matEq` (mB * mA))),
    ("Matrix (-): consistent with (+) and negate",
        (Mat 5 6 7 8 - Mat 1 2 3 4) `matEq` Mat 4 4 4 4),
    ("Matrix negate: basic", negate (Mat 1 (-2) 3 (-4)) `matEq` Mat (-1) 2 (-3) 4),
    ("Matrix negate: zero is its own negation", negate (Mat 0 0 0 0) `matEq` Mat 0 0 0 0),
    ("Matrix negate: double negation is identity", mX `matEq` mX),
    ("Matrix negate: consistent with (+)", (mX - mX) `matEq` Mat 0 0 0 0),
    ("Matrix negate: consistent with (*) and fromInteger",
        negate mX `matEq` (fromInteger (-1) * mX)),
    ("Matrix fromInteger 0 (base case)", (0 :: Matrix) `matEq` Mat 0 0 0 0),
    ("Matrix fromInteger 1 (catches 'fill all four entries' mistake)",
        (1 :: Matrix) `matEq` Mat 1 0 0 1),
    ("Matrix fromInteger 5", (5 :: Matrix) `matEq` Mat 5 0 0 5),
    ("Matrix fromInteger (-3)", ((-3) :: Matrix) `matEq` Mat (-3) 0 0 (-3)),
    ("Matrix fromInteger consistent with (+)",
        ((3 :: Matrix) + (4 :: Matrix)) `matEq` (7 :: Matrix)),
    ("Matrix fromInteger consistent with (*)",
        ((2 :: Matrix) * (3 :: Matrix)) `matEq` (6 :: Matrix)),

        -- ---------- Problem 2: Complex as Num and Fractional ----------

    ("Complex (+): basic", (Complex 1 2 + Complex 3 4) `closeC` Complex 4 6),
    ("Complex (+): zero is the identity", (cZ1 + Complex 0 0) `closeC` cZ1),
    ("Complex (+): commutative", (cZ1 + cZ2) `closeC` (cZ2 + cZ1)),
    ("Complex (*): basic (catches elementwise-multiply mistake)",
        (Complex 1 2 * Complex 3 4) `closeC` Complex (-5) 10),
    ("Complex (*): i*i == -1", (Complex 0 1 * Complex 0 1) `closeC` Complex (-1) 0),
    ("Complex (*): 1 is the identity", (Complex 1 0 * cZ1) `closeC` cZ1),
    ("Complex (*): zero absorbs", (Complex 0 0 * cZ1) `closeC` Complex 0 0),
    ("Complex (*): commutative (unlike Matrix (*) above)",
        (cZ1 * cZ2) `closeC` (cZ2 * cZ1)),
    ("Complex (-): consistent with (+) and negate",
        (Complex 5 6 - Complex 1 2) `closeC` Complex 4 4),
    ("Complex negate: basic", negate (Complex 3 (-4)) `closeC` Complex (-3) 4),
    ("Complex negate: zero is its own negation", negate (Complex 0 0) `closeC` Complex 0 0),
    ("Complex negate: consistent with (+)", (cZ1 - cZ1) `closeC` Complex 0 0),
    ("Complex negate: consistent with (*) and fromInteger",
        negate cZ1 `closeC` (fromInteger (-1) * cZ1)),
    ("Complex abs: 3-4-5 triangle", abs (Complex 3 4) `closeC` Complex 5 0),
    ("Complex abs: zero", abs (Complex 0 0) `closeC` Complex 0 0),
    ("Complex abs: negative components", abs (Complex (-3) (-4)) `closeC` Complex 5 0),
    ("Complex abs: purely imaginary", abs (Complex 0 (-5)) `closeC` Complex 5 0),
    ("Complex abs: already real and positive", abs (Complex 7 0) `closeC` Complex 7 0),
    ("Complex fromInteger 5", (5 :: Complex) `closeC` Complex 5 0),
    ("Complex fromInteger (-2)", ((-2) :: Complex) `closeC` Complex (-2) 0),
    ("Complex fromInteger consistent with (+)",
        ((3 :: Complex) + (4 :: Complex)) `closeC` (7 :: Complex)),
    ("Complex recip: 1", recip (Complex 1 0) `closeC` Complex 1 0),
    ("Complex recip: i (catches sign-of-conjugate mistake)",
        recip (Complex 0 1) `closeC` Complex 0 (-1)),
    ("Complex recip: round-trip z * recip z == 1",
        (cZ1 * recip cZ1) `closeC` Complex 1 0),
    -- ("Complex recip: 0 is non-invertible, yields NaN (not a crash)",
    --     isNaNC (recip (Complex 0 0))),
    ("Complex (/): basic, falls out of recip and (*) by default",
        (Complex 6 8 / Complex 2 0) `closeC` Complex 3 4),

        -- ---------- Problem 3: rref ----------

    ("rref: empty matrix (base case)", rref [] `closeMat` []),
    ("rref: one empty row (base case)", rref [[]] `closeMat` [[]]),
    ("rref: several empty rows", rref [[],[],[]] `closeMat` [[],[],[]]),
    ("rref: 1x1 nonzero normalizes to 1", rref [[5]] `closeMat` [[1]]),
    ("rref: 1x1 zero has no pivot to normalize", rref [[0]] `closeMat` [[0]]),
    ("rref: already the identity is unchanged",
        rref [[1,0],[0,1]] `closeMat` [[1,0],[0,1]]),
    ("rref: all-zero matrix has no pivots", rref [[0,0],[0,0]] `closeMat` [[0,0],[0,0]]),
    ("rref: invertible 2x2 (catches REF-vs-RREF -- stopping before back-substitution)",
        rref [[1,2],[3,4]] `closeMat` [[1,0],[0,1]]),
    ("rref: non-invertible, row2 = 2*row1", rref [[1,2],[2,4]] `closeMat` [[1,2],[0,0]]),
    ("rref: non-invertible with negative inputs",
        rref [[-1,-2],[2,4]] `closeMat` [[1,2],[0,0]]),
    ("rref: non-invertible, identical rows", rref [[1,1],[1,1]] `closeMat` [[1,1],[0,0]]),
    ("rref: non-invertible 3x3, rank 2 (zero row sinks to the bottom)",
        rref [[1,2,3],[2,4,6],[1,1,1]] `closeMat` [[1,0,-1],[0,1,2],[0,0,0]]),
    ("rref: needs a row swap to find a pivot (can't just divide by 0)",
        rref [[0,1],[1,0]] `closeMat` [[1,0],[0,1]]),
    ("rref: zero row not initially at the bottom, still needs a swap",
        rref [[0,0],[1,2],[3,4]] `closeMat` [[1,0],[0,1],[0,0]]),
    ("rref: wide matrix, more columns than rows",
        rref [[1,2,3],[4,5,6]] `closeMat` [[1,0,-1],[0,1,2]]),
    ("rref: tall matrix, more rows than columns",
        rref [[1,2],[3,4],[5,6]] `closeMat` [[1,0],[0,1],[0,0]]),
    ("rref: invertible 3x3, exercises full back-substitution",
        rref [[1,2,3],[4,5,6],[7,8,10]] `closeMat` [[1,0,0],[0,1,0],[0,0,1]]),
    ("rref: result keeps a genuine (non-integer) fraction",
        rref [[2,4,1],[1,3,1]] `closeMat` [[1,0,-0.5],[0,1,0.5]]),
    ("rref: works for Rational too (exact), not just Double",
        (rref [[1/3,2/3],[2/3,4/3]] :: [[Rational]]) == [[1,2],[0,0]]),

        -- ---------- Tests ----------

    ("all tests passed!", False)
    ]