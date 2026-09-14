-- Exercise 3: Monad Fundamentals
-- Compile: ghc monads.hs -o monads && ./monads

-- Maybe monad: short-circuits on Nothing
safeDiv :: Double -> Double -> Maybe Double
safeDiv _ 0 = Nothing
safeDiv x y = Just (x / y)

compoundDiv :: Double -> Double -> Double -> Double -> Maybe Double
compoundDiv a b c d = do
    x <- safeDiv a b
    y <- safeDiv c d
    safeDiv x y

compoundDiv' :: Double -> Double -> Double -> Double -> Maybe Double
compoundDiv' a b c d =
    safeDiv a b >>= \x ->
    safeDiv c d >>= \y ->
    safeDiv x y

-- List monad: non-deterministic computation
perms :: [a] -> [[a]]
perms [] = [[]]
perms xs = do
    x <- xs
    xs' <- perms (remove x xs)
    return (x : xs')
  where
    remove _ [] = []
    remove y (z:zs)
        | y == z    = zs
        | otherwise = z : remove y zs

allSums :: [Int] -> [Int] -> [Int]
allSums xs ys = do
    x <- xs
    y <- ys
    return (x + y)

-- Simple State monad (no library imports)
newtype SimpleState s a = SimpleState { runState :: s -> (a, s) }

instance Functor (SimpleState s) where
    fmap f (SimpleState g) = SimpleState $ \s ->
        let (a, s') = g s
        in (f a, s')

instance Applicative (SimpleState s) where
    pure a = SimpleState $ \s -> (a, s)
    SimpleState fg <*> SimpleState fx = SimpleState $ \s ->
        let (g, s')  = fg s
            (x, s'') = fx s'
        in (g x, s'')

instance Monad (SimpleState s) where
    SimpleState f >>= g = SimpleState $ \s ->
        let (a, s') = f s
            SimpleState h = g a
        in h s'

get :: SimpleState s s
get = SimpleState $ \s -> (s, s)

put :: s -> SimpleState s ()
put s = SimpleState $ \_ -> ((), s)

modify :: (s -> s) -> SimpleState s ()
modify f = SimpleState $ \s -> ((), f s)

tick :: SimpleState Int Int
tick = do
    n <- get
    put (n + 1)
    return n

replicateM :: Monad m => Int -> m a -> m [a]
replicateM 0 _ = return []
replicateM n action = do
    x <- action
    xs <- replicateM (n - 1) action
    return (x : xs)

-- Manual state threading for comparison
type Counter = Int

increment :: Counter -> (Int, Counter)
increment s = (s, s + 1)

twoIncrements :: Counter -> (Int, Int, Counter)
twoIncrements s =
    let (a, s1) = increment s
        (b, s2) = increment s1
    in (a, b, s2)

main :: IO ()
main = do
    putStrLn "--- Maybe monad ---"
    putStrLn $ "compoundDiv 10 2 8 4 = " ++ show (compoundDiv 10 2 8 4)
    putStrLn $ "compoundDiv 10 2 0 1 = " ++ show (compoundDiv 10 2 0 1)
    putStrLn $ "compoundDiv' same: " ++ show (compoundDiv' 10 2 0 1)

    putStrLn ""
    putStrLn "--- List monad ---"
    putStrLn $ "perms [1,2,3] = " ++ show (perms [1,2,3])
    putStrLn $ "allSums [1,2] [10,20,30] = " ++ show (allSums [1,2] [10,20,30])

    putStrLn ""
    putStrLn "--- State monad ---"
    putStrLn $ "twoIncrements 0 = " ++ show (twoIncrements 0)
    let (results, final) = runState (replicateM 5 tick) 0
    putStrLn $ "runState (replicateM 5 tick) 0 = " ++ show results ++ ", final = " ++ show final
