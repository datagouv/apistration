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

Un token en cache est réutilisé jusqu'à son expiration, avec une marge de
10 secondes. S'il est refusé par Sirene (HTTP 401), l'application invalide ce
token et rejoue l'appel une fois après réauthentification. Un token plus récent,
publié entre-temps par une autre requête, est conservé et réutilisé.

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
L'application mémorise alors l'échec pendant **30 minutes**, pour éviter de
multiplier les tentatives contre un compte potentiellement verrouillé. Ce
garde-fou bloque les nouvelles authentifications ; un token encore en cache
reste utilisable.

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

Ces commandes ne renouvellent pas le mot de passe. `rake cache:clear` ne lève pas
le garde-fou : sa clé est hors du namespace de cache habituel de l'application.

## Détails des caches

Les applications ont des Redis distincts : elles ne partagent ni token,
ni verrou, ni garde-fou. Chaque application peut donc faire ses propres
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
tentative. À la libération, elle vérifie que le verrou lui appartient encore.

Rails mémorise aussi les lectures de cache pendant une requête HTTP, y compris
les absences. `outside_the_request_cache` ouvre un `with_local_cache` imbriqué
pour que les lectures du token, du verrou et du garde-fou atteignent Redis et
voient les changements des autres processus.

Les tests de ce comportement sont dans `siade/`, avec Redis et un cache local
explicitement ouvert. Le `memory_store` des tests de `site/` ne reproduit pas
cette couche de cache locale.
