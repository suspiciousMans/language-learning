-- Exercise 1: List Processing
-- Compile: ghc lists.hs -o lists && ./lists

-- List comprehensions
dicePairs :: [(Int, Int)]
dicePairs = [(x, y) | x <- [1..6], y <- [1..6], x + y == 7]

pythagorean :: Int -> [(Int, Int, Int)]
pythagorean n =
    [(a, b, c) | a <- [1..n], b <- [a..n], c <- [b..n]
                , a^2 + b^2 == c^2]

-- Functional style
doubleAll :: [Int] -> [Int]
doubleAll = map (*2)

filterEvens :: [Int] -> [Int]
filterEvens = filter even

sumSquares :: [Int] -> Int
sumSquares = foldr (\x acc -> x^2 + acc) 0

listMax :: [Int] -> Maybe Int
listMax [] = Nothing
listMax (x:xs) = Just $ foldr max x xs

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : chunksOf n (drop n xs)

transpose :: [[a]] -> [[a]]
transpose [] = []
transpose ([]:xss) = transpose xss
transpose ((x:xs):xss) = (x : [h | (h:_) <- xss]) : transpose (xs : [t | (_:t) <- xss])

main :: IO ()
main = do
    putStrLn "Dice pairs summing to 7:"
    print dicePairs

    putStrLn ""
    putStrLn "Pythagorean triples up to 20:"
    print $ pythagorean 20

    putStrLn ""
    putStrLn "doubleAll [1,2,3,4,5] = " ++ show (doubleAll [1,2,3,4,5])
    putStrLn "filterEvens [1..10] = " ++ show (filterEvens [1..10])
    putStrLn "sumSquares [1,2,3] = " ++ show (sumSquares [1,2,3])
    putStrLn "listMax [3,7,2,9,1] = " ++ show (listMax [3,7,2,9,1])
    putStrLn "listMax [] = " ++ show (listMax ([] :: [Int]))

    putStrLn ""
    putStrLn "chunksOf 3 [1..10] = " ++ show (chunksOf 3 [1..10])
    putStrLn $ "chunksOf 2 \"haskell\" = " ++ show (chunksOf 2 "haskell")

    putStrLn ""
    putStrLn "transpose [[1,2,3],[4,5,6],[7,8,9]] = "
    print $ transpose [[1,2,3],[4,5,6],[7,8,9]]
