module Application
  ( appMain
  , makeApplication
  , makeFoundation
  ) where

import ClassyPrelude
import Control.Monad.Logger (runStdoutLoggingT)
import Data.String (fromString)
import Database.Persist.Sqlite
import Foundation
import Handler.Categorias
import Handler.Home
import Handler.Produto
import Handler.Sobre
import Model
import Network.HTTP.Client.TLS (newTlsManager)
import Network.Wai (Application)
import Network.Wai.Handler.Warp (runSettings, setHost, setPort, defaultSettings)
import Settings
import Yesod.Core
import Yesod.Static

mkYesodDispatch "App" resourcesApp

makeFoundation :: IO App
makeFoundation = do
  settings <- loadSettings
  manager <- newTlsManager
  staticSite <- static "static"
  pool <- runStdoutLoggingT $
    createSqlitePool (appDatabasePath settings) (databasePoolsize $ appDatabaseConf settings)
  runSqlPool (runMigration migrateAll >> seedCategorias) pool
  pure $ App settings pool manager staticSite

makeApplication :: IO Application
makeApplication = toWaiApp =<< makeFoundation

appMain :: IO ()
appMain = do
  foundation <- makeFoundation
  let settings = appSettings foundation
      warpSettings =
        setPort (appPort settings) $
          setHost (fromString $ unpack $ appHost settings) defaultSettings
  putStrLn $ "TypeStore rodando em http://localhost:" <> tshow (appPort settings)
  runSettings warpSettings =<< toWaiApp foundation

appDatabasePath :: AppSettings -> Text
appDatabasePath = databaseDatabase . appDatabaseConf

seedCategorias :: SqlPersistT IO ()
seedCategorias = do
  mapM_ insertCategoria ["Computador", "VideoGame", "Periferico"]
 where
  insertCategoria nomeCategoria = do
    exists <- getBy $ UniqueCategoria nomeCategoria
    when (isNothing exists) $
      void $ insert $ Categoria nomeCategoria
