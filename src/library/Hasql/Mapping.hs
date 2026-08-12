-- | Reexports of classes without methods.
--
-- To access the methods import the class-specific modules preferably qualified.
module Hasql.Mapping
  ( IsScalar,
    IsStatement,
    IsTransaction,
    IsSession,
  )
where

import Hasql.Mapping.IsScalar (IsScalar)
import Hasql.Mapping.IsSession (IsSession)
import Hasql.Mapping.IsStatement (IsStatement)
import Hasql.Mapping.IsTransaction (IsTransaction)
