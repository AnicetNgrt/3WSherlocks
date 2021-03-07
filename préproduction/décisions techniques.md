# Bourse Coddity 2021 : Décisions techniques

*auteur : Anicet Nougaret*

Après avoir finalement retenu l'idée de faire un site web de proposition et de vote d'hypothèses ([plus de détails ici](idées%20de%20solutions/solution-2.md)) j'ai réfléchi quelques jours à la solution technique.

Pour mettre en oeuvre cette idée, j'aura besoin de plusieurs choses :

- Backend
  - Serveur web
  - Authentication
    - Rôles d'utilisateurs (Admins, Modos, Votants)
    - (petit +) Vérification d'email pour éviter le spam
  - Persistence dans une base de données
    - Relations entre les données faciles (Hypothèses et votes)
    - (petit +) ORM
- Frontend
  - Pages web dynamiques
  - Formulaires
  - Composants réutilisables
  - (petit +) Vue des votes en temps réel avec un socket

Bref, afin de faire tout ça en deux mois, je vais avoir besoin d'un bon framework. J'ai un large panel d'outils avec lesquels j'ai déjà travaillé et qui permettent d'implémenter tout ça : Symfony (PHP), Flask (Python), Express (Node.js), JavaEE avec Tomcat, Actix (Rust) Phoenix (Elixir).

Mais bon, en ce moment je suis en plein apprentissage d'Elixir et de Phoenix. Surtout que Phoenix est très adapté car il permet de faire tout ce que je veux.

L'authentication, l'authorization et les rôles avec Pow prend 10 minutes à être implémentée, l'envoi d'email de confirmation peut aussi être implémenté avec Pow et Bamboo.

Tout le frontend sera implémenté en server-side rendering grâce aux templates EEx (j'aurai préféré React, mais restons simples pour commencer), et le rafraîchissement des votes sur le frontend sera sans prises de tête grâce à Phoenix LiveView. 

Les performances du serveur seront surement suffisantes pour gérer plus d'utilisateurs que je n'en aurai jamais. Je sais que ne devrai pas me soucier de ça si tôt, mais profitons qu'Elixir soit basé sur la VM BEAM, donc autant dire que c'est le nec + ultra de la programmation concurrente.

On aura même Ecto, l'ORM de Phoenix, qu'on pourra connecter à une de mes instances de PostgreSQL dockerisées qui tournent actuellement sur mon VPS Ubuntu.

En parlant de VPS, j'ai déjà essayé de déployer un serveur Phoenix sur ce dernier à l'aide de SystemD avec un reverse-proxy Nginx (ce qui est toujours stylé). On pourra toujours mettre de la CI avancée plus tard, mais en attendant je "git pullerai" et je "servicectl restarterai" naïvement.

