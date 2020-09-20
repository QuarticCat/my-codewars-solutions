module Fibonacci where

data Mat = Mat Integer Integer Integer Integer

infixl 7 |*|
(|*|) :: Mat -> Mat -> Mat
(Mat a b c d) |*| (Mat e f g h) = Mat (a * e + b * g) (a * f + b * h) (c * e + d * g) (c * f + d * h)

infixr 8 |^|
(|^|) :: Mat -> Integer -> Mat
_ |^| 0 = Mat 1 0 0 1
m |^| n
  | even n    = m' |*| m'
  | otherwise = m' |*| m' |*| m
  where
    m' = m |^| (n `quot` 2)

fib :: Integer -> Integer
fib n = let Mat _ x _ _ = (Mat 0 1 1 (if n < 0 then -1 else 1)) |^| n in x
