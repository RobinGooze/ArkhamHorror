{-# LANGUAGE PatternSynonyms #-}

module Arkham.Types.Matcher where

import Arkham.Prelude

import Arkham.Types.Action (Action)
import Arkham.Types.Asset.Uses
import Arkham.Types.Card.CardCode
import Arkham.Types.Card.CardType
import Arkham.Types.Card.Id
import Arkham.Types.ClassSymbol
import Arkham.Types.GameValue
import Arkham.Types.Id
import Arkham.Types.Keyword (Keyword)
import qualified Arkham.Types.Keyword as Keyword
import {-# SOURCE #-} Arkham.Types.Modifier
import Arkham.Types.Phase
import Arkham.Types.Timing
import Arkham.Types.Token
import Arkham.Types.Trait

type Who = InvestigatorMatcher

pattern InvestigatorWithAnyDamage :: InvestigatorMatcher
pattern InvestigatorWithAnyDamage <-
  InvestigatorWithDamage (GreaterThan (Static 0)) where
  InvestigatorWithAnyDamage = InvestigatorWithDamage (GreaterThan (Static 0))

pattern InvestigatorWithAnyHorror :: InvestigatorMatcher
pattern InvestigatorWithAnyHorror <-
  InvestigatorWithHorror (GreaterThan (Static 0)) where
  InvestigatorWithAnyHorror = InvestigatorWithHorror (GreaterThan (Static 0))

data InvestigatorMatcher
  = InvestigatorAt LocationMatcher
  | You
  | UnengagedInvestigator
  | NotYou
  | Anyone
  | UneliminatedInvestigator
  | InvestigatorCanMove
  | ContributedMatchingIcons ValueMatcher
  | HandWith CardListMatcher
  | DiscardWith CardListMatcher
  | InvestigatorWithoutModifier ModifierType
  | InvestigatorEngagedWith EnemyMatcher
  | InvestigatorWithDamage ValueMatcher
  | InvestigatorWithHorror ValueMatcher
  | InvestigatorWithResources ValueMatcher
  | InvestigatorWithId InvestigatorId
  | InvestigatorMatches [InvestigatorMatcher]
  | AnyInvestigator [InvestigatorMatcher]
  | TurnInvestigator
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

instance Semigroup InvestigatorMatcher where
  InvestigatorMatches xs <> InvestigatorMatches ys =
    InvestigatorMatches $ xs <> ys
  InvestigatorMatches xs <> x = InvestigatorMatches (x : xs)
  x <> InvestigatorMatches xs = InvestigatorMatches (x : xs)
  x <> y = InvestigatorMatches [x, y]

data AssetMatcher
  = AssetWithTitle Text
  | AssetWithFullTitle Text Text
  | AssetWithId AssetId
  | AssetWithClass ClassSymbol
  | AssetWithTrait Trait
  | AssetOwnedBy InvestigatorMatcher
  | AssetMatches [AssetMatcher]
  | AssetOneOf [AssetMatcher]
  | AssetAtLocation LocationId
  | AssetNonStory
  | AssetReady
  | AssetExhausted
  | AssetWithUseType UseType
  | AssetWithUses UseType
  | AssetIs CardCode
  | AnyAsset
  | EnemyAsset EnemyId
  | AssetAt LocationMatcher
  | DiscardableAsset
  | AssetWithDamage
  | AssetWithHorror
  | AssetCanBeAssignedDamageBy InvestigatorId
  | AssetCanBeAssignedHorrorBy InvestigatorId
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

assetIs :: HasCardCode a => a -> AssetMatcher
assetIs = AssetIs . toCardCode

instance Semigroup AssetMatcher where
  AnyAsset <> x = x
  x <> AnyAsset = x
  AssetMatches xs <> AssetMatches ys = AssetMatches (xs <> ys)
  AssetMatches xs <> x = AssetMatches (x : xs)
  x <> AssetMatches xs = AssetMatches (x : xs)
  x <> y = AssetMatches [x, y]

instance Monoid AssetMatcher where
  mempty = AnyAsset

enemyIs :: HasCardCode a => a -> EnemyMatcher
enemyIs = EnemyIs . toCardCode

pattern HunterEnemy :: EnemyMatcher
pattern HunterEnemy <- EnemyWithKeyword Keyword.Hunter where
  HunterEnemy = EnemyWithKeyword Keyword.Hunter

pattern EliteEnemy :: EnemyMatcher
pattern EliteEnemy <- EnemyWithTrait Elite where
  EliteEnemy = EnemyWithTrait Elite

pattern NonEliteEnemy :: EnemyMatcher
pattern NonEliteEnemy <- EnemyWithoutTrait Elite where
  NonEliteEnemy = EnemyWithoutTrait Elite

data EnemyMatcher
  = EnemyWithTitle Text
  | EnemyWithFullTitle Text Text
  | EnemyWithId EnemyId
  | EnemyWithTrait Trait
  | EnemyAt LocationMatcher
  | EnemyWithoutTrait Trait
  | EnemyWithKeyword Keyword
  | EnemyIs CardCode
  | AnyEnemy
  | CanFightEnemy
  | ExhaustedEnemy
  | NonWeaknessEnemy
  | EnemyMatchAll [EnemyMatcher]
  | EnemyEngagedWithYou
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

instance Semigroup EnemyMatcher where
  EnemyMatchAll xs <> EnemyMatchAll ys = EnemyMatchAll (xs <> ys)
  EnemyMatchAll xs <> x = EnemyMatchAll (x : xs)
  x <> EnemyMatchAll xs = EnemyMatchAll (x : xs)
  x <> y = EnemyMatchAll [x, y]

data EventMatcher
  = EventWithTitle Text
  | EventWithFullTitle Text Text
  | EventWithId EventId
  | EventWithTrait Trait
  | EventWithClass ClassSymbol
  | EventOwnedBy InvestigatorId
  | EventMatches [EventMatcher]
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON)

instance Semigroup EventMatcher where
  EventMatches xs <> EventMatches ys = EventMatches (xs <> ys)
  EventMatches xs <> x = EventMatches (x : xs)
  x <> EventMatches xs = EventMatches (x : xs)
  x <> y = EventMatches [x, y]

type Where = LocationMatcher

pattern LocationWithoutTreachery :: CardCode -> LocationMatcher
pattern LocationWithoutTreachery card <-
  LocationWithoutTreacheryWithCardCode card where
  LocationWithoutTreachery card =
    LocationWithoutTreacheryWithCardCode (toCardCode card)

pattern LocationWithAnyClues :: LocationMatcher
pattern LocationWithAnyClues <-
  LocationWithClues (GreaterThan (Static 0)) where
  LocationWithAnyClues = LocationWithClues (GreaterThan (Static 0))

pattern LocationWithoutClues :: LocationMatcher
pattern LocationWithoutClues <- LocationWithClues (EqualTo (Static 0)) where
  LocationWithoutClues = LocationWithClues (EqualTo (Static 0))

locationIs :: HasCardCode a => a -> LocationMatcher
locationIs = LocationIs . toCardCode

data LocationMatcher
  = LocationWithTitle Text
  | LocationWithFullTitle Text Text
  | LocationWithId LocationId
  | LocationWithLabel Text
  | LocationLeavingPlay
  | YourLocation
  | SameLocation
  | NotYourLocation
  | LocationIs CardCode
  | Anywhere
  | EmptyLocation
  | AccessibleLocation
  | AccessibleFrom LocationMatcher
  | AccessibleTo LocationMatcher
  | ConnectedLocation
  | LocationWithResources ValueMatcher
  | LocationWithClues ValueMatcher
  | LocationWithoutInvestigators
  | LocationWithoutEnemies
  | RevealedLocation
  | InvestigatableLocation
  | FarthestLocationFromYou LocationMatcher
  | LocationWithTrait Trait
  | LocationWithoutTreacheryWithCardCode CardCode
  | LocationMatchers [LocationMatcher]
  | FirstLocation [LocationMatcher]
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

instance Semigroup LocationMatcher where
  LocationMatchers xs <> LocationMatchers ys = LocationMatchers $ xs <> ys
  LocationMatchers xs <> x = LocationMatchers (x : xs)
  x <> LocationMatchers xs = LocationMatchers (x : xs)
  x <> y = LocationMatchers [x, y]

data SkillMatcher
  = SkillWithTitle Text
  | SkillWithFullTitle Text Text
  | SkillWithId SkillId
  | SkillWithTrait Trait
  | SkillWithClass ClassSymbol
  | SkillOwnedBy InvestigatorId
  | SkillMatches [SkillMatcher]
  | YourSkill
  | AnySkill
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

instance Semigroup SkillMatcher where
  AnySkill <> x = x
  x <> AnySkill = x
  SkillMatches xs <> SkillMatches ys = SkillMatches (xs <> ys)
  SkillMatches xs <> x = SkillMatches (x : xs)
  x <> SkillMatches xs = SkillMatches (x : xs)
  x <> y = SkillMatches [x, y]

instance Monoid SkillMatcher where
  mempty = AnySkill

data TreacheryMatcher
  = TreacheryWithTitle Text
  | TreacheryWithFullTitle Text Text
  | TreacheryWithId TreacheryId
  | TreacheryWithTrait Trait
  | AnyTreachery
  | TreacheryOwnedBy InvestigatorId
  | TreacheryMatches [TreacheryMatcher]
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

instance Semigroup TreacheryMatcher where
  AnyTreachery <> x = x
  x <> AnyTreachery = x
  TreacheryMatches xs <> TreacheryMatches ys = TreacheryMatches (xs <> ys)
  TreacheryMatches xs <> x = TreacheryMatches (x : xs)
  x <> TreacheryMatches xs = TreacheryMatches (x : xs)
  x <> y = TreacheryMatches [x, y]

instance Monoid TreacheryMatcher where
  mempty = AnyTreachery

pattern NonWeaknessTreachery :: CardMatcher
pattern NonWeaknessTreachery =
  CardMatches [NonWeakness, CardWithType TreacheryType]

pattern NonPeril :: CardMatcher
pattern NonPeril <- CardWithoutKeyword Keyword.Peril where
  NonPeril = CardWithoutKeyword Keyword.Peril

pattern EventCard :: CardMatcher
pattern EventCard <- CardWithType EventType where
  EventCard = CardWithType EventType

pattern AssetCard :: CardMatcher
pattern AssetCard <- CardWithType AssetType where
  AssetCard = CardWithType AssetType

-- | Relies on game state, can not be used purely
data ExtendedCardMatcher
  = BasicCardMatch CardMatcher
  | CardIsBeneathInvestigator Who
  | InHandOf Who
  | ExtendedCardWithOneOf [ExtendedCardMatcher]
  | ExtendedCardMatches [ExtendedCardMatcher]
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

instance Semigroup ExtendedCardMatcher where
  ExtendedCardMatches xs <> ExtendedCardMatches ys =
    ExtendedCardMatches $ xs <> ys
  ExtendedCardMatches xs <> x = ExtendedCardMatches (x : xs)
  x <> ExtendedCardMatches xs = ExtendedCardMatches (x : xs)
  x <> y = ExtendedCardMatches [x, y]

-- | Only relies on card state, can be used purely with `cardMatch`
data CardMatcher
  = CardWithType CardType
  | CardWithCardCode CardCode
  | CardWithTitle Text
  | CardWithTrait Trait
  | CardWithId CardId
  | CardWithoutKeyword Keyword
  | CardWithClass ClassSymbol
  | CardWithOneOf [CardMatcher]
  | CardMatches [CardMatcher]
  | IsEncounterCard
  | NonWeakness
  | NonExceptional
  | AnyCard
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

instance Semigroup CardMatcher where
  AnyCard <> a = a
  a <> AnyCard = a
  CardMatches xs <> CardMatches ys = CardMatches $ xs <> ys
  CardMatches xs <> x = CardMatches (x : xs)
  x <> CardMatches xs = CardMatches (x : xs)
  x <> y = CardMatches [x, y]

data WindowMatcher
  = EnemyDefeated Timing Who EnemyMatcher
  | EnemyEvaded Timing Who EnemyMatcher
  | EnemyEngaged Timing Who EnemyMatcher
  | MythosStep WindowMythosStepMatcher
  | AssetEntersPlay Timing AssetMatcher
  | AssetDealtDamage Timing AssetMatcher
  | DiscoveringLastClue Timing Who Where
  | EnemyAttacks Timing Who EnemyMatcher
  | RevealChaosToken Timing Who TokenMatcher
  | WouldRevealChaosToken Timing Who
  | SkillTestResult Timing Who SkillTestMatcher SkillTestResultMatcher
  | PlacedCounter Timing Who CounterMatcher ValueMatcher
  | WouldHaveSkillTestResult Timing Who SkillTestMatcher SkillTestResultMatcher
  | EnemySpawns Timing Where EnemyMatcher
  | FastPlayerWindow
  | TurnBegins Timing Who
  | TurnEnds Timing Who
  | DuringTurn Who
  | Enters Timing Who Where
  | OrWindowMatcher [WindowMatcher]
  | DealtDamageOrHorror Timing Who
  | DrawCard Timing Who ExtendedCardMatcher
  | PlayCard Timing Who ExtendedCardMatcher
  | PhaseBegins Timing PhaseMatcher
  | PhaseEnds Timing PhaseMatcher
  | PlayerHasPlayableCard ExtendedCardMatcher
  | RevealLocation Timing Who Where
  | PutLocationIntoPlay Timing Who Where
  | AnyWindow
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

data SkillTestMatcher
  = WhileInvestigating
  | WhileAttackingAnEnemy EnemyMatcher
  | SkillTestWithSkill SkillMatcher
  | AnySkillTest
  | SkillTestAtYourLocation
  | SkillTestOnTreachery TreacheryMatcher
  | UsingThis
  | SkillTestMatches [SkillTestMatcher]
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

instance Semigroup SkillTestMatcher where
  AnySkillTest <> x = x
  x <> AnySkillTest = x
  SkillTestMatches xs <> SkillTestMatches ys = SkillTestMatches $ xs <> ys
  SkillTestMatches xs <> x = SkillTestMatches $ xs <> [x]
  x <> SkillTestMatches xs = SkillTestMatches $ x : xs
  x <> y = SkillTestMatches [x, y]

data SkillTestResultMatcher = FailureResult ValueMatcher | SuccessResult ValueMatcher | AnyResult
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

pattern AtLeast :: GameValue Int -> ValueMatcher
pattern AtLeast n <- GreaterThanOrEqualTo n where
  AtLeast n = GreaterThanOrEqualTo n

pattern AtMost :: GameValue Int -> ValueMatcher
pattern AtMost n <- LessThanOrEqualTo n where
  AtMost n = LessThanOrEqualTo n

data ValueMatcher
  = LessThan (GameValue Int)
  | GreaterThan (GameValue Int)
  | LessThanOrEqualTo (GameValue Int)
  | GreaterThanOrEqualTo (GameValue Int)
  | EqualTo (GameValue Int)
  | AnyValue
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

data TokenMatcher
  = WithNegativeModifier
  | TokenFaceIs TokenFace
  | TokenFaceIsNot TokenFace
  | TokenMatchesAny [TokenMatcher]
  | AnyToken
  | TokenMatches [TokenMatcher]
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

instance Semigroup TokenMatcher where
  AnyToken <> x = x
  x <> AnyToken = x
  TokenMatches xs <> TokenMatches ys = TokenMatches $ xs <> ys
  TokenMatches xs <> x = TokenMatches $ xs <> [x]
  x <> TokenMatches xs = TokenMatches $ x : xs
  x <> y = TokenMatches [x, y]

data PhaseMatcher = AnyPhase | PhaseIs Phase
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

data WindowMythosStepMatcher = WhenAllDrawEncounterCard
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

data CounterMatcher = HorrorCounter | DamageCounter
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)

data ActionMatcher
  = ActionOnLocation LocationId
  | ActionIs Action
  | ActionWindow WindowMatcher
  | ActionMatches [ActionMatcher]
  | AnyAction
  | ActionOnScenarioCard

instance Semigroup ActionMatcher where
  AnyAction <> x = x
  x <> AnyAction = x
  ActionMatches xs <> ActionMatches ys = ActionMatches $ xs <> ys
  ActionMatches xs <> x = ActionMatches $ xs <> [x]
  x <> ActionMatches xs = ActionMatches $ x : xs
  x <> y = ActionMatches [x, y]

instance Monoid ActionMatcher where
  mempty = AnyAction

data CardListMatcher = LengthIs ValueMatcher | HasCard CardMatcher
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)
