module Specs.IsStatementSpec where

import Hasql.Mapping.IsStatement qualified as IsStatement
import Helpers.Fixtures (SelectOne (..))
import Helpers.Scripts qualified as Scripts
import Prelude
import Test.Hspec

spec :: SpecWith Scripts.ScopeParams
spec =
  it "toSession runs the statement and returns its result" \scopeParams ->
    Scripts.onConnection scopeParams \connection -> do
      result <- Scripts.session connection (IsStatement.toSession SelectOne)
      result `shouldBe` 1
