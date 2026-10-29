# api_particulier_v2: kept duplication

## The v2 show stays apart from the v3 one

Each v2 controller still renders its organizer the way every v3
controller does through `APIParticulier::V3AndMore::BaseController#show`:
the serialized payload on success, the errors otherwise. Behind the
same shape, v2 serializes differently and keeps its own error format
and HTTP codes (400 rather than 422 on a wrong parameter, 503 rather
than 502 on a provider error), part of the public v2 contract. Sharing the action between v2 and v3 would tie the
code that stays to the code that goes; folding the six v2 copies into
their base controller would rewrite code that only waits for its
removal.

```parallel
APIParticulier::V3AndMore::BaseController#show
APIParticulier::V2::CNAV::AbstractController#show
APIParticulier::V2::CNOUS::StudentScholarshipController#show
APIParticulier::V2::MEN::ScolaritesController#show
APIParticulier::V2::MESRI::StudentStatusController#show
APIParticulier::V2::PoleEmploi::IndemnitesController#show
APIParticulier::V2::PoleEmploi::StatutController#show
```
