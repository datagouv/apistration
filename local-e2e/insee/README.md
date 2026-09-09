# Vérification locale INSEE

Depuis la racine du worktree, avec le Ruby du projet, ses gems de test installées
et `redis-server` disponible :

```bash
./local-e2e/insee/siade.sh
./local-e2e/insee/site.sh
```

Chaque script charge les classes applicatives sans démarrer l'application
complète. Il crée un Redis temporaire sur socket Unix, injecte des credentials
fictifs et intercepte tous les échanges HTTP avec WebMock. Aucun credential
applicatif ni base Postgres n'est chargé. Le Redis temporaire est supprimé à la
fin, y compris en cas d'échec.

Le simulateur conserve le mot de passe et les tokens acceptés. Les scénarios
vérifient les replis, les erreurs temporaires, le garde-fou et son expiration,
la panne Redis, le bypass et l'expiration du token. Huit processus concurrents
vérifient l'authentification réussie, la désynchronisation, un OAuth lent,
un 503 et des 401 simultanés. Deux scénarios provoquent un remplacement juste
avant la suppression du token ou du verrou pour vérifier leur conservation.
`siade` vérifie aussi les 401 pendant une requête avec cache local,
les erreurs `01006` / `01011` et le chiffrement du token. `site` vérifie le
renouvellement, sa réponse perdue, la sortie du bypass et les conditions
d'exécution du job.

Chaque scénario affiche `OK`. Une assertion échouée arrête le script avec un
code de sortie non nul. Ces vérifications couvrent la logique applicative avec
un fournisseur simulé ; elles ne lancent ni le serveur HTTP Rails ni
l'ordonnanceur GoodJob.

Le scénario OAuth lent attend une erreur temporaire pour les sept processus
qui dépassent les 0,5 seconde d'attente, puis vérifie la reprise avec le token
publié. Les scénarios Redis indisponible et namespaces de démarrage distincts
vérifient les limites de la coordination : huit échanges sont possibles sans
Redis, ainsi qu'entre huit namespaces `siade`. Le namespace INSEE de `site`
reste commun aux démarrages.

Ces scripts ne prouvent pas la sérialisation réelle des jobs GoodJob ni un
plafond global de tentatives entre `site` et `siade`, dont les Redis sont
distincts. Le comportement de verrouillage du compte côté INSEE est simulé
uniquement par ses réponses OAuth ; son seuil réel n'est pas testé.
