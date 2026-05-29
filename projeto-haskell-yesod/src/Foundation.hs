module Foundation where

import ClassyPrelude.Yesod
import Database.Persist.Sql (ConnectionPool, SqlBackend, runSqlPool)
import Model
import Network.HTTP.Client (Manager)
import Settings
import Settings.StaticFiles
import Yesod.Static

data App = App
  { appSettings :: AppSettings
  , appConnPool :: ConnectionPool
  , appHttpManager :: Manager
  , getStatic :: Static
  }

mkYesodData "App" $(parseRoutesFile "config/routes")

instance Yesod App where
  approot = ApprootRelative

  -- defaultLayout centraliza o layout da aplicacao.
  -- Todos os handlers usam este ponto para ganhar navbar, CSS e JS.
  defaultLayout widget = do
    mmsg <- getMessage
    pc <- widgetToPageContent $ do
      addStylesheet $ StaticR css_style_css
      addScript $ StaticR js_app_js
      toWidget $(luciusFile "templates/style.lucius")
      toWidget $(juliusFile "templates/app.julius")
      widget
    withUrlRenderer $(hamletFile "templates/default-layout.hamlet")

instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend
  runDB action = do
    pool <- getsYesod appConnPool
    runSqlPool action pool

instance RenderMessage App FormMessage where
  renderMessage _ _ = defaultFormMessage
