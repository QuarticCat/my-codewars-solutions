{-# LANGUAGE TypeOperators, TypeFamilies, GADTs, UndecidableInstances #-}

module Kata.TimesComm where

import Kata.TimesComm.Definitions

refl :: Natural n -> Equal n n
refl NumZ = EqlZ
refl (NumS a) = EqlS (refl a)

symm :: Equal n m -> Equal m n
symm EqlZ = EqlZ
symm (EqlS q) = EqlS (symm q)

(|+|) :: Natural a -> Natural b -> Natural (a :+: b)
NumZ |+| b = b
NumS a |+| b = NumS (a |+| b)

(|*|) :: Natural a -> Natural b -> Natural (a :*: b)
NumZ |*| b = NumZ
NumS a |*| b = b |+| (a |*| b)

(<=>) :: Equal a b -> Equal b c -> Equal a c
EqlZ <=> EqlZ = EqlZ
EqlS a <=> EqlS b = EqlS (a <=> b)

(|+>) :: Natural a -> Equal n m -> Equal (a :+: n) (a :+: m)
NumZ |+> EqlZ = EqlZ
NumZ |+> EqlS q = EqlS (NumZ |+> q)
NumS a |+> q = EqlS (a |+> q)

(<+>) :: Equal a b -> Equal n m -> Equal (a :+: n) (b :+: m)
EqlZ <+> q = q
EqlS p <+> q = EqlS (p <+> q)

plusAssoc :: Natural a -> Natural b -> Natural c -> Equal (a :+: (b :+: c)) ((a :+: b) :+: c)
plusAssoc NumZ b c = refl (b |+| c)
plusAssoc (NumS a) b c = EqlS (plusAssoc a b c)

plusComm :: Natural a -> Natural b -> Equal (a :+: b) (b :+: a)
plusComm NumZ NumZ = EqlZ
plusComm NumZ (NumS b) = EqlS (plusComm NumZ b)
plusComm (NumS a) NumZ = EqlS (plusComm a NumZ)
plusComm sa@(NumS a) sb@(NumS b) = EqlS (plusComm a sb <=> EqlS (plusComm b a) <=> plusComm sa b)

zeroComm :: Natural a -> Equal Z (a :*: Z)
zeroComm NumZ = EqlZ
zeroComm (NumS a) = zeroComm a

timesComm :: Natural a -> Natural b -> Equal (a :*: b) (b :*: a)
timesComm NumZ b = zeroComm b
timesComm a NumZ = symm (zeroComm a)
timesComm sa@(NumS a) sb@(NumS b) =
    (sb |+> timesComm a sb)
    <=> plusAssoc sb a (b |*| a)
    <=> EqlS (plusComm b a <+> timesComm b a)
    <=> symm (plusAssoc sa b (a |*| b))
    <=> (sa |+> timesComm sa b)
