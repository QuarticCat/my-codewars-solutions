module Codewars.Kata.DigPow where

import Data.Char

digpow :: Integer -> Integer -> Integer
digpow n p
  | s `mod` n == 0 = s `div` n
  | otherwise      = -1
  where
    s = fromIntegral . sum $ zipWith (^) (map digitToInt $ show n) [p..]
