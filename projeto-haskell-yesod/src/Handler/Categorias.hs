module Handler.Categorias where

import ClassyPrelude.Yesod
import Foundation
import Model
import Numeric (showFFloat)
import TypeFamilies.Categorias

getCategoriasR :: Handler Html
getCategoriasR = do
  computadores <- runDB $ selectList [ProdutoCategoria ==. "Computador"] [Asc ProdutoNome]
  videoGames <- runDB $ selectList [ProdutoCategoria ==. "VideoGame"] [Asc ProdutoNome]
  perifericos <- runDB $ selectList [ProdutoCategoria ==. "Periferico"] [Asc ProdutoNome]
  let exemplos = exemplosTypeFamilies
      explicacao = categoriaExplicacao
  defaultLayout $ do
    setTitle "TypeStore - Categorias"
    $(hamletFile "templates/categorias.hamlet")

categoriaBloco :: Text -> [Entity Produto] -> Widget
categoriaBloco titulo produtos =
  $(hamletFile "templates/categoria-bloco.hamlet")

showPreco :: Double -> Text
showPreco valor = pack $ showFFloat (Just 2) valor ""
