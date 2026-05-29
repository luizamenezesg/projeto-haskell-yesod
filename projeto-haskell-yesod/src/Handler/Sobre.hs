module Handler.Sobre where

import ClassyPrelude.Yesod
import Foundation
import TypeFamilies.Categorias

getSobreR :: Handler Html
getSobreR = defaultLayout $ do
  setTitle "TypeStore - Sobre"
  let exemplos = exemplosTypeFamilies
  $(hamletFile "templates/sobre.hamlet")
