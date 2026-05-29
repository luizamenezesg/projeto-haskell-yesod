# TypeStore

TypeStore e um projeto academico em Haskell usando o framework Yesod. A aplicacao funciona como um catalogo simples de eletronicos e games, com cadastro, listagem, detalhes, remocao e filtro por categoria.

O foco do trabalho e demonstrar, em uma aplicacao web real, o uso de Haskell, Yesod, Stack, SQLite, Persistent, Hamlet, Lucius, Julius e Type Families.

## Objetivo

O projeto foi pensado para uma apresentacao de Programacao Funcional / Haskell. Ele mostra como Yesod organiza uma aplicacao web com rotas type-safe, handlers, templates e banco de dados, enquanto o modulo `TypeFamilies.Categorias` demonstra Type Families de forma pratica.

## Telas

1. **Home**: apresenta o projeto, Haskell, Yesod e Type Families.
2. **Cadastro de Produto**: formulario para cadastrar nome, categoria, preco e descricao.
3. **Lista de Produtos**: tabela com todos os produtos, botao de detalhes e botao de deletar.
4. **Detalhes do Produto**: mostra dados completos de um produto.
5. **Produtos por Categoria**: separa produtos em Computador, VideoGame e Periferico.
6. **Sobre o Projeto**: explica Type Families, vantagens e integracao com Yesod.

## Estrutura

```text
TypeStore/
  app/main.hs
  config/routes
  config/settings.yml
  src/Application.hs
  src/Foundation.hs
  src/Model.hs
  src/Handler/
  src/Settings/
  src/TypeFamilies/
  static/
  templates/
  package.yaml
  stack.yaml
```

## Banco SQLite

O banco usa SQLite via Persistent. A configuracao esta em `config/settings.yml`:

```yaml
database:
  database: typestore.sqlite3
  poolsize: 10
```

As entidades estao em `src/Model.hs`:

- `Produto`: nome, categoria, preco e descricao.
- `Categoria`: nomeCategoria.

As migrations sao automaticas. Ao iniciar o sistema, `Application.hs` executa:

```haskell
runSqlPool (runMigration migrateAll >> seedCategorias) pool
```

Isso cria/atualiza as tabelas e cadastra as categorias padrao.

## Type Families

O arquivo `src/TypeFamilies/Categorias.hs` contem:

```haskell
type family CategoriaInfo a

data Computador
data VideoGame
data Periferico

type instance CategoriaInfo Computador = String
type instance CategoriaInfo VideoGame = Int
type instance CategoriaInfo Periferico = Bool
```

Isso significa que cada tipo de categoria possui um tipo de informacao associado:

- `Computador` usa `String`.
- `VideoGame` usa `Int`.
- `Periferico` usa `Bool`.

A funcao de resumo usa polimorfismo: a mesma funcao trabalha com categorias diferentes, mas o tipo da informacao muda conforme a Type Family. A tela `/categorias` exibe esses exemplos junto dos produtos reais do banco.

## Como instalar

1. Instale o GHCup em `https://www.haskell.org/ghcup/`.
2. Pelo GHCup, instale GHC, Cabal e Stack.
3. Confirme que o Stack esta instalado:

```bash
stack --version
```

## Como executar

Na pasta do projeto:

```bash
stack build
stack exec -- typestore
```

Depois acesse:

```bash
http://localhost:3000
```

Se voce tiver `yesod-bin` instalado e quiser rodar em modo desenvolvimento:

```bash
stack install yesod-bin
stack exec -- yesod devel
```

## Rotas

```text
/                          HomeR           GET
/produto/new               ProdutoNewR     GET POST
/produtos                  ProdutosR       GET
/produto/#ProdutoId        ProdutoR        GET
/produto/#ProdutoId/delete ProdutoDeleteR POST
/categorias                CategoriasR     GET
/sobre                     SobreR          GET
```
