power :: Integer -> Int -> Integer
power x 0   = 1 
power x n   = x * power x (n-1) 

safeDiv :: Integer -> Integer -> Maybe Integer 
safeDiv x n = if n == 0 then Nothing else Just (x `div` n)

myArg :: Integer 
myArg = myArg 

infList :: [Integer]
infList = infFrom 0 

infFrom :: Integer -> [Integer]
infFrom n = n : infFrom (n+1)

primes :: [Integer]
primes = sieve [2..] where 
    sieve (p:xs) = p:sieve [x | x <- xs, x `mod` p /= 0]