---
name: hyperping-incidents
description: Manage the lifecycle of incidents on the API Entreprise / API Particulier Hyperping status pages (entreprise.api.gouv.fr, particulier.api.gouv.fr). Use to list, read, open, update, resolve or delete incidents, post progress updates, and look up monitor or status-page uuids. Triggers — "ouvre/crée un incident", "déclare une panne sur la status page", "mets à jour l'incident", "résous l'incident", "liste les incidents Hyperping", "quel est l'uuid du monitor X", "signale un problème sur entreprise/particulier.api.gouv.fr".
---

# Hyperping Incidents

Drive incidents on the two Hyperping status pages from the CLI. Wraps the
Hyperping API (read-only listing + full incident lifecycle).

## Setup

- Token from https://app.hyperping.io/project/developers, saved to
  `.hyperping_token` at the repo root. It is gitignored — never commit it.
- The CLI finds the token by searching upward from the working directory, so
  run it from anywhere inside the repo.

## CLI

All operations go through `scripts/hyperping` (Ruby, no gems). Commands that
write take their JSON body on **stdin**.

```
hyperping incidents [sp_xxx]            # list (optionally filter by status page)
hyperping incident <uuid>               # full incident JSON
hyperping create   < body.json          # open an incident
hyperping add-update <uuid> < up.json   # post a progress update / resolve
hyperping update   <uuid> < fields.json # edit title/type/components/pages (PUT)
hyperping delete   <uuid>               # delete (no confirmation prompt)
hyperping monitors [filter]             # list monitors, optional name filter
hyperping status-pages                  # the two known status pages
```

## Reference

Read `references/api_reference.md` for the API contract: endpoints, the create
/ update / add-update body schemas, enum values, and the status-page uuids.
Read it before constructing any write body.

## Key facts (do not relearn)

- Status pages: `sp_9CPwLOiid6RIv5` = Entreprise, `sp_SfFWlwddY5Mg7E` =
  Particulier. There is no API to list status pages.
- `affectedComponents` takes **monitor** uuids (`mon_...`) — resolve names with
  `hyperping monitors <filter>`.
- `title`/`text` are i18n objects; use the `fr` key (supported).
- `type`: `outage` (service down) vs `incident` (degradation / data-quality).
- **Start date trap**: the top-level `date` on create is ignored (forced to
  now). To backdate, set the first update's `date`.

## Workflows

### Open an incident

1. Resolve the monitor uuid(s): `hyperping monitors <name>`.
2. Pick the status page (Entreprise vs Particulier) and `type`.
3. Build the body (see reference), then:
   ```
   hyperping create <<'JSON'
   { "title": {"fr": "..."}, "type": "incident",
     "statuspages": ["sp_..."], "affectedComponents": ["mon_..."],
     "updates": [{"type":"investigating","date":"<ISO8601>","text":{"fr":"..."}}] }
   JSON
   ```
4. To backdate the start, set `updates[0].date` to the real start (UTC).

### Post an update / resolve

```
hyperping add-update <uuid> <<'JSON'
{ "type": "resolved", "date": "<ISO8601>", "text": {"fr": "Service rétabli."} }
JSON
```

Update `type` progression: `investigating` → `identified` → `update` →
`monitoring` → `resolved`.

## Cautions

- Incidents are **public** on gouv.fr status pages. Confirm content and target
  page before `create`, `add-update` or `delete`.
- `delete` is irreversible and unprompted.
- Times are UTC. Paris is UTC+2 in summer (CEST), UTC+1 in winter (CET).
