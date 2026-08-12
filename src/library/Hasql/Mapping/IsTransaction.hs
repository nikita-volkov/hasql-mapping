module Hasql.Mapping.IsTransaction where

import qualified Hasql.Session as Session
import Hasql.Transaction (Transaction)
import Hasql.Transaction.Sessions (IsolationLevel (..), Mode (..))
import qualified Hasql.Transaction.Sessions as Sessions

-- |
-- Evidence that a data-structure determines an atomic, retryable database transaction.
--
-- 'isolation' and 'mode' are properties of the transaction, not of the call site: whether an
-- operation needs 'Serializable' is a fact about what it does, and a caller reaching for
-- 'toSessionWithUnboundedRetries' or 'toSessionWithoutRetries' cannot override or forget them.
--
-- The defaults are the conservative ones ('Serializable' and 'Write'), so the safe case is free
-- and every relaxation is explicit and reviewable in the instance. The opposite defaults would
-- make an under-isolated transaction invisible.
--
-- A composite transaction declares the join of its components by hand, using 'Sessions.IsolationLevel'
-- and 'Sessions.Mode'\'s 'Semigroup' instances:
--
-- > instance IsTransaction Composite where
-- >   isolation = isolation \@Part1 <> isolation \@Part2
-- >   mode = mode \@Part1 <> mode \@Part2
--
-- The two identities are deliberately opposite, because a reader who learns one will guess the
-- other wrong:
--
-- * @mempty@ is @minBound@ ('ReadCommitted' and 'Read'), so that a component with no opinion
--   never downgrades a component that has one.
-- * An /omitted/ class method defaults to 'Serializable' and 'Write', so that an author who never
--   considered the question gets the safe answer.
--
-- Both are conservative, by opposite rules. The join is declared by hand rather than derived:
-- raising a component's isolation does not update its composites, so composites need re-checking
-- when a part changes.
--
-- ==== __Example of such a module__
--
-- > module MusicCatalogueDb.Transactions.InsertAlbumWithTracks where
-- >
-- > import Hasql.Mapping.IsTransaction
-- > import qualified Hasql.Transaction as Transaction
-- > import qualified MusicCatalogueDb.Statements.InsertAlbum as InsertAlbum
-- > import qualified MusicCatalogueDb.Statements.InsertTrack as InsertTrack
-- > import Prelude
-- >
-- > data InsertAlbumWithTracks = InsertAlbumWithTracks
-- >   { album :: InsertAlbum.InsertAlbum,
-- >     tracks :: [InsertTrack.InsertTrack]
-- >   }
-- >
-- > type InsertAlbumWithTracksResult = InsertAlbum.InsertAlbumResult
-- >
-- > instance IsTransaction InsertAlbumWithTracks where
-- >   type Result InsertAlbumWithTracks = InsertAlbumWithTracksResult
-- >   isolation = ReadCommitted -- inserts only fresh rows, so no anomaly exposure
-- >   transaction params = do
-- >     albumId <- Transaction.statement params.album InsertAlbum.statement
-- >     for_ params.tracks \track ->
-- >       Transaction.statement track InsertTrack.statement
-- >     pure albumId
class IsTransaction a where
  type Result a

  -- |
  -- Defaults to 'Serializable', the conservative choice.
  isolation :: IsolationLevel
  isolation = Serializable

  -- |
  -- Defaults to 'Write', the conservative choice.
  mode :: Mode
  mode = Write

  transaction :: a -> Transaction (Result a)

-- |
-- Runs the transaction with its declared 'isolation' and 'mode', retrying it indefinitely on
-- serialization failures and deadlocks.
--
-- @hasql-transaction@'s retry is a @fix@ loop with no backoff and no cap: a 'Serializable'
-- transaction under sustained contention can spin indefinitely, holding a connection and never
-- surfacing an error. Prefer 'toSessionWithoutRetries' with your own bounded retry loop unless
-- that is an acceptable risk for the operation.
toSessionWithUnboundedRetries :: forall a. (IsTransaction a) => a -> Session.Session (Result a)
toSessionWithUnboundedRetries a =
  Sessions.transaction (isolation @a) (mode @a) (transaction a)

-- |
-- Runs the transaction with its declared 'isolation' and 'mode', without retrying it on failure.
toSessionWithoutRetries :: forall a. (IsTransaction a) => a -> Session.Session (Result a)
toSessionWithoutRetries a =
  Sessions.transactionNoRetry (isolation @a) (mode @a) (transaction a)
