module Codewars.G964.FindEven where

import Data.List
import Data.Maybe

findEvenIndex :: [Int] -> Int
findEvenIndex arr = fromMaybe (-1) . elemIndex True $ zipWith (==) (scanl1 (+) arr) (scanr1 (+) arr)
