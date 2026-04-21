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

1. Extrait le token (`Authorization: Bearer`, `X-Api-Key`, query param `token`)
2. Décode via `JwtTokenService` (cache 1h)
3. Stocke le user dans `env['siade.current_user']`

### Tokens opaques (FranceConnect, X-Api-Key V2)

Les tokens qui ne sont pas des JWT valides ne peuvent pas être décodés par `JwtTokenService` : `env['siade.current_user']` reste `nil`. Ces flows utilisent leur propre logique d'authentification au niveau controller (ex: `FranceConnectable`).

## RateLimitingService

Fichier : `app/services/rate_limiting_service.rb`

Pur lecteur de `request.env` — ne fait aucune requête DB, ne décode aucun JWT.

- `ip_forbidden_access?` → lit `user.allowed_ips`
- `custom_rate_limit_for` → lit `user.rate_limit_per_minute`
- `discriminate_by_jwt_for_endpoints` → lit `user.token_id`, fallback SHA256 pour tokens opaques
- `whitelisted_access?` → comparaison directe du token brut (seul cas qui nécessite encore l'extraction)

## HandleTokens (controller)

Fichier : `app/controllers/concerns/handle_tokens.rb`

```
before_action :authenticate_user!       ← lit env, fallback JwtTokenService
before_action :set_monitoring_context   ← logstash + Sentry
before_action :authorize_access_to_resource!  ← vérifie les scopes
```

`authenticate_user!` prend le user depuis `request.env`. Si absent (controller specs, cas spéciaux), fallback sur `JwtTokenService.instance.extract_user(token)`.

`set_monitoring_context` émet l'event `'user_access'` pour LogStasher avec le user complet.

## JwtTokenService

Fichier : `app/services/jwt_token_service.rb`

Pur service de données : decode JWT, enrichit depuis la DB (Token, security settings), cache 1h. Aucun side-effect (pas de logging, pas de notification).

## Cas spéciaux

### INPIProxyController

Override complet de `authenticate_user!`. Utilise un `token_id` chiffré dans l'URL du proxy pour re-résoudre le token depuis la DB. Ne passe pas par le middleware.

### FranceConnectable

Override de `authenticate_user!`. Utilise le Bearer token comme access token FC opaque pour appeler l'IdP FranceConnect. Le middleware renvoie `nil` (token non-JWT).

### API Particulier V2

Utilise `X-Api-Key` comme header d'auth. Le middleware le gère directement (extraction depuis `HTTP_X_API_KEY`).

## Fichiers clés

- `app/lib/user_resolution_middleware.rb` : middleware de résolution
- `app/services/rate_limiting_service.rb` : rate limiting (lecteur pur)
- `app/controllers/concerns/handle_tokens.rb` : auth controller + logging
- `app/services/jwt_token_service.rb` : decode JWT + cache (pur data service)
- `config/initializers/rack_attack.rb` : wiring middleware + règles Rack::Attack
