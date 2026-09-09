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
la panne Redis, le bypass et huit authentifications dans des processus
concurrents. `siade` vérifie aussi les 401 pendant une requête avec cache local,
les erreurs `01006` / `01011` et le chiffrement du token. `site` vérifie le
renouvellement, sa réponse perdue, la sortie du bypass et les conditions
d'exécution du job.

Chaque scénario affiche `OK`. Une assertion échouée arrête le script avec un
code de sortie non nul. Ces vérifications couvrent la logique applicative avec
un fournisseur simulé ; elles ne lancent ni le serveur HTTP Rails ni
l'ordonnanceur GoodJob.
