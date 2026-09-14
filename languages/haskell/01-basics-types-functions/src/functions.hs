-- Exercise 3: Functions — Composition, Currying, Recursion
-- Compile: ghc functions.hs -o functions && ./functions

-- Simple function with type signature
add :: Int -> Int -> Int
add a b = a + b

-- Curried by default: add 3 returns a function Int -> Int
-- Partial application
add3 :: Int -> Int
add3 = add 3

-- Pattern-matching recursion
factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- Tail-recursive factorial with accumulator
factorialTail :: Integer -> Integer -> Integer
factorialTail n acc
    | n <= 1    = acc
    | otherwise  = factorialTail (n - 1) (n * acc)

factorial' :: Integer -> Integer
factorial' n = factorialTail n 1

-- Function returning a tuple
minMax :: [Int] -> (Int, Int)
minMax [] = error "empty list"
minMax (x:xs) = go x x xs
  where
    go lo hi []     = (lo, hi)
    go lo hi (y:ys)
        | y < lo    = go y hi ys
        | y > hi    = go lo y ys
        | otherwise = go lo hi ys

main :: IO ()
main = do
    putStrLn $ "3 + 5 = " ++ show (add 3 5)
    putStrLn $ "add 3 10 = " ++ show (add3 10)

    putStrLn $ "factorial 5 = " ++ show (factorial 5)
    putStrLn $ "factorial' 5 = " ++ show (factorial' 5)

    let numbers = [3, 7, 2, 9, 1]
    let (lo, hi) = minMax numbers
    putStrLn $ "Min: " ++ show lo ++ ", Max: " ++ show hi
