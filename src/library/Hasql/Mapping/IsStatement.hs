module Hasql.Mapping.IsStatement where

import qualified Hasql.Statement as Statement

class IsStatement a where
  type ResultOf a
  statementOf :: Statement.Statement a (ResultOf a)
