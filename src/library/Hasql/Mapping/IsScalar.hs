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
  scalarEncoder :: Encoders.Value a
  scalarDecoder :: Decoders.Value a

-- Numeric types
instance IsScalar Bool where
  scalarEncoder = Encoders.bool
  scalarDecoder = Decoders.bool

instance IsScalar Int16 where
  scalarEncoder = Encoders.int2
  scalarDecoder = Decoders.int2

instance IsScalar Int32 where
  scalarEncoder = Encoders.int4
  scalarDecoder = Decoders.int4

instance IsScalar Int64 where
  scalarEncoder = Encoders.int8
  scalarDecoder = Decoders.int8

instance IsScalar Int where
  scalarEncoder = fromIntegral >$< Encoders.int8
  scalarDecoder = fromIntegral <$> Decoders.int8

instance IsScalar Float where
  scalarEncoder = Encoders.float4
  scalarDecoder = Decoders.float4

instance IsScalar Double where
  scalarEncoder = Encoders.float8
  scalarDecoder = Decoders.float8

instance IsScalar Scientific where
  scalarEncoder = Encoders.numeric
  scalarDecoder = Decoders.numeric

-- Text types
instance IsScalar Text where
  scalarEncoder = Encoders.text
  scalarDecoder = Decoders.text

-- Binary types
instance IsScalar ByteString where
  scalarEncoder = Encoders.bytea
  scalarDecoder = Decoders.bytea

-- Date/Time types
instance IsScalar Day where
  scalarEncoder = Encoders.date
  scalarDecoder = Decoders.date

instance IsScalar LocalTime where
  scalarEncoder = Encoders.timestamp
  scalarDecoder = Decoders.timestamp

instance IsScalar UTCTime where
  scalarEncoder = Encoders.timestamptz
  scalarDecoder = Decoders.timestamptz

instance IsScalar TimeOfDay where
  scalarEncoder = Encoders.time
  scalarDecoder = Decoders.time

instance IsScalar (TimeOfDay, TimeZone) where
  scalarEncoder = Encoders.timetz
  scalarDecoder = Decoders.timetz

instance IsScalar DiffTime where
  scalarEncoder = Encoders.interval
  scalarDecoder = Decoders.interval

-- UUID
instance IsScalar UUID where
  scalarEncoder = Encoders.uuid
  scalarDecoder = Decoders.uuid

-- Network types
instance IsScalar IPRange where
  scalarEncoder = Encoders.inet
  scalarDecoder = Decoders.inet

instance IsScalar (Word8, Word8, Word8, Word8, Word8, Word8) where
  scalarEncoder = Encoders.macaddr
  scalarDecoder = Decoders.macaddr

-- JSON types
instance IsScalar Aeson.Value where
  scalarEncoder = Encoders.jsonb
  scalarDecoder = Decoders.jsonb
