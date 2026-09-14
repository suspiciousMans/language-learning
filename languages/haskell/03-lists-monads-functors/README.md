# Project 03: Lists, Monads, and Functors — Haskell

**Difficulty:** intermediate  
**Prerequisites:** Project 02 (Algebraic Data Types)

## Goals

- Write fluent list processing code with list comprehensions and higher-order functions
- Understand the Functor typeclass and `fmap`/`(<$>)`
- Understand the Monad typeclass and `do`-notation
- Use the standard monad instances: `Maybe`, `Either`, `[]` (lists), `IO`
- Write functions that work across all monads with `Monad` constraints

## Concepts

- **List comprehensions** — `[x*2 | x <- [1..10], even x]`
- **Higher-order list functions** — `map`, `filter`, `foldr`, `foldl`, `concatMap`
- **Functor** — `fmap :: (a -> b) -> f a -> f b` (map over any context)
- **Applicative** — `pure` and `(<*>)` for applying functions in context
- **Monad** — `(>>=)` (bind) for sequencing computations that produce context
- **`do`-notation** — syntactic sugar for monadic sequencing
- **`return`** — wraps a value in the monad (not a keyword, just a function!)

## Exercises

### Exercise 1: List Processing

Create `src/lists.hs`:

```haskell
-- List comprehensions: Haskell's answer to Python list comprehensions
-- with filtering and nesting

-- All combinations of two dice rolls that sum to 7
dicePairs :: [(Int, Int)]
dicePairs = [(x, y) | x <- [1..6], y <- [1..6], x + y == 7]

-- Pythagorean triples up to n
pythagorean :: Int -> [(Int, Int, Int)]
pythagorean n =
    [(a, b, c) | a <- [1..n], b <- [a..n], c <- [b..n]
                , a^2 + b^2 == c^2]

-- Functional style: map, filter, fold
doubleAll :: [Int] -> [Int]
doubleAll = map (*2)

filterEvens :: [Int] -> [Int]
filterEvens = filter even

sumSquares :: [Int] -> Int
sumSquares = foldr (\x acc -> x^2 + acc) 0

-- List maximum using foldr
listMax :: [Int] -> Maybe Int
listMax [] = Nothing
listMax (x:xs) = Just $ foldr max x xs

-- Group a list into chunks of n
chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : chunksOf n (drop n xs)

-- Transpose a list of lists (matrix transpose)
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
```

Compile and run. **Expected output:**
```
Dice pairs summing to 7:
[(1,6),(2,5),(3,4),(4,3),(5,2),(6,1)]

Pythagorean triples up to 20:
[(3,4,5),(6,8,10),(5,12,13),(9,12,15),(8,15,17),(12,16,20)]

doubleAll [1,2,3,4,5] = [2,4,6,8,10]
filterEvens [1..10] = [2,4,6,8,10]
sumSquares [1,2,3] = 14
listMax [3,7,2,9,1] = Just 9
listMax [] = Nothing

chunksOf 3 [1..10] = [[1,2,3],[4,5,6],[7,8,9],[10]]
chunksOf 2 "haskell" = ["ha","sk","el","lk"]

transpose [[1,2,3],[4,5,6],[7,8,9]] = 
[[1,4,7],[2,5,8],[3,6,9]]
```

### Exercise 2: Functor and Applicative

Create `src/functors.hs`:

```haskell
-- Functor: map over a context
-- fmap :: Functor f => (a -> b) -> f a -> f b

-- Maybe as a functor: apply function only if Just
safeDouble :: Maybe Int -> Maybe Int
safeDouble = fmap (*2)

-- Either as a functor: apply function only to Right value
safeAdd :: Either String Int -> Either String Int
safeAdd = fmap (+10)

-- List as a functor: map over list
listAdd :: [Int] -> [Int]
listAdd = fmap (+1)

-- Function as a functor: fmap = composition!
-- fmap f g = f . g
fmapExample :: IO ()
fmapExample = do
    let add1 = (+1) :: Int -> Int
        double = (*2) :: Int -> Int
        -- fmap on functions is just composition
        addThenDouble = fmap double add1   -- = double . add1
    putStrLn $ "fmap double (+1) applied to 5 = " ++ show (addThenDouble 5)
    -- = double (add1 5) = double 6 = 12

-- Applicative: apply a function in context to a value in context
-- (<*>) :: Applicative f => f (a -> b) -> f a -> f b
-- pure  :: Applicative f => a -> f a

-- Maybe applicative: apply only if both are Just
addMaybe :: Maybe Int -> Maybe Int -> Maybe Int
addMaybe mx my = pure (+) <*> mx <*> my
-- Equivalently: (+) <$> mx <*> my

-- Either applicative
addEither :: Either String Int -> Either String Int -> Either String Int
addEither ex ey = pure (+) <*> ex <*> ey

-- List applicative: Cartesian product of applications
addLists :: [Int] -> [Int] -> [Int]
addLists xs ys = pure (+) <*> xs <*> ys
-- Result: [x+y | x <- xs, y <- ys]

-- IO applicative: combine IO actions
addIO :: IO Int -> IO Int -> IO Int
addIO mx my = pure (+) <*> mx <*> my

-- sequenceA: traverse a structure of applicatives
-- sequenceA :: Applicative f => t (f a) -> f (t a)
sequenceExample :: IO ()
sequenceExample = do
    let actions = [putStrLn "Hello", putStrLn "World", putStrLn "!"]
    sequence_ actions   -- sequence_ for IO: sequence + forget results

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
    -- Cartesian product: [1+10, 1+20, 2+10, 2+20] = [11,21,12,22]

    putStrLn ""
    putStrLn "--- sequence_ example ---"
    sequenceExample
```

Compile and run. **Expected output:**
```
--- Functor examples ---
safeDouble (Just 5) = Just 10
safeDouble Nothing = Nothing
safeAdd (Right 10) = Right 20
safeAdd (Left "error") = Left "error"
listAdd [1,2,3] = [2,3,4]
fmap double (+1) applied to 5 = 12

--- Applicative examples ---
addMaybe (Just 3) (Just 4) = Just 7
addMaybe (Just 3) Nothing = Nothing
addEither (Right 3) (Right 4) = Right 7
addEither (Left "err") (Right 4) = Left "err"
addLists [1,2] [10,20] = [11,21,12,22]

--- sequence_ example ---
Hello
World
!
```

### Exercise 3: Monad Fundamentals

Create `src/monads.hs`:

```haskell
-- Monad: (>>=) :: Monad m => m a -> (a -> m b) -> m b
-- (bind) takes a monadic value, extracts the value, and passes it
-- to a function that produces another monadic value.

-- Maybe monad: short-circuits on Nothing
-- This is the same as the case-chain we wrote in Project 02,
-- but much cleaner with (>>=) or do-notation.

-- Safe division chain with Maybe monad
safeDiv :: Double -> Double -> Maybe Double
safeDiv _ 0 = Nothing
safeDiv x y = Just (x / y)

-- Compute (a / b) / (c / d) safely — returns Nothing if any division fails
compoundDiv :: Double -> Double -> Double -> Double -> Maybe Double
compoundDiv a b c d = do
    x <- safeDiv a b
    y <- safeDiv c d
    safeDiv x y

-- Same with explicit (>>=)
compoundDiv' :: Double -> Double -> Double -> Double -> Maybe Double
compoundDiv' a b c d =
    safeDiv a b >>= \x ->
    safeDiv c d >>= \y ->
    safeDiv x y

-- List monad: non-deterministic computation
-- Each step can produce multiple results; monad combines them all
perms :: [a] -> [[a]]
perms [] = [[]]
perms xs = do
    x <- xs                    -- pick one element
    xs' <- perms (remove x xs) -- permute the rest
    return (x : xs')
  where
    remove _ [] = []
    remove y (z:zs)
        | y == z    = zs
        | otherwise = z : remove y zs

-- All possible sums from two lists (list monad)
allSums :: [Int] -> [Int] -> [Int]
allSums xs ys = do
    x <- xs
    y <- ys
    return (x + y)

-- Same as list comprehension: [x+y | x <- xs, y <- ys]

-- The State monad: threaded state without manual plumbing
-- State s a = s -> (a, s)
-- We'll use a simple version without importing Control.Monad.State

-- A counter that increments and returns the new value
type Counter = Int

increment :: Counter -> (Int, Counter)
increment s = (s, s + 1)

-- Chain two increments manually
twoIncrements :: Counter -> (Int, Int, Counter)
twoIncrements s =
    let (a, s1) = increment s
        (b, s2) = increment s1
    in (a, b, s2)

-- Simulated State monad
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

-- Use the State monad to implement a simple counter
tick :: SimpleState Int Int
tick = do
    n <- get
    put (n + 1)
    return n

runTicks :: Int -> Int -> ([Int], Int)
runTicks n k = runState (replicateM k tick) n

-- replicateM for our SimpleState
replicateM :: Monad m => Int -> m a -> m [a]
replicateM 0 _ = return []
replicateM n action = do
    x <- action
    xs <- replicateM (n - 1) action
    return (x : xs)

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
    let (results, final) = runTicks 0 5
    putStrLn $ "runTicks 0 5 = " ++ show results ++ ", final state = " ++ show final
```

Compile and run. **Expected output:**
```
--- Maybe monad ---
compoundDiv 10 2 8 4 = Just 2.5
compoundDiv 10 2 0 1 = Nothing
compoundDiv' same: Nothing

--- List monad ---
perms [1,2,3] = [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
allSums [1,2] [10,20,30] = [11,21,31,12,22,32]

--- State monad ---
twoIncrements 0 = (0,1,2)
runTicks 0 5 = [0,1,2,3,4], final state = 5
```

### Exercise 4: Monad Transformers (Introduction)

Create `src/transformers_intro.hs`:

```haskell
-- A monad transformer stacks monads so you can use multiple effects.
-- ReaderT r m a: read an environment r, plus the effects of m
-- StateT s m a: threaded state s, plus the effects of m
-- MaybeT m a: short-circuit on Nothing, plus the effects of m

-- For this exercise, we'll build simple transformer-like compositions
-- WITHOUT importing Control.Monad.Trans (to keep it dependency-free).

-- A simple "Reader" pattern: pass an environment to functions
type Reader r a = r -> a

readerExample :: Reader [(String, Int)] Int
readerExample env = case lookup "answer" env of
    Just n  -> n * 2
    Nothing -> 42

-- A "Reader + Maybe" combined manually
type ReaderMaybe r a = r -> Maybe a

lookupUser :: String -> ReaderMaybe [(String, Int)] Int
lookupUser name env = lookup name env

processUser :: String -> ReaderMaybe [(String, Int)] String
processUser name env = do
    age <- lookupUser name env
    if age >= 18
        then return $ name ++ " is an adult (age " ++ show age ++ ")"
        else return $ name ++ " is a minor (age " ++ show age ++ ")"

-- A "Reader + State" combined: environment + threaded state
type ReaderState r s a = r -> s -> (a, s)

-- Count how many users we've processed
data ProcessState = ProcessState
    { processedCount :: Int
    } deriving (Show)

processUsers :: [String] -> ReaderState [(String, Int)] ProcessState [String]
processUsers names env state = go names env state []
  where
    go [] _ st acc = (reverse acc, st)
    go (n:ns) e (ProcessState count) acc =
        case lookup n e of
            Nothing -> go ns e (ProcessState count) acc  -- skip unknown
            Just age ->
                let msg = n ++ " (age " ++ show age ++ ")"
                    newSt = ProcessState (count + 1)
                in go ns e newSt (msg : acc)

-- Using the combined reader/state to process a list
main :: IO ()
main = do
    let env = [("Alice", 30), ("Bob", 15), ("Charlie", 25), ("Diana", 17)]

    putStrLn "--- Reader example ---"
    putStrLn $ "readerExample env = " ++ show (readerExample env)
    putStrLn $ "readerExample [\"answer\" :=> 21] = " ++ show (readerExample [("answer", 21)])

    putStrLn ""
    putStrLn "--- ReaderMaybe example ---"
    putStrLn $ "processUser \"Alice\" env = " ++ show (processUser "Alice" env)
    putStrLn $ "processUser \"Bob\" env = " ++ show (processUser "Bob" env)
    putStrLn $ "processUser \"Unknown\" env = " ++ show (processUser "Unknown" env)

    putStrLn ""
    putStrLn "--- ReaderState example ---"
    let initState = ProcessState 0
    let (results, finalState) = processUsers ["Alice", "Bob", "Charlie", "Diana", "Eve"] env initState
    putStrLn $ "Results: " ++ show results
    putStrLn $ "Final state: " ++ show finalState

    -- Show what happens when we process only verified users
    let verified = ["Alice", "Charlie"]
    let (okResults, okState) = processUsers verified env initState
    putStrLn $ "Processing only verified: " ++ show okResults
    putStrLn $ "State after: " ++ show okState
```

Compile and run. **Expected output:**
```
--- Reader example ---
readerExample env = 60
readerExample [("answer" .=> 21)] = 42

--- ReaderMaybe example ---
processUser "Alice" env = Just "Alice is an adult (age 30)"
processUser "Bob" env = Just "Bob is a minor (age 15)"
processUser "Unknown" env = Nothing

--- ReaderState example ---
Results: ["Alice (age 30)","Charlie (age 25)"]
Final state: ProcessState {processedCount = 2}

Processing only verified: ["Alice (age 30)","Charlie (age 25)"]
State after: ProcessState {processedCount = 2}
```

## Completion Checklist

- [ ] You can use list comprehensions with guards and multiple generators
- [ ] You can use `map`, `filter`, `foldr`, `foldl` fluently
- [ ] You understand `fmap` as "map over a context" for any Functor
- [ ] You can use `(<$>)` as an infix `fmap`
- [ ] You understand `pure` and `(<*>)` for Applicative
- [ ] You can use do-notation for any monad (Maybe, Either, [], IO)
- [ ] You understand `(>>=)` as "bind" — extract value and pass to next computation
- [ ] You can use the State monad pattern for threaded state
- [ ] You understand monad transformers conceptually (stacking effects)

## Hints

- List comprehensions are syntactic sugar for `concatMap` and `guard`
- Functor is the simplest: `fmap` is just "apply a function inside a box"
- Applicative is a step up: apply a function *inside a box* to a value *inside a box*
- Monad is the most powerful: the next computation can depend on the previous result
- `do`-notation is just sugar for `(>>=)` chains — desugar in your head when stuck
- The State monad doesn't mutate state; it passes a new state to each step
- Monad transformers let you combine effects; real code uses `ReaderT`, `StateT`, `ExceptT`
