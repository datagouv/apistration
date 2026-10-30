# brand_home: kept duplication

## Each brand's home lists its own sections

Both homes are the same shape, a run of `render` calls, but each names
its brand's partials and its own order: API Particulier has a
demonstrator section, API Entreprise an endpoints section. A shared
partial would only move the list into a parameter.

```parallel
views/api_entreprise/pages/home.html.erb
views/api_particulier/pages/home.html.erb
```
