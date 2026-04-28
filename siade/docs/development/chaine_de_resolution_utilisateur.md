# Chaîne de résolution utilisateur

## Vue d'ensemble

L'authentification et la résolution de l'utilisateur sont centralisées dans un middleware Rack (`UserResolutionMiddleware`) qui s'exécute **avant** Rack::Attack. Tous les consumers (rate limiting, IP check, controllers) lisent le résultat depuis `request.env`.

```
Requête HTTP
  │
  ▼
UserResolutionMiddleware        ← résout le user complet (1 seule fois)
  │
  ▼
Rack::Attack                    ← lit request.env (IP, rate limit, blacklist)
  │
  ▼
RateLimitHeadersMiddleware      ← ajoute les headers RateLimit-*
  │
  ▼
Controller (HandleTokens)       ← lit request.env, vérifie expiration, logge
```

## UserResolutionMiddleware

Fichier : `app/lib/user_resolution_middleware.rb`

### Ce qu'il fait

1. Extrait le token (`Authorization: Bearer`, `X-Api-Key`, query param `token`)
2. Décode via `JwtTokenService` (cache 1h)
3. Si jeton éditeur **et** paramètre `recipient` présent : délègue à `EditorDelegationResolver`
4. Stocke le user enrichi dans `env['siade.current_user']`

### Clés `request.env`

| Clé | Type | Description |
|-----|------|-------------|
| `siade.current_user` | `JwtUser` ou `nil` | User résolu (avec délégation appliquée pour les éditeurs) |
| `siade.editor_delegation` | `EditorDelegation` ou `nil` | Délégation résolue (si applicable) |
| `siade.editor_delegation_ambiguous` | `true` ou absent | Plusieurs délégations matchent sans `delegation_id` |

### Tokens opaques (FranceConnect, X-Api-Key V2)

Les tokens qui ne sont pas des JWT valides ne peuvent pas être décodés par `JwtTokenService` : `env['siade.current_user']` reste `nil`. Ces flows utilisent leur propre logique d'authentification au niveau controller (ex: `FranceConnectable`).

## EditorDelegationResolver

Fichier : `app/services/editor_delegation_resolver.rb`

Service dédié à la résolution de la délégation éditeur. Encapsule :
- Lookup délégation par `editor_id` + `recipient` SIRET
- Disambiguation via `delegation_id` (avec validation UUID)
- Enrichissement du user avec les scopes/allowed_ips/rate_limit de l'AR

## RateLimitingService

Fichier : `app/services/rate_limiting_service.rb`

Pur lecteur de `request.env` — ne fait aucune requête DB.

- `ip_forbidden_access?` → lit `user.allowed_ips` (déjà enrichi par le middleware)
- `custom_rate_limit_for` → lit `user.rate_limit_per_minute`
- `authorization_request_discriminator` → lit `user.authorization_request_id`
- Fallback pour tokens classiques sans AR : `"token:<token_id>"`
- Fallback pour éditeurs sans délégation résolue : `"editor:<editor_id>"`
- Fallback pour tokens opaques (FC, X-Api-Key V2) : `SHA256(token)`

## HandleTokens (controller)

Fichier : `app/controllers/concerns/handle_tokens.rb`

```
before_action :authenticate_user!       ← lit env, fallback JwtTokenService
before_action :set_monitoring_context   ← logstash + Sentry
before_action :authorize_access_to_resource!  ← vérifie les scopes
```

`authenticate_user!` prend le user depuis `request.env`. Si absent (controller specs, cas spéciaux), fallback sur `JwtTokenService.instance.extract_user(token)`.

`instrument_user_access` (appelé depuis `authenticate_user!`) émet l'event `'user_access'` pour LogStasher. `set_monitoring_context` alimente Sentry.

## HandleEditorDelegation (controller)

Fichier : `app/controllers/concerns/handle_editor_delegation.rb`

Ne fait **aucune requête DB**. Lit l'état de la délégation depuis `request.env` et gère les réponses d'erreur :

- Délégation absente → 403
- Délégation ambiguë → 422

Inclus dans les base controllers V3+ (API Entreprise, API Particulier) **après** `before_action :verify_recipient_is_a_siret!` pour que la validation du format SIRET prime.

## Cas spéciaux

### INPIProxyController

Override complet de `authenticate_user!`. Utilise `token_id`, `token_type` et `authorization_request_id` chiffrés dans l'URL du proxy pour re-résoudre le token depuis la DB (`Token` ou `EditorToken`). Pour les jetons éditeur, ré-enrichit le user avec la délégation via `authorization_request_id`. Ne passe pas par le middleware.

### FranceConnectable

Override de `authenticate_user!`. Utilise le Bearer token comme access token FC opaque pour appeler l'IdP FranceConnect. Le middleware renvoie `nil` (token non-JWT).

### API Particulier V2

Utilise `X-Api-Key` comme header d'auth. Le middleware le gère directement (extraction depuis `HTTP_X_API_KEY`).

## Logstash

L'event `'user_access'` est émis une seule fois, au niveau controller (`HandleTokens#instrument_user_access`), avec les infos complètes :

```ruby
{
  user: current_user.logstash_id,           # UUID du token
  jti: current_user.token_id,               # JTI
  iat: current_user.iat,                    # issued at
  authorization_request_id: current_user.authorization_request_id  # habilitation
}
```

Pour les jetons éditeur, `authorization_request_id` correspond à l'habilitation résolue via la délégation.

## Fichiers clés

- `app/lib/user_resolution_middleware.rb` : middleware de résolution
- `app/services/editor_delegation_resolver.rb` : résolution délégation éditeur
- `app/services/rate_limiting_service.rb` : rate limiting (lecteur pur)
- `app/controllers/concerns/handle_tokens.rb` : auth controller + logging
- `app/controllers/concerns/handle_editor_delegation.rb` : validation délégation
- `app/services/jwt_token_service.rb` : decode JWT + cache (pur data service)
- `config/initializers/rack_attack.rb` : wiring middleware + règles Rack::Attack
