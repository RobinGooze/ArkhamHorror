{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Orphans where

import Yesod.Core.Content
import Data.Aeson

instance {-# OVERLAPPABLE #-} ToJSON a => ToTypedContent a where
  toTypedContent = TypedContent typeJson . toContent

instance {-# OVERLAPPABLE #-} ToJSON a => ToContent a where
  toContent = toContent . encode

