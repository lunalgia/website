data Nat = Zero | Succ Nat 
    deriving Eq

instance Show Nat where 
    show :: Nat -> String
    show = show . natToInteger

isZero :: Nat -> Bool
isZero Zero = True 
isZero _ = False 

prev :: Nat -> Nat 
prev Zero = Zero 
prev (Succ n) = n 

plus :: Nat -> Nat -> Nat 
plus m Zero = m 
plus m (Succ n) = Succ (plus m n)

sub :: Nat -> Nat -> Nat 
sub m Zero = m 
sub m (Succ n) = sub (prev m) n

mult :: Nat -> Nat -> Nat 
mult m Zero = Zero 
mult m (Succ n) = plus m (mult m n)

integerToNat :: Integer -> Nat 
-- Works only for non-negative integers
integerToNat n 
    | n < 0     = error "Can only convert non-negative integers to Nat!"
    | otherwise = if n == 0 then Zero else Succ (integerToNat (n-1))

natToInteger :: Nat -> Integer 
natToInteger Zero = 0
natToInteger (Succ n) = natToInteger n + 1

data List a = Nil | Cons a (List a)
    deriving Show 

head :: List a -> Maybe a 
head Nil        = Nothing 
head (Cons x _) = Just x 

tail :: List a -> Maybe (List a)
tail Nil        = Nothing 
tail (Cons _ l) = Just l 

instance Foldable List where 
    foldr :: (a -> b -> b) -> b -> List a -> b 
    foldr f v Nil           = v 
    foldr f v (Cons x xs)   = f x (foldr f v xs) 

myList :: List Int 
myList = Cons 1 (Cons 2 (Cons 3 (Cons 52 (Cons 33 Nil))))

data Exp = Val Int | Add Exp Exp | Sub Exp Exp | Mul Exp Exp | Div Exp Exp 
    deriving Eq 

exp1, exp2, exp3 :: Exp
exp1 = Add (Val 3) (Mul (Val 5) (Val 2))
exp2 = Mul (Add (Val 3) (Val 5)) (Val 2)
exp3 = Mul (Div (Val 22) (Val 3)) (Add (Val 4) (Val 5))

instance Show Exp where
    show :: Exp -> String
    show (Val n) = show n
    show (Add expl expr) = "(" ++ show expl ++ " + " ++ show expr ++ ")"
    show (Sub expl expr) = "(" ++ show expl ++ " - " ++ show expr ++ ")"
    show (Mul expl expr) = "(" ++ show expl ++ " * " ++ show expr ++ ")"
    show (Div expl expr) = "(" ++ show expl ++ " / " ++ show expr ++ ")"

eval :: Exp -> Int 
eval (Val n)            = n 
eval (Add expl expr)    = eval expl + eval expr 
eval (Sub expl expr)    = eval expl - eval expr 
eval (Mul expl expr)    = eval expl * eval expr 
eval (Div expl expr)    = eval expl `div` eval expr 

type Token = Either Int (Exp -> Exp -> Exp)
strToTokList :: String -> [Token]
strToTokList str = map tokenize (words str) where
    tokenize :: String -> Token
    tokenize "+" = Right Add
    tokenize "-" = Right Sub
    tokenize "*" = Right Mul
    tokenize "/" = Right Div
    tokenize str = Left (read str :: Int)

tokListToExp :: [Token] -> Exp 
tokListToExp toks               = e where 
    (e:_)                       = foldl step [] toks 
    step :: [Exp] -> Token -> [Exp]
    step es         (Left n)    = Val n : es 
    step (e2:e1:es) (Right op)  = op e1 e2 : es

strToExp :: String -> Exp 
strToExp = tokListToExp . strToTokList 

evalExpString :: String -> Int 
evalExpString = eval . strToExp 

instance Semigroup Int where 
    (<>) :: Int -> Int -> Int
    (<>) = (+)

instance Monoid Int where
    mempty :: Int
    mempty = 0 