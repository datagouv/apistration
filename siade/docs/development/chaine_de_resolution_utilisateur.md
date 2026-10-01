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

1. Liste les tokens présentés, dans cet ordre unique : `Authorization: Bearer`, `X-Api-Key`, param `token` (un header `Authorization` non Bearer est ignoré)
2. Décode chacun via `JwtTokenService` (cache 1h) et retient le premier qui donne un user ; à défaut, le premier token présenté et la raison d'échec de son extraction
3. Si jeton éditeur **et** paramètre `recipient` présent : délègue à `EditorDelegationResolver`
4. Stocke le token retenu et le user enrichi dans `request.env`

C'est la seule extraction du token : Rack::Attack (safelist, blocklists, throttles) et les controllers lisent `request.env` et ne relisent jamais les headers ou les params eux-mêmes. Une requête portant plusieurs tokens est donc authentifiée et contrôlée sur le même. Elle n'est pas rejetée : les access logs ne stockent pas les headers, impossible de savoir si des clients envoient légitimement un header invalide à côté d'un `?token=` valide.

Les params (`token`, `recipient`, `delegation_id`) sont lus exactement comme les params Rails des controllers : body (formulaire ou JSON) fusionné avec la query string, qui est prioritaire. Un token envoyé dans le body (appels MCP notamment) est donc accepté et contrôlé par toutes les couches, et la délégation est résolue sur le `recipient` que les controllers transmettront. Un body illisible laisse les headers utilisables ; Rails le rejette ensuite en 400.

`UserResolutionMiddleware.resolve(env)` est idempotent : `HandleTokens` l'appelle aussi, ce qui ne refait rien en temps normal et résout la requête quand le middleware n'a pas tourné (controller specs).

### Clés `request.env`

| Clé | Type | Description |
|-----|------|-------------|
| `siade.user_resolved` | `true` | La résolution a eu lieu (garde d'idempotence) |
| `siade.token` | `String` ou `nil` | Token retenu : celui du user résolu, sinon le premier présenté |
| `siade.token_extraction_failure_reason` | `Symbol` ou absent | Raison d'échec d'extraction quand aucun token ne donne de user (`:malformed`, `:production_token_on_staging`…) |
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

- `whitelisted_access?` → compare `env['siade.token']` à `jwt_whitelist`
- `ip_forbidden_access?` → lit `user.allowed_ips` (habilitation, déjà enrichi par le middleware) `user.editor_token_allowed_ips` (jeton éditeur) et `user.editor_allowed_ips` (plage déclarée de l'éditeur) : l'IP doit être autorisée par chaque liste non vide
- `custom_rate_limit_for` → lit `user.rate_limit_per_minute`
- `authorization_request_discriminator` → lit `user.authorization_request_id`
- Fallback pour tokens classiques sans AR : `"token:<token_id>"`
- Fallback pour éditeurs sans délégation résolue : `"editor:<editor_id>"`
- Fallback pour tokens opaques (FC, X-Api-Key V2) : `SHA256(env['siade.token'])`

Le throttle global API Particulier V2 est lui aussi discriminé par `env['siade.token']`, quelle que soit la source du token.

## HandleTokens (controller)

Fichier : `app/controllers/concerns/handle_tokens.rb`

```
before_action :authenticate_user!       ← lit env (résout via le middleware s'il n'a pas tourné)
before_action :set_monitoring_context   ← logstash + Sentry
before_action :authorize_access_to_resource!  ← vérifie les scopes
```

`authenticate_user!` prend le user depuis `request.env`, sans jamais extraire de token lui-même. Les erreurs d'environnement (jeton de production en staging et inversement) de `invalid_token_error` s'appuient sur `env['siade.token_extraction_failure_reason']`.

`instrument_user_access` (appelé depuis `authenticate_user!`) émet l'event `'user_access'` pour LogStasher. `set_monitoring_context` alimente Sentry.

## HandleEditorDelegation (controller)

Fichier : `app/controllers/concerns/handle_editor_delegation.rb`

Ne fait **aucune requête DB**. Lit l'état de la délégation depuis `request.env` et gère les réponses d'erreur :

- Délégation absente → 403
- Délégation dont le SIRET de l'habilitation diffère de `params[:recipient]` → 403 (même erreur). Le middleware lit déjà les mêmes params que les controllers ; cette vérification garantit qu'une requête n'est jamais autorisée sous une délégation et transmise aux fournisseurs avec un autre SIRET si ces deux lectures divergeaient à nouveau.
- Délégation ambiguë → 422

Inclus dans les base controllers V3+ (API Entreprise, API Particulier) **après** `before_action :verify_recipient_is_a_siret!` pour que la validation du format SIRET prime.

## Cas spéciaux

### INPIProxyController

Override complet de `authenticate_user!`. Utilise `token_id`, `token_type` et `authorization_request_id` chiffrés dans l'URL du proxy pour re-résoudre le token depuis la DB (`Token` ou `EditorToken`). Pour les jetons éditeur, ré-enrichit le user avec la délégation via `authorization_request_id`. Ne passe pas par le middleware.

### FranceConnectable

Override de `authenticate_user!`. Utilise le Bearer token comme access token FC opaque pour appeler l'IdP FranceConnect. Le middleware ne résout pas de user à partir de ce token non-JWT. Sur API Particulier V2, les clients envoient leur clé d'API dans `X-Api-Key` à côté du Bearer FC : c'est elle que Rack::Attack contrôle (allowlist IP, liste noire, throttles), tandis que le controller authentifie l'usager via FranceConnect dès qu'un Bearer est présent.

### Tokens internes

Les tokens internes (`JwtUser.debugger_id`) passent par la même extraction ; seul `JwtTokenService` les distingue en ne les cherchant pas en base.

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
