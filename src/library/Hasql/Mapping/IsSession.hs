module Hasql.Mapping.IsSession where

import Hasql.Session (Session)

-- |
-- Evidence that a data-structure determines a top-level database operation: one with its own
-- error channel and 'System.IO' capability, the two things a bare 'Hasql.Transaction.Transaction'
-- cannot have.
--
-- A single 'Result' rather than separate success/error associated types. An operation with a
-- domain failure expresses it as @type XResult = Either XError A@, which names the outcome once
-- at the definition rather than in every signature. Separate error/success types would
-- additionally force infallible sessions — bulk loads via 'Hasql.Session.onLibpqConnection',
-- @LISTEN@\/@NOTIFY@, batching through 'Hasql.Session.pipeline' — to write @Error X = Void@ and
-- their callers to match an impossible 'Left'.
--
-- Unlike 'Hasql.Mapping.IsTransaction.IsTransaction', this class needs no runner: 'session'
-- already produces a 'Session'.
--
-- ==== __Example: insert-and-catch__
--
-- Insert-and-catch is preferable to check-then-insert: the latter needs 'Serializable' to be
-- correct and costs an extra round trip, while the former is correct at any isolation level in
-- one. Catching above 'Hasql.Mapping.IsTransaction.toSessionWithoutRetries' is safe because by
-- the time an error escapes the runner, the transaction has already been rolled back:
--
-- > module MusicCatalogueDb.Sessions.RegisterAlbum where
-- >
-- > import Hasql.Mapping.IsSession
-- > import qualified Hasql.Mapping.IsTransaction as IsTransaction
-- > import Prelude
-- >
-- > data RegisterAlbum = RegisterAlbum { ... }
-- >
-- > data RegisterAlbumError = AlbumAlreadyExists
-- >
-- > type RegisterAlbumResult = Either RegisterAlbumError AlbumId
-- >
-- > instance IsSession RegisterAlbum where
-- >   type Result RegisterAlbum = RegisterAlbumResult
-- >   session params =
-- >     catchingSqlState (\case "23505" -> Just AlbumAlreadyExists; _ -> Nothing)
-- >       $ IsTransaction.toSessionWithoutRetries (InsertAlbumWithTracks params.album params.tracks)
--
-- (@catchingSqlState@ is proposed upstream at
-- <https://github.com/nikita-volkov/hasql/issues/322 nikita-volkov/hasql#322> and is not yet
-- part of @hasql@; the shape above is illustrative of how it will compose over this class.)
class IsSession a where
  type Result a
  session :: a -> Session (Result a)
