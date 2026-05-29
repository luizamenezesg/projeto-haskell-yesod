module TypeFamilies.Categorias
  ( CategoriaInfo
  , Computador
  , VideoGame
  , Periferico
  , CategoriaResumo (..)
  , exemplosTypeFamilies
  , categoriaExplicacao
  ) where

import ClassyPrelude
import Data.Proxy (Proxy (..))

-- Type Families permitem calcular um tipo a partir de outro tipo.
-- Aqui cada categoria de produto possui um tipo de informacao diferente.
type family CategoriaInfo a

data Computador
data VideoGame
data Periferico

-- Para Computador, a informacao associada e uma String.
type instance CategoriaInfo Computador = String

-- Para VideoGame, a informacao associada e um Int.
type instance CategoriaInfo VideoGame = Int

-- Para Periferico, a informacao associada e um Bool.
type instance CategoriaInfo Periferico = Bool

-- Esta classe mostra polimorfismo: a funcao categoriaResumo trabalha com
-- qualquer tipo "a" que tenha uma instancia CategoriaType. O tipo do campo
-- info muda conforme a Type Family CategoriaInfo a.
class CategoriaType a where
  nomeTipo :: Proxy a -> Text
  infoPadrao :: Proxy a -> CategoriaInfo a
  renderInfo :: Proxy a -> CategoriaInfo a -> Text

instance CategoriaType Computador where
  nomeTipo _ = "Computador"
  infoPadrao _ = "Hardware, memoria, processador e armazenamento"
  renderInfo _ = pack

instance CategoriaType VideoGame where
  nomeTipo _ = "VideoGame"
  infoPadrao _ = 9
  renderInfo _ valor = "Nota academica da categoria: " <> tshow valor <> "/10"

instance CategoriaType Periferico where
  nomeTipo _ = "Periferico"
  infoPadrao _ = True
  renderInfo _ True = "Categoria costuma ser plug and play"
  renderInfo _ False = "Categoria exige configuracao manual"

data CategoriaResumo = CategoriaResumo
  { resumoNome :: Text
  , resumoTipoAssociado :: Text
  , resumoValor :: Text
  }

categoriaResumo :: CategoriaType a => Proxy a -> Text -> CategoriaResumo
categoriaResumo proxy tipoAssociado =
    CategoriaResumo
      { resumoNome = nomeTipo proxy
      , resumoTipoAssociado = tipoAssociado
      , resumoValor = renderInfo proxy (infoPadrao proxy)
      }

exemplosTypeFamilies :: [CategoriaResumo]
exemplosTypeFamilies =
  [ categoriaResumo (Proxy :: Proxy Computador) "String"
  , categoriaResumo (Proxy :: Proxy VideoGame) "Int"
  , categoriaResumo (Proxy :: Proxy Periferico) "Bool"
  ]

categoriaExplicacao :: Text
categoriaExplicacao =
  "A mesma funcao trabalha com categorias diferentes, mas a Type Family define o tipo de informacao de cada uma."
