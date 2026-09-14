# Project 01: Basics — Types, Functions, and Control Flow — Haskell

**Difficulty:** beginner  
**Prerequisites:** Project 00 (Tooling Check)

## Goals

- Understand Haskell's basic syntax: functions, types, pattern matching, conditionals
- Write and run simple Haskell programs
- Learn Haskell's static type system and type inference
- Understand purity: no side effects in regular functions

## Concepts

- **`let` and `where`** — local bindings in functions
- **Type signatures** — `::` notation: `add :: Int -> Int -> Int`
- **Type inference** — GHC figures out types from context
- **Pattern matching** — deconstruct values in function definitions and `case` expressions
- **Guards** — conditional branching with `|` predicates
- **If-then-else** — every `if` must have an `else` (it's an expression)
- **Lazy evaluation** — expressions are evaluated only when needed

## Exercises

### Exercise 1: Variables and Types

Create `src/basics.hs`:

```haskell
-- Haskell has no mutable variables — everything is a definition
-- Use 'let' for local bindings inside functions
-- Use 'where' for local bindings at the top of a function

main :: IO ()
main = do
    let name = "Haskell" :: String
    let year = 1990 :: Int        -- First release year
    let version = 9.4 :: Double   -- Current GHC version

    -- Type inference means you often don't need annotations
    message = "Learning " ++ name   -- inferred as String

    putStrLn $ name ++ " was released in " ++ show year
    putStrLn $ "Version: " ++ show version
    putStrLn message
```

Compile and run:

```bash
ghc src/basics.hs -o basics && ./basics
```

**Expected output:**
```
Haskell was released in 1990
Version: 9.4
Learning Haskell
```

**Note:** Haskell is strict about types. `show` converts numbers to strings for concatenation. The `++` operator works on lists (including strings), not general types.

### Exercise 2: Control Flow — Pattern Matching and Guards

Create `src/control_flow.hs`:

```haskell
-- Pattern matching on function arguments
grade :: Int -> String
grade score
    | score >= 90 = "A"
    | score >= 80 = "B"
    | score >= 70 = "C"
    | otherwise   = "F"          -- 'otherwise' is just True

-- Pattern matching on values (like switch)
dayName :: Int -> String
dayName 1 = "Monday"
dayName 2 = "Tuesday"
dayName 3 = "Wednesday"
dayName 4 = "Thursday"
dayName 5 = "Friday"
dayName 6 = "Saturday"
dayName 7 = "Sunday"
dayName _ = "Unknown"            -- _ matches anything (wildcard)

-- Recursive counting with pattern matching
countDown :: Int -> IO ()
countDown 0 = putStrLn "Go!"
countDown n = do
    putStr (show n ++ "... ")
    countDown (n - 1)

main :: IO ()
main = do
    let score = 87
    putStrLn $ "Score: " ++ show score ++ " -> Grade: " ++ grade score

    let day = 3
    putStrLn $ "Day " ++ show day ++ " is " ++ dayName day

    putStr "Counting 1 to 5: "
    sequence_ [putStr (show i ++ " ") | i <- [1..5]]
    putStrLn ""

    putStrLn "Countdown: "
    countDown 5
```

Compile and run. **Expected output:**
```
Score: 87 -> Grade: B
Day 3 is Wednesday
Counting 1 to 5: 1 2 3 4 5 
Countdown: 
5... 4... 3... 2... 1... Go!
```

### Exercise 3: Functions — Composition and Recursion

Create `src/functions.hs`:

```haskell
-- Simple function with type signature
add :: Int -> Int -> Int
add a b = a + b

-- Curried by default: add 3 returns a function Int -> Int
-- Partial application
add3 :: Int -> Int
add3 = add 3

-- Function with pattern matching
factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- Guard-based factorial (tail-recursive with accumulator)
factorialTail :: Integer -> Integer -> Integer
factorialTail n acc
    | n <= 1    = acc
    | otherwise  = factorialTail (n - 1) (n * acc)

factorial' :: Integer -> Integer
factorial' n = factorialTail n 1

-- Function that returns a tuple (multiple values)
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

    putStrLn $ "factorial 5 = " ++ show (factorial 5)   -- 120
    putStrLn $ "factorial' 5 = " ++ show (factorial' 5) -- 120

    let numbers = [3, 7, 2, 9, 1]
    let (lo, hi) = minMax numbers
    putStrLn $ "Min: " ++ show lo ++ ", Max: " ++ show hi
```

Compile and run. **Expected output:**
```
3 + 5 = 8
add 3 10 = 13
factorial 5 = 120
factorial' 5 = 120
Min: 1, Max: 9
```

### Exercise 4: Custom Data Types

Create `src/data_types.hs`:

```haskell
-- Algebraic data type: a Shape can be a Circle or a Rectangle
data Shape
    = Circle Double    -- radius
    | Rectangle Double Double  -- width, height
    deriving (Show)

-- Pattern matching to compute area
area :: Shape -> Double
area (Circle r)      = pi * r * r
area (Rectangle w h) = w * h

-- Record syntax: auto-generated accessor functions
data Person = Person
    { name    :: String
    , age     :: Int
    , city    :: String
    } deriving (Show)

-- Update a record (creates a new Person — values are immutable)
birthday :: Person -> Person
birthday p = p { age = age p + 1 }

-- Type synonym: String is just [Char]
type UserName = String
type Email    = String

-- A function using record accessors
greet :: Person -> String
greet p = "Hello, " ++ name p ++ " from " ++ city p ++ "!"

main :: IO ()
main = do
    let c = Circle 5.0
    let r = Rectangle 3.0 4.0
    putStrLn $ "Circle area: " ++ show (area c)
    putStrLn $ "Rectangle area: " ++ show (area r)

    let alice = Person "Alice" 30 "New York"
    putStrLn $ show alice
    putStrLn $ greet alice

    let olderAlice = birthday alice
    putStrLn $ "After birthday: " ++ show olderAlice
```

Compile and run. **Expected output:**
```
Circle area: 78.53981633974483
Rectangle area: 12.0
Person {name = "Alice", age = 30, city = "New York"}
Hello, Alice from New York!
After birthday: Person {name = "Alice", age = 31, city = "New York"}
```

## Completion Checklist

- [ ] You understand `let` and `where` for local bindings
- [ ] You can write type signatures with `::`
- [ ] You can use pattern matching in function definitions
- [ ] You can use guards (`|`) for conditional logic
- [ ] You understand that `if` always requires an `else`
- [ ] You can write recursive functions
- [ ] You understand currying: `add 3` is a function
- [ ] You can define custom data types with `data`
- [ ] You can use record syntax for named fields
- [ ] You can use `deriving (Show)` for automatic pretty-printing
- [ ] You understand that values are immutable — "updating" creates new values

## Hints

- Read the official Haskell getting started: https://www.haskell.org/ghc/
- Pattern matching is Haskell's superpower — prefer it over if-then-else when possible
- Every Haskell function is curried by default — `f a b c` means `((f a) b) c`
- Use `deriving (Show, Eq)` for almost every data type you define
- `:t expr` in GHCi shows the type of any expression
