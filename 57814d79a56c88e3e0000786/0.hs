module AlternateSplit.JorgeVS.Kata where

import Data.List

encrypt :: String -> Int -> String
encrypt s n
  | n <= 0    = s
  | otherwise = encrypt s' (n - 1)
  where
    s' = map fst . uncurry (++) $ partition (odd . snd) (zip s [0..])

decrypt :: String -> Int -> String
decrypt s n
  | n <= 0    = s
  | otherwise = decrypt s' (n - 1)
  where
    s' = concat . transpose . (\(a, b) -> [b, a]) $ splitAt (length s `div` 2) s
