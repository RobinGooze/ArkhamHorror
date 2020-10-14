{-# LANGUAGE UndecidableInstances #-}
module Arkham.Types.Location.Cards.Attic where

import Arkham.Json
import Arkham.Types.Classes
import Arkham.Types.GameValue
import Arkham.Types.Location.Attrs
import Arkham.Types.Location.Runner
import Arkham.Types.LocationSymbol
import Arkham.Types.Message
import Arkham.Types.Source
import ClassyPrelude

newtype Attic = Attic Attrs
  deriving newtype (Show, ToJSON, FromJSON)

attic :: Attic
attic = Attic $ (baseAttrs "01113" "Attic" 1 (PerPlayer 2) Triangle [Square] []
                )
  { locationVictory = Just 1
  }

instance HasModifiersFor env investigator Attic where
  getModifiersFor _ _ _ = pure []

instance (IsInvestigator investigator) => HasActions env investigator Attic where
  getActions i window (Attic attrs) = getActions i window attrs

instance (LocationRunner env) => RunMessage env Attic where
  runMessage msg a@(Attic attrs@Attrs {..}) = case msg of
    AfterEnterLocation iid lid | lid == locationId -> do
      unshiftMessage
        $ InvestigatorAssignDamage iid (LocationSource locationId) 0 1
      pure a
    _ -> Attic <$> runMessage msg attrs
