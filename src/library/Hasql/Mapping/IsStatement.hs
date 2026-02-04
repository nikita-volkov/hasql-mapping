module Hasql.Mapping.IsStatement where

import qualified Hasql.Statement as Statement

-- | Mapping to a SQL statement indexed by its parameter type with result type associated.
--
-- Use this to define modular mappings, where each statement is defined in an isolated module.
class IsStatement a where
  type Result a
  statement :: Statement.Statement a (Result a)
