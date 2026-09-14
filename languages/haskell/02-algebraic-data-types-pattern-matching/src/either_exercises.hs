-- Exercise 3: Error Handling with Either
-- Compile: ghc either_exercises.hs -o either_exercises && ./either_exercises

-- Either is for operations that can fail with a typed error
-- data Either e a = Left e | Right a
-- By convention: Left = error, Right = success

validateAge :: Int -> Either String Int
validateAge age
    | age < 0    = Left "Age cannot be negative"
    | age > 150  = Left "Age seems unrealistic"
    | otherwise  = Right age

validateName :: String -> Either String String
validateName name
    | null (trim name) = Left "Name cannot be empty"
    | length name > 50 = Left "Name too long"
    | otherwise        = Right (trim name)
  where
    trim = dropWhile (== ' ') . reverse . dropWhile (== ' ') . reverse

data UserProfile = UserProfile
    { upName  :: String
    , upAge   :: Int
    } deriving (Show)

-- Chain validations with do-notation
createProfile :: String -> Int -> Either String UserProfile
createProfile name age = do
    validName <- validateName name
    validAge  <- validateAge age
    return $ UserProfile validName validAge

-- Same with explicit pattern matching
createProfile' :: String -> Int -> Either String UserProfile
createProfile' name age =
    case validateName name of
        Left err        -> Left err
        Right validName ->
            case validateAge age of
                Left err        -> Left err
                Right validAge  -> Right $ UserProfile validName validAge

parseInt :: String -> Either String Int
parseInt s =
    case reads s of
        [(n, "")] -> Right n
        _         -> Left $ "Cannot parse '" ++ s ++ "' as Int"

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
