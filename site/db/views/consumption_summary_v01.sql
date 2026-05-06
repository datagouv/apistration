SELECT
  DATE(al.timestamp) AS date,
  CASE WHEN ar.external_id IS NOT NULL THEN 'token' ELSE 'france_connect' END AS source_type,
  COALESCE(ar.external_id, al.params->'france_connect_client'->>'id') AS source_id,
  al.controller AS api,
  MAX(u.email) AS email_demandeur,
  MAX(ar.demarche) AS demarche,
  COUNT(*) AS appels_totaux,
  SUM(CASE WHEN al.status = '200' THEN 1 ELSE 0 END) AS appels_succes,
  SUM(CASE WHEN al.status = '404' THEN 1 ELSE 0 END) AS appels_echecs,
  SUM(CASE WHEN al.cached THEN 1 ELSE 0 END) AS appels_cache,
  COUNT(DISTINCT COALESCE(al.params->>'hashed_params', al.path)) AS appels_uniques,
  COUNT(*) - COUNT(DISTINCT COALESCE(al.params->>'hashed_params', al.path)) AS appels_non_uniques,
  AVG(CASE WHEN al.status IN ('200', '404') THEN al.duration::float END) AS avg_duration,
  SUM(
    CASE
      WHEN al.api_version ~ '^v([3-9]|[1-9][0-9]+)$' AND al.status = '502' THEN 1
      WHEN al.api_version = 'v2' AND al.status IN ('503', '504') THEN 1
      ELSE 0
    END
  ) AS appels_erreurs_fournisseur
FROM
  access_logs al
  LEFT OUTER JOIN tokens t ON al.token_id = t.id
  LEFT OUTER JOIN authorization_requests ar ON t.authorization_request_model_id = ar.id
  LEFT OUTER JOIN user_authorization_request_roles uar
    ON ar.id = uar.authorization_request_id AND uar.role = 'demandeur'
  LEFT OUTER JOIN users u ON u.id = uar.user_id
WHERE
  al.timestamp >= (now() + (INTERVAL '- 18 months'))
  AND al.controller NOT IN (
    'uptime', 'ping', 'errors',
    'api_particulier/introspect',
    'api_entreprise/proxied_files',
    'api_particulier/ping_providers',
    'api_entreprise/ping_providers',
    'api_entreprise/inpi_proxy',
    'api_particulier/france_connect_jwks'
  )
GROUP BY
  DATE(al.timestamp),
  ar.external_id,
  source_id,
  al.controller;
