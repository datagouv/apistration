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

Pour le jeton du back-office du site, la réponse brute du fournisseur peut
être renvoyée dans la payload plutôt que d'être seulement écrite dans les logs.
C'est voulu : les admins du back-office voient les données brutes du
fournisseur, au-delà des scopes du jeton.

Trois conditions cumulatives (`ProviderResponseDebuggingService`) :

* le jeton est celui d'une habilitation du back-office (`JwtUser#back_office?`) :
    l'`external_id` de son habilitation figure dans
    `commons/data/back_office_authorization_requests.yml`, la même liste que
    celle où le site (`AdminAPIToken`) cherche son jeton ;
* ce jeton est restreint par IP (`JwtUser#ip_restricted?`) : retirer la liste
    d'IP de l'habilitation coupe l'exposition ;
* l'appel porte le header `X-Debug-Provider-Response`.

Aucun autre jeton (jeton interne, jeton éditeur, autre habilitation, quels que
soient ses scopes) n'obtient la réponse brute. Le contrat est couvert par
`spec/requests/provider_response_exposure_spec.rb`. Côté site, chaque
affichage de la réponse brute émet le security event
`admin.provider_response.revealed`, avec l'admin comme acteur.

La payload est alors enrichie d'un `meta.provider_response` contenant le
`status`, les `headers` et le `body` de la réponse du fournisseur, que l'appel
soit en succès ou en erreur. Le body est renvoyé tel quel : tous les
fournisseurs ne répondent pas du JSON, et c'est au consommateur de tenter un
formatage.

Deux cas ne peuvent pas être renvoyés tels quels :

* les réponses binaires (attestations PDF), qu'elles arrivent brutes ou
    encodées en base64 par le fournisseur — le `Content-Type` ne permet pas de
    les reconnaître, certains annoncent `application/json` en renvoyant un PDF.
    Elles sont détectées par la présence d'un octet nul et remplacées par
    `[contenu binaire, N octets]` ;
* les réponses de plus de 64 Ko, tronquées en indiquant la taille d'origine.

Le reste est nettoyé de ses octets invalides en UTF-8, sans quoi la payload ne
pourrait pas être sérialisée en JSON.

Ce header n'est pas documenté publiquement : sans le jeton du back-office il
n'a aucun effet.
