-- Exercise 1: Common Typeclasses
-- Compile: ghc typeclasses.hs -o typeclasses && ./typeclasses

-- Temperature: a custom ADT
data Temperature
    = Freezing
    | Cold
    | Mild
    | Warm
    | Hot
    deriving (Show, Enum, Bounded)

instance Eq Temperature where
    Freezing == Freezing = True
    Cold     == Cold     = True
    Mild     == Mild     = True
    Warm     == Warm     = True
    Hot      == Hot      = True
    _        == _        = False

instance Ord Temperature where
    compare Freezing Cold = LT
    compare Freezing _    = LT
    compare Cold Mild     = LT
    compare Cold Warm     = LT
    compare Cold Hot      = LT
    compare Cold Freezing = GT
    compare Mild Warm     = LT
    compare Mild Hot      = LT
    compare Mild Freezing = GT
    compare Mild Cold     = GT
    compare Warm Hot      = LT
    compare Warm Freezing = GT
    compare Warm Cold     = GT
    compare Warm Mild     = GT
    compare Hot _         = GT
    compare _ Hot         = LT
    compare x y           = if x == y then EQ else error "unreachable"

data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
    deriving (Show, Eq, Enum, Bounded, Ord)

data Point = Point
    { px :: Double
    , py :: Double
    } deriving (Show)

instance Eq Point where
    (Point x1 y1) == (Point x2 y2) = x1 == x2 && y1 == y2

instance Ord Point where
    compare (Point x1 y1) (Point x2 y2) =
        case compare x1 x2 of
            EQ -> compare y1 y2
            other -> other

newtype NonNegative = NonNegative Int
    deriving (Show, Eq)

instance Num NonNegative where
    NonNegative a + NonNegative b = NonNegative (a + b)
    NonNegative a * NonNegative b = NonNegative (a * b)
    negate _ = error "cannot negate NonNegative"
    abs (NonNegative n) = NonNegative n
    signum (NonNegative 0) = NonNegative 0
    signum (NonNegative _) = NonNegative 1
    fromInteger n
        | n >= 0    = NonNegative (fromInteger n)
        | otherwise = error "fromInteger: negative value"

data Suit = Hearts | Diamonds | Clubs | Spades
    deriving (Show, Eq, Bounded)

instance Enum Suit where
    fromEnum Hearts   = 0
    fromEnum Diamonds = 1
    fromEnum Clubs    = 2
    fromEnum Spades   = 3

    toEnum 0 = Hearts
    toEnum 1 = Diamonds
    toEnum 2 = Clubs
    toEnum 3 = Spades
    toEnum _ = error "toEnum: invalid suit index"

main :: IO ()
main = do
    putStrLn "--- Temperature typeclass examples ---"
    putStrLn $ "Freezing == Cold? " ++ show (Freezing == Cold)
    putStrLn $ "Hot > Cold? " ++ show (Hot > Cold)
    putStrLn $ "min Mild Hot = " ++ show (min Mild Hot)
    putStrLn $ "max Mild Hot = " ++ show (max Mild Hot)
    putStrLn $ "succ Mild = " ++ show (succ Mild)
    putStrLn $ "pred Hot = " ++ show (pred Hot)
    putStrLn $ "minBound :: Temperature = " ++ show (minBound :: Temperature)
    putStrLn $ "maxBound :: Temperature = " ++ show (maxBound :: Temperature)

    putStrLn ""
    putStrLn "--- Day typeclass examples ---"
    putStrLn $ "Monday < Friday? " ++ show (Monday < Friday)
    putStrLn $ "enumFrom Monday = " ++ show (enumFrom Monday)
    putStrLn $ "[Monday .. Friday] = " ++ show ([Monday .. Friday])
    putStrLn $ "minBound :: Day = " ++ show (minBound :: Day)
    putStrLn $ "maxBound :: Day = " ++ show (maxBound :: Day)

    putStrLn ""
    putStrLn "--- Point typeclass examples ---"
    let p1 = Point 3.0 4.0
        p2 = Point 3.0 5.0
        p3 = Point 5.0 1.0
    putStrLn $ "p1 == p2? " ++ show (p1 == p2)
    putStrLn $ "p1 < p3? " ++ show (p1 < p3)
    putStrLn $ "sort [p3, p1, p2] = " ++ show (sort [p3, p1, p2 :: Point])

    putStrLn ""
    putStrLn "--- NonNegative examples ---"
    let a = NonNegative 5
        b = NonNegative 3
    putStrLn $ "a + b = " ++ show (a + b)
    putStrLn $ "a * b = " ++ show (a * b)
    putStrLn $ "abs (NonNegative 5) = " ++ show (abs (NonNegative 5))
    putStrLn $ "fromInteger 42 = " ++ show (fromInteger 42 :: NonNegative)

    putStrLn ""
    putStrLn "--- Suit examples ---"
    putStrLn $ "fromEnum Hearts = " ++ show (fromEnum Hearts)
    putStrLn $ "toEnum 2 = " ++ show (toEnum 2 :: Suit)
    putStrLn $ "succ Hearts = " ++ show (succ Hearts)
    putStrLn $ "pred Spades = " ++ show (pred Spades)
    putStrLn $ "[Hearts .. Spades] = " ++ show ([Hearts .. Spades])
