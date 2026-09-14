-- Exercise 1: Shape Area with ADTs
-- Compile: ghc shapes.hs -o shapes && ./shapes

-- A Shape is either a Circle, Rectangle, or Triangle
-- This is a SUM type: Shape = Circle + Rectangle + Triangle
data Shape
    = Circle Double
    | Rectangle Double Double
    | Triangle Double Double Double
    deriving (Show, Eq)

-- Pattern match on each constructor
area :: Shape -> Double
area (Circle r)            = pi * r * r
area (Rectangle w h)       = w * h
area (Triangle a b c)      = sqrt (s * (s - a) * (s - b) * (s - c))
  where
    s = (a + b + c) / 2    -- Heron's formula

perimeter :: Shape -> Double
perimeter (Circle r)       = 2 * pi * r
perimeter (Rectangle w h)  = 2 * (w + h)
perimeter (Triangle a b c) = a + b + c

-- Classify by size using case expression with guards
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
