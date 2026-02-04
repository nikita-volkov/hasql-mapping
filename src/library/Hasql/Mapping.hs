-- | Reexports of classes without methods.
--
-- To access the methods import the class-specific modules preferably qualified.
module Hasql.Mapping
  ( IsScalar,
    IsStatement,
  )
where

import Hasql.Mapping.IsScalar (IsScalar)
import Hasql.Mapping.IsStatement (IsStatement)
