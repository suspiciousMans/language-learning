# Project 04: Typeclasses and Lenses — Haskell

**Difficulty:** intermediate  
**Prerequisites:** Project 03 (Lists, Monads, Functors)

## Goals

- Understand Haskell's typeclass system: ad-hoc polymorphism
- Define and use common typeclasses: `Eq`, `Ord`, `Show`, `Enum`, `Bounded`, `Num`, `Foldable`, `Traversable`
- Write instances for custom types
- Use the `lens` library for composable, immutable data updates
- Understand how `lens` relates to `Functor` and `Traversable`

## Concepts

- **Typeclasses** — Haskell's ad-hoc polymorphism: `class` defines operations, `instance` provides implementations
- **`Eq`** — equality: `(==)` and `(/=)`
- **`Ord`** — ordering: `compare`, `(<)`, `(<=)`, `(>)`, `(>=)`, `min`, `max`
- **`Show`** — string representation: `show`
- **`Enum`** — sequential types: `succ`, `pred`, `toEnum`, `fromEnum`, enumeration ranges
- **`Bounded`** — upper and lower bounds: `minBound`, `maxBound`
- **`Num`** — numeric operations: `+`, `*`, `negate`, `abs`, `signum`, `fromInteger`
- **`Foldable`** — left and right folds over data structures: `foldMap`, `foldr`, `foldl`
- **`Traversable`** — traverse with effects: `traverse`, `sequenceA`
- **`Lens`** — composable getters and setters: `lens`, `view`, `set`, `over`
- **`Iso`** — bidirectional isomorphism: `iso`, `view`, `review`

## Exercises

### Exercise 1: Common Typeclasses

Create `src/typeclasses.hs`:

```haskell
-- A custom data type we'll write instances for
data Temperature
    = Freezing
    | Cold
    | Mild
    | Warm
    | Hot
    deriving (Show, Enum, Bounded)

-- Eq instance (deriving works, but let's write it manually)
instance Eq Temperature where
    Freezing == Freezing = True
    Cold     == Cold     = True
    Mild     == Mild     = True
    Warm     == Warm     = True
    Hot      == Hot      = True
    _        == _        = False

-- Ord instance: ordering from cold to hot
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

-- A more practical Ord: derive it from Enum
data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
    deriving (Show, Eq, Enum, Bounded, Ord)

-- A Point type to practice writing multiple instances
data Point = Point
    { px :: Double
    , py :: Double
    } deriving (Show)

-- Eq for Point
instance Eq Point where
    (Point x1 y1) == (Point x2 y2) = x1 == x2 && y1 == y2

-- Ord for Point (lexicographic: compare x first, then y)
instance Ord Point where
    compare (Point x1 y1) (Point x2 y2) =
        case compare x1 x2 of
            EQ -> compare y1 y2
            other -> other

-- A custom numeric type: non-negative integers only
newtype NonNegative = NonNegative Int
    deriving (Show, Eq)

-- We can't derive Num safely (would allow negative), so we guard
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

-- Enum instance for a custom type
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
```

Compile and run. **Expected output:**
```
--- Temperature typeclass examples ---
Freezing == Cold? False
Hot > Cold? True
min Mild Hot = Mild
max Mild Hot = Hot
succ Mild = Warm
pred Hot = Warm
minBound :: Temperature = Freezing
maxBound :: Temperature = Hot

--- Day typeclass examples ---
Monday < Friday? True
enumFrom Monday = [Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday]
[Monday .. Friday] = [Monday,Tuesday,Wednesday,Thursday,Friday]
minBound :: Day = Monday
maxBound :: Day = Sunday

--- Point typeclass examples ---
p1 == p2? False
p1 < p3? True
sort [p3, p1, p2] = [Point {px = 3.0, py = 4.0},Point {px = 3.0, py = 5.0},Point {px = 5.0, py = 1.0}]

--- NonNegative examples ---
a + b = NonNegative 8
a * b = NonNegative 15
abs (NonNegative 5) = NonNegative 5
fromInteger 42 = NonNegative 42

--- Suit examples ---
fromEnum Hearts = 0
toEnum 2 = Clubs
succ Hearts = Diamonds
pred Spades = Clubs
[Hearts .. Spades] = [Hearts,Diamonds,Clubs,Spades]
```

### Exercise 2: Foldable and Traversable

Create `src/foldable.hs`:

```haskell
-- A custom binary tree (from Project 02)
data Tree a
    = Empty
    | Node (Tree a) a (Tree a)
    deriving (Show, Eq)

-- Foldable instance for Tree
-- foldMap :: Monoid m => (a -> m) -> Tree a -> m
-- We accumulate monoid values by traversing in-order
instance Foldable Tree where
    foldMap _ Empty = mempty
    foldMap f (Node l x r) = foldMap f l <> f x <> foldMap f r

    foldr _ z Empty = z
    foldr f z (Node l x r) = foldr f (f x (foldr f z r)) l

    foldl _ z Empty = z
    foldl f z (Node l x r) = foldl f (f (foldl f z l) x) r

-- Traversable instance: traverse effects over the tree
instance Traversable Tree where
    traverse _ Empty = pure Empty
    traverse f (Node l x r) = Node <$> traverse f l <*> f x <*> traverse f r

-- Now we can use all Foldable functions on trees
tree1 :: Tree Int
tree1 = Node (Node Empty 1 Empty)
             2
             (Node (Node Empty 3 Empty) 4 (Node Empty 5 Empty))

-- A rose tree (tree with arbitrary branching)
data RoseTree a
    = RoseNode a [RoseTree a]
    deriving (Show)

instance Functor RoseTree where
    fmap f (RoseNode x children) = RoseNode (f x) (map (fmap f) children)

instance Foldable RoseTree where
    foldMap f (RoseNode x children) = f x <> mconcat (map (foldMap f) children)

instance Traversable RoseTree where
    traverse f (RoseNode x children) = RoseNode <$> f x <*> traverse (traverse f) children

-- A simple rose tree
rose1 :: RoseTree String
rose1 = RoseNode "root"
    [ RoseNode "left" [RoseNode "leaf1" [], RoseNode "leaf2" []]
    , RoseNode "right" [RoseNode "leaf3" []]
    ]

main :: IO ()
main = do
    putStrLn "--- Tree Foldable ---"
    putStrLn $ "tree1: " ++ show tree1
    putStrLn $ "foldr (+) 0 tree1 = " ++ show (foldr (+) 0 tree1)
    putStrLn $ "foldl (+) 0 tree1 = " ++ show (foldl (+) 0 tree1)
    putStrLn $ "sum tree1 = " ++ show (sum tree1)
    putStrLn $ "product tree1 = " ++ show (product tree1)
    putStrLn $ "maximum tree1 = " ++ show (maximum tree1)
    putStrLn $ "minimum tree1 = " ++ show (minimum tree1)
    putStrLn $ "length tree1 = " ++ show (length tree1)
    putStrLn $ "null tree1 = " ++ show (null tree1)
    putStrLn $ "elem 3 tree1 = " ++ show (elem 3 tree1)
    putStrLn $ "toList tree1 = " ++ show (toList tree1)

    putStrLn ""
    putStrLn "--- Tree Traversable ---"
    putStrLn $ "traverse (\\x -> if even x then Just (x*10) else Nothing) tree1 = "
        ++ show (traverse (\x -> if even x then Just (x*10) else Nothing) tree1)
    putStrLn $ "traverse (\\x -> if even x then Just (x*10) else Nothing) (Node Empty 3 Empty) = "
        ++ show (traverse (\x -> if even x then Just (x*10) else Nothing) (Node Empty 3 Empty))

    -- SequenceA on a tree of IO actions
    putStrLn ""
    putStrLn "--- sequenceA on Tree of IO ---"
    let ioTree = Node (Node Empty (putStrLn "a" >> return 1) Empty)
                      (putStrLn "b" >> return 2)
                      (Node Empty (putStrLn "c" >> return 3) Empty)
    results <- sequenceA ioTree
    putStrLn $ "Results: " ++ show results

    putStrLn ""
    putStrLn "--- RoseTree Foldable ---"
    putStrLn $ "rose1: " ++ show rose1
    putStrLn $ "foldMap (\\s -> Sum (length s)) rose1 = " ++ show (foldMap (Sum . length) rose1)
    putStrLn $ "concat (toList rose1) = " ++ show (concat (toList rose1))

    putStrLn ""
    putStrLn "--- RoseTree Traversable ---"
    let upperTree = fmap (\s -> if head s == 'l' then "L" ++ tail s else s) rose1
    putStrLn $ "fmap upper on leaf nodes: " ++ show upperTree
```

Compile and run. **Expected output:**
```
--- Tree Foldable ---
tree1: Node (Node Empty 1 Empty) 2 (Node (Node Empty 3 Empty) 4 (Node Empty 5 Empty))
foldr (+) 0 tree1 = 15
foldl (+) 0 tree1 = 15
sum tree1 = 15
product tree1 = 120
maximum tree1 = 5
minimum tree1 = 1
length tree1 = 5
null tree1 = False
elem 3 tree1 = True
toList tree1 = [1,2,3,4,5]

--- Tree Traversable ---
traverse (\x -> if even x then Just (x*10) else Nothing) tree1 = 
Just (Node (Node Empty 1 Empty) 20 (Node (Node Empty 3 Empty) 40 (Node Empty 5 Empty)))
traverse (\x -> if even x then Just (x*10) else Nothing) (Node Empty 3 Empty) = 
Nothing

--- sequenceA on Tree of IO ---
a
b
c
Results: Node (Node Empty 1 Empty) 2 (Node Empty 3 Empty)

--- RoseTree Foldable ---
rose1: RoseNode "root" [RoseNode "left" [RoseNode "leaf1" [],RoseNode "leaf2" []],RoseNode "right" [RoseNode "leaf3" []]]
foldMap (\s -> Sum (length s)) rose1 = Sum 18
concat (toList rose1) = "rootleftleaf1leaf2rightleaf3"

--- RoseTree Traversable ---
fmap upper on leaf nodes: RoseNode "root" [RoseNode "left" [RoseNode "Leaf1" [],RoseNode "Leaf2" []],RoseNode "right" [RoseNode "leaf3" []]]
```

### Exercise 3: Lenses — Introduction

Create `src/lenses_intro.hs`:

```haskell
-- A lens is a composable getter and setter for a field in a data structure.
-- Instead of record syntax updates (p { age = age p + 1 }),
-- lenses let you compose field accesses and modifications.

-- We'll implement a simple lens without importing the lens library,
-- then show the lens library version.

-- --- Manual lens implementation ---

-- A lens is a getter (whole -> part) and a setter (part -> whole -> whole)
data ManualLens whole part = ManualLens
    { getPart :: whole -> part
    , setPart :: part -> whole -> whole
    }

-- Compose two lenses: lens on outer, lens on inner field
composeLenses :: ManualLens b c -> ManualLens a b -> ManualLens a c
composeLenses (ManualLens getB setB) (ManualLens getA setA) =
    ManualLens
        { getPart = getB . getA
        , setPart = \c a -> setA (setB c (getA a)) a
        }

-- A simple Person type
data Person = Person
    { pName    :: String
    , pAge     :: Int
    , pAddress :: Address
    } deriving (Show)

data Address = Address
    { aStreet :: String
    , aCity   :: String
    , aZip    :: String
    } deriving (Show)

-- Manual lenses for Person fields
nameLens :: ManualLens Person String
nameLens = ManualLens
    { getPart = pName
    , setPart = \n p -> p { pName = n }
    }

ageLens :: ManualLens Person Int
ageLens = ManualLens
    { getPart = pAge
    , setPart = \a p -> p { pAge = a }
    }

addressLens :: ManualLens Person Address
addressLens = ManualLens
    { getPart = pAddress
    , setPart = \a p -> p { pAddress = a }
    }

-- Manual lenses for Address fields
cityLens :: ManualLens Address String
cityLens = ManualLens
    { getPart = aCity
    , setPart = \c a -> a { aCity = c }
    }

zipLens :: ManualLens Address String
zipLens = ManualLens
    { getPart = aZip
    , setPart = \z a -> a { aZip = z }
    }

-- Composed lens: Person -> Address -> City
personCityLens :: ManualLens Person String
personCityLens = composeLenses cityLens addressLens

-- Use the lens
alice :: Person
alice = Person "Alice" 30 (Address "123 Main St" "New York" "10001")

main :: IO ()
main = do
    putStrLn "--- Manual Lens Demo ---"
    putStrLn $ "alice = " ++ show alice
    putStrLn $ "getPart nameLens alice = " ++ show (getPart nameLens alice)
    putStrLn $ "getPart ageLens alice = " ++ show (getPart ageLens alice)
    putStrLn $ "getPart personCityLens alice = " ++ show (getPart personCityLens alice)

    -- Update with the lens
    let olderAlice = setPart ageLens 31 alice
    putStrLn $ "setPart ageLens 31 alice = " ++ show olderAlice

    -- Compose: change city
    let aliceInLA = setPart personCityLens "Los Angeles" alice
    putStrLn $ "setPart personCityLens \"Los Angeles\" alice = " ++ show aliceInLA

    -- Increment age by 1 using get + set (lens doesn't have built-in modify,
    -- but we can compose get and set)
    let birthday p = setPart ageLens (getPart ageLens p + 1) p
    putStrLn $ "birthday alice = " ++ show (birthday alice)

-- --- Using the real lens library ---
-- To use the lens library, add to your .cabal:
--   build-depends: lens >= 5.0
--
-- Then import Control.Lens and use:
--
-- import Control.Lens
--
-- data Person = Person { _name :: String, _age :: Int } deriving (Show)
-- makeLenses ''Person   -- Template Haskell: generates name, age lenses
--
-- alice ^. age          -- view: get age
-- alice & age .~ 31    -- set: set age to 31
-- alice & age +~ 1     -- modify: add 1 to age
-- alice ^. address . city  -- composed view
--
-- The lens library provides many more combinators:
-- over, set, view, to, mapping, folded, traversed, etc.
```

Compile and run. **Expected output:**
```
--- Manual Lens Demo ---
alice = Person {pName = "Alice", pAge = 30, pAddress = Address {aStreet = "123 Main St", aCity = "New York", aZip = "10001"}}
getPart nameLens alice = "Alice"
getPart ageLens alice = 30
getPart personCityLens alice = "New York"
setPart ageLens 31 alice = Person {pName = "Alice", pAge = 31, pAddress = Address {aStreet = "123 Main St", aCity = "New York", aZip = "10001"}}
setPart personCityLens "Los Angeles" alice = Person {pName = "Alice", pAge = 30, pAddress = Address {aStreet = "123 Main St", aCity = "Los Angeles", aZip = "10001"}}
birthday alice = Person {pName = "Alice", pAge = 31, pAddress = Address {aStreet = "123 Main St", aCity = "New York", aZip = "10001"}}
```

### Exercise 4: Typeclass Hierarchies and Constraints

Create `src/typeclass-constraints.hs`:

```haskell
-- Haskell's typeclass hierarchy:
-- Eq  <-  Ord  <-  Enum  (roughly)
-- Num  <-  Fractional  <-  Floating
-- Functor  <-  Applicative  <-  Monad
-- Foldable  and  Traversable  (independent, but often implemented together)

-- A type that can be "shown" as a table
class TableShow a where
    tableShow :: a -> String

-- A type that knows its column names
class HasColumns a where
    columnNames :: a -> [String]

-- Constrained functions: require multiple typeclass instances
-- This function works for any type that is both TableShow and HasColumns
printTable :: (TableShow a, HasColumns a) => a -> IO ()
printTable table = do
    putStrLn $ "Columns: " ++ show (columnNames table)
    putStrLn $ "Data:\n" ++ tableShow table

-- A simple Row type
data Row = Row [(String, String)]
    deriving (Show)

instance TableShow Row where
    tableShow (Row cells) = unlines $ map formatCell cells
      where
        formatCell (col, val) = "  " ++ col ++ ": " ++ val

instance HasColumns Row where
    columnNames (Row cells) = map fst cells

-- A Table type (list of rows)
data Table = Table [Row]
    deriving (Show)

instance TableShow Table where
    tableShow (Table rows) = unlines $ map tableShow rows

instance HasColumns Table where
    columnNames (Table rows) = case rows of
        []     -> []
        (r:_)  -> columnNames r

-- A generic function to find rows matching a criteria
-- Requires: Foldable (to fold over rows), and a way to check each row
findRows :: (Foldable t, Eq a) => String -> String -> t Row -> [Row]
findRows column value rows = foldr filterRow [] rows
  where
    filterRow row acc =
        case lookup column (toPairList row) of
            Just v | v == value -> row : acc
            _                   -> acc
    toPairList (Row cells) = cells

-- A type that can be converted to and from JSON-like representation
-- (simplified: just a list of string pairs)
class ToPairs a where
    toPairs :: a -> [(String, String)]

instance ToPairs Row where
    toPairs (Row cells) = cells

instance ToPairs Table where
    toPairs (Table rows) = concatMap toPairs rows

-- Constrained composition: use ToPairs with TableShow
describeTable :: (ToPairs a, TableShow a) => a -> String
describeTable table =
    "Table with " ++ show (length (toPairs table)) ++ " cells:\n" ++ tableShow table

main :: IO ()
main = do
    let aliceRow = Row [("Name", "Alice"), ("Age", "30"), ("City", "New York")]
        bobRow   = Row [("Name", "Bob"), ("Age", "25"), ("City", "Boston")]
        table     = Table [aliceRow, bobRow]

    putStrLn "--- Constrained functions ---"
    printTable table

    putStrLn ""
    putStrLn "--- findRows ---"
    let adults = findRows "Age" "30" table
    putStrLn $ "findRows \"Age\" \"30\" table = "
    mapM_ (putStrLn . tableShow) adults

    let bostonians = findRows "City" "Boston" table
    putStrLn $ "findRows \"City\" \"Boston\" table = "
    mapM_ (putStrLn . tableShow) bostonians

    putStrLn ""
    putStrLn "--- describeTable ---"
    putStrLn $ describeTable table

    putStrLn ""
    putStrLn "--- ToPairs ---"
    putStrLn $ "toPairs aliceRow = " ++ show (toPairs aliceRow)
    putStrLn $ "toPairs table = " ++ show (toPairs table)
```

Compile and run. **Expected output:**
```
--- Constrained functions ---
Columns: ["Name","Age","City"]
Data:
  Name: Alice
  Age: 30
  City: New York
  Name: Bob
  Age: 25
  City: Boston

--- findRows ---
findRows "Age" "30" table = 
  Name: Alice
  Age: 30
  City: New York
findRows "City" "Boston" table = 
  Name: Bob
  Age: 25
  City: Boston

--- describeTable ---
Table with 6 cells:
  Name: Alice
  Age: 30
  City: New York
  Name: Bob
  Age: 25
  City: Boston

--- ToPairs ---
toPairs aliceRow = [("Name","Alice"),("Age","30"),("City","New York")]
toPairs table = [("Name","Alice"),("Age","30"),("City","New York"),("Name","Bob"),("Age","25"),("City","Boston")]
```

## Completion Checklist

- [ ] You can define Eq, Ord, Show, Enum, Bounded instances for custom types
- [ ] You understand the difference between deriving and writing instances manually
- [ ] You can write Num instances for newtypes (with safety checks)
- [ ] You can implement Foldable for custom data structures
- [ ] You can implement Traversable for custom data structures
- [ ] You understand how Foldable and Traversable relate to Functor
- [ ] You can use `traverse` and `sequenceA` with any Traversable
- [ ] You understand the lens concept: composable getter + setter
- [ ] You can compose lenses manually
- [ ] You know how to use the lens library (Template Haskell `makeLenses`)
- [ ] You can write constrained functions that require multiple typeclasses

## Hints

- Almost every data type should derive `Show` and `Eq` — add them automatically
- `Ord` can be derived for most types: `deriving (Ord)` does lexicographic ordering
- `Enum` and `Bounded` work for simple enumerations (like `Day`, `Suit`)
- `Foldable` is the key to using `sum`, `length`, `null`, `toList` on your types
- `Traversable` lets you use `traverse` and `sequenceA` with effects
- Lenses compose: `lensAB . lensBC` gives you access to nested fields
- The lens library is powerful but complex — start with `makeLenses` and `^.`, `&`, `.~`, `+~`
