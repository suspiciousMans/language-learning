-- Exercise 3: Lenses — Introduction
-- Compile: ghc lenses_intro.hs -o lenses_intro && ./lenses_intro

-- A manual lens: getter + setter
data ManualLens whole part = ManualLens
    { getPart :: whole -> part
    , setPart :: part -> whole -> whole
    }

-- Compose two lenses
composeLenses :: ManualLens b c -> ManualLens a b -> ManualLens a c
composeLenses (ManualLens getB setB) (ManualLens getA setA) =
    ManualLens
        { getPart = getB . getA
        , setPart = \c a -> setA (setB c (getA a)) a
        }

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

personCityLens :: ManualLens Person String
personCityLens = composeLenses cityLens addressLens

alice :: Person
alice = Person "Alice" 30 (Address "123 Main St" "New York" "10001")

main :: IO ()
main = do
    putStrLn "--- Manual Lens Demo ---"
    putStrLn $ "alice = " ++ show alice
    putStrLn $ "getPart nameLens alice = " ++ show (getPart nameLens alice)
    putStrLn $ "getPart ageLens alice = " ++ show (getPart ageLens alice)
    putStrLn $ "getPart personCityLens alice = " ++ show (getPart personCityLens alice)

    let olderAlice = setPart ageLens 31 alice
    putStrLn $ "setPart ageLens 31 alice = " ++ show olderAlice

    let aliceInLA = setPart personCityLens "Los Angeles" alice
    putStrLn $ "setPart personCityLens \"Los Angeles\" alice = " ++ show aliceInLA

    let birthday p = setPart ageLens (getPart ageLens p + 1) p
    putStrLn $ "birthday alice = " ++ show (birthday alice)

    putStrLn ""
    putStrLn "--- Instructions for using the lens library ---"
    putStrLn "To use the lens library, add 'lens' to your .cabal build-depends,"
    putStrLn "then import Control.Lens and use Template Haskell:"
    putStrLn ""
    putStrLn "  import Control.Lens"
    putStrLn "  data Person = Person { _name :: String, _age :: Int } deriving (Show)"
    putStrLn "  makeLenses ''Person"
    putStrLn "  alice ^. age          -- view: get age"
    putStrLn "  alice & age .~ 31    -- set: set age to 31"
    putStrLn "  alice & age +~ 1     -- modify: add 1 to age"
    putStrLn "  alice ^. address . city  -- composed view"
