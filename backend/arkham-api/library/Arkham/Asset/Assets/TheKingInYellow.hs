module Arkham.Asset.Assets.TheKingInYellow (theKingInYellow, TheKingInYellow (..)) where

import Arkham.Ability
import Arkham.Asset.Cards qualified as Cards
import Arkham.Asset.Import.Lifted
import Arkham.Investigator.Types (Field (..))
import Arkham.Matcher hiding (PlayCard)
import Arkham.Message.Lifted.Placement
import Arkham.Modifier
import Arkham.Placement
import Arkham.Projection

newtype TheKingInYellow = TheKingInYellow AssetAttrs
  deriving anyclass IsAsset
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

theKingInYellow :: AssetCard TheKingInYellow
theKingInYellow =
  assetWith TheKingInYellow Cards.theKingInYellow
    $ canLeavePlayByNormalMeansL
    .~ False

instance HasAbilities TheKingInYellow where
  getAbilities (TheKingInYellow x) =
    [ restricted x 1 ControlsThis
        $ freeReaction
        $ SkillTestResult #after (You <> ContributedMatchingIcons (atLeast 6)) AnySkillTest #success
    ]

instance HasModifiersFor TheKingInYellow where
  getModifiersFor (SkillTestTarget _) (TheKingInYellow attrs) = do
    case assetPlacement attrs of
      InThreatArea minh -> do
        commitedCardsCount <- fieldMap InvestigatorCommittedCards length minh
        toModifiers attrs [CannotPerformSkillTest | commitedCardsCount == 1 || commitedCardsCount == 2]
      _ -> pure [] -- if drawn during a skill test, it will have a small moment where it can't modify
  getModifiersFor _ _ = pure []

instance RunMessage TheKingInYellow where
  runMessage msg a@(TheKingInYellow attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      putCardIntoPlay iid attrs
      pure a
    CardEnteredPlay iid card | card.id == attrs.cardId -> do
      place attrs.id (InThreatArea iid)
      pure $ a
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      toDiscardBy iid (attrs.ability 1) attrs
      pure a
    _ -> TheKingInYellow <$> liftRunMessage msg attrs
