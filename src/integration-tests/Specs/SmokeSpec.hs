module Specs.SmokeSpec where

import Helpers.Scripts qualified as Scripts
import Prelude
import Test.Hspec

spec :: SpecWith Scripts.ScopeParams
spec =
  it "Provisions a connection against a running postgres" \scopeParams ->
    Scripts.onConnection scopeParams \_connection -> pure ()
