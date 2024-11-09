module Arkham.Location.Cards.GatewayToYhanthlei
  ( gatewayToYhanthlei
  , GatewayToYhanthlei(..)
  )
where

import Arkham.Location.Cards qualified as Cards
import Arkham.Location.Import.Lifted

newtype GatewayToYhanthlei = GatewayToYhanthlei LocationAttrs
  deriving anyclass (IsLocation, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

gatewayToYhanthlei :: LocationCard GatewayToYhanthlei
gatewayToYhanthlei = location GatewayToYhanthlei Cards.gatewayToYhanthlei 2 (Static 0)

instance HasAbilities GatewayToYhanthlei where
  getAbilities (GatewayToYhanthlei attrs) =
    extendRevealed attrs []

instance RunMessage GatewayToYhanthlei where
  runMessage msg (GatewayToYhanthlei attrs) = runQueueT $ case msg of
    _ -> GatewayToYhanthlei <$> liftRunMessage msg attrs
