-- Exercise 4: Custom Data Types
-- Compile: ghc data_types.hs -o data_types && ./data_types

-- Algebraic data type: Shape can be Circle or Rectangle
data Shape
    = Circle Double
    | Rectangle Double Double
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

-- "Update" a record — creates a new Person (immutable)
birthday :: Person -> Person
birthday p = p { age = age p + 1 }

-- Type synonyms
type UserName = String
type Email    = String

-- Using record accessors
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
