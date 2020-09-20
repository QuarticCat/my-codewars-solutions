module Haskell.Codewars.Peano where
import Prelude hiding (even, odd, div, compare, Num, Int, Integer, Float, Double, Rational, Word)

data Peano = Zero | Succ Peano deriving (Eq, Show)

add, sub, mul, div :: Peano -> Peano -> Peano

add Zero     b = b
add (Succ a) b = Succ (add a b)

sub a        Zero     = a
sub Zero     b        = error "negative number"
sub (Succ a) (Succ b) = sub a b

mul Zero     _ = Zero
mul (Succ a) b = add b (mul a b)

div a Zero = error "divide by 0"
div a b
    | compare a b == LT = Zero
    | otherwise = Succ (div (sub a b) b)

even, odd :: Peano -> Bool

even Zero     = True
even (Succ a) = not (even a)

odd = not . even

compare :: Peano -> Peano -> Ordering

compare Zero     Zero     = EQ
compare Zero     _        = LT
compare _        Zero     = GT
compare (Succ a) (Succ b) = compare a b
