{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Models.Tag where

import           Control.Applicative ((<$>), (<*>))
import           Control.Monad.CatchIO (throw)
import           Control.Monad.State
import           Data.Baeson.Types
import           Data.Bson
import           Database.MongoDB
import qualified Data.Bson as BSON
import qualified Database.MongoDB as DB
import           Snap.Snaplet.Auth
import           Snap.Snaplet.MongoDB
import qualified Data.Text as T
import           Data.Time (UTCTime)

import           Application
import           Models.Exception
import           Models.Utils
import           Models.Internal.Types

--import           Control.Monad.Trans

-- | Tag model
-- 
data Tag = Tag
    { _tagId      :: Maybe ObjectId
    , _tagName    :: T.Text
    , _tagContent :: T.Text
    } deriving (Show, Eq)

-- | Schema name
-- 
tagCollection :: Collection
tagCollection = u "tags"

-- | Shortcut to get Tag Id in {Text}.
-- 
getTagId :: Tag -> T.Text
getTagId = objectIdToText . _tagId


--------------------------------------------------------------------------------
-- Impl of Persistent Interface
--------------------------------------------------------------------------------


-- | FIXME: couple of thoughts: 
--   0. save or create ?
--   1. Input from web is [String]
--   2. batch create new tags?
-- 
instance MongoDBPersistent Tag where
  mongoColl _  = tagCollection
  toMongoDoc   = tagToDocument
  fromMongoDoc = tagFromDocumentOrThrow
  mongoInsertId tag value = tag { _tagId = BSON.cast' value }

--------------------------------------------------------------------------------
-- CRUD
--------------------------------------------------------------------------------


-- | Insert a new tag.
--   meaning insert it if its new (has no "_id" field) or update it if its not new (has "_id" field)
--   TODO: better to make sure _id exists because Nothing objectId will cause error other when viewing.
insertTag :: Tag -> AppHandler Tag
insertTag = mongoInsert


findAllTags :: AppHandler [Tag]
findAllTags  = mongoFindAll undefined


--------------------------------------------------------------------------------
-- MongoDB Document Transform
--------------------------------------------------------------------------------


-- | Transform @Tag@ to mongoDB document.
--   Nothing of id mean new topic thus empty "_id" let mongoDB generate objectId.
-- 
tagToDocument :: Tag -> Document
tagToDocument tag = case _tagId tag of 
                          Nothing -> docs
                          Just x  -> ("_id" .= x) : docs
                    where docs = [ "name"     .= _tagName tag
                                 , "content"  .= _tagContent tag
                                 ]

-- | Transform mongo Document to be a Tag parser.
-- 
documentToTag :: Document -> Parser Tag
documentToTag d = Tag
                  <$> d .: "_id"
                  <*> d .: "name"
                  <*> d .: "content"

-- | parse the tag document
-- 
tagFromDocumentOrThrow :: Document -> IO Tag
tagFromDocumentOrThrow d = case parseEither documentToTag d of
    Left e  -> throw $ BackendError $ show e
    Right r -> return r