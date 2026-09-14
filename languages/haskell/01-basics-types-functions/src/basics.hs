-- Exercise 1: Variables and Types
-- Compile: ghc basics.hs -o basics && ./basics

main :: IO ()
main = do
    let name = "Haskell" :: String
    let year = 1990 :: Int
    let version = 9.4 :: Double

    -- Type inference means you often don't need type annotations
    message = "Learning " ++ name

    putStrLn $ name ++ " was released in " ++ show year
    putStrLn $ "Version: " ++ show version
    putStrLn message
