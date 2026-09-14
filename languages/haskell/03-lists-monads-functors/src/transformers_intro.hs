-- Exercise 4: Monad Transformers (Introduction)
-- Compile: ghc transformers_intro.hs -o transformers_intro && ./transformers_intro

-- A simple "Reader" pattern: pass an environment
type Reader r a = r -> a

readerExample :: Reader [(String, Int)] Int
readerExample env = case lookup "answer" env of
    Just n  -> n * 2
    Nothing -> 42

-- "Reader + Maybe" combined manually
type ReaderMaybe r a = r -> Maybe a

lookupUser :: String -> ReaderMaybe [(String, Int)] Int
lookupUser name env = lookup name env

processUser :: String -> ReaderMaybe [(String, Int)] String
processUser name env = do
    age <- lookupUser name env
    if age >= 18
        then return $ name ++ " is an adult (age " ++ show age ++ ")"
        else return $ name ++ " is a minor (age " ++ show age ++ ")"

-- "Reader + State" combined
type ReaderState r s a = r -> s -> (a, s)

data ProcessState = ProcessState
    { processedCount :: Int
    } deriving (Show)

processUsers :: [String] -> ReaderState [(String, Int)] ProcessState [String]
processUsers names env state = go names env state []
  where
    go [] _ st acc = (reverse acc, st)
    go (n:ns) e (ProcessState count) acc =
        case lookup n e of
            Nothing -> go ns e (ProcessState count) acc
            Just age ->
                let msg = n ++ " (age " ++ show age ++ ")"
                    newSt = ProcessState (count + 1)
                in go ns e newSt (msg : acc)

main :: IO ()
main = do
    let env = [("Alice", 30), ("Bob", 15), ("Charlie", 25), ("Diana", 17)]

    putStrLn "--- Reader example ---"
    putStrLn $ "readerExample env = " ++ show (readerExample env)
    putStrLn $ "readerExample [(\"answer\", 21)] = " ++ show (readerExample [("answer", 21)])

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

    let verified = ["Alice", "Charlie"]
    let (okResults, okState) = processUsers verified env initState
    putStrLn $ "Processing only verified: " ++ show okResults
    putStrLn $ "State after: " ++ show okState
