# Quotas des fournisseurs de données

Quotas d'appels que les fournisseurs de données imposent à API Entreprise /
API Particulier en tant que client.

À ne pas confondre avec `commons/data/throttle.yml`, qui décrit les limites
que nous imposons à nos propres clients.

| Fournisseur | Limite | Source | Mise à jour |
|---|---|---|---|
| INSEE | 2000 req/min | email du service grands comptes | 2024-12 |
| INPI RNE | 50 000 req/jour par compte, 2 comptes prod en 50/50 soit ~100 000 req/jour ; bannissement IP après plusieurs 401 | commit a1896a225e | 2026-02 |
