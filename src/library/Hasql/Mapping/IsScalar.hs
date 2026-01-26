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
  encoderOf :: Encoders.Value a
  decoderOf :: Decoders.Value a

-- Numeric types
instance IsScalar Bool where
  encoderOf = Encoders.bool
  decoderOf = Decoders.bool

instance IsScalar Int16 where
  encoderOf = Encoders.int2
  decoderOf = Decoders.int2

instance IsScalar Int32 where
  encoderOf = Encoders.int4
  decoderOf = Decoders.int4

instance IsScalar Int64 where
  encoderOf = Encoders.int8
  decoderOf = Decoders.int8

instance IsScalar Int where
  encoderOf = fromIntegral >$< Encoders.int8
  decoderOf = fromIntegral <$> Decoders.int8

instance IsScalar Float where
  encoderOf = Encoders.float4
  decoderOf = Decoders.float4

instance IsScalar Double where
  encoderOf = Encoders.float8
  decoderOf = Decoders.float8

instance IsScalar Scientific where
  encoderOf = Encoders.numeric
  decoderOf = Decoders.numeric

-- Text types
instance IsScalar Text where
  encoderOf = Encoders.text
  decoderOf = Decoders.text

-- Binary types
instance IsScalar ByteString where
  encoderOf = Encoders.bytea
  decoderOf = Decoders.bytea

-- Date/Time types
instance IsScalar Day where
  encoderOf = Encoders.date
  decoderOf = Decoders.date

instance IsScalar LocalTime where
  encoderOf = Encoders.timestamp
  decoderOf = Decoders.timestamp

instance IsScalar UTCTime where
  encoderOf = Encoders.timestamptz
  decoderOf = Decoders.timestamptz

instance IsScalar TimeOfDay where
  encoderOf = Encoders.time
  decoderOf = Decoders.time

instance IsScalar (TimeOfDay, TimeZone) where
  encoderOf = Encoders.timetz
  decoderOf = Decoders.timetz

instance IsScalar DiffTime where
  encoderOf = Encoders.interval
  decoderOf = Decoders.interval

-- UUID
instance IsScalar UUID where
  encoderOf = Encoders.uuid
  decoderOf = Decoders.uuid

-- Network types
instance IsScalar IPRange where
  encoderOf = Encoders.inet
  decoderOf = Decoders.inet

instance IsScalar (Word8, Word8, Word8, Word8, Word8, Word8) where
  encoderOf = Encoders.macaddr
  decoderOf = Decoders.macaddr

-- JSON types
instance IsScalar Aeson.Value where
  encoderOf = Encoders.jsonb
  decoderOf = Decoders.jsonb
