-- Jayme Woogerd
-- Comp 150fp
-- September 15, 2013 

{-# OPTIONS -Wall -Werror -fno-warn-name-shadowing #-}

--
-- Defining a class for containers
--

newtype List a = List [a] deriving Show
newtype Pair a = Pair (a, a) deriving Show

data Tree a = Nil 
            | Node {left :: Tree a, value :: a, right :: Tree a} deriving Show

class Container c where
    toList :: c a -> [a]
    mapC   :: (a -> b) -> c a -> c b

instance Container List where
    toList (List xs) = id xs
    mapC f (List xs) = List (map f xs) 

instance Container Pair where
    toList (Pair (x, y)) = [x, y]
    mapC f (Pair (x, y)) = Pair (f x, f y)

instance Container Maybe where
    toList Nothing  = [] 
    toList (Just x) = [x]

    mapC f x = case x of Nothing  -> Nothing
                         (Just x) -> Just (f x) 

instance Container Tree where
    toList Nil = []
    toList (Node l v r) = (toList l) ++ [v] ++ (toList r)
    
    mapC f tree = case tree of
        Nil          -> Nil
        (Node l v r) -> Node (mapC f l) (f v) (mapC f r)

{--
    some notes from class presentation:
    what are other data structures that belong to this class?
    what about sets as characteristic functions?
    what are other operations that could be added to this class?
        - length?
--}
