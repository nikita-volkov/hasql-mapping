module Hasql.Mapping.IsStatement where

import Data.Tagged (Tagged (..))
import Data.Text (Text)
import qualified Hasql.Statement as Statement

class IsStatement a where
  type ResultOf a
  statementOf :: Statement.Statement a (ResultOf a)
