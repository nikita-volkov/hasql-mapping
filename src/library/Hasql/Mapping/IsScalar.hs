module Hasql.Mapping.IsScalar where

import qualified Data.Aeson as Aeson
import Data.ByteString (ByteString)
import Data.Functor.Contravariant ((>$<))
import Data.IP (IPRange)
import Data.Int (Int16, Int32, Int64)
import Data.Scientific (Scientific)
import Data.Text (Text)
import Data.Time (Day, DiffTime, LocalTime, TimeOfDay, TimeZone, UTCTime)
import Data.UUID (UUID)
import Data.Word (Word8)
import qualified Hasql.Decoders as Decoders
import qualified Hasql.Encoders as Encoders
import Prelude

-- | Mapping to a scalar value. Anything but array.
class IsScalar a where
  encoder :: Encoders.Value a
  decoder :: Decoders.Value a

-- Numeric types
instance IsScalar Bool where
  encoder = Encoders.bool
  decoder = Decoders.bool

instance IsScalar Int16 where
  encoder = Encoders.int2
  decoder = Decoders.int2

instance IsScalar Int32 where
  encoder = Encoders.int4
  decoder = Decoders.int4

instance IsScalar Int64 where
  encoder = Encoders.int8
  decoder = Decoders.int8

instance IsScalar Int where
  encoder = fromIntegral >$< Encoders.int8
  decoder = fromIntegral <$> Decoders.int8

instance IsScalar Float where
  encoder = Encoders.float4
  decoder = Decoders.float4

instance IsScalar Double where
  encoder = Encoders.float8
  decoder = Decoders.float8

instance IsScalar Scientific where
  encoder = Encoders.numeric
  decoder = Decoders.numeric

-- Text types
instance IsScalar Text where
  encoder = Encoders.text
  decoder = Decoders.text

-- Binary types
instance IsScalar ByteString where
  encoder = Encoders.bytea
  decoder = Decoders.bytea

-- Date/Time types
instance IsScalar Day where
  encoder = Encoders.date
  decoder = Decoders.date

instance IsScalar LocalTime where
  encoder = Encoders.timestamp
  decoder = Decoders.timestamp

instance IsScalar UTCTime where
  encoder = Encoders.timestamptz
  decoder = Decoders.timestamptz

instance IsScalar TimeOfDay where
  encoder = Encoders.time
  decoder = Decoders.time

instance IsScalar (TimeOfDay, TimeZone) where
  encoder = Encoders.timetz
  decoder = Decoders.timetz

instance IsScalar DiffTime where
  encoder = Encoders.interval
  decoder = Decoders.interval

-- UUID
instance IsScalar UUID where
  encoder = Encoders.uuid
  decoder = Decoders.uuid

-- Network types
instance IsScalar IPRange where
  encoder = Encoders.inet
  decoder = Decoders.inet

instance IsScalar (Word8, Word8, Word8, Word8, Word8, Word8) where
  encoder = Encoders.macaddr
  decoder = Decoders.macaddr

-- JSON types
instance IsScalar Aeson.Value where
  encoder = Encoders.jsonb
  decoder = Decoders.jsonb
