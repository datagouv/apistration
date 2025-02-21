# Format des payloads

Les payloads suivent systématiquement le même format qui suit la logique REST.
Celle-ci est fortement inspirée de [JSON:API](https://jsonapi.org/)

Pour une resource seule:

```json
{
  "data": {
    "attribute1": "value1",
    "attribute2": "value2",
    "nested_attribute": {
      "nested_attribue1": "nested_value1"
    }
  },
  "links": {
    "name": "https://whatever.com"
  },
  "meta": {
    "meta1": "meta_value1"
  }
}
```

Les clés `data`, `links` et `meta` sont systématiquement présentes et sont
forcément un objet. (à minima l'objet vide `{}`)

Pour une collection:

```json
{
  "data": [
    {
      "attribute1": "value1",
      "attribute2": "value2",
      "nested_attribute": {
        "nested_attribue1": "nested_value1"
      }
    }
  ],
  "links": {
    "name": "https://whatever.com"
  },
  "meta": {
    "meta1": "meta_value1"
  }
}
```

La clé `data` est un tableau de données. Les 3 clés sont aussi systématiquement
présentes. A noter que `links` et `meta` s'appliquent à l'ensemble de la collection.

Pour des erreurs:

```json
{
  "errors": [
    {
      "code": "00304",
      "title": "Entité non traitable",
      "detail": "Le numéro de siret ou le numéro EORI n'est pas correctement formatté",
      "source": {
        "parameter": "id"
      }
    }
  ]
}
```

Chaque entrée du tableau `errors` possède comme attributs:

- `code`, `string`: code correspondant à la table de correspondance
- `title`, `string`: nom associé au code (fixe en fonction du code)
- `detail`, `string`: description exhaustive associée à l'erreur
