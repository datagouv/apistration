# Gestion des scopes

## Intégration nouveaux scopes

Lors de la création d'une nouvelle ressource, il faut souvent créer
un (voir plusieurs pour API Particulier) nouveau(x) scopes.

L'ensemble des scopes doivent être regroupés dans le fichier
[`commons/data/authorizations.yml`](../../commons/data/authorizations.yml)
(à la racine du dépôt, partagé avec mocks).

Le format est le suivant:

```yaml
endpoint_path_without_controller:
  - scope1
  - scope2
```

Pour API Particulier, les scopes sont également utilisés dans le
serializer pour granuler la distribution de la donnée : toute clé racine
est derrière un scope, et une nouvelle clé derrière un nouveau scope
impose une nouvelle version de l'endpoint (règles 1 et 2 de
[`regles_de_conception.md`](regles_de_conception.md)).

### FranceConnect

Les scopes doivent être transmis à FranceConnect dans le cas d'APIs
FranceConnectées.

### Datapass

Les nouveaux scopes doivent être implémentés dans Datapass pour
pouvoir être demandés par les futurs utilisateurs.
