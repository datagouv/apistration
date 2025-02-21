# Gestion des scopes

## Intégration nouveaux scopes

Lors de la création d'une nouvelle ressource, il faut souvent créer
un (voir plusieurs pour API Particulier) nouveau(x) scopes.

L'ensemble des scopes doivent être regroupés dans le fichier
[`config/authorizations.yml`](./config/authorizations.yml).

Le format est le suivant:

```yaml
endpoint_path_without_controller:
  - scope1
  - scope2
```

Pour API Particulier, les scopes sont également utilisés dans le
serializer pour granuler la distribution de la donnée.

### FranceConnect

Les scopes doivent être transmis à FranceConnect dans le cas d'APIs
FranceConnectées.

### Datapass

Les nouveaux scopes doivent être implémentés dans Datapass pour
pouvoir être demandés par les futurs utilisateurs.
