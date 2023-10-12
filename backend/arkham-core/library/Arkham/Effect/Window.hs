module Arkham.Effect.Window (
  module Arkham.Effect.Window,
) where

import Arkham.Prelude

import Arkham.Card.Id
import Arkham.Phase

data EffectWindow
  = EffectPhaseWindow
  | EffectPhaseWindowFor Phase
  | EffectCostWindow
  | EffectSkillTestWindow
  | EffectRoundWindow
  | EffectNextActionWindow
  | EffectSetupWindow
  | EffectTurnWindow
  | EffectCardResolutionWindow
  | EffectGameWindow
  | EffectAttackWindow
  | FirstEffectWindow [EffectWindow]
  | EffectEventWindow
  | EffectAbilityWindow
  | EffectSearchWindow
  | EffectCardCostWindow CardId
  | EffectUI
  deriving stock (Eq, Show, Generic)
  deriving anyclass (ToJSON, FromJSON)
