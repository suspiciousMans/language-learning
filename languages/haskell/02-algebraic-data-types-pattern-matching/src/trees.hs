-- Exercise 4: Recursive Data Structures — Binary Trees
-- Compile: ghc trees.hs -o trees && ./trees

-- A binary tree: Empty or Node with left subtree, value, right subtree
data Tree a
    = Empty
    | Node (Tree a) a (Tree a)
    deriving (Show, Eq)

-- Insert into a BST
insert :: Ord a => a -> Tree a -> Tree a
insert x Empty = Node Empty x Empty
insert x (Node left v right)
    | x < v     = Node (insert x left) v right
    | x > v     = Node left v (insert x right)
    | otherwise = Node left v right

-- Build from a list
fromList :: Ord a => [a] -> Tree a
fromList = foldr insert Empty

-- Search
contains :: Ord a => a -> Tree a -> Bool
contains _ Empty = False
contains x (Node left v right)
    | x < v     = contains x left
    | x > v     = contains x right
    | otherwise = True

-- In-order traversal
inOrder :: Tree a -> [a]
inOrder Empty = []
inOrder (Node left v right) = inOrder left ++ [v] ++ inOrder right

-- Height
height :: Tree a -> Int
height Empty = 0
height (Node left _ right) = 1 + max (height left) (height right)

-- Tree fold (catamorphism)
treeFold :: b -> (b -> a -> b -> b) -> Tree a -> b
treeFold leaf _ Empty = leaf
treeFold leaf node (Node l x r) =
    node (treeFold leaf node l) x (treeFold leaf node r)

-- Count nodes using fold
countNodes :: Tree a -> Int
countNodes = treeFold 0 (\l _ r -> 1 + l + r)

-- Sum values using fold
treeSum :: Num a => Tree a -> a
treeSum = treeFold 0 (\l x r -> l + x + r)

-- Map over a tree
treeMap :: (a -> b) -> Tree a -> Tree b
treeMap _ Empty = Empty
treeMap f (Node l x r) = Node (treeMap f l) (f x) (treeMap f r)

-- Pretty-print sideways
prettyPrint :: Show a => Tree a -> IO ()
prettyPrint t = go t 0
  where
    go Empty _ = return ()
    go (Node l x r) depth = do
        go r (depth + 1)
        putStrLn $ replicate (depth * 4) ' ' ++ show x
        go l (depth + 1)

main :: IO ()
main = do
    let nums = [5, 3, 7, 1, 4, 6, 8]
    let tree = fromList nums

    putStrLn "Tree from list " ++ show nums ++ ":"
    prettyPrint tree

    putStrLn ""
    putStrLn $ "Contains 4? " ++ show (contains 4 tree)
    putStrLn $ "Contains 9? " ++ show (contains 9 tree)
    putStrLn $ "In-order: " ++ show (inOrder tree)
    putStrLn $ "Height: " ++ show (height tree)
    putStrLn $ "Node count: " ++ show (countNodes tree)
    putStrLn $ "Sum: " ++ show (treeSum (fromList [1..10] :: Tree Int))

    let doubled = treeMap (* 2) tree
    putStrLn $ "Doubled in-order: " ++ show (inOrder doubled)
