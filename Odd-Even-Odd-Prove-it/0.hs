{-# LANGUAGE GADTs, DataKinds,
             TypeFamilies, UndecidableInstances #-}

module OddsAndEvens where

data Nat = Z | S Nat

data Even (a :: Nat) :: * where
  ZeroEven :: Even Z
  NextEven :: Even n -> Even (S (S n))

data Odd (a :: Nat) :: * where
  OneOdd :: Odd (S Z)
  NextOdd :: Odd n -> Odd (S (S n))

evenPlusOne :: Even n -> Odd (S n)
evenPlusOne ZeroEven     = OneOdd
evenPlusOne (NextEven n) = NextOdd (evenPlusOne n)

oddPlusOne :: Odd n -> Even (S n)
oddPlusOne OneOdd      = NextEven ZeroEven
oddPlusOne (NextOdd n) = NextEven (oddPlusOne n)

type family   Add (n :: Nat) (m :: Nat) :: Nat
type instance Add Z     m = m
type instance Add (S n) m = S (Add n m)

evenPlusEven :: Even n -> Even m -> Even (Add n m)
evenPlusEven ZeroEven     m = m
evenPlusEven (NextEven n) m = NextEven (evenPlusEven n m)

oddPlusOdd :: Odd n -> Odd m -> Even (Add n m)
oddPlusOdd OneOdd      OneOdd      = NextEven ZeroEven
oddPlusOdd OneOdd      (NextOdd m) = NextEven (oddPlusOdd OneOdd m)
oddPlusOdd (NextOdd n) m           = NextEven (oddPlusOdd n m)

evenPlusOdd :: Even n -> Odd m -> Odd (Add n m)
evenPlusOdd ZeroEven     m = m
evenPlusOdd (NextEven n) m = NextOdd (evenPlusOdd n m)

oddPlusEven :: Odd n -> Even m -> Odd (Add n m)
oddPlusEven OneOdd      ZeroEven     = OneOdd
oddPlusEven OneOdd      (NextEven m) = NextOdd (oddPlusEven OneOdd m)
oddPlusEven (NextOdd n) m            = NextOdd (oddPlusEven n m)

type family   Mult (n :: Nat) (m :: Nat) :: Nat
type instance Mult Z     m = Z
type instance Mult (S n) m = Add m (Mult n m)

evenTimesEven :: Even n -> Even m -> Even (Mult n m)
evenTimesEven ZeroEven     m = ZeroEven
evenTimesEven (NextEven n) m = evenPlusEven m (evenPlusEven m (evenTimesEven n m))

oddTimesOdd :: Odd n -> Odd m -> Odd (Mult n m)
oddTimesOdd OneOdd      OneOdd      = OneOdd
oddTimesOdd OneOdd      (NextOdd m) = oddPlusEven OneOdd (oddPlusOdd OneOdd (oddTimesOdd OneOdd m))
oddTimesOdd (NextOdd n) m           = oddPlusEven m (oddPlusOdd m (oddTimesOdd n m))

evenTimesOdd :: Even n -> Odd m -> Even (Mult n m)
evenTimesOdd ZeroEven     m = ZeroEven
evenTimesOdd (NextEven n) m = oddPlusOdd m (oddPlusEven m (evenTimesOdd n m))

oddTimesEven :: Odd n -> Even m -> Even (Mult n m)
oddTimesEven OneOdd      ZeroEven     = ZeroEven
oddTimesEven OneOdd      (NextEven m) = oddPlusOdd OneOdd (oddPlusEven OneOdd (oddTimesEven OneOdd m))
oddTimesEven (NextOdd n) m            = evenPlusEven m (evenPlusEven m (oddTimesEven n m))
