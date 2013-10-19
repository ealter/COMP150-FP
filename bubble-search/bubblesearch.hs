{-# OPTIONS -Wall -Werror -fno-warn-name-shadowing #-}

-- Nate Tarrh and Zhe Lu

import System.Random
import Albums

maxSize :: Integer
maxSize = 4700000000

type Dvd = (Integer, [Album])

blankdisk :: Dvd
blankdisk = (maxSize, [])

backups :: [Dvd]
backups = blankdisk : backups

-- first fit bin packing
writeFirst :: Album -> [Dvd] -> [Dvd]
writeFirst (a, s) ((remaining, albums):dvds)
  | s < remaining = (remaining - s, (a,s):albums):dvds
  | otherwise = (remaining, albums):writeFirst (a,s) dvds
writeFirst _ _ = error "Can't write onto empty list"

backup :: [Album] -> [Dvd]
backup as = backup' as backups
  where backup' [] dvds = takeWhile ((/= []) . snd) dvds
        backup' (x:xs) dvds = backup' xs $ writeFirst x dvds

takeWithProb :: Double -> StdGen -> [a] -> (a, [a])
takeWithProb _ _ [x] = (x, [])
takeWithProb p g (x:xs) =
  let (g', g'') = split g
      (d, _) = random g' :: (Double, StdGen)
  in if d <= p then (x, xs) else
    let (x', xs') = takeWithProb p g'' xs
    in (x', x:xs')
takeWithProb _ _ _ = error "Can't take from empty list"

topK :: Double -> StdGen -> [a] -> [a]
topK p g xs = topK' p g xs []
  where topK' _ _ [] ys = ys
        topK' p g xs ys =
          let (g', g'') = split g
              (x', xs') = takeWithProb p g'' xs
          in topK' p g' xs' (ys ++ [x'])

newtype MyRandom a = MyRandom { runRandom :: StdGen -> (a, StdGen) }

instance Monad MyRandom where
  return x = MyRandom $ \g -> (x, g)
  m >>= k = MyRandom $ \g -> let (x, g') = (runRandom m) g
                             in (runRandom $ k x) g'

permuteAndCons :: [a] -> Double -> [[a]] -> MyRandom [[a]]
permuteAndCons as p = \xs -> MyRandom $ \g ->
                              let (g', g'') = split g
                                  x = topK p g' as
                              in (x:xs, g'')

makeNPermutations :: [a] -> Double -> Int -> MyRandom [[a]]
makeNPermutations best p n
  | n <= 0 = return [best] 
  | otherwise = makeNPermutations best p (n - 1) >>= (permuteAndCons best p)

numberOfDvds :: [Dvd] -> Int
numberOfDvds s = length s

newtype Score = Score (Int, Integer) deriving (Show)

instance Eq Score where
  (==) (Score (n1, x1)) (Score (n2, x2)) = n1 == n2 && x1 == x2

instance Ord Score where
compare :: Score -> Score -> Ordering
(Score (n1, x1)) `compare` (Score (n2, x2))
  | n1 < n2 = LT
  | n1 > n2 = GT
  | otherwise = Prelude.compare x1 x2

-- number of DVDs and maximum empty space
scoreSolution :: [Dvd] -> Score
scoreSolution s =
  Score (numberOfDvds s, maximum $ Prelude.map fst s)

runGreedyAndScore :: [Album] -> Score
runGreedyAndScore = scoreSolution . backup

findInputWithLowestScore :: Ord b => ([a] -> b) -> [[a]] -> ([a], b)
findInputWithLowestScore f as = findLowest $ Prelude.map (\a -> (a, f a)) as
  where findLowest [x] = x
        findLowest (x:xs) =
          let x'@(_,s) = findLowest xs
          in case snd x `Prelude.compare` s
               of LT -> x
                  _ -> x'
        findLowest _ = error "Can't find best on empty list"
{-
findBestOrder :: [[Album]] -> ([Album], Score)
findBestOrder as = findBestOrder' $ Prelude.map
                                     (\a -> (a, scoreSolution $ backup a)) as
  where findBestOrder' [x] = x
        findBestOrder' (x:xs) =
          let x'@(_,s) = findBestOrder' xs
          in case snd x `Main.compare` s
               of LT -> x
                  _ -> x'
        findBestOrder' _ = undefined
-}

-- second argument should be strictly less than 1.0
-- Usage example:
--   runBubbleSearch norman'sAlbums 0.5 runGreedyAndScore 100 20 (mkStdGen 123)
runBubbleSearch :: Ord b => [a] -> Double -> ([a] -> b) -> Int -> Int -> StdGen
                                -> ([a], b)
runBubbleSearch start _ f 0 _ _ = (start, f start)
runBubbleSearch start p f i size g =
  let (g', g'') = split g
      (best, _) = findInputWithLowestScore f $ fst $
                    (runRandom $ makeNPermutations start p size) g'
  in runBubbleSearch best ((1 + 2 * p) / 3) f (i - 1) size g''
