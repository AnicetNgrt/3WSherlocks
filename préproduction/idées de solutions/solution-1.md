# Idée de solution n°1
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