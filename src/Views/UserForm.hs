{-# LANGUAGE OverloadedStrings, TemplateHaskell #-}
module Views.UserForm where

import Control.Applicative ((<$>), (<*>))
import qualified Data.Text as T
import Data.Text (Text)
import Text.Digestive
import qualified Data.ByteString as BS
import qualified Data.Configurator.Types as Config

import Views.Validators

data LoginUser = LoginUser
    { loginName :: Text
    , password :: Text
    } deriving (Show)

-- | Need a better design to get message from i18n snaplet.
-- 
userForm :: Monad m => (Text, Text) -> Form Text m LoginUser
userForm (a, b) = LoginUser
    <$> "loginName" .: check a requiredValidator (text Nothing)
    <*> "password" .:  check b requiredValidator (text Nothing)

