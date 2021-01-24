{-# LANGUAGE ScopedTypeVariables, Rank2Types #-}

module ScottEncoding where

import Prelude hiding (null, length, map, foldl, foldr, take, fst, snd, curry, uncurry, concat, zip, (++))

newtype SMaybe a = SMaybe { runMaybe :: forall b. b -> (a -> b) -> b }
newtype SList a = SList { runList :: forall b. b -> (a -> SList a -> b) -> b }
newtype SEither a b = SEither { runEither :: forall c. (a -> c) -> (b -> c) -> c }
newtype SPair a b = SPair { runPair :: forall c. (a -> b -> c) -> c }

toPair :: SPair a b -> (a,b)
toPair (SPair p) = p (,)
fromPair :: (a,b) -> SPair a b
fromPair (a, b) = SPair (\f -> f a b)
fst :: SPair a b -> a
fst (SPair p) = p (\x y -> x)
snd :: SPair a b -> b
snd (SPair p) = p (\x y -> y)
swap :: SPair a b -> SPair b a
swap (SPair p) = p (\x y -> fromPair (y, x))
curry :: (SPair a b -> c) -> (a -> b -> c)
curry f x y = f (fromPair (x, y))
uncurry :: (a -> b -> c) -> (SPair a b -> c)
uncurry f (SPair p) = p f

toMaybe :: SMaybe a -> Maybe a
toMaybe (SMaybe m) = m Nothing Just
fromMaybe :: Maybe a -> SMaybe a
fromMaybe Nothing = SMaybe (\x f -> x)
fromMaybe (Just m) = SMaybe (\x f -> f m)
isJust :: SMaybe a -> Bool
isJust (SMaybe m) = m False (const True)
isNothing :: SMaybe a -> Bool
isNothing = not . isJust
catMaybes :: SList (SMaybe a) -> SList a
catMaybes = foldr (\(SMaybe m) l -> m l (`cons` l)) (fromList [])

toEither :: SEither a b -> Either a b
toEither (SEither e) = e Left Right
fromEither :: Either a b -> SEither a b
fromEither (Left e) = SEither (\f1 f2 -> f1 e)
fromEither (Right e) = SEither (\f1 f2 -> f2 e)
isLeft :: SEither a b -> Bool
isLeft (SEither e) = e (const True) (const False)
isRight :: SEither a b -> Bool
isRight = not . isLeft
partition :: SList (SEither a b) -> SPair (SList a) (SList b)
partition = (\(l, r) -> fromPair (fromList l, fromList r)) .
  foldr (\(SEither e) (l, r) -> e (\x -> (x:l, r)) (\x -> (l, x:r))) ([], [])

toList :: SList a -> [a]
toList (SList l) = l [] (\x xs -> x : toList xs)
fromList :: [a] -> SList a
fromList [] = SList (\n f -> n)
fromList (x:xs) = SList (\n f -> f x (fromList xs))
cons :: a -> SList a -> SList a
cons x l = SList (\n f -> f x l)
concat :: SList a -> SList a -> SList a
concat a b = foldr cons b a
null :: SList a -> Bool
null (SList l) = l True (\x xs -> False)
length :: SList a -> Int
length = foldr (\x acc -> acc + 1) 0
map :: (a -> b) -> SList a -> SList b
map f = fromList . foldr (\x xs -> f x : xs) []
zip :: SList a -> SList b -> SList (SPair a b)
zip (SList a) (SList b) = a (fromList []) (\x xs -> b (fromList []) (\y ys ->
  cons (fromPair (x, y)) (zip xs ys)))
foldl :: (b -> a -> b) -> b -> SList a -> b
foldl f i (SList l) = l i (\x xs -> foldl f (f i x) xs)
foldr :: (a -> b -> b) -> b -> SList a -> b
foldr f i (SList l) = l i (\x xs -> f x (foldr f i xs))
take :: Int -> SList a -> SList a
take 0 _ = fromList []
take n (SList l) = l (fromList []) (\x xs -> cons x (take (n - 1) xs))
