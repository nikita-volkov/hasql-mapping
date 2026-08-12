module Helpers.Scripts
  ( ScopeParams,
    onConnection,
    session,
    trySession,
  )
where

import Hasql.Connection qualified as Connection
import Hasql.Connection.Settings qualified as Settings
import Hasql.Decoders qualified as Decoders
import Hasql.Encoders qualified as Encoders
import Hasql.Errors qualified as Errors
import Hasql.Session qualified as Session
import Hasql.Statement qualified as Statement
import Pqi qualified
import Prelude

-- |
-- Adapter, host and port of a running isolated postgres server.
type ScopeParams = (Pqi.Adapter, Text, Word16)

-- |
-- Acquire a connection against a fresh copy of the fixture schema (a single table,
-- @mapping_test_rows@, dropped and recreated on every call), releasing the connection once the
-- action completes.
onConnection :: ScopeParams -> (Connection.Connection -> IO a) -> IO a
onConnection (adapter, host, port) action =
  bracket acquire Connection.release use
  where
    acquire =
      Connection.acquire adapter connectionSettings
        >>= either (fail . show) return
    connectionSettings =
      Settings.hostAndPort host port
        <> Settings.user "postgres"
        <> Settings.password "postgres"
        <> Settings.dbname "postgres"
    use connection = do
      _ <- try (session connection dropRowsTable) :: IO (Either SomeException ())
      session connection createRowsTable
      action connection

-- |
-- Run a session, failing the test on any 'Errors.SessionError'.
session :: Connection.Connection -> Session.Session a -> IO a
session connection theSession =
  Connection.use connection theSession
    >>= either (fail . show) return

-- |
-- Run a session, keeping any 'Errors.SessionError' for the test to assert on.
trySession :: Connection.Connection -> Session.Session a -> IO (Either Errors.SessionError a)
trySession = Connection.use

createRowsTable :: Session.Session ()
createRowsTable =
  Session.statement () (Statement.unpreparable "create table mapping_test_rows (id int8 primary key)" Encoders.noParams Decoders.noResult)

dropRowsTable :: Session.Session ()
dropRowsTable =
  Session.statement () (Statement.unpreparable "drop table mapping_test_rows" Encoders.noParams Decoders.noResult)
