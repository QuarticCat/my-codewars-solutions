{-# LANGUAGE NoImplicitPrelude, GADTs , DataKinds, TypeFamilies, TypeOperators, RankNTypes, DeriveFunctor #-}

module Singletons where

import Prelude hiding (drop, take, head, tail, index, zipWith, replicate, map, (++))

data Vec a n where
  VNil :: Vec a Zero
  VCons :: a -> Vec a n -> Vec a (Succ n)

data Nat = Zero | Succ Nat

data SNat a where
  SZero :: SNat Zero
  SSucc :: SNat a -> SNat (Succ a)

type family (a :: Nat) :< (b :: Nat) :: Bool
type instance m :< Zero = False
type instance Zero :< Succ n = True
type instance (Succ m) :< (Succ n) = m :< n

type family (Add (a :: Nat) (b :: Nat)) :: Nat
type instance Add Zero b = b
type instance Add (Succ a) b = Succ (Add a b)

type family (Min (a :: Nat) (b :: Nat)) :: Nat
type instance Min Zero b = Zero
type instance Min a Zero = Zero
type instance Min (Succ a) (Succ b) = Succ (Min a b)

type family (Drop (a :: Nat) (b :: Nat)) :: Nat
type instance Drop Zero b = Zero
type instance Drop a Zero = a
type instance Drop (Succ a) (Succ b) = Drop a b

map :: (a -> b) -> Vec a n -> Vec b n
map f VNil = VNil
map f (VCons x xs) = VCons (f x) (map f xs)

index :: ((a :< b) ~ True) => SNat a -> Vec s b -> s
index SZero (VCons x xs) = x
index (SSucc n) (VCons x xs) = index n xs

replicate :: s -> SNat a -> Vec s a
replicate a SZero = VNil
replicate a (SSucc SZero) = VCons a VNil
replicate a (SSucc n) = VCons a (replicate a n)

zipWith :: (a -> b -> c) -> Vec a n -> Vec b n -> Vec c n
zipWith f VNil b = VNil
zipWith f a VNil = VNil
zipWith f (VCons a as) (VCons b bs) = VCons (f a b) (zipWith f as bs)

(++) :: Vec v m -> Vec v n -> Vec v (Add m n)
VNil ++ b = b
(VCons a as) ++ b = VCons a (as ++ b)

take :: SNat k -> Vec a n -> Vec a (Min k n)
take k VNil = VNil
take SZero a = VNil
take (SSucc k) (VCons a as) = VCons a (take k as)

drop :: SNat k -> Vec a n -> Vec a (Drop n k)
drop k VNil = VNil
drop SZero a = a
drop (SSucc k) (VCons a as) = drop k as

head :: ((Zero :< n) ~ True) => Vec a n -> a
head (VCons a as) = a

tail :: ((Zero :< n) ~ True) => Vec a n -> Vec a (Drop n (Succ Zero))
tail (VCons a as) = as
