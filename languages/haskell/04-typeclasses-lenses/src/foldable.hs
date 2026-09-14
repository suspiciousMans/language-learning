-- Exercise 2: Foldable and Traversable
-- Compile: ghc foldable.hs -o foldable && ./foldable

-- Custom binary tree (from Project 02)
data Tree a
    = Empty
    | Node (Tree a) a (Tree a)
    deriving (Show, Eq)

instance Foldable Tree where
    foldMap _ Empty = mempty
    foldMap f (Node l x r) = foldMap f l <> f x <> foldMap f r

    foldr _ z Empty = z
    foldr f z (Node l x r) = foldr f (f x (foldr f z r)) l

    foldl _ z Empty = z
    foldl f z (Node l x r) = foldl f (f (foldl f z l) x) r

instance Traversable Tree where
    traverse _ Empty = pure Empty
    traverse f (Node l x r) = Node <$> traverse f l <*> f x <*> traverse f r

-- Rose tree: arbitrary branching
data RoseTree a
    = RoseNode a [RoseTree a]
    deriving (Show)

instance Functor RoseTree where
    fmap f (RoseNode x children) = RoseNode (f x) (map (fmap f) children)

instance Foldable RoseTree where
    foldMap f (RoseNode x children) = f x <> mconcat (map (foldMap f) children)

instance Traversable RoseTree where
    traverse f (RoseNode x children) = RoseNode <$> f x <*> traverse (traverse f) children

tree1 :: Tree Int
tree1 = Node (Node Empty 1 Empty)
             2
             (Node (Node Empty 3 Empty) 4 (Node Empty 5 Empty))

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
