# Idées de solutions
## Sommaire
1. [~~Une institution qui catalogue les hypothèses~~](#idée-n1)
2. [Voter et soumettre des hypothèses en mettant en valeur les sources](#idée-n2)
---
# ~~Idée n°1~~
Institution en ligne de référencement des hypothèses, mettant à disposition du public une API participative des hypothèses connues, de leur contexte, de leurs preuves, de leurs infirmations et de leurs soutiens.

## Philosophie
La philosophie de l'institution visera à maximiser la confiance avec le public.

Le but ne sera pas de juger si une hypothèse est vraie ou fausse, mais bien de collecter et de mettre à disposition le plus d'informations et d'avis possibles.

Afin de pallier aux limitations humaines d'impartialité lors des ajouts/suppression d'informations par l'institution elle-même, les canaux de communication entre l'institution et le public devront être disponibles à tout moment.

Les processus d'ajout d'information de façon démocratique devront toujours être envisagés 
et ammenés au fur et à mesure avec beaucoup de soin pour éviter les vulnérabilités.

## Fonctionnalités
Classées par ordre de priorité

1. Mise à disposition d'informations sur l'institution et sa démarche
2. Ajout d'hypothèses et de leurs informations par l'institution
3. Recherche et découverte d'hypothèses par le public
4. Mise à jour des informations sur des hypothèses par l'institution
5. Ajout automatique d'hypothèses sur pétition (seuil de votes puis étude et modération)
6. Ajout et suppression de documents scientifiques relatifs à une hypothèse par l'institution
7. Mise à disposition d'un canal de communication temps réel pour certaines données de l'API
8. Participation libre au débat autours d'une hypothèse sous forme de commentaires
9. Tri des commentaires par les votes du public
10. Ajout et suppression de soutiens/contestations venant d'entités publiques

## Détail des fonctionnalités
### 1. Mise à disposition d'informations sur l'institution et sa démarche
- HTML
  - main page
  - white paper
  - about/contact
- API
  - InstitutionMember
    - full name
    - bio
    - joining date
    - leaving date
  - InstitutionDecision
    - prompt
    - issuer
    - issue date
    - closing date
    - approvals count
    - rejections count
  - InstitutionAction
    - details
    - related vote
    - date
- Internal systems
  - Admin API
    - Login as admin
    - Add member
    - Register decision
    - Cast votes on decision
    - Register action on behalf of approved/rejected decision

### 2. Ajout d'hypothèses et de leurs informations par l'institution

---
# Idée n°2
Un site web : hypothesis.io, où l'on peut soumettre des hypothèses, voter pour ou contre en citant sa source principale, et accéder à des informations utiles aux chercheurs et aux journalistes, telles que les sources les plus citées par les deux partis, les graphiques des votes en fonction du temps et la recherche d'hypothèses par thème et par centre de gravité des votes.

## Mockup
Cette idée m'est apparue de façon très visuelle, donc j'ai commencé par faire une maquette rapide :

![mockup0](./resources/hypothesesio-mockup0.PNG)
*maquette initiale*

![mockup1](./resources/hypothesesio-mockup1.PNG)
*maquette revisitée*

## Philosophie
Le but est de proposer des données riches sur les débats existant et ayant existé autours d'hypothèses et de faits controversés.

L'approche serait de ne modérer aucun sujet et de ne stigmatiser/prioriser aucun avis afin d'attirer le plus de données que possible.

En effet, le problème avec la lutte contre les fake news réside parfois selon moi dans la censure et la stigmatisation de ceux qui croient aux théories farfelues et aux fake news.

La stigmatisation rend le débat plus virulent et moins lisible, alors que la censure tait le débat et limite donc l'information disponible aux chercheurs, sans parler de la possibilité de censurer à tort.

Je pense que si l'on veut apprendre à combattre les fake news, il faut d'abord comprendre les sources et les discours qui les influencent.

Pour cela, je propose de laisser chacun défendre ses opinions de façon équitable et sans préjugés sur la plateforme à l'aide de sources interposées que chacun essaiera de mettre en valeur.

Afin d'éviter que la qualité du débat ne se dégrade en laissant trop les utilisateurs s'exprimer, on se limitera au vote et à l'ajout de sources tierces faisant preuves d'arguments, ainsi les chercheurs et journalistes pourront s'épargner un surplus d'avis d'internautes en accédant immédiatement aux sources les plus populaires, et donc probablement les plus importantes à mettre en valeur ou à débunker.

De part sa neutralité, les leviers d'action que le site mettra en place contre les fake news pourront alors paraître aussi puissants que ceux mis en place, malgré lui, contre les information vérifiées.

Heureusement, la plateforme aidera peut-être ceux qui croient aux fake news à s'intéresser aux avis contraires, notamment grâce à une mise en valeur équitable des sources citées par les deux partis. 

En effet, convaincu que les fausses croyances naissent plutôt d'une absence de sources fiables que d'une surreprésentation de sources mythomanes, ma conjecture est qu'il soit plus facile pour l'utilisateur de changer d'avis lorsque ses propres sources sont placées à côté de sources contradictoires plus sérieuses, que l'inverse.

Que cela soit vrai ou faux, je pense que cette approche pourra au moins être une expérience pertinente dans la recherche sur la lutte contre les fake news.

## Fonctionnalités
1. Soumission d'hypothèses (phrases affirmatives) par pétition
   - Les hypothèses dépassant un certain nombre de signatures seront ajoutées
   - Les signatures ne seront jamais perdues avec le temps, mais pourront être retirées par leur émetteurs
   - La soumission sera anonyme, mais requierera un compte sur la plateforme
2. Recherche et découverte d'hypothèses (version basique)
   - Chaque hypothèse se verra attribuer des tags par leur emetteur parmi une gamme existante
   - L'administration pourra changer les tags d'une hypothèse
   - Si un tag souhaité est indisponible, il pourra être ajouté, mais ne sera visible qu'une fois approuvé par l'administration
   - Les pétitions et les hypothèses approuvées pourront être parcourues dans deux pages distinctes avec des filtrages par tags
3. Ajout d'opinion sur une hypothèse (vrai, faux) avec source obligatoire
   - Seuls les utilisateurs login pourront donner leur opinion