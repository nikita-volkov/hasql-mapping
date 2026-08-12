module Helpers.Fixtures where

import Hasql.Decoders qualified as Decoders
import Hasql.Encoders qualified as Encoders
import Hasql.Mapping.IsSession (IsSession (..))
import Hasql.Mapping.IsStatement (IsStatement (..))
import Hasql.Mapping.IsTransaction (IsTransaction (..))
import Hasql.Mapping.IsTransaction qualified as IsTransaction
import Hasql.Statement qualified as Statement
import Hasql.Transaction qualified as Transaction
import Prelude

-- | Inserts a row into the fixture table @mapping_test_rows@ (see 'Helpers.Scripts.onConnection').
insertRow :: Statement.Statement Int64 ()
insertRow =
  Statement.preparable
    "insert into mapping_test_rows (id) values ($1)"
    (Encoders.param (Encoders.nonNullable Encoders.int8))
    Decoders.noResult

-- | Reads back a row's id, or 'Nothing' if it was never committed.
selectRow :: Statement.Statement Int64 (Maybe Int64)
selectRow =
  Statement.preparable
    "select id from mapping_test_rows where id = $1"
    (Encoders.param (Encoders.nonNullable Encoders.int8))
    (Decoders.rowMaybe (Decoders.column (Decoders.nonNullable Decoders.int8)))

currentIsolation :: Statement.Statement () Text
currentIsolation =
  Statement.preparable
    "select current_setting('transaction_isolation')"
    Encoders.noParams
    (Decoders.singleRow (Decoders.column (Decoders.nonNullable Decoders.text)))

-- | Parameterless statement exercised by 'Hasql.Mapping.IsStatement.toSession'.
data SelectOne = SelectOne

instance IsStatement SelectOne where
  type Result SelectOne = Int64
  statement =
    Statement.preparable "select 1::int8" (const () >$< Encoders.noParams) decoder
    where
      decoder = Decoders.singleRow (Decoders.column (Decoders.nonNullable Decoders.int8))

-- | Inherits the default 'mode' ('Hasql.Mapping.IsTransaction.Write'), so the insert commits.
newtype WritableInsert = WritableInsert Int64

instance IsTransaction WritableInsert where
  type Result WritableInsert = ()
  transaction (WritableInsert rowId) = Transaction.statement rowId insertRow

-- | Overrides 'mode' to 'Hasql.Mapping.IsTransaction.Read', so the database rejects the insert.
newtype ReadOnlyInsert = ReadOnlyInsert Int64

instance IsTransaction ReadOnlyInsert where
  type Result ReadOnlyInsert = ()
  mode = IsTransaction.Read
  transaction (ReadOnlyInsert rowId) = Transaction.statement rowId insertRow

-- | Inherits the default 'isolation' ('Hasql.Mapping.IsTransaction.Serializable'), read back from the server.
data DefaultIsolationCheck = DefaultIsolationCheck

instance IsTransaction DefaultIsolationCheck where
  type Result DefaultIsolationCheck = Text
  transaction DefaultIsolationCheck = Transaction.statement () currentIsolation

-- | One component of 'Composite': relaxes 'mode' but takes the default 'isolation'.
data Part1 = Part1

instance IsTransaction Part1 where
  type Result Part1 = ()
  mode = IsTransaction.Read
  transaction _ = pure ()

-- | The other component of 'Composite': takes both defaults.
data Part2 = Part2

instance IsTransaction Part2 where
  type Result Part2 = ()
  transaction _ = pure ()

-- | Declares the join of its parts by hand, per §6.4 of the Data-Access Architecture guide:
-- 'Part1'\'s relaxed 'mode' must not win over 'Part2'\'s default, and both parts share
-- 'isolation'\'s default, so the composite's 'isolation' stays at the default too.
data Composite = Composite

instance IsTransaction Composite where
  type Result Composite = ()
  isolation = isolation @Part1 <> isolation @Part2
  mode = mode @Part1 <> mode @Part2
  transaction _ = pure ()

-- | Round-trips through 'IsTransaction.toSessionWithoutRetries', exercising 'IsSession' end to end.
newtype InsertRowSession = InsertRowSession Int64

instance IsSession InsertRowSession where
  type Result InsertRowSession = ()
  session (InsertRowSession rowId) =
    IsTransaction.toSessionWithoutRetries (WritableInsert rowId)
