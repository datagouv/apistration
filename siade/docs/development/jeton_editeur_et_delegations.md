# Jeton éditeur et délégations

## Contexte

Un éditeur logiciel gère des centaines d'administrations clientes. Historiquement, 1 habilitation = 1 jeton : l'éditeur devait maintenir autant de jetons que de clients.

Le jeton éditeur introduit la notion de **délégation** : l'administration délègue son habilitation à un éditeur, qui utilise un jeton unique et permanent. À chaque appel, l'API résout l'habilitation effective via le SIRET passé en paramètre `recipient`.

## Acteurs

- `Editor` : entité éditeur logiciel (gérée côté `site/`).
- `EditorToken` : jeton JWT unique de l'éditeur (`iat`, `exp`). Pas de scopes persistés — résolus dynamiquement via la délégation.
- `EditorDelegation` : lien entre un `Editor` et une `AuthorizationRequest`. Peut être révoquée (`revoked_at`).
- `AuthorizationRequest` : habilitation (DataPass) portée par l'administration cliente.

## Résolution de la délégation

La résolution est effectuée par `UserResolutionMiddleware` via `EditorDelegationResolver` (voir [chaîne de résolution](chaine_de_resolution_utilisateur.md)) :

1. Le middleware décode le JWT et détecte un jeton éditeur (`editor` claim).
2. Si `recipient` est présent, `EditorDelegationResolver` cherche les délégations actives de l'éditeur dont l'`authorization_request.siret` correspond.
3. Le user est enrichi avec les scopes, `allowed_ips` et `rate_limit_per_minute` de l'habilitation résolue. Les `allowed_ips` du jeton éditeur (`editor_token_allowed_ips`) sont conservées à côté : une requête doit satisfaire les deux listes non vides, sinon 403 (code 00107), délégation résolue ou non.
4. Le controller (`HandleEditorDelegation`) valide que la délégation existe et gère les erreurs.

### Réponses possibles

| Situation | Réponse |
|-----------|---------|
| `recipient` absent ou invalide | 422 (validation SIRET) |
| 0 délégation pour ce SIRET | 403 |
| 1 délégation | succès |
| N délégations sans `delegation_id` | 422 (ambiguïté) |
| `delegation_id` ne matche pas | 403 |

## Désambiguïsation

Un éditeur peut disposer de plusieurs délégations actives sur le même SIRET (plusieurs DataPass distinctes pour la même administration).

### Paramètre `delegation_id`

L'éditeur fournit `delegation_id` en query string : l'`id` (UUID) de l'`EditorDelegation` à utiliser.

```
GET /api/.../endpoint?recipient=13002526500013&delegation_id=6f3c8d9a-…
```

UUID non-inférable (généré par `gen_random_uuid()`), validé côté middleware avant query DB.

### Réponse en cas d'ambiguïté

422 avec le code erreur `00212` (voir `config/errors.yml`).

## Rate limiting

Le rate limiting se base sur l'`authorization_request_id` du user résolu (pas sur la signature JWT). Cela permet :

- de partager le compteur entre un jeton classique et un jeton éditeur pointant vers la même habilitation ;
- d'isoler les compteurs de chaque délégation pour un même jeton éditeur ;
- de piloter la limite au niveau de `AuthorizationRequestSecuritySettings`.

Fallback si la délégation n'est pas résolvable → `"editor:<editor_id>"`.

## Révocation

Une délégation est exclue dès lors que `revoked_at` est renseigné (scope `EditorDelegation.active`). Aucune action côté jeton : le jeton éditeur reste valide, seule la délégation change d'état.

## Non-régression

Les jetons classiques (`Token` non-éditeur) ne passent pas par la logique de délégation. Le middleware leur applique directement les settings de leur `AuthorizationRequest`.

## Fichiers clés

- `app/lib/user_resolution_middleware.rb` : résolution middleware
- `app/services/editor_delegation_resolver.rb` : résolution délégation éditeur
- `app/controllers/concerns/handle_editor_delegation.rb` : validation controller
- `app/errors/ambiguous_delegation_error.rb` : erreur `00212`
- `app/models/editor_delegation.rb` : scope `active`
- `spec/requests/editor_delegation_spec.rb` : tests de bout en bout
