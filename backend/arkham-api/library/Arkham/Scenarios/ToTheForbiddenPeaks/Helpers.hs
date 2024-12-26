module Arkham.Scenarios.ToTheForbiddenPeaks.Helpers where

import Arkham.Campaigns.EdgeOfTheEarth.Helpers
import Arkham.I18n
import Arkham.Prelude

scenarioI18n :: (HasI18n => a) -> a
scenarioI18n a = campaignI18n $ scope "toTheForbiddenPeaks" a
