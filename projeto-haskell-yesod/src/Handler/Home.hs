module Handler.Home where

import ClassyPrelude.Yesod
import Foundation

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
  setTitle "TypeStore - Home"
  $(hamletFile "templates/home.hamlet")
