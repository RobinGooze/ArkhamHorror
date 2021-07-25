{-# OPTIONS_GHC -Wno-orphans #-}
module Arkham.Types.Card.CardDef where

import Arkham.Prelude

import Arkham.Json
import Arkham.Types.Action (Action)
import Arkham.Types.Card.CardCode
import Arkham.Types.Card.CardMatcher
import Arkham.Types.Card.CardType
import Arkham.Types.Card.Cost
import Arkham.Types.ClassSymbol
import Arkham.Types.CommitRestriction
import Arkham.Types.EncounterSet
import Arkham.Types.Keyword (HasKeywords(..), Keyword)
import Arkham.Types.Name
import Arkham.Types.PlayRestriction
import Arkham.Types.SkillType
import Arkham.Types.Trait
import Arkham.Types.Window
import Arkham.Types.WindowMatcher (WindowMatcher)

data AttackOfOpportunityModifier = DoesNotProvokeAttacksOfOpportunity
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

data EventChoicesRepeatable = EventChoicesRepeatable | EventChoicesNotRepeatable
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

data EventChoice = EventChooseN Int EventChoicesRepeatable
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

data CardDef = CardDef
  { cdCardCode :: CardCode
  , cdName :: Name
  , cdRevealedName :: Maybe Name
  , cdCost :: Maybe CardCost
  , cdLevel :: Int
  , cdCardType :: CardType
  , cdWeakness :: Bool
  , cdClassSymbol :: Maybe ClassSymbol
  , cdSkills :: [SkillType]
  , cdCardTraits :: HashSet Trait
  , cdKeywords :: HashSet Keyword
  , cdFast :: Bool
  , cdFastWindow :: Maybe WindowMatcher -- WARNING: This is new
  , cdWindows :: HashSet Window -- WARNING: This is legact
  , cdAction :: Maybe Action
  , cdRevelation :: Bool
  , cdVictoryPoints :: Maybe Int
  , cdPlayRestrictions :: [PlayRestriction]
  , cdCommitRestrictions :: [CommitRestriction]
  , cdAttackOfOpportunityModifiers :: [AttackOfOpportunityModifier]
  , cdPermanent :: Bool
  , cdEncounterSet :: Maybe EncounterSet
  , cdEncounterSetQuantity :: Maybe Int
  , cdUnique :: Bool
  , cdDoubleSided :: Bool
  , cdLimits :: [CardLimit]
  , cdExceptional :: Bool
  }
  deriving stock (Show, Eq, Generic)
  deriving anyclass Hashable

data CardLimit = LimitPerInvestigator Int | LimitPerTrait Trait Int
  deriving stock (Show, Eq, Generic)
  deriving anyclass (Hashable, FromJSON, ToJSON)

instance Named CardDef where
  toName = cdName

weaknessL :: Lens' CardDef Bool
weaknessL = lens cdWeakness $ \m x -> m { cdWeakness = x }

keywordsL :: Lens' CardDef (HashSet Keyword)
keywordsL = lens cdKeywords $ \m x -> m { cdKeywords = x }

cardTraitsL :: Lens' CardDef (HashSet Trait)
cardTraitsL = lens cdCardTraits $ \m x -> m { cdCardTraits = x }

instance ToJSON CardDef where
  toJSON = genericToJSON $ aesonOptions $ Just "cd"
  toEncoding = genericToEncoding $ aesonOptions $ Just "cd"

instance FromJSON CardDef where
  parseJSON = genericParseJSON $ aesonOptions $ Just "cd"

class GetCardDef env a where
  getCardDef :: MonadReader env m => a -> m CardDef

class HasCardDef a where
  toCardDef :: a -> CardDef

class HasCardCode a where
  toCardCode :: a -> CardCode

class HasOriginalCardCode a where
  toOriginalCardCode :: a -> CardCode

class HasCardType a where
  toCardType :: a -> CardType

instance HasCardDef a => HasCardType a where
  toCardType = cdCardType . toCardDef

instance {-# OVERLAPPABLE #-} HasCardDef a => HasTraits a where
  toTraits = cdCardTraits . toCardDef

instance HasCardDef a => HasKeywords a where
  toKeywords = cdKeywords . toCardDef

instance HasCardDef a => HasCardCode a where
  toCardCode = cdCardCode . toCardDef

instance HasCardDef CardDef where
  toCardDef = id

cardMatch :: HasCardDef a => CardMatcher -> a -> Bool
cardMatch (CardMatchByType (cardType', traits)) a =
  (toCardType a == cardType')
    && (null traits || notNull (intersection (toTraits a) traits))
cardMatch (CardMatchByCardCode cardCode) card = toCardCode card == cardCode
cardMatch (CardMatchByTitle title) card =
  (nameTitle . cdName $ toCardDef card) == title

testCardDef :: CardType -> CardCode -> CardDef
testCardDef cardType cardCode = CardDef
  { cdCardCode = cardCode
  , cdName = "Test"
  , cdRevealedName = Nothing
  , cdCost = Nothing
  , cdLevel = 0
  , cdCardType = cardType
  , cdWeakness = False
  , cdClassSymbol = Nothing
  , cdSkills = []
  , cdCardTraits = mempty
  , cdKeywords = mempty
  , cdFast = False
  , cdWindows = mempty
  , cdFastWindow = Nothing
  , cdAction = Nothing
  , cdRevelation = False
  , cdVictoryPoints = Nothing
  , cdPlayRestrictions = []
  , cdCommitRestrictions = []
  , cdAttackOfOpportunityModifiers = []
  , cdPermanent = False
  , cdEncounterSet = Nothing
  , cdEncounterSetQuantity = Nothing
  , cdUnique = False
  , cdDoubleSided = False
  , cdLimits = []
  , cdExceptional = False
  }
