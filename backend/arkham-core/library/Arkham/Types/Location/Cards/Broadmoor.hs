{-# LANGUAGE UndecidableInstances #-}
module Arkham.Types.Location.Cards.Broadmoor where

import Arkham.Import

import qualified Arkham.Types.Action as Action
import qualified Arkham.Types.EncounterSet as EncounterSet
import Arkham.Types.Location.Attrs
import Arkham.Types.Location.Helpers
import Arkham.Types.Location.Runner
import Arkham.Types.Trait

newtype Broadmoor = Broadmoor Attrs
  deriving newtype (Show, ToJSON, FromJSON)

broadmoor :: Broadmoor
broadmoor = Broadmoor $ (baseAttrs
                          "81009"
                          (LocationName "Broadmoor" Nothing)
                          EncounterSet.CurseOfTheRougarou
                          3
                          (PerPlayer 1)
                          Plus
                          [Square, Plus]
                          [NewOrleans]
                        )
  { locationVictory = Just 1
  }

instance HasModifiersFor env Broadmoor where
  getModifiersFor = noModifiersFor

instance ActionRunner env => HasActions env Broadmoor where
  getActions iid NonFast (Broadmoor attrs@Attrs {..}) = do
    baseActions <- getActions iid NonFast attrs
    canAffordActions <- getCanAffordCost
      iid
      (toSource attrs)
      (ActionCost 1 (Just Action.Resign) locationTraits)
    pure
      $ baseActions
      <> [ ActivateCardAbilityAction
             iid
             (mkAbility
               (toSource attrs)
               1
               (ActionAbility 1 (Just Action.Resign))
             )
         | iid `member` locationInvestigators && canAffordActions
         ]
  getActions i window (Broadmoor attrs) = getActions i window attrs

instance (LocationRunner env) => RunMessage env Broadmoor where
  runMessage msg l@(Broadmoor attrs) = case msg of
    UseCardAbility iid source _ 1 | isSource attrs source ->
      l <$ unshiftMessage (Resign iid)
    _ -> Broadmoor <$> runMessage msg attrs
