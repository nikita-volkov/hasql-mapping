module Specs.IsTransactionModeSpec where

import Hasql.Mapping.IsTransaction qualified as IsTransaction
import Hasql.Session qualified as Session
import Helpers.Fixtures (ReadOnlyInsert (..), WritableInsert (..), selectRow)
import Helpers.Scripts qualified as Scripts
import Prelude
import Test.Hspec

spec :: SpecWith Scripts.ScopeParams
spec = do
  it "The default mode (Write) allows the transaction to commit a write" \scopeParams ->
    Scripts.onConnection scopeParams \connection -> do
      Scripts.session connection (IsTransaction.toSessionWithoutRetries (WritableInsert 1))
      row <- Scripts.session connection (Session.statement 1 selectRow)
      row `shouldBe` Just 1

  it "Overriding mode to Read causes the database to reject the write" \scopeParams ->
    Scripts.onConnection scopeParams \connection -> do
      result <- Scripts.trySession connection (IsTransaction.toSessionWithoutRetries (ReadOnlyInsert 2))
      result `shouldSatisfy` either (isInfixOf "read-only transaction" . show) (const False)
