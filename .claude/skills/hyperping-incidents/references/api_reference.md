# Hyperping incidents API — reference

Confirmed by live calls (2026-06-26) and the official docs at
https://hyperping.com/docs/api/incidents/create (only the `/create` page
renders the schema; overview pages are JS-only and fetch empty).

## Auth & base

- Base: `https://api.hyperping.io`
- Header: `Authorization: Bearer <token>`
- Token obtained at https://app.hyperping.io/project/developers, stored in
  `.hyperping_token` at repo root (gitignored). The same token serves
  `/v1/monitors` and `/v3/incidents`.

## API versions (mind the mix)

| Resource  | Endpoint            | Status |
|-----------|---------------------|--------|
| Monitors  | `GET /v1/monitors`  | 200    |
| Incidents | `/v3/incidents`     | 200    |
| `/v1/incidents`, `/v1/projects` | 401 (other scope) |
| `/v3/monitors`, `/v3/status-pages`, `/v3/projects` | 404 (do not exist) |

There is **no listing endpoint for status pages**. Their uuids are only
discoverable via existing incidents (`statuspages` field). Known stable uuids:

- `sp_9CPwLOiid6RIv5` → API Entreprise (entreprise.api.gouv.fr)
- `sp_SfFWlwddY5Mg7E` → API Particulier (particulier.api.gouv.fr)

## Incident lifecycle endpoints

| Action        | Call                                    |
|---------------|-----------------------------------------|
| List          | `GET    /v3/incidents`                  |
| Get           | `GET    /v3/incidents/{uuid}`           |
| Create        | `POST   /v3/incidents`                  |
| Update fields | `PUT    /v3/incidents/{uuid}`           |
| Append update | `POST   /v3/incidents/{uuid}/updates`   |
| Delete        | `DELETE /v3/incidents/{uuid}`           |

## Create body (POST /v3/incidents)

Required:
- `title` — i18n object. Supported keys: `en fr de ru nl pl se`. **`fr` works.**
- `type` — enum: `outage` | `incident`.

Optional:
- `affectedComponents` — array of uuids. Docs show `comp_...` but the API
  **accepts monitor uuids `mon_...`** (these are what real incidents use).
- `statuspages` — array of `sp_...` uuids.
- `updates` — array of `{ type, date, text }` objects.
  - `type` ∈ `investigating | identified | update | monitoring | resolved`
  - `date` — ISO 8601 (e.g. `2026-06-24T04:00:00Z`)
  - `text` — i18n object

```json
{
  "title": { "fr": "..." },
  "type": "incident",
  "statuspages": ["sp_SfFWlwddY5Mg7E"],
  "affectedComponents": ["mon_gmbGFmHu84Y7qm"],
  "updates": [
    { "type": "investigating", "date": "2026-06-24T04:00:00Z", "text": { "fr": "..." } }
  ]
}
```

### Start date: the trap

The incident's top-level `date` is **ignored on create** — the API forces it
to the POST timestamp. The displayed start date comes from the **first
update's `date`**. To backdate an incident, set `updates[0].date`, not the
top-level `date`.

Proven on `inci_bJnhZWAOfyE1r4`:

| sent                       | value sent             | kept              |
|----------------------------|------------------------|-------------------|
| `date` (top-level)         | `2026-06-24T04:00:00Z` | overwritten (now) |
| `updates[0].date`          | `2026-06-24T04:00:00Z` | kept              |

## Append update body (POST /v3/incidents/{uuid}/updates)

Same shape as one element of `updates`:

```json
{ "type": "monitoring", "date": "2026-06-26T10:00:00Z", "text": { "fr": "..." } }
```

To resolve an incident, append an update with `"type": "resolved"`.

## Update fields body (PUT /v3/incidents/{uuid})

Send the fields to change (`title`, `type`, `statuspages`,
`affectedComponents`). Same JSON conventions as create. Lifecycle changes
(investigating → resolved) go through `add-update`, not PUT.

> `update`, `add-update` and `delete` reuse the exact JSON conventions proven
> by the create POST (auth, i18n keys, `mon_` uuids); endpoint shapes are from
> the official docs but were not write-tested live to avoid mutating real
> public incidents.
