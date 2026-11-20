# ─── base ─────────────────────────────
#
# Image officielle Ruby, variante « slim » (Debian minimal) sur Debian 13
FROM ruby:4.0.9-slim-trixie@sha256:d8cb2c0714bdaba0f318af897a01d2dbde3cfa8e62d47e99cea55feb13c0e90d AS base

#   BUNDLE_DEPLOYMENT : mode strict, le Gemfile.lock doit être respecté à la lettre
#   BUNDLE_PATH       : les gems vont dans un dossier à part, hors du code
#   BUNDLE_WITHOUT    : les gems de développement et de test ne sont pas installées
ENV BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

WORKDIR /app

# ─── build ──────────────────────────────
FROM base AS build

# Outils nécessaires seulement pour compiler les gems qui contiennent du C :
#   build-essential : compilateurs C/C++ (gcc, make…)
#   git             : une gem (active_model_serializers) est tirée de GitHub
#   libgpgme-dev    : fichiers de GPG nécessaires pour compiler la gem gpgme
#   libssl-dev      : fichiers d'OpenSSL nécessaires pour compiler la gem openssl
#   pkg-config      : aide le compilateur à trouver ces bibliothèques
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential git libgpgme-dev libssl-dev pkg-config \
 && rm -rf /var/lib/apt/lists/*

# On copie la liste des gems
COPY siade/Gemfile siade/Gemfile.lock ./

# La version de Bundler avec laquelle le Gemfile.lock a été produit (lue à la
# fin du fichier, ligne « BUNDLED WITH »)
RUN gem install bundler --no-document \
      -v "$(awk '/^BUNDLED WITH/ { getline; print $1 }' Gemfile.lock)"

# La gem gpgme utilise le GPG fourni par Debian au lieu d'en télécharger et
# d'en compiler sa propre copie.
ENV RUBY_GPGME_USE_SYSTEM_LIBRARIES=1

# Installation des gems, puis ménage : archives téléchargées et historique git
# de la gem venue de GitHub, inutiles une fois l'installation faite.
RUN bundle install \
 && rm -rf "$BUNDLE_PATH"/cache "$BUNDLE_PATH"/ruby/*/cache "$BUNDLE_PATH"/ruby/*/bundler/gems/*/.git

# Le code de siade. Copié après les gems
COPY siade/ ./

# Les fichiers partagés vers lesquels pointent les liens symboliques de siade,
# posés à part dans /tmp/repo, avec la même organisation que le dépôt.
COPY commons/ /tmp/repo/commons/
COPY mocks/payloads/ /tmp/repo/mocks/payloads/
COPY bin/expand_shared_paths /tmp/repo/bin/

# Chaque lien listé dans .expand est remplacé par une vraie copie, puis ménage :
# les fichiers partagés ne servent plus, et le lien « commons » (vers tout le
# dossier commons/ du dépôt) n'est utile qu'en développement.
# Garde-fou : la construction échoue s'il reste un lien cassé dans l'image.
RUN /tmp/repo/bin/expand_shared_paths /tmp/repo . \
 && rm -rf /tmp/repo commons \
 && if find . -xtype l | grep .; then echo "Liens symboliques cassés" >&2; exit 1; fi

# ─── runtime : l'image livrée ────────────────────────────
FROM base AS runtime

# Bibliothèques nécessaires à l'exécution, sans leurs fichiers de compilation :
#   tzdata         : fuseaux horaires (config.time_zone = 'Europe/Paris')
#   libgpgme11t64  : bibliothèque GPG utilisée par la gem gpgme
#   gpg, gpg-agent : programmes GPG appelés pour chiffrer et signer
RUN apt-get update \
 && apt-get install -y --no-install-recommends tzdata libgpgme11t64 gpg gpg-agent \
 && rm -rf /var/lib/apt/lists/*

# Utilisateur sans privilèges qui fera tourner l'application. L'identifiant
# numérique (1000) permet à Kubernetes de vérifier qu'il ne s'agit pas de root.
RUN groupadd --system --gid 1000 rails \
 && useradd --system --uid 1000 --gid rails --home-dir /app/tmp/home --shell /usr/sbin/nologin rails

# Les gems compilées et le code, récupérés depuis l'atelier. Ils appartiennent
# à root : l'application peut les lire, jamais les modifier.
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# Les seuls dossiers où l'application a le droit d'écrire. Dans Kubernetes,
# des volumes temporaires (emptyDir) y seront montés.
RUN mkdir -p tmp log \
 && chown rails:rails tmp log

# Réglages par défaut, que Kubernetes peut remplacer :
#   RAILS_ENV           : environnement Rails (sandbox et staging le remplacent)
#   RAILS_LOG_TO_STDOUT : le journal de Rails part sur la sortie standard (Loki)
#   HOME                : dossier personnel de rails (Bundler y écrit), dans le volume tmp/
#   TMPDIR              : fichiers temporaires de Ruby, au lieu de /tmp en lecture seule
#   GNUPGHOME           : trousseau de clés GPG, dans un dossier où l'on peut écrire
#   MALLOC_ARENA_MAX    : limite la consommation mémoire de Ruby avec plusieurs threads
# HOME, TMPDIR et GNUPGHOME sont des sous-dossiers créés au démarrage par
# bin/docker-entrypoint : ils appartiennent à rails, contrairement au volume
# lui-même, que Ruby refuse comme dossier temporaire s'il est ouvert à tous.
ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    HOME=/app/tmp/home \
    TMPDIR=/app/tmp/files \
    GNUPGHOME=/app/tmp/gnupg \
    MALLOC_ARENA_MAX=2

USER 1000:1000

# Port d'écoute de Puma (cf. config/puma.rb). Simple indication : c'est le
# Service Kubernetes qui décide de ce qui est réellement exposé.
EXPOSE 3000

# Au démarrage : le script prépare les dossiers de travail, puis lance la
# commande par défaut ci-dessous (remplaçable, ex. « bin/rails console »).
ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
