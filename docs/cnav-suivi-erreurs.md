# API-SECU : suivre les erreurs remontées

Mode opératoire pour lire, qualifier et faire remonter les erreurs de
la chaîne API-SECU. Le fonctionnel de la chaîne est dans
[`cnav-api-secu.md`](cnav-api-secu.md) ; le code de restitution dans
`siade/app/interactors/cnav/`.

## Pourquoi un mode opératoire

Une réponse d'API-SECU passe par cinq systèmes (guichet, SNGI, RNCPS,
CAF, MSA) et un seul code HTTP en ressort. Un 400 peut venir du
contrôle de saisie du guichet ou d'une caisse ; un 404 de trois
systèmes différents ; un même code fournisseur est parfois envoyé en
nombre, parfois en chaîne, selon l'émetteur. Sans discipline, on lit
« civilité refusée » pendant des mois alors que la cause est une
période trop ancienne ou un sexe absent, et personne ne sait quel
acteur a refusé quoi.

Le suivi repose sur trois sources, chacune avec son rôle. Aucune ne
suffit seule.

## Ce que chaque erreur laisse derrière elle

| Source | Contenu | Rétention | Sert à |
|---|---|---|---|
| Réponse à l'appelant | code DINUM (`561`, `565`, `000`, `404`…), caisse dans `meta.provider`, code et libellé du guichet dans `meta.provider_error_code` / `provider_error_message` | — | l'appelant, le support |
| `access_logs` (Metabase) | statut HTTP, `error_code` / `error_subcode` (notre code), `provider_error_code` (celui du guichet), `recipient`, `token_id`, `annee` / `mois`, `hashed_params` (identité hachée) | 30 jours et plus | volumes, qui appelle, depuis quand, déterminisme par identité |
| Sentry `siade-backend` | une issue par code fournisseur (fingerprint `cnav-bad-request` / code), tags `cnav_error_code`, `regime`, `recipient` ; contexte : corps de la réponse, régime, forme des paramètres, paramètres chiffrés | 14 jours | détection, diagnostic d'un cas |
| Back-office | réponse brute du fournisseur sur une requête (`X-Debug-Provider-Response`, tokens autorisés) | à la demande | reproduire un cas avec un appelant |

Sentry détecte, Metabase compte, la réponse explique. Une question de
volume (« combien de 40013 par jour chez la Direction des sports ? »)
se pose à Metabase, jamais à Sentry : 14 jours, 100 events par page,
pas de recipient sur la v2.

## Lire un event Sentry

Le niveau dit qui possède le problème, pas sa gravité technique :

| Niveau | Codes | Signification | Action |
|---|---|---|---|
| `error` | code absent de la table CNAV, corps illisible, code que nos validateurs rendent impossible (40002 nom absent, 40026 année, 40029 période désormais bornée en amont…) | quelque chose a changé, chez eux ou chez nous | qualifier le jour même |
| `warning` | 40000, 40024, les 500 | défaillance derrière le guichet, à la CAF ou à la MSA | surveiller le volume ; prévenir la CNAV en cas de rafale |
| `info` | contrôles de saisie du guichet : 40003 nom, 40013 commune, 40014 sexe, 40019 département, 40011, 40015, 40016, 40031 | l'appelant peut corriger | ne pas surveiller à la main ; un recipient qui explose se voit dans Metabase |

Ensuite, trois questions dans l'ordre :

1. **Le tag `regime` est-il présent ?** Absent : l'appel a été bloqué
   avant d'atteindre une caisse, au contrôle de saisie ou au SNGI.
   Présent : c'est la caisse nommée (CNAF, MSA, RNCPS) qui a répondu,
   et le problème est dans son dossier, pas dans l'identité.
2. **Que dit la table d'erreurs CNAV pour ce code ?** Sa colonne
   « composant » nomme l'émetteur : contrôle d'entrée, SNGI, RNCPS,
   API FAMILLE. Un libellé accentué vient du guichet, un libellé en
   majuscules sans accent vient d'une caisse. Un code absent de la
   table (40000) est un code par défaut du guichet : le message est
   celui de la caisse.
3. **Est-ce déterministe ?** Dans `access_logs`, la même
   `hashed_params` a-t-elle déjà obtenu un 200, sur cet endpoint ou un
   autre ? Jamais de 200 en 30 jours sur des dizaines d'identités :
   ce n'est pas transitoire, et « réessayez plus tard » est un
   mensonge pour l'appelant.

Pour un 40003 ou un 40013, le contexte `params_shape` donne la
longueur et les classes de caractères de chaque nom (apostrophe,
tiret, chiffre, espace en bord, caractère perdu à la translittération)
et le préfixe de chaque code INSEE, sans exposer l'identité. Le
pattern refusé se lit sur une semaine d'events sans déchiffrer un seul
paramètre.

## Requêtes de référence

Volumes par code, appelant et jour :

```sql
select date_trunc('day', timestamp) as jour,
       params->>'provider_error_code' as code,
       params->>'recipient' as recipient,
       count(*)
from access_logs
where controller like 'api_particulier/%cnav/%'
  and params->>'provider_error_code' is not null
  and timestamp > now() - interval '30 days'
group by 1, 2, 3
order by 1, 4 desc;
```

Historique d'une identité :

```sql
select status, params->>'error_code', params->>'annee', params->>'mois',
       controller, count(*), min(timestamp), max(timestamp)
from access_logs
where params->>'hashed_params' = '<hash>'
  and timestamp > now() - interval '30 days'
group by 1, 2, 3, 4, 5;
```

Sentry, depuis le dépôt (`bin/sentry/README.md`) :

```bash
bin/sentry/issues -q 'is:unresolved "Bad request" level:error'
bin/sentry/issues -q 'cnav_error_code:40000 regime:MSA' -p 24h
bin/sentry/export <issue> --full          # corps des réponses en CSV
```

## Escalader à la CNAV

La CNAV retrouve un appel par son `X-Correlation-ID`, qui est notre
`request_id` : tag `request_id` de l'event Sentry. `access_logs` ne le
porte pas ; un event se rapproche d'une ligne d'`access_logs` par
horodatage à quelques secondes près, contrôleur et recipient. Un
signalement utile contient, pour chaque cas :

- l'horodatage et le `X-Correlation-ID` ;
- le code et le libellé renvoyés par le guichet ;
- le régime lu dans `X-APISECU-FD`, ou son absence ;
- l'endpoint et la modalité d'appel (identité ou FranceConnect).

Jamais d'identité en clair : la CNAV la retrouve par le corrélation
ID. Trois ou quatre cas espacés dans le temps valent mieux qu'une
liste de cinq cents. Les décisions prises en réunion sont reportées
dans [`cnav-api-secu.md`](cnav-api-secu.md), section par section, avec
la date du point.

## Quand un code nouveau apparaît

Une issue Sentry `[CNAF & MSA] Bad request (<code>)` en `error` que
personne ne connaît :

1. Chercher le code dans la table d'erreurs CNAV et lire sa colonne
   « composant ».
2. Décider de la restitution à l'appelant : `561` si c'est un contrôle
   de saisie, `565` si c'est une période, `000` si c'est une caisse
   qui défaille, `404` avec la caisse si c'est un dossier absent. En
   cas de doute, laisser le `561` et poser la question à la CNAV avec
   des corrélation ID.
3. Décider du niveau Sentry selon le tableau ci-dessus, et l'inscrire
   dans les constantes de `CNAV::ValidateResponse` (contrôles de
   saisie) ou de sa déclinaison quotient familial (codes caisse).
4. Si la restitution change : fiche endpoint dans `commons/endpoints/`,
   changelog, OpenAPI régénéré, exemple rswag.
5. Résoudre l'issue Sentry une fois le code déployé ; la suivante sur
   ce code repartira de zéro avec le bon niveau.

## Ce qui reste ouvert

- **40000** : déterministe par identité, hypothèse d'un routage vers
  une caisse sans dossier. Ticket ouvert côté MSA ; le tag `regime`
  dira, après une semaine, si c'est toujours la même caisse. Si oui,
  la restitution devrait devenir le `404` « dossier absent » de cette
  caisse plutôt que l'erreur interne.
- **40003 et 40013** : le pattern refusé se lira dans `params_shape`.
  Une fois connu, soit un contrôle en amont, soit une correction
  silencieuse, soit une documentation du format attendu.
- **40019** : codes de département `00`, tous en transcodage ; à
  regarder dans `ExtractCodeCommuneFromTranscogage`.
