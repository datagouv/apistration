# Déploiement sur les serveurs

Les déploiements se font traditionnellement via Github Action mais il existe un script pour déployer manuellement :

```sh
./bin/deploy [env] [branch]
```

`env` est par défaut à `production`, et accepte uniquement `sandbox`, `staging`
et `production`
`branch` est pris en compte uniquement si `env` est `sandbox`

