# 3W Sherlocks

*Note au lecteur : l'ancien nom de code du projet était "fakebusters", c'est pourquoi vous trouverez cette appellation à plusieurs endroits pour désigner les espaces de noms du projet.*

# Installation 🔧

## Envionnement Dev

1. Mettez en place une base de donnée PostgreSQL avec identifiant `postgres` et mot de passe `postgres` sur `localhost:5432`
   - Avec docker 🐳 : `docker run --name postgres-fakebusters -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 postgres:alpine` 
   - [Sans docker](https://www.postgresql.org/download/)
2. Installez Elixir [Windows](https://elixir-lang.org/install.html#windows) | [Linux](https://elixir-lang.org/install.html#gnulinux) | [Mac](https://elixir-lang.org/install.html#macos)
3. Installez [NPM](https://www.npmjs.com/)
4. Faites `mix setup`
5. Faites `cd assets`, `npm install` puis `cd ..`
6. Lancez le serveur `mix phx.server`
7. [Amusez-vous bien :)](http://localhost:4000)

# Commandes utiles 👩‍💻

## Reset la base de donnée
`mix ecto.reset`

## Dump et load la base donnée
1. Installer les utilitaires `pg_dump` et `psql`.
2. Dump : `mix ecto.dump -d <output_path>`
3. Load : `mix ecto.load -d <input_path>`

## Formater le code
`mix format`

## Lancer l'analyse statique du code

Pour l'analyse avec [Credo](https://github.com/rrrene/credo) :

- `mix credo` 
- *(veuillez ignorer les 73 erreurs du type `File is using unix line endings while most of the files use windows line`)*

## Tester le code
`mix test`

# Resources utiles

- [Apprendre Elixir](https://elixirschool.com/fr/)
- [LiveView expliqué pour les néophytes](https://www.youtube.com/watch?v=U_Pe8Ru06fM)
- [Documentation de la librairie standard d'Elixir](https://hexdocs.pm/elixir/Kernel.html)
- [Documentation des templates .eex](https://hexdocs.pm/eex/EEx.html)
- [Documentation de Phoenix](https://hexdocs.pm/phoenix/overview.html)
- [Documentation de Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [Documentation d'Ecto](https://hexdocs.pm/ecto/Ecto.html)
- [Documentation de Plug](https://hexdocs.pm/plug/readme.html)