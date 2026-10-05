# Rotation du mot de passe INSEE

`site/` et `siade/` utilisent le même compte INSEE. Les deux applications
calculent son mot de passe ; seul le job quotidien de `site/` le renouvelle
auprès de l'INSEE.

## Fonctionnement

### Un mot de passe par bimestre

La dérivation commence le **1er novembre 2026** (`DERIVATION_START = '2026-11'`).
Avant cette date, les applications utilisent le mot de passe statique des
credentials.

À partir de cette date, `INSEE::PasswordDerivation` calcule le mot de passe à
partir d'une clé secrète commune et du bimestre : `2026-11` pour novembre et
décembre 2026, `2027-01` pour janvier et février 2027, etc. Le calcul utilise
HMAC-SHA256, puis un encodage sur 16 caractères garantissant majuscule,
minuscule, chiffre et caractère spécial.

Les credentials portent des noms différents, mais leurs valeurs doivent
correspondre dans les deux applications :

| Valeur | `site/` | `siade/` |
| --- | --- | --- |
| Mot de passe statique | `insee_password` | `insee_apim_password` |
| Clé de dérivation | `insee_password_derivation_key` | `insee_apim_password_derivation_key` |
| Mot de passe de secours, facultatif | `insee_password_bypass` | `insee_apim_password_bypass` |

### Authentification

L'OAuth de l'INSEE est un realm Keycloak. Chaque échange émet un nouveau token,
valable 5 minutes (`expires_in: 300`), sans refresh token : chaque
renouvellement repasse par le grant `password` et consomme donc une tentative
sur le compte.

Un token en cache est réutilisé jusqu'à son expiration, avec une marge de
10 secondes. S'il est refusé par Sirene (HTTP 401), l'application invalide ce
token et rejoue l'appel une fois après réauthentification. Un token plus récent,
publié entre-temps par une autre requête, est conservé et réutilisé.

`siade/` renouvelle le token avant son expiration : à partir de 90 secondes
avant la fin de sa vie, la requête qui obtient le verrou s'authentifie, les
autres continuent avec le token courant. Le token courant reste publié tant que
le nouveau n'est pas obtenu ; si le renouvellement échoue, la requête utilise le
token courant sans erreur. Chaque tentative repousse la suivante de 30 secondes,
quelle que soit la cause de l'échec, pour qu'un OAuth indisponible ne reçoive pas
un appel par requête. Une tentative peut enchaîner jusqu'à trois échanges OAuth
(courant, précédent, puis courant à nouveau), de 20 secondes au plus chacun :
aucune tentative ne démarre si tous ses échanges ne peuvent aboutir avant
l'expiration du token en cache. Pour un token de 5 minutes, les tentatives ont
lieu à 3 min 30 et 4 min avant la dérivation, à 3 min 30 seulement ensuite. Un
token qui vit moins de 90 secondes est gardé jusqu'à son expiration. Un refus isolé de l'INSEE ne
coupe ainsi rien, tant qu'une tentative suivante aboutit avant l'expiration.

Une requête qui trouve le token expiré, ou refusé par Sirene, pendant qu'un
renouvellement est en cours attend 0,5 seconde le token publié, puis renvoie une
erreur temporaire : la fenêtre ci-dessus rend ce cas rare sans l'exclure.

Pour obtenir un token, les mots de passe sont essayés dans cet ordre :

| Situation | Ordre des tentatives |
| --- | --- |
| Avant le début de la dérivation | Statique, une seule fois |
| Dérivation active | Courant, précédent, puis courant une dernière fois |
| Bypass configuré | Bypass, puis courant |

Les tentatives s'arrêtent dès qu'un mot de passe est accepté. Seul un
`invalid_grant` sur HTTP 400 ou 401 permet de passer au suivant. Deux candidats
identiques ne sont pas essayés à la suite. Le « courant » reste le mot de passe
statique avant le début de la dérivation.

Le dernier essai du mot de passe courant couvre une rotation survenue pendant
l'authentification : le courant a pu être refusé avant le renouvellement, puis
le précédent refusé après. Avec le bypass, le courant est déjà essayé en dernier.

**Exemple au 1er janvier 2027 :** tant que le job n'a pas tourné, le mot de passe
de novembre reste accepté. Après renouvellement, celui de janvier fonctionne.
Ce repli couvre un retard de rotation tant que l'INSEE accepte encore le mot de
passe précédent ; il ne garantit pas l'accès après plusieurs bimestres sans
rotation.

### Rotation quotidienne

`INSEEPasswordRotationJob` tourne à **00h05, heure de Paris**, en production,
sur la machine frontale (`FRONTAL=true`). GoodJob empêche deux exécutions
simultanées du job.

Le job ne fait rien avant le début de la dérivation, si un bypass est configuré
ou si le garde-fou d'échec est actif. Sinon, `INSEE::PasswordRotation#rotate!`
vérifie les mots de passe directement auprès de l'INSEE, sans utiliser le token
en cache :

| Vérification | Action et résultat |
| --- | --- |
| Le courant est accepté | Aucun renouvellement : `:already_current` |
| Le courant est refusé, le précédent accepté | Renouvellement vers le courant : `:renewed` |
| Les deux sont refusés par `invalid_grant` | Alerte et garde-fou côté `site/` : `:desynchronized` |
| OAuth est indisponible ou le renouvellement échoue | `UnavailableError`, avertissement du job |
| OAuth refuse l'échange lui-même | Alerte et garde-fou côté `site/`, puis `UnavailableError` |

Le job réessaie le lendemain. Une rotation réussie produit une notification
`INSEE password rotated`.

### Échecs et garde-fou

Un timeout, un HTTP 408, 429 ou 5xx interrompt l'authentification avec une erreur
temporaire. Aucun autre candidat n'est essayé et aucun échec n'est mémorisé :
ces réponses ne prouvent pas que le mot de passe est incorrect.

Un autre refus HTTP 4xx arrête immédiatement les tentatives et déclenche une
alerte. L'épuisement des candidats sur `invalid_grant` a le même effet.
L'application suspend alors les nouvelles authentifications ; un token encore en
cache reste utilisable.

`site/` suspend pendant **30 minutes**. `siade/` suspend selon un backoff
exponentiel, pour qu'un refus isolé de l'INSEE ne coupe pas Sirene une demi-heure
alors que le token ne vit que 5 minutes :

| Échec d'authentification | Suspension côté `siade/` |
| --- | --- |
| 1er refus consécutif | 30 secondes |
| 2e | 1 minute |
| 3e | 2 minutes |
| 4e | 4 minutes |
| 5e et suivants | 5 minutes |
| Refus de l'échange OAuth lui-même (`invalid_client`…) | 30 minutes |

Le compteur de refus repart de zéro au premier token obtenu, et expire après une
heure sans nouveau refus. Sa mise à jour n'est pas atomique : pendant le
recouvrement de deux démarrages d'un déploiement, qui partagent ce compteur, un
refus peut se perdre, une alerte être doublée ou manquer, ou une suspension être
raccourcie.

Keycloak verrouille le compte après **5 refus consécutifs**, tous clients
confondus, et seul un succès remet son compteur à zéro : espacer les tentatives
ne l'épargne pas. Jusqu'à six instances `siade/` (trois serveurs, sandbox et
production) et `site/` partagent ce budget sans partager de Redis ; en pratique
deux instances s'authentifient. Un épisode long de refus en HTTP 401 peut donc
atteindre le seuil.

Côté `siade/`, les alertes suivent les épisodes plutôt que chaque échec : une
erreur au premier refus, rien pendant le backoff, puis un avertissement
`INSEE authentication recovered` au premier token obtenu, avec le nombre de
refus (`refusals`) et la durée de l'épisode (`outage_seconds`). Un refus de
l'échange OAuth lui-même alerte à chaque tentative. Avec un seul
candidat (avant la dérivation), l'alerte s'intitule `INSEE refused the only
password candidate` : une désynchronisation est alors impossible à détecter.

L'alerte porte le code HTTP, `error` et `error_description` du refus. Sentry
masque `error_description` (« Invalid user credentials » contient un mot qu'il
filtre), d'où `refusal_reason`, qui le traduit en mots qu'il laisse passer :

| `error_description` de Keycloak | `refusal_reason` |
| --- | --- |
| Account temporarily disabled | `account_temporarily_disabled` |
| Account disabled | `account_disabled` |
| Account is not fully set up | `account_not_fully_set_up` |
| Invalid user credentials | `refused_login` |
| Autre | `unknown` |

Le code HTTP compte autant que la description. Dans Keycloak 26, le grant
`password` répond :

| Situation | Réponse |
| --- | --- |
| Mot de passe faux | 401, Invalid user credentials |
| Compte verrouillé par la détection de brute force | 401, Invalid user credentials |
| Compte désactivé | 400, Account disabled |
| Mot de passe accepté, action requise en attente | 400, Account is not fully set up |

Un verrouillage par brute force est donc indiscernable d'un mot de passe faux,
et aucune description ne permet de le détecter : `siade/` n'a pas de suspension
dédiée et applique le backoff à tous les `invalid_grant`. Un refus en 400, comme
ceux de septembre et octobre 2026, ne vient ni d'un mot de passe faux ni de la
détection de brute force, et ne consomme donc pas le budget de cinq refus si
l'INSEE utilise une version proche ; « Account temporarily disabled » est le
libellé de versions plus anciennes.

## Exploitation

### Sortir du bypass

Le bypass sert lorsque le mot de passe détenu par l'INSEE ne correspond plus
aux candidats calculés. Sa présence suspend la rotation automatique. Sa valeur
ne doit pas être vide : une clé présente mais vide déclenche
`MissingBypassPasswordError`.

Pour revenir à la dérivation :

1. Vérifier que les deux applications sont déployées avec la même clé de
   dérivation et le même bypass.
2. Depuis une console Rails de **`site/` sur la frontale de production**, lancer :

   ```ruby
   INSEE::PasswordRotation.new.exit_bypass!
   ```

3. Si le résultat est `:renewed` **ou** `:already_current`, supprimer la clé de
   bypass des credentials des **deux** applications, puis déployer.
4. Si un garde-fou avait été activé, le lever dans chaque application avec les
   commandes ci-dessous.

L'opération vérifie d'abord le mot de passe courant, puis utilise le bypass
pour renouveler si nécessaire. Elle refuse de tourner sans bypass
(`BypassNotInUseError`) ou avant le 1er novembre 2026
(`DerivationNotStartedError`).

En cas de `:desynchronized`, corriger le problème avant de relancer. En cas de
`UnavailableError`, vérifier le message d'erreur avant de réessayer. Un timeout
peut avoir masqué un renouvellement réussi : l'appel suivant renverra alors
`:already_current`, sans renouveler une seconde fois.

Tant que le bypass est présent après un renouvellement réussi, toute nouvelle
authentification essaie ce mot de passe devenu invalide avant le courant.

### Lever le garde-fou après correction

Le garde-fou survit aux déploiements. Une fois les credentials corrigés ou le
compte déverrouillé, exécuter dans la console Rails de chaque application :

Pour `site/` :

```ruby
INSEEAPIAuthentication.clear_guards!
```

Pour `siade/` :

```ruby
INSEE::Authenticate.clear_guards!
```

Côté `siade/`, la commande remet aussi à zéro le compteur du backoff.

Ces commandes ne renouvellent pas le mot de passe. `rake cache:clear` ne lève pas
le garde-fou : sa clé est hors du namespace de cache habituel de l'application.

## Détails des caches

Les applications ont des Redis distincts : elles ne partagent ni token,
ni verrou, ni garde-fou. Chaque serveur a aussi son propre Redis local : les
trois serveurs `siade/` d'un environnement s'authentifient chacun de leur côté. Chaque application peut donc faire ses propres
tentatives sur le compte commun. Le garde-fou de `site/`, y compris celui posé
par le job, ne bloque pas `siade/`.

| Application | Namespace du token et du verrou | Namespace du garde-fou |
| --- | --- | --- |
| `site/` | `insee`, stable entre déploiements | `insee` |
| `siade/` | Namespace applicatif, contenant le timestamp de démarrage | `insee` |

L'option `namespace:` remplace le namespace du store. Le garde-fou reste donc
accessible après un redémarrage. Le verrou, lui, doit avoir la même portée que
le token pour que les requêtes qui attendent puissent lire le résultat publié.
Il expire après 30 secondes côté `site/`, 90 secondes côté `siade/`.

Sous verrou, l'authentification relit le token et le garde-fou avant toute
tentative. Une requête concurrente attend 0,5 seconde, puis utilise le token
publié. S'il n'est pas encore disponible, elle renvoie une erreur temporaire
sans lancer son propre échange OAuth.

La suppression du verrou et l'invalidation d'un token refusé sont
conditionnelles et atomiques dans Redis. `ConditionalCacheDelete` lit la valeur
sérialisée, vérifie le propriétaire ou le token, puis un script Lua ne supprime
la clé que si sa valeur n'a pas changé. Un remplacement entre la comparaison
et la suppression est ainsi conservé, y compris pour le token chiffré de
`siade/`.

Rails mémorise aussi les lectures de cache pendant une requête HTTP, y compris
les absences. `outside_the_request_cache` ouvre un `with_local_cache` imbriqué
pour que les lectures du token et du garde-fou atteignent Redis et voient les
changements des autres processus. Les suppressions conditionnelles accèdent
directement à Redis.

Les tests de ce comportement sont dans `siade/`, avec Redis et un cache local
explicitement ouvert. Le `memory_store` des tests de `site/` ne reproduit pas
cette couche de cache locale ; le script local utilise un vrai Redis pour les
deux applications.

Cette coordination vaut pour un même namespace de token, tant que Redis est
disponible et que le verrou n'a pas expiré. Deux démarrages de `siade/` avec
des namespaces différents ont chacun leur verrou. En cas de panne Redis,
chaque requête peut s'authentifier directement : ni le verrou ni le garde-fou
ne peuvent alors limiter les tentatives. Il n'existe donc pas de plafond
global d'essais sur le compte INSEE commun aux deux applications.

## Vérification locale isolée

Les scripts et leur mode d’emploi sont regroupés dans
[`local-e2e/insee/`](../local-e2e/insee/README.md).
