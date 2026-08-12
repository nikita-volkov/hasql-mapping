module Specs.IsTransactionCompositionSpec where

import Hasql.Mapping.IsTransaction qualified as IsTransaction
import Helpers.Fixtures (Composite (..), DefaultIsolationCheck (..), Part1 (..), Part2 (..))
import Helpers.Scripts qualified as Scripts
import Prelude
import Test.Hspec

spec :: SpecWith Scripts.ScopeParams
spec = do
  it "Composite.mode is the join of its parts: Part1's Read does not win over Part2's default Write" \_ ->
    IsTransaction.mode @Composite `shouldBe` IsTransaction.Write

  it "Composite.isolation stays at the shared default (both parts take Serializable)" \_ ->
    IsTransaction.isolation @Composite `shouldBe` IsTransaction.Serializable

  it "A transaction with no isolation override reports Serializable to the server" \scopeParams ->
    Scripts.onConnection scopeParams \connection -> do
      reported <- Scripts.session connection (IsTransaction.toSessionWithoutRetries DefaultIsolationCheck)
      reported `shouldBe` "serializable"
