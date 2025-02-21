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
