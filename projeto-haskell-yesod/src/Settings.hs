module Settings where

import ClassyPrelude
import Data.Aeson (FromJSON (..), (.:), withObject)
import Data.Yaml (decodeFileEither)

data DatabaseConf = DatabaseConf
  { databaseDatabase :: Text
  , databasePoolsize :: Int
  }
  deriving (Show)

data AppSettings = AppSettings
  { appDatabaseConf :: DatabaseConf
  , appHost :: Text
  , appPort :: Int
  }
  deriving (Show)

instance FromJSON DatabaseConf where
  parseJSON = withObject "DatabaseConf" $ \o ->
    DatabaseConf
      <$> o .: "database"
      <*> o .: "poolsize"

instance FromJSON AppSettings where
  parseJSON = withObject "AppSettings" $ \o ->
    AppSettings
      <$> o .: "database"
      <*> o .: "host"
      <*> o .: "port"

loadSettings :: IO AppSettings
loadSettings = do
  result <- decodeFileEither "config/settings.yml"
  case result of
    Left err -> error $ unpack $ "Erro ao ler config/settings.yml: " <> tshow err
    Right settings -> pure settings
