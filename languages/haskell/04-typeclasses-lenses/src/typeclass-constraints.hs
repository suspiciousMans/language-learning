-- Exercise 4: Typeclass Hierarchies and Constraints
-- Compile: ghc typeclass-constraints.hs -o typeclass-constraints && ./typeclass-constraints

-- A type that can be shown as a table
class TableShow a where
    tableShow :: a -> String

-- A type that knows its column names
class HasColumns a where
    columnNames :: a -> [String]

printTable :: (TableShow a, HasColumns a) => a -> IO ()
printTable table = do
    putStrLn $ "Columns: " ++ show (columnNames table)
    putStrLn $ "Data:\n" ++ tableShow table

data Row = Row [(String, String)]
    deriving (Show)

instance TableShow Row where
    tableShow (Row cells) = unlines $ map formatCell cells
      where
        formatCell (col, val) = "  " ++ col ++ ": " ++ val

instance HasColumns Row where
    columnNames (Row cells) = map fst cells

data Table = Table [Row]
    deriving (Show)

instance TableShow Table where
    tableShow (Table rows) = unlines $ map tableShow rows

instance HasColumns Table where
    columnNames (Table rows) = case rows of
        []     -> []
        (r:_)  -> columnNames r

-- Find rows matching a column value
findRows :: (Foldable t, Eq a) => String -> String -> t Row -> [Row]
findRows column value rows = foldr filterRow [] rows
  where
    filterRow row acc =
        case lookup column (toPairList row) of
            Just v | v == value -> row : acc
            _                   -> acc
    toPairList (Row cells) = cells

-- A type that can be converted to pairs
class ToPairs a where
    toPairs :: a -> [(String, String)]

instance ToPairs Row where
    toPairs (Row cells) = cells

instance ToPairs Table where
    toPairs (Table rows) = concatMap toPairs rows

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
