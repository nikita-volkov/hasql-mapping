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
--
-- The current Hasql API doesn't provide a typesafe boundary to enforce the value being scalar,
-- so consider this to be a part of the contract to not define instances for array mappings using this class.
class IsScalar a where
  encoder :: Encoders.Value a
  decoder :: Decoders.Value a

-- | Maps to PostgreSQL @bool@.
instance IsScalar Bool where
  encoder = Encoders.bool
  decoder = Decoders.bool

-- | Maps to PostgreSQL @int2@.
instance IsScalar Int16 where
  encoder = Encoders.int2
  decoder = Decoders.int2

-- | Maps to PostgreSQL @int4@.
instance IsScalar Int32 where
  encoder = Encoders.int4
  decoder = Decoders.int4

-- | Maps to PostgreSQL @int8@.
instance IsScalar Int64 where
  encoder = Encoders.int8
  decoder = Decoders.int8

-- | Maps to PostgreSQL @int8@.
instance IsScalar Int where
  encoder = fromIntegral >$< Encoders.int8
  decoder = fromIntegral <$> Decoders.int8

-- | Maps to PostgreSQL @float4@.
instance IsScalar Float where
  encoder = Encoders.float4
  decoder = Decoders.float4

-- | Maps to PostgreSQL @float8@.
instance IsScalar Double where
  encoder = Encoders.float8
  decoder = Decoders.float8

-- | Maps to PostgreSQL @numeric@.
instance IsScalar Scientific where
  encoder = Encoders.numeric
  decoder = Decoders.numeric

-- | Maps to PostgreSQL @text@.
instance IsScalar Text where
  encoder = Encoders.text
  decoder = Decoders.text

-- | Maps to PostgreSQL @bytea@.
instance IsScalar ByteString where
  encoder = Encoders.bytea
  decoder = Decoders.bytea

-- | Maps to PostgreSQL @date@.
instance IsScalar Day where
  encoder = Encoders.date
  decoder = Decoders.date

-- | Maps to PostgreSQL @timestamp@.
instance IsScalar LocalTime where
  encoder = Encoders.timestamp
  decoder = Decoders.timestamp

-- | Maps to PostgreSQL @timestamptz@.
instance IsScalar UTCTime where
  encoder = Encoders.timestamptz
  decoder = Decoders.timestamptz

-- | Maps to PostgreSQL @time@.
instance IsScalar TimeOfDay where
  encoder = Encoders.time
  decoder = Decoders.time

-- | Maps to PostgreSQL @timetz@.
instance IsScalar (TimeOfDay, TimeZone) where
  encoder = Encoders.timetz
  decoder = Decoders.timetz

-- | Maps to PostgreSQL @interval@.
instance IsScalar DiffTime where
  encoder = Encoders.interval
  decoder = Decoders.interval

-- | Maps to PostgreSQL @uuid@.
instance IsScalar UUID where
  encoder = Encoders.uuid
  decoder = Decoders.uuid

-- | Maps to PostgreSQL @inet@.
instance IsScalar IPRange where
  encoder = Encoders.inet
  decoder = Decoders.inet

-- | Maps to PostgreSQL @macaddr@.
instance IsScalar (Word8, Word8, Word8, Word8, Word8, Word8) where
  encoder = Encoders.macaddr
  decoder = Decoders.macaddr

-- | Maps to PostgreSQL @jsonb@.
instance IsScalar Aeson.Value where
  encoder = Encoders.jsonb
  decoder = Decoders.jsonb
