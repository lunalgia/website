import Stack ( Stack, push, pop, top, empty )

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
tokListToExp            = top . foldl step empty where 
    step :: Stack Exp -> Token -> Stack Exp
    step st (Left n)    = push (Val n) st
    step st (Right op)  = push (op e2 e1) st where 
        (e1, st1)       = pop st 
        (e2, st2)       = pop st1

strToExp :: String -> Exp 
strToExp = tokListToExp . strToTokList 

evalExpString :: String -> Int 
evalExpString = eval . strToExp 

