module Arkham.Types.Name
  ( module Arkham.Types.Name
  )
where

import Arkham.Prelude

import Arkham.Json
import Arkham.Types.Helpers

data Name = Name
  { nameTitle :: Text
  , nameSubtitle :: Maybe Text
  }
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSONKey, FromJSONKey, Hashable)

mkName :: Text -> Name
mkName = flip Name Nothing

mkFullName :: Text -> Text -> Name
mkFullName = (. Just) . Name

instance ToJSON Name where
  toJSON = genericToJSON $ aesonOptions $ Just "name"
  toEncoding = genericToEncoding $ aesonOptions $ Just "name"

instance FromJSON Name where
  parseJSON = genericParseJSON $ aesonOptions $ Just "name"

newtype LocationName = LocationName { unLocationName :: Name }
  deriving newtype (Show, Eq, ToJSON, FromJSON, ToJSONKey, FromJSONKey, Hashable)

newtype EnemyName = EnemyName { unEnemyName :: Name }
  deriving newtype (Show, Eq, ToJSON, FromJSON, ToJSONKey, FromJSONKey, Hashable)

newtype TreacheryName = TreacheryName { unTreacheryName :: Name }
  deriving newtype (Show, Eq, ToJSON, FromJSON, ToJSONKey, FromJSONKey, Hashable)

nameToLabel :: Name -> Text
nameToLabel = pack . toLabel . replaceNonLetters . unpack . nameTitle
