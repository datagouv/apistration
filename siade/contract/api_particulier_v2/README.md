# api_particulier_v2

The legacy v2 controllers of API Particulier. They answer with the v2
error format (`format_error`, `application/json`), and new endpoints
never go there: they are v3 and inherit from
`APIParticulier::V3AndMore::BaseController`. The v2 controllers live
until the v2 routes are shut down, then go away with them.

```covers
APIParticulier::V2::*
```
