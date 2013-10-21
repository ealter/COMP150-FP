{-# OPTIONS -Wall -Werror -fno-warn-name-shadowing #-}

module RandomnessMonad where

import qualified System.Random as SysRand
import System.Random (StdGen)

newtype Rand a = Rand (StdGen -> (a, StdGen))

instance Monad Rand where
    return a = Rand (\g -> (a,g))
    Rand m0 >>= k = Rand (\g0 -> let (a, g1) = m0 g0
                                     Rand m1 = k a
                                 in m1 g1)

type RandomInt = Int

applyWithRandom :: (RandomInt -> a -> b) -> a -> Rand b
applyWithRandom f v = Rand (\g -> let (r, g') = SysRand.next g
                                  in ((f r v), g'))

escape :: Rand a -> StdGen -> a
escape (Rand m) g = fst $ m g

split :: Rand a -> StdGen -> ((a, StdGen), (a, StdGen))
split (Rand m) g0 = (m g1, m g2)
                    where (g1,g2) = SysRand.split g0

gimmeRandom :: StdGen -> RandomInt
gimmeRandom g = escape (return (0::RandomInt) >>= applyWithRandom (\x _ -> x)) g

randPair :: StdGen -> (RandomInt, RandomInt)
randPair g0 = let m = return (0::RandomInt) >>= applyWithRandom const
                  ((r1, _), (r2, _)) = split m g0
              in (r1, r2)

