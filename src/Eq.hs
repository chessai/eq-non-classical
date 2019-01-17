{-# LANGUAGE CPP          #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeInType   #-}

module Eq
  ( Eq(..)
  ) where

import Data.Kind (Type)
import Prelude hiding (Eq(..))
import qualified Prelude

-- | Equality comparison using non-classical logic. Consider the type of equality comparison:
--
-- @(==) :: Eq a => a -> a -> Logic a@
--
-- The return value is given by the type family @Logic a@, which specifies the logical system used
-- to compare the type @a@.
--
-- For most types, @Logic a@ will be 'Bool', and everything else will behave as you would expect.
-- But this more general type lets us define equality on types for which classical equality is either
-- uncomputable, undefined, or not what we actually want.
--
-- Consider the case of functions. Classical equality over functions is uncomputable. But here, we define:
--
-- @ instance Eq b => Eq (a -> b) where
--     type Logic (a -> b) = a -> Logic b
--     f == g = \a -> f a == g a
-- @
--
-- This non-classical logic simplifies many situations. For example, we can use the '&&' and '||' operators
-- on functions:
--
-- >>> filter ( (>= 'c') && (< 'f') || (== 'q') ) ['a'..'z']
-- "cdeq"
--
-- The 'Eq' typeclass corresponds to the idea of equivalences classes in algebra. There are much more general
-- notions of equality that are well-studies, e.g. tolerance classes.
class Eq a where
  type Logic a :: Type

  infix 4 ==
  (==) :: a -> a -> Logic a

#define deriveEq(ty)       \
instance Eq (ty) where {   \
    type Logic (ty) = Bool \
;   (==) = (Prelude.==)    \
;   {-# INLINE (==) #-}    \
}

instance Eq b => Eq (a -> b) where
  type Logic (a -> b) = a -> Logic b
  f == g = \a -> f a == g a

instance Eq () where
  type Logic () = ()
  _ == _ = ()
  {-# INLINE (==) #-}

deriveEq(Bool)
deriveEq(Char)
deriveEq(Int)
deriveEq(Integer)
