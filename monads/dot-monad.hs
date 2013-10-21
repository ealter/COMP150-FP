-- Exercise 2: dot --

-- Graph representation (so bad!)
data Node a = Node { val :: a, n_label :: Maybe String }
data Edge a = Edge { src :: Node a, dst :: Node a, e_label :: Maybe String }

data Graph a = Graph [Node a] [Edge a] deriving Show

-- Show instances for these types 
instance Show a => Show (Node a) where
  show (Node val label) = "Node: " ++ show val ++ ", Label: " ++ (show $ getLabel (Node val label))
  
instance Show a => Show (Edge a) where
  show (Edge src dst Nothing) = "None" ++ ": " ++ show src ++ " -> " ++ show dst
  show (Edge src dst (Just label)) = label ++ ": " ++ show src ++ " -> " ++ show dst
  
getNodeForVal :: Eq a => a -> Graph a -> Node a
getNodeForVal search_val (Graph [] _) = error "No such node"
getNodeForVal search_val (Graph ((Node val label):ns) es) = if search_val == val
                                                              then Node val label
                                                              else getNodeForVal search_val (Graph ns es)
                                                                   
getLabel :: Node a -> String
getLabel (Node val Nothing) = ""
getLabel (Node val (Just label)) = label

--- Attempting to hide possible Node and Edge implementations --
class GraphType g where
  addNode :: Show a => a -> Maybe String -> g a -> g a
  addEdge :: (Show a, Eq a) => a -> a -> Maybe String -> g a -> g a
 
instance GraphType Graph where
  addNode x label (Graph nodes edges) = Graph ((Node x label):nodes) edges
  addEdge x y label g = let (Graph nodes edges) = g
                            src = getNodeForVal x g
                            dst = getNodeForVal y g
                        in (Graph nodes ((Edge src dst label):edges))

-- Sadly requires newlines between each new item added
data Output a = Output (String, a) deriving Show

instance Monad Output where
  return g = Output ("digraph G {\n}", g)
  o >>= f = let Output (str0, g0) = o
                Output (str1, g1) = f g0
                dot0 = unlines . tail . init $ lines str0 -- getting the graph string
                dot1 = unlines .tail . init $ lines str1  -- ditto
                composedDot = dot0 ++ " " ++ dot1
            in if composedDot == " "
               then Output ("digraph G {\n}", g1)
               else Output ("digraph G {\n" ++ composedDot ++"}", g1)
               
emptyGraph :: Output (Graph a)
emptyGraph = return (Graph [] [])

fetchDot :: Output a -> String
fetchDot (Output (str, _)) = str

-- Add a node to graph and document a Dot notation
addNodeDot :: (GraphType g, Show a) => a -> Maybe String -> g a -> Output (g a)
addNodeDot x Nothing g = Output ("digraph G{\n" ++ show x ++ "\n}", addNode x Nothing g)
addNodeDot x (Just label) g = Output ("digraph G{\n" ++ show x ++ 
                                      "[label=" ++ label ++ "]\n}", 
                                      addNode x (Just label) g)
                             
-- Add an edge to graph and document a Dot notation                             
addEdgeDot :: (GraphType g, Eq a, Show a) => a -> a -> Maybe String -> g a -> Output (g a)
addEdgeDot x y Nothing g = Output ("digraph G{\n" ++ show x ++ " -> " ++ show y ++ "\n}", 
                                   addEdge x y Nothing g)
addEdgeDot x y (Just label) g = Output ("digraph G{\n" ++ show x ++ " -> " ++ show y ++ 
                                        "[label=" ++ label ++ "]\n}", 
                                        addEdge x y (Just label) g)
