module Arkham.Location.Cards.OnyxGuardians
  ( onyxGuardians
  , OnyxGuardians(..)
  )
where

import Arkham.Location.Cards qualified as Cards
import Arkham.Location.Import.Lifted

newtype OnyxGuardians = OnyxGuardians LocationAttrs
  deriving anyclass (IsLocation, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

onyxGuardians :: LocationCard OnyxGuardians
onyxGuardians = location OnyxGuardians Cards.onyxGuardians 0 (Static 0)

instance HasAbilities OnyxGuardians where
  getAbilities (OnyxGuardians attrs) =
    extendRevealed attrs []

instance RunMessage OnyxGuardians where
  runMessage msg (OnyxGuardians attrs) = runQueueT $ case msg of
    _ -> OnyxGuardians <$> liftRunMessage msg attrs
