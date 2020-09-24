module Kata.SmallestPossibleSum where

import Data.List

smallestPossibleSum :: (Integral a) => [a] -> a
smallestPossibleSum l = foldl1 gcd l * genericLength l
