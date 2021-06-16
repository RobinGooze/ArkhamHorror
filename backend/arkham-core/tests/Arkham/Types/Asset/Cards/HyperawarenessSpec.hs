module Arkham.Types.Asset.Cards.HyperawarenessSpec
  ( spec
  )
where

import TestImport

import Arkham.Types.Investigator.Attrs (InvestigatorAttrs(..))

spec :: Spec
spec = describe "Hyperawareness" $ do
  it "Adds 1 to intellect check for each resource spent" $ do
    hyperawareness <- buildAsset "01034"
    investigator <- testInvestigator "00000"
      $ \attrs -> attrs { investigatorIntellect = 1, investigatorResources = 2 }

    (didPassTest, logger) <- didPassSkillTestBy investigator SkillIntellect 0

    gameTestWithLogger
        logger
        investigator
        [ SetTokens [Zero]
        , playAsset investigator hyperawareness
        , beginSkillTest investigator SkillIntellect 3
        ]
        (assetsL %~ insertEntity hyperawareness)
      $ do
          runMessages
          chooseOptionMatching
            "use ability"
            (\case
              Run{} -> True
              _ -> False
            )
          chooseOptionMatching
            "use ability"
            (\case
              Run{} -> True
              _ -> False
            )
          chooseOptionMatching
            "start skill test"
            (\case
              StartSkillTest{} -> True
              _ -> False
            )
          chooseOnlyOption "apply results"
          didPassTest `refShouldBe` True

  it "Adds 1 to agility check for each resource spent" $ do
    hyperawareness <- buildAsset "01034"
    investigator <- testInvestigator "00000"
      $ \attrs -> attrs { investigatorAgility = 1, investigatorResources = 2 }

    (didPassTest, logger) <- didPassSkillTestBy investigator SkillAgility 0

    gameTestWithLogger
        logger
        investigator
        [ SetTokens [Zero]
        , playAsset investigator hyperawareness
        , beginSkillTest investigator SkillAgility 3
        ]
        (assetsL %~ insertEntity hyperawareness)
      $ do
          runMessages
          chooseOptionMatching
            "use ability"
            (\case
              Run{} -> True
              _ -> False
            )
          chooseOptionMatching
            "use ability"
            (\case
              Run{} -> True
              _ -> False
            )
          chooseOptionMatching
            "start skill test"
            (\case
              StartSkillTest{} -> True
              _ -> False
            )
          chooseOnlyOption "apply results"
          didPassTest `refShouldBe` True
