# Project 02: Algebraic Data Types and Pattern Matching — Haskell

**Difficulty:** beginner  
**Prerequisites:** Project 01 (Basics)

## Goals

- Master Haskell's algebraic data types (ADTs): sum types and product types
- Use pattern matching exhaustively on ADTs
- Understand `Maybe`, `Either`, and other standard ADTs
- Learn `case` expressions and nested pattern matching
- Write recursive functions over recursive data structures (lists, trees)

## Concepts

- **Sum types** — `data T = A | B | C` (a value is one of several alternatives)
- **Product types** — `data T = T Int String` (a value combines multiple fields)
- **Recursive types** — a type that refers to itself (lists, trees)
- **Exhaustive pattern matching** — the compiler warns about missing cases
- **`Maybe a`** — `data Maybe a = Nothing | Just a` (safe null handling)
- **`Either e a`** — `data Either e a = Left e | Right a` (error handling)
- **`case` expressions** — pattern matching anywhere, not just function arguments

## Exercises

### Exercise 1: Shape Area with ADTs

Create `src/shapes.hs`:

```haskell
-- A Shape is either a Circle (one Double) or a Rectangle (two Doubles)
-- This is a SUM type: Shape = Circle + Rectangle
data Shape
    = Circle Double              -- radius
    | Rectangle Double Double    -- width, height
    | Triangle Double Double Double  -- three sides
    deriving (Show, Eq)

-- Pattern match on each constructor
area :: Shape -> Double
area (Circle r)            = pi * r * r
area (Rectangle w h)       = w * h
area (Triangle a b c)      = sqrt (s * (s - a) * (s - b) * (s - c))
  where
    s = (a + b + c) / 2    -- Heron's formula

-- Perimeter using pattern matching
perimeter :: Shape -> Double
perimeter (Circle r)       = 2 * pi * r
perimeter (Rectangle w h)  = 2 * (w + h)
perimeter (Triangle a b c) = a + b + c

-- Classify a shape by size
describe :: Shape -> String
describe shape =
    case area shape of
        a | a > 100   -> "Large shape (area > 100)"
          | a > 10    -> "Medium shape"
          | otherwise -> "Small shape"

main :: IO ()
main = do
    let shapes = [ Circle 5.0
                 , Rectangle 3.0 4.0
                 , Triangle 3.0 4.0 5.0
                 ]

    mapM_ (\s -> putStrLn $ show s ++ " -> area = " ++ show (area s)) shapes

    putStrLn ""
    putStrLn $ "Circle perimeter: " ++ show (perimeter (Circle 5.0))
    putStrLn $ "Rectangle description: " ++ describe (Rectangle 10 20)
```

Compile and run. **Expected output:**
```
Circle 5.0 -> area = 78.53981633974483
Rectangle 3.0 4.0 -> area = 12.0
Triangle 3.0 4.0 5.0 -> area = 6.0

Circle perimeter: 31.41592653589793
Rectangle description: Large shape (area > 100)
```

### Exercise 2: Safe Operations with Maybe

Create `src/maybe_exercises.hs`:

```haskell
-- Maybe is Haskell's safe null: no nulls, no crashes
-- data Maybe a = Nothing | Just a

-- Safe division: returns Nothing for division by zero
safeDiv :: Double -> Double -> Maybe Double
safeDiv _ 0 = Nothing
safeDiv x y = Just (x / y)

-- Safe head: returns Nothing for empty list
safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x

-- Safe tail
safeTail :: [a] -> Maybe [a]
safeTail []     = Nothing
safeTail (_:[]) = Just []
safeTail (_:xs) = Just xs

-- Chaining Maybe with do-notation (monadic style)
-- Find the average of the first two numbers in a list, safely
averageFirstTwo :: [Double] -> Maybe Double
averageFirstTwo xs = do
    x <- safeHead xs
    ys <- safeTail xs
    y <- safeHead ys
    let sum = x + y
    return (sum / 2)

-- Without do-notation (explicit case chains)
averageFirstTwo' :: [Double] -> Maybe Double
averageFirstTwo' xs =
    case safeHead xs of
        Nothing -> Nothing
        Just x  -> case safeTail xs of
            Nothing -> Nothing
            Just ys -> case safeHead ys of
                Nothing -> Nothing
                Just y  -> Just ((x + y) / 2)

-- mapMaybe: filter out Nothing values and extract Just values
import Data.Maybe (mapMaybe)

-- Extract all even numbers from a list, safely handled
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
```

Compile and run. **Expected output:**
```
safeDiv 10 2 = Just 5.0
safeDiv 10 0 = Nothing
safeHead [1,2,3] = Just 1
safeHead [] = Nothing
averageFirstTwo [10, 20, 30] = Just 15.0
averageFirstTwo [10] = Nothing
averageFirstTwo [] = Nothing
averageFirstTwo' same results:
  [10,20,30] = Just 15.0
  [] = Nothing
extractEvens [1,2,3,4,5,6] = [2,4,6]
```

### Exercise 3: Error Handling with Either

Create `src/either_exercises.hs`:

```haskell
-- Either is for operations that can fail with a typed error
-- data Either e a = Left e | Right a
-- By convention: Left = error, Right = success

-- Validate an age: Left String for error, Right Int for success
validateAge :: Int -> Either String Int
validateAge age
    | age < 0    = Left "Age cannot be negative"
    | age > 150  = Left "Age seems unrealistic"
    | otherwise  = Right age

-- Validate a name
validateName :: String -> Either String String
validateName name
    | null (trim name) = Left "Name cannot be empty"
    | length name > 50 = Left "Name too long"
    | otherwise        = Right (trim name)
  where
    trim = dropWhile (== ' ') . reverse . dropWhile (== ' ') . reverse

-- Create a user profile by chaining validations
data UserProfile = UserProfile
    { upName  :: String
    , upAge   :: Int
    } deriving (Show)

createProfile :: String -> Int -> Either String UserProfile
createProfile name age = do
    validName <- validateName name
    validAge  <- validateAge age
    return $ UserProfile validName validAge

-- Chain multiple Either computations with explicit pattern matching
createProfile' :: String -> Int -> Either String UserProfile
createProfile' name age =
    case validateName name of
        Left err     -> Left err
        Right validName ->
            case validateAge age of
                Left err     -> Left err
                Right validAge ->
                    Right $ UserProfile validName validAge

-- A function that returns Either for parsing
parseInt :: String -> Either String Int
parseInt s =
    case reads s of
        [(n, "")] -> Right n
        _         -> Left $ "Cannot parse '" ++ s ++ "' as Int"

-- Combine parseInt with validation
parseAndValidate :: String -> Either String Int
parseAndValidate s = do
    n <- parseInt s
    validateAge n

main :: IO ()
main = do
    putStrLn "validateAge 25 = " ++ show (validateAge 25)
    putStrLn "validateAge (-5) = " ++ show (validateAge (-5))
    putStrLn "validateAge 200 = " ++ show (validateAge 200)

    putStrLn ""
    putStrLn "createProfile \"Alice\" 30 = " ++ show (createProfile "Alice" 30)
    putStrLn "createProfile \"  \" 30 = " ++ show (createProfile "  " 30)
    putStrLn "createProfile \"Alice\" (-1) = " ++ show (createProfile "Alice" (-1))

    putStrLn ""
    putStrLn "parseInt \"42\" = " ++ show (parseInt "42")
    putStrLn "parseInt \"abc\" = " ++ show (parseInt "abc")
    putStrLn "parseAndValidate \"25\" = " ++ show (parseAndValidate "25")
    putStrLn "parseAndValidate \"-5\" = " ++ show (parseAndValidate "-5")
    putStrLn "parseAndValidate \"abc\" = " ++ show (parseAndValidate "abc")
```

Compile and run. **Expected output:**
```
validateAge 25 = Right 25
validateAge (-5) = Left "Age cannot be negative"
validateAge 200 = Left "Age seems unrealistic"

createProfile "Alice" 30 = Right (UserProfile {upName = "Alice", upAge = 30})
createProfile "  " 30 = Left "Name cannot be empty"
createProfile "Alice" (-1) = Left "Age cannot be negative"

parseInt "42" = Right 42
parseInt "abc" = Left "Cannot parse 'abc' as Int"
parseAndValidate "25" = Right 25
parseAndValidate "-5" = Left "Age cannot be negative"
parseAndValidate "abc" = Left "Cannot parse 'abc' as Int"
```

### Exercise 4: Recursive Data Structures — Binary Trees

Create `src/trees.hs`:

```haskell
-- A binary tree: either empty or a node with left subtree, value, right subtree
data Tree a
    = Empty
    | Node (Tree a) a (Tree a)
    deriving (Show, Eq)

-- Insert a value into a BST (binary search tree)
insert :: Ord a => a -> Tree a -> Tree a
insert x Empty = Node Empty x Empty
insert x (Node left v right)
    | x < v     = Node (insert x left) v right
    | x > v     = Node left v (insert x right)
    | otherwise = Node left v right   -- no duplicates

-- Build a tree from a list
fromList :: Ord a => [a] -> Tree a
fromList = foldr insert Empty

-- Search for a value
contains :: Ord a => a -> Tree a -> Bool
contains _ Empty = False
contains x (Node left v right)
    | x < v     = contains x left
    | x > v     = contains x right
    | otherwise = True

-- In-order traversal (sorted for BST)
inOrder :: Tree a -> [a]
inOrder Empty = []
inOrder (Node left v right) = inOrder left ++ [v] ++ inOrder right

-- Tree height
height :: Tree a -> Int
height Empty = 0
height (Node left _ right) = 1 + max (height left) (height right)

-- Tree fold (catamorphism)
treeFold :: b -> (b -> a -> b -> b) -> Tree a -> b
treeFold leaf node Empty = leaf
treeFold leaf node (Node l x r) =
    node (treeFold leaf node l) x (treeFold leaf node r)

-- Count nodes using fold
countNodes :: Tree a -> Int
countNodes = treeFold 0 (\l _ r -> 1 + l + r)

-- Sum values using fold (for numeric trees)
treeSum :: Num a => Tree a -> a
treeSum = treeFold 0 (\l x r -> l + x + r)

-- Map over a tree
treeMap :: (a -> b) -> Tree a -> Tree b
treeMap _ Empty = Empty
treeMap f (Node l x r) = Node (treeMap f l) (f x) (treeMap f r)

-- Pretty-print a tree sideways
prettyPrint :: Show a => Tree a -> IO ()
prettyPrint t = go t 0
  where
    go Empty _ = return ()
    go (Node l x r) depth = do
        go r (depth + 1)
        putStrLn $ replicate (depth * 4) ' ' ++ show x
        go l (depth + 1)

main :: IO ()
main = do
    let nums = [5, 3, 7, 1, 4, 6, 8]
    let tree = fromList nums

    putStrLn "Tree from list " ++ show nums ++ ":"
    prettyPrint tree

    putStrLn ""
    putStrLn $ "Contains 4? " ++ show (contains 4 tree)
    putStrLn $ "Contains 9? " ++ show (contains 9 tree)
    putStrLn $ "In-order: " ++ show (inOrder tree)
    putStrLn $ "Height: " ++ show (height tree)
    putStrLn $ "Node count: " ++ show (countNodes tree)
    putStrLn $ "Sum: " ++ show (treeSum (fromList [1..10] :: Tree Int))

    let doubled = treeMap (*2) tree
    putStrLn $ "Doubled in-order: " ++ show (inOrder doubled)
```

Compile and run. **Expected output:**
```
Tree from list [5,3,7,1,4,6,8]:
        8
    7
        6
5
        4
    3
        1

Contains 4? True
Contains 9? False
In-order: [1,3,4,5,6,7,8]
Height: 3
Node count: 7
Sum: 55
Doubled in-order: [2,6,8,10,12,14,16]
```

## Completion Checklist

- [ ] You can define sum types with multiple constructors
- [ ] You can define product types with multiple fields
- [ ] You can use pattern matching in function definitions
- [ ] You can use `case` expressions for pattern matching anywhere
- [ ] You understand `Maybe a` for safe nullable values
- [ ] You can chain `Maybe` computations with do-notation
- [ ] You understand `Either e a` for typed error handling
- [ ] You can define recursive data types (trees, lists)
- [ ] You can write recursive functions over recursive types
- [ ] You understand `deriving (Show, Eq)` and when to use it
- [ ] You can write a fold over a recursive data structure

## Hints

- Always add `deriving (Show)` to data types so GHCi can print them
- The compiler warns about non-exhaustive patterns — pay attention to these
- `Maybe` is far more common than `Either` in simple code
- Do-notation with `Maybe` and `Either` works the same way (both are Monads)
- Recursive data structures are everywhere in Haskell — lists, trees, ASTs
