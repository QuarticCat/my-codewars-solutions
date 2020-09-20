{-# LANGUAGE TypeOperators, TypeFamilies, GADTs #-}

module Kata.AdditionAssoc where

import Kata.AdditionAssoc.Definitions

refl :: Natural n -> Equal n n
refl NumZ     = EqlZ
refl (NumS a) = EqlS (refl a)

(|+|) :: Natural a -> Natural b -> Natural (a :+: b)
NumZ     |+| b = b
(NumS a) |+| b = NumS (a |+| b)

plusAssoc :: Natural a -> Natural b -> Natural c -> Equal (a :+: (b :+: c)) ((a :+: b) :+: c)
plusAssoc NumZ     b c = refl (b |+| c)
plusAssoc (NumS a) b c = EqlS (plusAssoc a b c)
