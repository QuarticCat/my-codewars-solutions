module MexicanWave where

import Data.Char

wave :: String -> [String]
wave s = foldr f [] . zip [0 ..] $ s
  where
    f (x, c) acc
        | isAlpha c = (take x s ++ [toUpper c] ++ drop (x + 1) s) : acc
        | otherwise = acc
