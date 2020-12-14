module Arkham.Types.Trait
  ( Trait(..)
  , EnemyTrait(..)
  )
where

import ClassyPrelude
import Data.Aeson

newtype EnemyTrait = EnemyTrait { unEnemyTrait :: Trait }

data Trait
  = Abomination
  | Agency
  | Ally
  | AncientOne
  | Arkham
  | Armor
  | Artist
  | Assistant
  | Augury
  | Avatar
  | Bayou
  | Believer
  | Blessed
  | Blunder
  | Bold
  | Boon
  | Byakhee
  | Cave
  | Central
  | Charm
  | Chosen
  | Civic
  | Clairvoyant
  | Clothing
  | Composure
  | Condition
  | Connection
  | Conspirator
  | Creature
  | Criminal
  | Cultist
  | Curse
  | Cursed
  | DarkYoung
  | DeepOne
  | Desperate
  | Detective
  | Developed
  | Dhole
  | Dreamer
  | Dreamlands
  | Drifter
  | Eldritch
  | Elite
  | Endtimes
  | Evidence
  | Expert
  | Extradimensional
  | Fated
  | Favor
  | Firearm
  | Flaw
  | Footwear
  | Fortune
  | Gambit
  | Geist
  | Ghoul
  | Grant
  | Gug
  | Hazard
  | Hex
  | Human
  | Humanoid
  | Hunter
  | Illicit
  | Improvised
  | Injury
  | Innate
  | Insight
  | Instrument
  | Item
  | Job
  | Lunatic
  | Madness
  | Mask
  | Medic
  | Melee
  | Miskatonic
  | Monster
  | Mystery
  | NewOrleans
  | Nightgaunt
  | Obstacle
  | Occult
  | Omen
  | Otherworld
  | Pact
  | Paradox
  | Patron
  | Performer
  | Poison
  | Police
  | Power
  | Practiced
  | Ranged
  | Relic
  | Reporter
  | Research
  | Ritual
  | Riverside
  | Scheme
  | Scholar
  | Science
  | Serpent
  | Service
  | Servitor
  | SilverTwilight
  | Socialite
  | Song
  | Sorcerer
  | Spell
  | Spirit
  | Summon
  | Supply
  | Syndicate
  | Tactic
  | Talent
  | Tarot
  | Task
  | Terror
  | Tindalos
  | Tome
  | Tool
  | Trap
  | Trick
  | Upgrade
  | Veteran
  | Warden
  | Wayfarer
  | Weapon
  | Wilderness
  | Witch
  | Woods
  | Unhallowed
  | Yithian
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON, Hashable)
