module Specs.IsSessionSpec where

import Hasql.Mapping.IsSession qualified as IsSession
import Hasql.Session qualified as Session
import Helpers.Fixtures (InsertRowSession (..), selectRow)
import Helpers.Scripts qualified as Scripts
import Prelude
import Test.Hspec

spec :: SpecWith Scripts.ScopeParams
spec =
  it "session runs the underlying transaction and commits" \scopeParams ->
    Scripts.onConnection scopeParams \connection -> do
      Scripts.session connection (IsSession.session (InsertRowSession 3))
      row <- Scripts.session connection (Session.statement 3 selectRow)
      row `shouldBe` Just 3
