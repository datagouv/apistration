# Gestion des maintenances des fournisseurs de données

Certains fournisseurs de données sont en maintenance applicatives de manière
journalières, d'autres annonces des maintenances de manières ponctuelles.

Il est possible de gérer applicativement ces 2 types de maintenances dans SIADE et renvoyer
aux utilisateurs des erreurs spécifiques à ces maintenances (avec les dates, et
quand est-ce que la maintenance s'arrête).

La configuration s'effectue dans le fichier
[maintenances.yml](./config/maintenances.yml) sous la clé `production`.

La liste exacte des fournisseurs se trouve dans le fichier
[nomenclature-errors](./nomenclature-errors.md)
