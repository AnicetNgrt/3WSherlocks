# 3W Sherlocks
[🔗 Check it out!](https://bourse2021-coddity.anicetnougaret.fr)

# Documentation [FR]

- [🔧 Installation](#-installation)
  - [Envionnement Dev](#envionnement-dev)
- [🍷 Concepts Elixir pour review le code](#-concepts-elixir-pour-review-le-code)
  - [Return des fonctions](#return-des-fonctions)
  - [Pattern matching](#pattern-matching)
- [🧭 Visite guidée du code source](#-visite-guidée-du-code-source)
  - [Fakebusters et FakebustersWeb](#fakebusters-et-fakebustersweb)
  - [Code autogénéré et code fait main](#code-autogénéré-et-code-fait-main)
  - [MVC](#mvc)
  - [Arbre de supervision](#arbre-de-supervision)
  - [Où est le JS ???](#où-est-le-js-)
  - [Mix et config](#mix-et-config)
  - [Migrations](#migrations)
  - [Tests](#tests)
  - [Docker](#docker)
- [👩‍💻 Commandes utiles](#-commandes-utiles)
  - [Reset la base de donnée](#reset-la-base-de-donnée)
  - [Dump et load la base donnée](#dump-et-load-la-base-donnée)
  - [Formater le code](#formater-le-code)
  - [Lancer l'analyse statique du code](#lancer-lanalyse-statique-du-code)
  - [Tester le code](#tester-le-code)
- [💡 Resources utiles](#-resources-utiles)

## 🔧 Installation
### Envionnement Dev
1. Mettez en place une base de donnée PostgreSQL avec identifiant `postgres` et mot de passe `postgres` sur `localhost:5432`
   - Avec docker 🐳 : `docker run --name postgres-fakebusters -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 postgres:alpine` 
   - [Sans docker](https://www.postgresql.org/download/)
2. Installez Elixir [Windows](https://elixir-lang.org/install.html#windows) | [Linux](https://elixir-lang.org/install.html#gnulinux) | [Mac](https://elixir-lang.org/install.html#macos)
3. Installez [NPM](https://www.npmjs.com/)
4. Faites `mix setup`
5. Faites `cd assets`, `npm install` puis `cd ..`
6. Lancez le serveur `mix phx.server`
7. [Amusez-vous bien :)](http://localhost:4000)

## 🍷 Concepts Elixir pour review le code
Elixir est un langage pas comme les autres. Si vous avez un dev Ruby sous la main alors il n'aura pas trop de soucis, mais sinon je dois vous expliquer certaines choses.

### Return des fonctions
Le return d'une fonction est le résultat de sa dernière instruction.

```elixir
# renvoie 5
def ma_fonction do
  5
end

# renvoie 6
def ma_fonction_v2, do: 6

# renvoie 5 si param est true, 6 sinon
def ma_fonction_v3(param) do
  if param do
    ma_fonction
  else
    ma_fonction_v2
  end
end
```

### Pattern matching
Le pattern matching c'est l'orsqu'on essaye de faire correspondre une valeur avec un pattern.

Une valeur c'est n'importe quelle chose qu'on pourrait mettre dans une variable. (`6`, `40.5`, `"hello world"`, `%Point2D{x: 5, y: 10}`...)

Un pattern représente un "ensemble de valeurs possible", un peu comme une expression régulière. Il est composé de valeurs et/ou de variables.

Le pattern `[5, _]` correspond à toutes les listes de taille 2 commençant par 5. Le mot-clé `_` match avec n'importe quelle valeur de n'importe quel type. Ici, 5 doit matcher avec le premier élément et `_` avec le second.

Le pattern `[5 | _]` correspond à toutes les listes (peu importe leur taille) commençant par 5. Avec l'opérateur `|` on a donc 5 qui doit matcher avec le premier élément et `_` avec la liste de tous les éléments suivants.

Le pattern `[5 | a]` fait la même chose que celui du dessus, mais il crée aussi une variable nommée `a` matchant avec n'importe quelle valeur de n'importe quel type. La valeur matchant `a` lui sera assignée en cas de succès.

Pour que le pattern matching fonctionne il faut donc que la valeur soit un sous-ensemble des valeurs correspondant au pattern.

#### Exemples
Le `=` effectue le pattern matching entre la valeur à droite et le pattern à gauche. Comme tous les pattern matchings, il y a affectation si succès. Donc pour les cas simples ça fonctionne comme le `=` dans tous les langages.

```elixir
def main do
  var = 6
  # var peut matcher l'ensemble des valeurs de
  # n'importe quel type, dont 6 fait évidemment
  # partie
  # var vaut maintenant 6

  6 = var
  # pattern matching de var par 6
  # ne plante pas car var vaut 6
  # c'est donc un sous-ensemble de {6}

  5 = var
  # pattern matching de var par 5
  # plante car var (= 6) n'appartient pas à
  # l'ensemble {5}
```

```elixir
def main do
  {a, b, c} = {1, 2, 3}
  # {a, b, c} correspond à l'ensemble des triplets
  # de valeurs de n'importe quel type
  # donc {1, 2, 3} est un sous-ensemble valide

  # Succès donc affectation
  IO.puts("#{a}, #{b}, #{c}")
  # 1, 2, 3

  {a, b, c} = {:ok, [12, 35], "hello"}
  # {:ok, [12, 35], "hello"} est un sous-ensemble valide
  # des triplets de valeurs de n'importe quel type
  
  # Succès donc affectation
  IO.puts("#{a}, #{b}, #{c}")
  # :ok, [12, 35], hello

  {a, {b, c}, d} = {1, 2, 3}
  # plante
  # 2 n'appartient pas à l'ensemble des couples
  # de valeurs de n'importe quel type

  {a, {b, c}, d} = {1, {28.08, "hello world"}, 3}
  # fonctionne
  # {28.08, "hello world"} fait bien parti de
  # l'ensemble des couples de valeurs de n'importe quel type
end
```

Le pattern matching est aussi effectué lorsqu'on utilise le mot-clé `case` : 

```elixir
def fonction(valeur) do
  case valeur do
    # passe ici si valeur est un tuple à 4 valeurs
    # tel que sa dernière valeur vaut 10
    {a, b, c, 10} -> {:ok, b}

    # passe ici si valeur est quoi que ce soit
    # d'autre que ce qui peut matcher au dessus
    # un peu comme le 'default' dans un switch case
    _ -> :error
end

fonction({1, 2, 3, 10}) # {:ok, 2}
fonction({{}, "b", 54.3, 10}) # {:ok, "b"}

fonction("test") # :error
fonction({}) # :error
fonction({10, [1, 2], "truc", "machin"}) # :error
```

Les appels de fonction sont du pattern matching, ce qui permet de faire des surcharges :

```elixir
def fonction(:ok), do: "il m'a donné :ok"
def fonction(19), do: "il m'a donné 19"
def fonction({a, b}), do: "il m'a donné un couple de valeurs"
def fonction(_), do: "il m'a donné n'importe quoi"

fonction(:ok) # "il m'a donné :ok"
fonction(19) # "il m'a donné 19"
fonction({1, "hello world"}) # "il m'a donné un couple de valeurs"
fonction(%{x: 10, y: -35}) # "il m'a donné n'importe quoi"
```

Il y a d'autres cas mais ce sont les principaux.

## 🧭 Visite guidée du code source
*Note au lecteur : l'ancien nom de code du projet étant "fakebusters", il est resté le nom du projet au sein du code source.*

Le code est organisée de façon monolithique, le back et le front dans un même projet Elixir dont la racine est le répertoire actuel.

Le tout structuré selon les bonnes pratiques recommandées par la communauté Elixir, telles que l'utilisation du ["domain driven design"](https://en.wikipedia.org/wiki/Domain-driven_design) et de certaines briques du MVC (imposées par Phoenix). 

### Fakebusters et FakebustersWeb
Le code source est organisé en deux modules Elixir de premier niveau :

- `lib/fakebusters` Partie "Model" en MVC standard, il contient les APIs minimales nécessaires à l'exploitation de la logique métier et de la modélisation des données.
- `lib/fakebusters_web` Partie "View", "Controller", et bien plus encore. La seule limite est que le code soit exclusif à une interface "web", c'est à dire par WebSockets, APIs HTTP, templates (.eex) et LiveViews (.leex). Si l'on souhaitait par la suite faire un tchat bot ou une GUI avec les bindings Erlang d'OpenGL (pitié ne faites pas ça) nous pourrions créer un autre module du même genre. 

Par ailleurs, les relations de dépendances entre ces deux parties sont strictes, `fakebusters_web` dépend de `fakebusters` mais jamais l'inverse.

### Code autogénéré et code fait main
Phoenix propose de nombreux générateurs. Pour différencier mon code du code généré, compliqué car ils sont tous les deux ~~d'excellente qualité~~.

90% du code lié à l'authentification fut généré par [phx_gen_auth](https://github.com/aaronrenner/phx_gen_auth)

50% du code des contextes (comme [Fakebusters.Accounts](lib/fakebusters/accounts.ex) par exemple) fut généré lors de la création de chaque contexte avec `phx.gen.context`.

### MVC
Comme expliqué ci-dessus, Phoenix impose un simili de modèle MVC.

#### Models & contexts
Fakebusters est découpé en trois "contextes" qui correspondent à la partie Models de MVC :

- [Fakebusters.Accounts](lib/fakebusters/accounts.ex) Gère l'authent.
- [Fakebusters.Boards](lib/fakebusters/boards.ex) Gère les investigations, les messages et les votes.
- [Fakebusters.Topics](lib/fakebusters/topics.ex) Gère les tags. (J'ai décidé de le séparer pour le rendre réutilisable pour d'autres features plus tard.)

Dans les sous dossiers de ces trois contextes l'on retrouve les schémas et les "changesets" (= des règles de validations).

Ce découpage est arbitraire et n'a pas d'autres conséquences que l'organisation du code.

#### Views
Les Views sont dans le dossier `lib/fakebusters_web/views` mais ne contiennent que peu de code. 

Les templates .eex sont situés dans des sous dossiers aux noms de views dans `lib/fakebusters_web/templates`.

Les templates peuvent inclurent d'autres templates et des LiveViews, la requête est alors étendue vers les parties du code concernées.

#### Controllers, assigns, et plugs
Les controllers sont dans `lib/fakebusters_web/controllers`. Ils définissent des "assigns", des variables attachées à un objet `conn` qui est passé entre chaque traitement de la requête, du routeur jusqu'au template.

Les [plugs](https://hexdocs.pm/plug/readme.html) sont principalement des middelewares qui ajoutent ou retirent des assigns et peuvent effectuer des redirections. Je n'ai pas crée de middlewares customs pour ce projet, ils font partis des dépendances mais vous en verrez la mention à plusieurs endroits.

#### LiveViews
Les LiveViews sont des templates comme les autres, sauf que leur extension est .leex et qu'ils n'ont pas de module associé dans les views. 

Ils sont situés à côté de leur module LiveView qui agit en sorte de controller "réactif en temps réel".

Tout ce beau monde est situé dans `lib/fakebusters_web/live`.

Le controller de LiveViews est comme un controller normal sauf qu'il attache les assigns à un objet socket dont les changements sont transmis par WebSocket au JS du framework inclu automatiquement dans le front et qui vient éditer le DOM au besoin.

On écrit simplement nos templates mais on sait qu'au moindre changement d'un assign il y aura un allez-retour de paquets entre le client et le serveur. Ce qui induit parfois de la latence. C'est pourquoi on ne fait pas tout en LiveView, on doit parfois ajouter du JS pour tout ce qui est petites intéractions côté client comme les modales, listes déroulantes...

On peut aussi écouter des évènements dans nos LiveViews, par exemple si on s'est abonné à un PubSub, ou si on attend un envoi de formulaire.

Tout comme les templates, les LiveViews peuvent inclure d'autres LiveViews.

#### Router
[FakebustersWeb.Router](lib/fakebusters_web/router.ex) décrit les différentes routes HTTP, WebSockets et LiveViews disponibles, ainsi que les différents middlewares par lesquels ils passent.

### Arbre de supervision
Les applications Elixir sont organisées en modules pour l'aspect sémantique, mais aussi en threads super légers qu'on appelle "BEAM processes" pour l'aspect concurrenciel. 

Ces process sont parallèles et communiquent par messages, souvent un module va permettre de décrire un type de process, mais ce n'est pas toujours le cas.

Les processus sont hiérarchisés entre eux et font partie de ce qu'on appelle un arbre de supervision.

La partie de l'arbre qui nous intéresse est comme suit :

- `Elixir.Fakebusters.Supervisor` correspond à la racine déclarée dans [Fakebusters.Application](lib/fakebusters/application.ex).

- [Elixir.FakebustersWeb.Endpoint](lib/fakebusters_web/endpoint.ex) et ses enfants (organisés je sais pas trop comment) gèrent les requêtes HTTP et WebSockets.

- `Elixir.Fakebusters.CountdownsSupervisor` permet de lancer des [décomptes automatiques](lib/fakebusters/countdown.ex) auxquels les LiveViews peuvent s'abonner pour garder les compteurs de temps côté client à jour.

- `Elixir.Fakebusters.PubSub` et ses enfants permettent de mettre en place un Observer Pattern thread safe entre les processus de [Fakebusters]((lib/fakebusters.ex)) et de [FakebustersWeb](lib/fakebusters_web.ex). Par exemple quand un message de tchat est crée [Fakebusters.Boards](lib/fakebusters/boards.ex) notifie le PubSub qui va notifier les controllers des LiveViews dans `lib/fakebusters_web/live` pour actualiser les changements partout en temps réel.

- `Elixir.Fakebusters.Repo` sert à la persistance des données. C'est ce module (donc ce process) qu'on appelle quand on veut exécuter une requête Ecto. Requête ensuite redirigée à une des 10 connexions à PostgreSQL.

![supervision](docs/process.png)

Le tout est robuste grâce à des politiques de redémarrage en cas de crash par exemple. La devise d'Elixir est "Let it crash" au passage.

*NB : Pour voir cet arbre vous-mêmes faites `iex -S mix` (ou `iex.bat -S mix` sur Windows) puis `:observer.start()`. Rendez-vous ensuite dans `Applications` et `Fakebusters` sur la gauche.*

### Où est le JS ???
Phoenix gère presque tout le JS pour nous (bien heureusement). Mais parfois on en écrit un peu ~~pour le plaisir~~.

Par exemple si l'on souhaite changer la config PostCSS et Tailwind c'est dans `assets`. 

Pour écrire un peu de SASS c'est dans `assets/css/app.scss`.

Pour écrire des [hooks Phoenix](https://hexdocs.pm/phoenix_live_view/js-interop.html) en JS pour réagir côté client de façon plus avancée, c'est dans `assets/js/app.js`.

### Mix et config
Le projet Elixir et ses dépendances sont gérés par Mix. Le fichier principal de Mix est `mix.exs` qui contient un peu de configuration et la liste des dépendances.

La config générale est dans `config/config.exs` et les configs spécifiques aux environnements sont dans le même répertoire.

### Migrations
Ecto (l'ORM d'Elixir) fonctionne avec des migrations que vous trouverez dans `priv/repo/migrations`.

### Tests
Les tests sont dans `test/`. Je dis "les tests" au pluriel, mais en réalité il n'y en a pas. Pas encore du moins 😖 *Tout oubli est une retrouvaille en puissance*.

### Docker
Il y a le fameux `Dockerfile` et l'`entrypoint.sh` dans ce repertoire qui simplifient le déploiement en production.

Sur mon VPS il y a aussi une config `docker-compose` et Nginx que vous pouvez retrouver dans [ce repo](https://github.com/AnicetNgrt/personal-vps-setup).

## 👩‍💻 Commandes utiles
### Reset la base de donnée
`mix ecto.reset`

### Dump et load la base donnée
1. Installer les utilitaires `pg_dump` et `psql`.
2. Dump : `mix ecto.dump -d <output_path>`
3. Load : `mix ecto.load -d <input_path>`

### Formater le code
`mix format`

### Lancer l'analyse statique du code
Pour l'analyse avec [Credo](https://github.com/rrrene/credo) :

- `mix credo` 
- *(veuillez ignorer les 73 erreurs du type `File is using unix line endings while most of the files use windows line`)*

### Tester le code
`mix test`

## 💡 Resources utiles
- [Apprendre Elixir](https://elixirschool.com/fr/)
- [LiveView expliqué pour les néophytes](https://www.youtube.com/watch?v=U_Pe8Ru06fM)
- [Documentation de la librairie standard d'Elixir](https://hexdocs.pm/elixir/Kernel.html)
- [Documentation des templates .eex](https://hexdocs.pm/eex/EEx.html)
- [Documentation de Phoenix](https://hexdocs.pm/phoenix/overview.html)
- [Documentation de Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [Documentation d'Ecto](https://hexdocs.pm/ecto/Ecto.html)
- [Documentation de Plug](https://hexdocs.pm/plug/readme.html)
