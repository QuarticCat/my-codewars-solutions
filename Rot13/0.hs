module Rot13 where

import Data.Char

rot13 :: String -> String
rot13 = map f where
  f x | isAsciiUpper x = if x > chr (ord 'Z' - 13)
                           then chr (ord x - 13)
                           else chr (ord x + 13)
      | isAsciiLower x = if x > chr (ord 'z' - 13)
                           then chr (ord x - 13)
                           else chr (ord x + 13)
      | otherwise      = x
