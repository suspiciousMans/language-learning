-- Exercise 2: Functor and Applicative
-- Compile: ghc functors.hs -o functors && ./functors

-- Functor: map over a context
-- fmap :: Functor f => (a -> b) -> f a -> f b

safeDouble :: Maybe Int -> Maybe Int
safeDouble = fmap (*2)

safeAdd :: Either String Int -> Either String Int
safeAdd = fmap (+10)

listAdd :: [Int] -> [Int]
listAdd = fmap (+1)

-- Applicative: apply function in context
-- (<*>) :: Applicative f => f (a -> b) -> f a -> f b
-- pure  :: Applicative f => a -> f a

addMaybe :: Maybe Int -> Maybe Int -> Maybe Int
addMaybe mx my = pure (+) <*> mx <*> my

addEither :: Either String Int -> Either String Int -> Either String Int
addEither ex ey = pure (+) <*> ex <*> ey

addLists :: [Int] -> [Int] -> [Int]
addLists xs ys = pure (+) <*> xs <*> ys

-- IO applicative
addIO :: IO Int -> IO Int -> IO Int
addIO mx my = pure (+) <*> mx <*> my

-- Function as a functor: fmap = composition
fmapExample :: IO ()
fmapExample = do
    let add1 = (+1) :: Int -> Int
        double = (*2) :: Int -> Int
        addThenDouble = fmap double add1
    putStrLn $ "fmap double (+1) applied to 5 = " ++ show (addThenDouble 5)

-- sequence_ for IO
sequenceExample :: IO ()
sequenceExample = do
    let actions = [putStrLn "Hello", putStrLn "World", putStrLn "!"]
    sequence_ actions

main :: IO ()
main = do
    putStrLn "--- Functor examples ---"
    putStrLn $ "safeDouble (Just 5) = " ++ show (safeDouble (Just 5))
    putStrLn $ "safeDouble Nothing = " ++ show (safeDouble (Nothing :: Maybe Int))

    putStrLn $ "safeAdd (Right 10) = " ++ show (safeAdd (Right 10 :: Either String Int))
    putStrLn $ "safeAdd (Left \"error\") = " ++ show (safeAdd (Left "error" :: Either String Int))

    putStrLn $ "listAdd [1,2,3] = " ++ show (listAdd [1,2,3])

    fmapExample

    putStrLn ""
    putStrLn "--- Applicative examples ---"
    putStrLn $ "addMaybe (Just 3) (Just 4) = " ++ show (addMaybe (Just 3) (Just 4))
    putStrLn $ "addMaybe (Just 3) Nothing = " ++ show (addMaybe (Just 3) (Nothing :: Maybe Int))
    putStrLn $ "addEither (Right 3) (Right 4) = " ++ show (addEither (Right 3) (Right 4))
    putStrLn $ "addEither (Left \"err\") (Right 4) = " ++ show (addEither (Left "err") (Right 4 :: Either String Int))

    putStrLn $ "addLists [1,2] [10,20] = " ++ show (addLists [1,2] [10,20])

    putStrLn ""
    putStrLn "--- sequence_ example ---"
    sequenceExample
