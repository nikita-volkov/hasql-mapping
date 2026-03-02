module Hasql.Mapping.IsStatement where

import qualified Hasql.Statement as Statement

-- |
-- Evidence that a data-structure models statement parameters determining the statement and its result type.
--
-- Supports a modularisation pattern, where you define everything related to one statement in an isolated module.
-- This pattern leads to high code cohesion and low coupling.
--
-- ==== __Example of such a module__
--
-- > module MusicCatalogueDb.Statements.SelectArtistIdsByName where
-- >
-- > import Data.Functor.Contravariant
-- > import Data.Text (Text)
-- > import Data.UUID (UUID)
-- > import Data.Vector (Vector)
-- > import qualified Hasql.Decoders as Decoders
-- > import qualified Hasql.Encoders as Encoders
-- > import Hasql.Mapping.IsStatement
-- > import Prelude
-- >
-- > data SelectArtistIdsByName = SelectArtistIdsByName
-- >   { name :: Text
-- >   }
-- >
-- > type SelectArtistIdsByNameResult = Vector SelectArtistIdsByNameResultRow
-- >
-- > data SelectArtistIdsByNameResultRow = SelectArtistIdsByNameResultRow
-- >   { id :: UUID
-- >   }
-- >
-- > instance IsStatement SelectArtistIdsByName where
-- >   type Result SelectArtistIdsByName = SelectArtistIdsByNameResult
-- >   statement =
-- >     Statement.preparable sql encoder decoder
-- >     where
-- >       sql =
-- >         "select id from artist\n\
-- >         \where name = $1\n\
-- >         \limit 1"
-- >       encoder =
-- >         mconcat
-- >           [ (\(SelectArtistIdsByName x) -> x)
-- >               >$< Encoders.param (Encoders.nonNullable Encoders.text)
-- >           ]
-- >       decoder =
-- >         Decoders.rowVector
-- >           ( SelectArtistIdsByNameResultRow
-- >               <$> Decoders.column (Decoders.nonNullable Decoders.uuid)
-- >           )
class IsStatement a where
  type Result a
  statement :: Statement.Statement a (Result a)
