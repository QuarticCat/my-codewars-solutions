module A9n where

import Data.List
import Data.Char
import Data.Function

abbreviate :: String -> String
abbreviate = concat . map f . groupBy ((==) `on` isAlpha)
  where
    f s@(x:_)
      | length s < 4 || not (isAlpha x) = s
      | otherwise = [x] ++ show (length s - 2) ++ [last s]
