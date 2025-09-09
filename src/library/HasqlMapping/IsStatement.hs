module HasqlMapping.IsStatement where

import Data.Tagged (Tagged (..))
import Data.Text (Text)
import qualified Hasql.Decoders
import qualified Hasql.Encoders

class IsStatement a where
  type Result a
  sql :: Tagged a Text
  encoder :: Hasql.Encoders.Params a
  decoder :: Tagged a (Hasql.Decoders.Result (Result a))
