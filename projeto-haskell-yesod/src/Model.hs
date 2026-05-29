module Model where

import ClassyPrelude.Yesod
import Database.Persist.TH

-- Persistent gera os tipos Haskell, as chaves primarias e as migrations SQL.
-- A entidade Produto usa categoria como Text para manter o formulário simples
-- e facilitar a explicação em sala de aula.
share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|
Categoria
    nomeCategoria Text
    UniqueCategoria nomeCategoria
    deriving Show

Produto
    nome Text
    categoria Text
    preco Double
    descricao Textarea
    deriving Show
|]
