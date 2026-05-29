module Handler.Produto where

import ClassyPrelude.Yesod
import Foundation
import Model
import Numeric (showFFloat)

categoriasDisponiveis :: [(Text, Text)]
categoriasDisponiveis =
  [ ("Computador", "Computador")
  , ("VideoGame", "VideoGame")
  , ("Periferico", "Periferico")
  ]

-- Formulario Yesod: os campos HTML sao convertidos para um valor Produto.
-- Esse e um exemplo de programacao funcional aplicada a web: o formulario
-- inteiro e composto por funcoes puras combinadas com operadores applicativos.
produtoForm :: Maybe Produto -> Html -> MForm Handler (FormResult Produto, Widget)
produtoForm produto =
  renderDivs $
    Produto
      <$> areq textField "Nome" (produtoNome <$> produto)
      <*> areq (selectFieldList categoriasDisponiveis) "Categoria" (produtoCategoria <$> produto)
      <*> areq doubleField "Preco" (produtoPreco <$> produto)
      <*> areq textareaField "Descricao" (produtoDescricao <$> produto)

getProdutoNewR :: Handler Html
getProdutoNewR = do
  (widget, enctype) <- generateFormPost $ produtoForm Nothing
  defaultLayout $ do
    setTitle "TypeStore - Cadastro de Produto"
    $(hamletFile "templates/produto-new.hamlet")

postProdutoNewR :: Handler Html
postProdutoNewR = do
  ((result, widget), enctype) <- runFormPost $ produtoForm Nothing
  case result of
    FormSuccess produto -> do
      produtoId <- runDB $ insert produto
      setMessage "Produto cadastrado com sucesso."
      redirect $ ProdutoR produtoId
    _ -> defaultLayout $ do
      setTitle "TypeStore - Erro no Cadastro"
      $(hamletFile "templates/produto-new.hamlet")

getProdutosR :: Handler Html
getProdutosR = do
  produtos <- runDB $ selectList [] [Asc ProdutoNome]
  defaultLayout $ do
    setTitle "TypeStore - Produtos"
    $(hamletFile "templates/produtos.hamlet")

getProdutoR :: ProdutoId -> Handler Html
getProdutoR produtoId = do
  produto <- runDB $ get404 produtoId
  defaultLayout $ do
    setTitle "TypeStore - Detalhes do Produto"
    $(hamletFile "templates/produto-detalhe.hamlet")

postProdutoDeleteR :: ProdutoId -> Handler Html
postProdutoDeleteR produtoId = do
  -- get404 evita deletar silenciosamente um registro inexistente.
  _ <- runDB $ get404 produtoId
  runDB $ delete produtoId
  setMessage "Produto removido com sucesso."
  redirect ProdutosR

showPreco :: Double -> Text
showPreco valor = pack $ showFFloat (Just 2) valor ""
