{-# LANGUAGE GADTs         #-}
{-# LANGUAGE TypeFamilies  #-}
{-# LANGUAGE TypeOperators #-}

module Kata.AdditionCommutes
  ( plusCommutes ) where

import Kata.AdditionCommutes.Definitions
  ( Z, S
  , Natural(..), Equal(..)
  , (:+:))

(<=>) :: Equal a b -> Equal b c -> Equal a c
EqlZ <=> EqlZ = EqlZ
(EqlS a) <=> (EqlS b) = EqlS (a <=> b)

plusCommutes :: Natural a -> Natural b -> Equal (a :+: b) (b :+: a)
plusCommutes NumZ NumZ = EqlZ
plusCommutes (NumS a) NumZ = EqlS (plusCommutes a NumZ)
plusCommutes NumZ (NumS b) = EqlS (plusCommutes NumZ b)
plusCommutes sa@(NumS a) sb@(NumS b) = EqlS ((plusCommutes a sb) <=> (EqlS (plusCommutes b a)) <=> (plusCommutes sa b))
