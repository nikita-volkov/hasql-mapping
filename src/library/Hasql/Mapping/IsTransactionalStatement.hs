module Hasql.Mapping.IsTransactionalStatement where

import Data.Tagged (Tagged (..))
import Hasql.Mapping.IsStatement
import Prelude

-- | A statement that has transactional properties associated with it.
class (IsStatement a) => IsTransactionalStatement a where
  writes :: Tagged a Bool
