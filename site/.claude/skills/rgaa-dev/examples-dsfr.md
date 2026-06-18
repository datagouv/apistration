# Exemples de code accessibles — DSFR

> Exemples utilisant le **Système de Design de l'État (DSFR)**.
> Pour des exemples HTML/WCAG/ARIA sans DSFR → voir [examples-html.md](examples-html.md)

---

## Règles DSFR spécifiques

### Icônes `fr-icon-*`
```html
<!-- Icône seule dans un bouton : label sur le bouton, aria-hidden sur l'icône -->
<button type="button" aria-label="Supprimer le fichier rapport.pdf">
  <span class="fr-icon-delete-line" aria-hidden="true"></span>
</button>

<!-- Icône + texte : aria-hidden suffit, le texte porte l'information -->
<button type="button">
  <span class="fr-icon-add-line" aria-hidden="true"></span>
  Ajouter un document
</button>
```

### Alertes — `role` uniquement, pas `aria-live`
```html
<!-- role="alert" implique aria-live="assertive" — ne pas combiner -->
<div class="fr-alert fr-alert--error" role="alert">
  <p class="fr-alert__title">Erreur de connexion</p>
</div>

<!-- role="status" implique aria-live="polite" — ne pas combiner -->
<div class="fr-alert fr-alert--success" role="status">
  <p class="fr-alert__title">Modifications enregistrées</p>
</div>
```

### Badges — texte explicite obligatoire
```html
<!-- ❌ Information transmise uniquement par la couleur -->
<span class="fr-badge fr-badge--success">✓</span>

<!-- ✅ Texte explicite (RGAA 3.1) -->
<span class="fr-badge fr-badge--success">Validée</span>
```

### Upload de fichiers
```html
<div class="fr-upload-group">
  <label class="fr-label" for="doc-upload">
    Justificatif
    <span class="fr-hint-text">PDF, DOC — 10 Mo max</span>
  </label>
  <input class="fr-upload" type="file" id="doc-upload" name="document"
         accept=".pdf,.doc,.docx"
         aria-describedby="doc-hint">
  <p id="doc-hint" class="fr-hint-text">
    Formats acceptés : PDF, DOC, DOCX. Taille maximale : 10 Mo.
  </p>
</div>
```

### Modale DSFR — ne pas réimplémenter le focus trap
Le DSFR gère le focus trap nativement via l'élément `<dialog>`. Ne pas ajouter un JS custom.
Ajouter uniquement `aria-labelledby` et `aria-modal="true"` (voir §Composants dynamiques → Modale).

---

## Liens

### Lien externe
Quand le lien redirige vers un site externe, il doit s'ouvrir dans une nouvelle fenêtre.

```html
<a href="https://example.com" target="_blank" rel="noopener external"
   title="Libellé lien - nouvelle fenêtre" class="fr-link">
  Libellé lien
</a>
```

**Pourquoi :**
- `target="_blank"` ouvre dans un nouvel onglet
- `title="... - nouvelle fenêtre"` prévient l'utilisateur au survol/focus
- `rel="noopener external"` : sécurité (empêche accès à `window.opener`) + sémantique

### Lien de téléchargement
```html
<!-- Fichier standard -->
<a download href="document.pdf" class="fr-link fr-link--download">
  Télécharger le document lorem ipsum
  <span class="fr-link__detail">PDF – 1,81 Mo</span>
</a>

<!-- Fichier en langue étrangère -->
<a hreflang="en" download href="report.pdf" class="fr-link fr-link--download">
  Télécharger le rapport
  <span class="fr-link__detail">PDF – 2,4 Mo - Anglais</span>
</a>

<!-- Détail auto-rempli en JS (DSFR) -->
<a download href="document.pdf" class="fr-link fr-link--download"
   data-fr-assess-file>
  Télécharger le document
  <span class="fr-link__detail"></span>
</a>
```

### Lien au fil du texte
Ne pas utiliser la classe `fr-link` dans les paragraphes de texte.

```html
<p>Consulter la <a href="/documentation">documentation complète</a> pour en savoir plus.</p>
```

### Groupe de liens
```html
<!-- Liste de liens (ensemble logique) -->
<ul class="fr-links-group">
  <li><a href="/mentions-legales" class="fr-link">Mentions légales</a></li>
  <li><a href="/accessibilite" class="fr-link">Accessibilité</a></li>
  <li><a href="/donnees-personnelles" class="fr-link">Données personnelles</a></li>
</ul>

<!-- Liens indépendants (pas de liste) -->
<div class="fr-links-group">
  <a href="/connexion" class="fr-link">Se connecter</a>
  <a href="/inscription" class="fr-link">S'inscrire</a>
</div>
```

### Lien avec intitulé complété pour les lecteurs d'écran
```html
<!-- Quand l'intitulé visuel est ambigu -->
<a href="/habilitations/123">
  Consulter
  <span class="fr-sr-only"> l'habilitation API Particulier — DINUM</span>
</a>
```

---

## Boutons

### Bouton avec icône uniquement
```html
<button type="button" aria-label="Supprimer l'habilitation API Particulier">
  <svg aria-hidden="true" focusable="false">
    <use href="#fr-icon-delete-line"></use>
  </svg>
</button>
```

### Bouton toggle (expand/collapse)
```html
<button type="button" aria-expanded="false" aria-controls="details-id">
  Voir les détails
</button>
<div id="details-id" hidden>
  <p>Contenu des détails...</p>
</div>
```

```javascript
// JS pour synchroniser aria-expanded
button.addEventListener('click', () => {
  const expanded = button.getAttribute('aria-expanded') === 'true'
  button.setAttribute('aria-expanded', !expanded)
  content.hidden = expanded
})
```

---

## Formulaires

### Champ texte complet
```html
<div class="fr-input-group">
  <label class="fr-label" for="nom">
    Nom de famille
    <span class="fr-hint-text">Tel qu'il apparaît sur vos documents officiels</span>
  </label>
  <input class="fr-input" type="text" id="nom" name="nom"
         autocomplete="family-name"
         aria-required="true"
         aria-describedby="nom-error">
  <p id="nom-error" class="fr-error-text" role="alert" hidden>
    Veuillez saisir votre nom de famille.
  </p>
</div>
```

### Champ avec erreur visible
```html
<div class="fr-input-group fr-input-group--error">
  <label class="fr-label" for="email">Adresse e-mail</label>
  <input class="fr-input fr-input--error" type="email" id="email" name="email"
         aria-invalid="true"
         aria-describedby="email-error"
         value="adresse-invalide">
  <p id="email-error" class="fr-error-text" role="alert">
    Le format de l'adresse e-mail est invalide. Exemple : nom@domaine.fr
  </p>
</div>
```

### Champ avec succès
```html
<div class="fr-input-group fr-input-group--valid">
  <label class="fr-label" for="siret">Numéro SIRET</label>
  <input class="fr-input fr-input--valid" type="text" id="siret" name="siret"
         aria-describedby="siret-valid">
  <p id="siret-valid" class="fr-valid-text">
    Numéro SIRET valide — INSEE
  </p>
</div>
```

### Select accessible
```html
<div class="fr-select-group">
  <label class="fr-label" for="region">
    Région
    <span class="fr-hint-text">Sélectionnez votre région de rattachement</span>
  </label>
  <select class="fr-select" id="region" name="region" aria-required="true">
    <option value="" disabled selected>Sélectionner une option</option>
    <option value="idf">Île-de-France</option>
    <option value="ara">Auvergne-Rhône-Alpes</option>
  </select>
</div>
```

### Checkbox et radio
```html
<!-- Groupe de checkboxes -->
<fieldset class="fr-fieldset">
  <legend class="fr-fieldset__legend">
    Types de données demandées
    <span class="fr-hint-text">Cochez tout ce qui s'applique</span>
  </legend>
  <div class="fr-fieldset__content">
    <div class="fr-checkbox-group">
      <input type="checkbox" id="donnees-identite" name="donnees[]" value="identite">
      <label class="fr-label" for="donnees-identite">Identité</label>
    </div>
    <div class="fr-checkbox-group">
      <input type="checkbox" id="donnees-adresse" name="donnees[]" value="adresse">
      <label class="fr-label" for="donnees-adresse">Adresse</label>
    </div>
  </div>
</fieldset>

<!-- Groupe de boutons radio -->
<fieldset class="fr-fieldset">
  <legend class="fr-fieldset__legend">Fréquence d'appels</legend>
  <div class="fr-fieldset__content">
    <div class="fr-radio-group">
      <input type="radio" id="freq-faible" name="frequence" value="faible">
      <label class="fr-label" for="freq-faible">Moins de 100 appels/jour</label>
    </div>
    <div class="fr-radio-group">
      <input type="radio" id="freq-eleve" name="frequence" value="eleve">
      <label class="fr-label" for="freq-eleve">Plus de 100 appels/jour</label>
    </div>
  </div>
</fieldset>
```

---

## Navigation et structure

### Liens d'évitement
```html
<!-- Premier élément du <body> -->
<div class="fr-skiplinks">
  <nav class="fr-container" aria-label="Accès rapide">
    <ul class="fr-skiplinks__list">
      <li>
        <a class="fr-link fr-skiplinks__link" href="#content">
          Contenu
        </a>
      </li>
      <li>
        <a class="fr-link fr-skiplinks__link" href="#navigation">
          Menu
        </a>
      </li>
      <li>
        <a class="fr-link fr-skiplinks__link" href="#footer">
          Pied de page
        </a>
      </li>
    </ul>
  </nav>
</div>
```

### Pagination accessible
```html
<nav role="navigation" aria-label="Pagination">
  <ul class="fr-pagination__list">
    <li>
      <a class="fr-pagination__link fr-pagination__link--prev"
         href="/habilitations?page=1" aria-label="Page précédente">
        Page précédente
      </a>
    </li>
    <li>
      <a class="fr-pagination__link" href="/habilitations?page=1"
         aria-label="Page 1">1</a>
    </li>
    <li>
      <a class="fr-pagination__link" aria-current="page"
         href="/habilitations?page=2" aria-label="Page 2, page actuelle">2</a>
    </li>
    <li>
      <a class="fr-pagination__link" href="/habilitations?page=3"
         aria-label="Page 3">3</a>
    </li>
    <li>
      <a class="fr-pagination__link fr-pagination__link--next"
         href="/habilitations?page=3" aria-label="Page suivante">
        Page suivante
      </a>
    </li>
  </ul>
</nav>
```

---

## Composants dynamiques

### Notification / Toast
```html
<!-- role="status" implique aria-live="polite" — inutile de les combiner -->
<div role="status" aria-atomic="true">
  Vos modifications ont été sauvegardées.
</div>

<!-- role="alert" implique aria-live="assertive" — inutile de les combiner -->
<div role="alert" aria-atomic="true">
  Erreur : impossible de sauvegarder. Vérifiez votre connexion.
</div>
```

### Modale (Dialog)
```html
<dialog id="confirm-delete" aria-labelledby="dialog-title"
        aria-describedby="dialog-desc" aria-modal="true">
  <div class="fr-modal__body">
    <div class="fr-modal__header">
      <button class="fr-btn--close fr-btn" aria-controls="confirm-delete"
              title="Fermer la fenêtre modale">
        Fermer
      </button>
    </div>
    <div class="fr-modal__content">
      <h1 class="fr-modal__title" id="dialog-title">
        Supprimer l'habilitation
      </h1>
      <p id="dialog-desc">
        Cette action est irréversible. L'habilitation sera définitivement supprimée.
      </p>
    </div>
    <div class="fr-modal__footer">
      <button type="button" class="fr-btn fr-btn--secondary"
              aria-controls="confirm-delete">
        Annuler
      </button>
      <button type="button" class="fr-btn fr-btn--danger">
        Confirmer la suppression
      </button>
    </div>
  </div>
</dialog>
```

### Onglets
```html
<div class="fr-tabs">
  <ul class="fr-tabs__list" role="tablist" aria-label="Sections de l'habilitation">
    <li role="presentation">
      <button class="fr-tabs__tab" role="tab"
              aria-selected="true" aria-controls="panel-general" id="tab-general">
        Informations générales
      </button>
    </li>
    <li role="presentation">
      <button class="fr-tabs__tab" role="tab"
              aria-selected="false" aria-controls="panel-donnees" id="tab-donnees">
        Données demandées
      </button>
    </li>
  </ul>
  <div id="panel-general" class="fr-tabs__panel fr-tabs__panel--selected"
       role="tabpanel" aria-labelledby="tab-general">
    <!-- Contenu onglet 1 -->
  </div>
  <div id="panel-donnees" class="fr-tabs__panel"
       role="tabpanel" aria-labelledby="tab-donnees" hidden>
    <!-- Contenu onglet 2 -->
  </div>
</div>
```

### Accordéon
```html
<section class="fr-accordion">
  <h3 class="fr-accordion__title">
    <button class="fr-accordion__btn" aria-expanded="false"
            aria-controls="accordion-content-1">
      Cadre juridique
    </button>
  </h3>
  <div class="fr-collapse" id="accordion-content-1">
    <p>Contenu de l'accordéon...</p>
  </div>
</section>
```

---

## Tableaux

### Tableau complexe avec en-têtes multiples
```html
<table>
  <caption>
    Historique des demandes d'habilitation
    <span class="fr-hint-text">Triées par date de modification décroissante</span>
  </caption>
  <thead>
    <tr>
      <th scope="col">Intitulé</th>
      <th scope="col">API</th>
      <th scope="col">
        Statut
        <button aria-label="Trier par statut" aria-sort="none">↕</button>
      </th>
      <th scope="col">Dernière modification</th>
      <th scope="col"><span class="fr-sr-only">Actions</span></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Habilitation DINUM 2024</th>
      <td>API Particulier</td>
      <td>
        <span class="fr-badge fr-badge--success">Validée</span>
        <span class="fr-sr-only">Validée</span>
      </td>
      <td>
        <time datetime="2024-03-15">15 mars 2024</time>
      </td>
      <td>
        <a href="/habilitations/1" class="fr-link">
          Consulter
          <span class="fr-sr-only"> l'habilitation DINUM 2024</span>
        </a>
      </td>
    </tr>
  </tbody>
</table>
```

---

## Images et médias

### Image complexe avec description longue
```html
<!-- Graphique avec description détaillée -->
<figure>
  <img src="graphique-stats.png"
       alt="Graphique des habilitations par mois"
       aria-describedby="graphique-desc">
  <figcaption id="graphique-desc">
    En 2024, les habilitations ont augmenté de 45% entre janvier (120) et
    décembre (174), avec un pic en juin (198).
  </figcaption>
</figure>
```

### Vidéo accessible
```html
<video controls aria-label="Tutoriel de demande d'habilitation">
  <source src="tutoriel.mp4" type="video/mp4">
  <track kind="captions" src="captions-fr.vtt" srclang="fr"
         label="Sous-titres français" default>
  <track kind="descriptions" src="descriptions-fr.vtt" srclang="fr"
         label="Audiodescription">
  <p>
    Votre navigateur ne supporte pas la vidéo HTML5.
    <a href="tutoriel.mp4" download>Télécharger la vidéo</a>
  </p>
</video>
```

---

## Cas limites

### Composant tiers non accessible — stratégie de contournement
Quand un composant tiers n'expose pas les bonnes API ARIA, encapsuler avec un wrapper accessible.

```html
<!-- Composant tiers opaque (ex: datepicker JS) -->
<div class="date-picker-wrapper">
  <label for="date-accessible">Date de début</label>
  <!-- Champ natif visible et accessible en backup -->
  <input type="date" id="date-accessible" name="date_start"
         aria-describedby="date-hint">
  <p id="date-hint" class="fr-hint-text">Format : JJ/MM/AAAA</p>
  <!-- Composant tiers caché aux AT si non accessible -->
  <div aria-hidden="true" class="fancy-datepicker">...</div>
</div>
```

### Filtrage dynamique avec annonce du nombre de résultats
```html
<!-- Zone de recherche -->
<div role="search">
  <label for="search-input">Rechercher une habilitation</label>
  <input type="search" id="search-input"
         aria-controls="results-list"
         aria-describedby="results-count">
</div>

<!-- Annonce du nombre de résultats (mis à jour en JS) -->
<p id="results-count" role="status" aria-live="polite" aria-atomic="true">
  12 habilitations trouvées
</p>

<!-- Liste de résultats -->
<ul id="results-list">...</ul>
```

```javascript
// Mettre à jour après filtrage
function updateResults (count) {
  document.getElementById('results-count').textContent =
    `${count} habilitation${count > 1 ? 's' : ''} trouvée${count > 1 ? 's' : ''}`
}
```

### Chargement asynchrone (Turbo / fetch)
```html
<!-- Indiquer le chargement -->
<div aria-live="polite" aria-busy="true" id="content-area">
  <p class="fr-sr-only">Chargement en cours…</p>
</div>

<!-- Une fois chargé -->
<div aria-live="polite" aria-busy="false" id="content-area">
  <!-- Nouveau contenu -->
</div>
```

```javascript
// Avec Turbo
document.addEventListener('turbo:before-fetch-request', () => {
  document.getElementById('content-area').setAttribute('aria-busy', 'true')
})
document.addEventListener('turbo:render', () => {
  document.getElementById('content-area').setAttribute('aria-busy', 'false')
})
```

### Bouton de suppression dans une liste — context explicite
```html
<!-- Problème : "Supprimer" répété est ambigu pour les lecteurs d'écran -->
<ul>
  <li>
    Habilitation API Particulier
    <button type="button">Supprimer</button> <!-- ❌ ambigu -->
  </li>
  <li>
    Habilitation API Entreprise
    <button type="button">Supprimer</button> <!-- ❌ ambigu -->
  </li>
</ul>

<!-- Solution 1 : aria-label -->
<button type="button"
        aria-label="Supprimer l'habilitation API Particulier">
  Supprimer
</button>

<!-- Solution 2 : fr-sr-only (visible à l'écran + lecteur d'écran) -->
<button type="button">
  Supprimer
  <span class="fr-sr-only"> l'habilitation API Particulier</span>
</button>

<!-- Solution 3 : aria-describedby (intitulé + contexte séparés) -->
<li id="hab-1">
  <span id="hab-1-name">Habilitation API Particulier</span>
  <button type="button" aria-describedby="hab-1-name">Supprimer</button>
</li>
```

### Tableau avec actions par ligne — colonne « Actions »
```html
<table>
  <thead>
    <tr>
      <th scope="col">Intitulé</th>
      <th scope="col">
        <!-- « Actions » visible uniquement pour lecteurs d'écran -->
        <span class="fr-sr-only">Actions disponibles</span>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row" id="row-hab-1">API Particulier — DINUM</th>
      <td>
        <a href="/habilitations/1" aria-describedby="row-hab-1">Consulter</a>
        <button type="button" aria-describedby="row-hab-1">Modifier</button>
      </td>
    </tr>
  </tbody>
</table>
```

### État de chargement d'un bouton (submit)
```html
<!-- État initial -->
<button type="submit" id="submit-btn">
  Soumettre la demande
</button>

<!-- État chargement (en JS après clic) -->
<button type="submit" id="submit-btn"
        aria-disabled="true"
        aria-describedby="submit-status">
  <span class="fr-icon-refresh-line" aria-hidden="true"></span>
  Envoi en cours…
</button>
<span id="submit-status" class="fr-sr-only" role="status" aria-live="polite">
  Envoi de la demande en cours, veuillez patienter.
</span>
```

### Champ de recherche avec suggestions (autocomplete/combobox)
Pattern ARIA 1.2 : `role="combobox"` directement sur l'`<input>` (pas sur un div wrapper).

```erb
<%# ERB — avec Stimulus controller combobox %>
<div data-controller="combobox">
  <label for="search-org">Organisation</label>
  <input type="text" id="search-org"
         role="combobox"
         aria-expanded="false"
         aria-autocomplete="list"
         aria-controls="suggestions-list"
         aria-activedescendant=""
         autocomplete="off"
         data-combobox-target="input"
         data-action="input->combobox#search keydown->combobox#navigate">

  <ul id="suggestions-list"
      role="listbox"
      aria-label="Suggestions d'organisations"
      data-combobox-target="listbox"
      hidden>
    <%# Rempli dynamiquement par le controller %>
  </ul>
</div>
```

```javascript
// app/javascript/controllers/combobox_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'listbox', 'option']

  connect () {
    this.selectedIndex = -1
  }

  async search () {
    const query = this.inputTarget.value.trim()
    if (query.length < 2) { this.close(); return }

    const response = await fetch(`/search?q=${encodeURIComponent(query)}`, {
      headers: { Accept: 'application/json' }
    })
    const results = await response.json()
    this.renderOptions(results)
    this.open()
  }

  renderOptions (results) {
    this.listboxTarget.innerHTML = results.map((r, i) =>
      `<li role="option" id="opt-${i}" aria-selected="false"
           data-combobox-target="option"
           data-action="click->combobox#selectOption">${r.label}</li>`
    ).join('')
    this.selectedIndex = -1
  }

  open () {
    this.inputTarget.setAttribute('aria-expanded', 'true')
    this.listboxTarget.hidden = false
  }

  close () {
    this.inputTarget.setAttribute('aria-expanded', 'false')
    this.listboxTarget.hidden = true
    this.selectedIndex = -1
    this.inputTarget.removeAttribute('aria-activedescendant')
  }

  navigate (event) {
    const options = this.optionTargets
    if (!options.length) return

    if (event.key === 'ArrowDown') {
      event.preventDefault()
      this.selectedIndex = Math.min(this.selectedIndex + 1, options.length - 1)
    } else if (event.key === 'ArrowUp') {
      event.preventDefault()
      this.selectedIndex = Math.max(this.selectedIndex - 1, 0)
    } else if (event.key === 'Enter' && this.selectedIndex >= 0) {
      event.preventDefault()
      this.selectOption({ currentTarget: options[this.selectedIndex] })
      return
    } else if (event.key === 'Escape') {
      this.close()
      return
    } else {
      return
    }

    options.forEach((opt, i) => {
      opt.setAttribute('aria-selected', i === this.selectedIndex)
    })
    this.inputTarget.setAttribute(
      'aria-activedescendant',
      options[this.selectedIndex]?.id || ''
    )
  }

  selectOption (event) {
    this.inputTarget.value = event.currentTarget.textContent.trim()
    this.close()
    this.inputTarget.focus()
  }
}
```

### Erreurs de formulaire — récapitulatif en haut de page
```html
<!-- Après soumission avec erreurs -->
<div role="alert" aria-labelledby="error-summary-title" class="fr-alert fr-alert--error">
  <h2 id="error-summary-title" class="fr-alert__title">
    Erreur — 3 problèmes à corriger
  </h2>
  <ul>
    <li><a href="#nom">Le nom de famille est obligatoire</a></li>
    <li><a href="#email">L'adresse e-mail est invalide</a></li>
    <li><a href="#siret">Le numéro SIRET doit comporter 14 chiffres</a></li>
  </ul>
</div>

<!-- Les liens pointent vers les champs en erreur -->
<div class="fr-input-group fr-input-group--error">
  <label class="fr-label" for="nom">Nom de famille</label>
  <input class="fr-input fr-input--error" type="text" id="nom"
         aria-invalid="true" aria-describedby="nom-error">
  <p id="nom-error" class="fr-error-text">Le nom de famille est obligatoire</p>
</div>
```

### Navigation : menu actif avec aria-current
```html
<nav aria-label="Navigation principale">
  <ul>
    <li>
      <a href="/habilitations" aria-current="page"
         class="fr-nav__link">
        Habilitations
      </a>
    </li>
    <li>
      <a href="/profil" class="fr-nav__link">Mon profil</a>
    </li>
  </ul>
</nav>

<!-- Sous-menu : aria-current="true" sur le parent si enfant actif -->
<nav aria-label="Navigation principale">
  <ul>
    <li>
      <button aria-expanded="true" aria-current="true">
        Habilitations
      </button>
      <ul>
        <li><a href="/habilitations" aria-current="page">Liste</a></li>
        <li><a href="/habilitations/new">Nouvelle demande</a></li>
      </ul>
    </li>
  </ul>
</nav>
```

### Skeleton loading accessible
```html
<!-- Pendant le chargement -->
<div aria-busy="true" aria-label="Chargement de la liste des habilitations">
  <div class="skeleton-row" aria-hidden="true"></div>
  <div class="skeleton-row" aria-hidden="true"></div>
  <div class="skeleton-row" aria-hidden="true"></div>
</div>

<!-- Une fois chargé (remplace le skeleton) -->
<div aria-busy="false">
  <table>...</table>
</div>
```

---

## Stepper multi-étapes

### Barre de progression DSFR (`fr-stepper`)

```erb
<%# Progression accessible — DSFR stepper %>
<div class="fr-stepper">
  <h2 class="fr-stepper__title">
    <span class="fr-stepper__state">Étape <%= step %> sur <%= total_steps %></span>
    <%= step_title %>
  </h2>
  <% if next_step_title.present? %>
    <p class="fr-stepper__details">
      <span class="fr-text--bold">Étape suivante :</span> <%= next_step_title %>
    </p>
  <% end %>
  <div class="fr-stepper__steps"
       data-fr-current-step="<%= step %>"
       data-fr-steps="<%= total_steps %>"
       role="progressbar"
       aria-valuenow="<%= step %>"
       aria-valuemin="1"
       aria-valuemax="<%= total_steps %>"
       aria-label="Progression : étape <%= step %> sur <%= total_steps %>">
  </div>
</div>
```

### Focus management entre étapes

Quand Turbo remplace le contenu d'une étape, le focus doit aller sur le titre `<h1>` ou `<h2>` de la nouvelle étape.

```erb
<%# Titre de l'étape — tabindex="-1" permet de recevoir le focus programmatique %>
<h1 id="step-title" tabindex="-1" class="fr-h4">
  <%= step_title %>
</h1>
```

```javascript
// app/javascript/controllers/stepper_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    // Déplace le focus sur le titre de l'étape à chaque navigation Turbo
    document.addEventListener('turbo:render', this.focusStepTitle.bind(this))
  }

  disconnect () {
    document.removeEventListener('turbo:render', this.focusStepTitle.bind(this))
  }

  focusStepTitle () {
    const title = document.getElementById('step-title')
    title?.focus()
  }
}
```

```erb
<%# Wrapper de la page step — attache le controller %>
<div data-controller="stepper">
  <%= render 'stepper_progress', step:, total_steps:, next_step_title: %>
  <h1 id="step-title" tabindex="-1"><%= step_title %></h1>
  <%= render "steps/#{step}" %>
</div>
```

---

## Tableau triable

### Pattern complet avec `aria-sort` et annonce live

`aria-sort` se place sur le `<th>`, pas sur le bouton. Valeurs : `ascending`, `descending`, `none`.

```erb
<%# Annonce aux lecteurs d'écran après tri %>
<div role="status" aria-live="polite" aria-atomic="true" class="fr-sr-only" id="sort-announcement">
  <%= @sort_announcement %>
</div>

<table>
  <caption>Liste des demandes</caption>
  <thead>
    <tr>
      <th scope="col" <%= aria_sort_for(:intitule, @sort_column, @sort_direction) %>>
        <%= sort_link_for(:intitule, 'Intitulé') %>
      </th>
      <th scope="col" <%= aria_sort_for(:date, @sort_column, @sort_direction) %>>
        <%= sort_link_for(:date, 'Date') %>
      </th>
      <th scope="col">Statut</th>
      <th scope="col"><span class="fr-sr-only">Actions</span></th>
    </tr>
  </thead>
  <tbody>
    <% @resources.each do |resource| %>
      <tr>
        <th scope="row"><%= resource.title %></th>
        <td><time datetime="<%= resource.created_at.iso8601 %>"><%= l(resource.created_at, format: :short) %></time></td>
        <td><span class="fr-badge fr-badge--<%= resource.status_color %>"><%= resource.status_label %></span></td>
        <td>
          <a href="<%= resource_path(resource) %>">
            Consulter
            <span class="fr-sr-only"> <%= resource.title %></span>
          </a>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>
```

**Helper `aria_sort_for`** — voir `rails-patterns.md` §Tri de tableau accessible.