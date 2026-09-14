-- Exercise 2: Control Flow — Pattern Matching and Guards
-- Compile: ghc control_flow.hs -o control_flow && ./control_flow

-- Pattern matching on function arguments
grade :: Int -> String
grade score
    | score >= 90 = "A"
    | score >= 80 = "B"
    | score >= 70 = "C"
    | otherwise   = "F"

-- Pattern matching on values
dayName :: Int -> String
dayName 1 = "Monday"
dayName 2 = "Tuesday"
dayName 3 = "Wednesday"
dayName 4 = "Thursday"
dayName 5 = "Friday"
dayName 6 = "Saturday"
dayName 7 = "Sunday"
dayName _ = "Unknown"

-- Recursive countdown with pattern matching
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
