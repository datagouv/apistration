# Debug de requêtes

Il est possible de sauvegarder dans un fichier de log temporaire
`log/requests_debugger.log` les appels HTTP en 200 et 404 afin d'effectuer des
investigation sur des bugs.

Le fichier de configuration se trouve dans [config/requests_debugging.yml](config/requests_debugging.yml)
et permet:

* D'activer / désactiver le monitoring à l'aide d'une date `enabled_until` ;
* De lister les opérations monitorées (pour une liste exhaustive, cherchez
    `x-operationId` dans les fichiers swaggers)

Il y a de même un filtrage sur les status, qui exclut principalement les erreurs
clients (401, 403, 422)

## Réponse fournisseur dans la payload

Pour les jetons que nous détenons (le back-office du site notamment), la
réponse brute du fournisseur peut être renvoyée dans la payload plutôt que
d'être seulement écrite dans les logs.

Deux conditions cumulatives :

* le jeton (`jti`) est listé dans le credential
    `debug_provider_response_token_ids` ;
* l'appel porte le header `X-Debug-Provider-Response`.

La payload est alors enrichie d'un `meta.provider_response` contenant le
`status`, les `headers` et le `body_base64` de la réponse du fournisseur, que
l'appel soit en succès ou en erreur. Le body est encodé en base64 car certains
fournisseurs renvoient des binaires (PDF).

Ce header n'est pas documenté publiquement : il est réservé à nos propres
jetons, et sans entrée dans le credential il n'a aucun effet.

Le credential attend une liste d'ids de jetons (colonne `tokens.id`) : en
production et staging via `very_ansible`, en développement via
`config/credentials.yml` (non versionné).
