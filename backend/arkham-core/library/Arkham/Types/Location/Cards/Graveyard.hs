{-# LANGUAGE UndecidableInstances #-}
module Arkham.Types.Location.Cards.Graveyard where

import Arkham.Import

import qualified Arkham.Types.EncounterSet as EncounterSet
import Arkham.Types.Location.Attrs
import Arkham.Types.Location.Runner
import Arkham.Types.Trait

newtype Graveyard = Graveyard Attrs
  deriving newtype (Show, ToJSON, FromJSON)

graveyard :: Graveyard
graveyard = Graveyard $ (baseAttrs
                          "01133"
                          (LocationName "Graveyard" Nothing)
                          EncounterSet.TheMidnightMasks
                          1
                          (PerPlayer 2)
                          Hourglass
                          [Circle]
                          [Arkham]
                        )
  { locationVictory = Just 1
  }

instance HasModifiersFor env Graveyard where
  getModifiersFor = noModifiersFor

instance ActionRunner env => HasActions env Graveyard where
  getActions i window (Graveyard attrs) = getActions i window attrs

instance (LocationRunner env) => RunMessage env Graveyard where
  runMessage msg l@(Graveyard attrs@Attrs {..}) = case msg of
    AfterEnterLocation iid lid | lid == locationId -> do
      unshiftMessage
        (BeginSkillTest
          iid
          (LocationSource lid)
          (InvestigatorTarget iid)
          Nothing
          SkillWillpower
          3
        )
      Graveyard <$> runMessage msg attrs
    FailedSkillTest iid _ source _ _ | isSource attrs source ->
      l <$ unshiftMessage
        (chooseOne
          iid
          [InvestigatorAssignDamage iid source 0 2, MoveTo iid "01125"]
        )
    _ -> Graveyard <$> runMessage msg attrs
