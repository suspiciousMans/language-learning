-- Exercise 2: Safe Operations with Maybe
-- Compile: ghc maybe_exercises.hs -o maybe_exercises && ./maybe_exercises

-- Maybe is Haskell's safe nullable: no nulls, no crashes
-- data Maybe a = Nothing | Just a

safeDiv :: Double -> Double -> Maybe Double
safeDiv _ 0 = Nothing
safeDiv x y = Just (x / y)

safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x

safeTail :: [a] -> Maybe [a]
safeTail []     = Nothing
safeTail (_:[]) = Just []
safeTail (_:xs) = Just xs

-- Chaining Maybe with do-notation (monadic style)
averageFirstTwo :: [Double] -> Maybe Double
averageFirstTwo xs = do
    x <- safeHead xs
    ys <- safeTail xs
    y <- safeHead ys
    let s = x + y
    return (s / 2)

-- Same thing with explicit case chains
averageFirstTwo' :: [Double] -> Maybe Double
averageFirstTwo' xs =
    case safeHead xs of
        Nothing -> Nothing
        Just x  -> case safeTail xs of
            Nothing -> Nothing
            Just ys -> case safeHead ys of
                Nothing -> Nothing
                Just y  -> Just ((x + y) / 2)

-- Extract all even numbers, filtering out failures
extractEvens :: [Int] -> [Int]
extractEvens = mapMaybe (\x -> if even x then Just x else Nothing)

main :: IO ()
main = do
    putStrLn "safeDiv 10 2 = " ++ show (safeDiv 10 2)
    putStrLn "safeDiv 10 0 = " ++ show (safeDiv 10 0)

    putStrLn "safeHead [1,2,3] = " ++ show (safeHead [1,2,3])
    putStrLn "safeHead [] = " ++ show (safeHead ([] :: [Int]))

    putStrLn "averageFirstTwo [10, 20, 30] = " ++ show (averageFirstTwo [10, 20, 30])
    putStrLn "averageFirstTwo [10] = " ++ show (averageFirstTwo [10])
    putStrLn "averageFirstTwo [] = " ++ show (averageFirstTwo ([] :: [Double]))

    putStrLn "averageFirstTwo' same results:"
    putStrLn "  [10,20,30] = " ++ show (averageFirstTwo' [10, 20, 30])
    putStrLn "  [] = " ++ show (averageFirstTwo' ([] :: [Double]))

    putStrLn $ "extractEvens [1,2,3,4,5,6] = " ++ show (extractEvens [1,2,3,4,5,6])
