# Exemples de code accessibles — HTML / WCAG / ARIA

> Exemples **sans framework ni design system**. Basés sur les spécifications WCAG 2.1 et WAI-ARIA 1.2.
> Pour les exemples avec DSFR → voir [examples-dsfr.md](examples-dsfr.md)
>
> Références :
> - WCAG 2.1 : https://www.w3.org/TR/WCAG21/
> - WAI-ARIA Authoring Practices : https://www.w3.org/WAI/ARIA/apg/
> - HTML ARIA conformance : https://www.w3.org/TR/html-aria/

---

## Liens

### Lien externe (WCAG 3.2.5 / RGAA 13.2)
Deux approches conformes. La plus robuste inclut un texte visible aux lecteurs d'écran :

```html
<!-- Approche 1 : title seul (accepté par RGAA 13.2, mais title pas toujours vocalisé) -->
<a href="https://example.com" target="_blank" rel="noopener external"
   title="Nom du site - nouvelle fenêtre">
  Nom du site
</a>

<!-- Approche 2 : texte sr-only (plus robuste, recommandée par WCAG) -->
<a href="https://example.com" target="_blank" rel="noopener external">
  Nom du site
  <span class="sr-only"> (nouvelle fenêtre)</span>
</a>

<!-- Approche 3 : icône avec aria-label (si l'icône est la seule indication) -->
<a href="https://example.com" target="_blank" rel="noopener external"
   aria-label="Nom du site, s'ouvre dans une nouvelle fenêtre">
  Nom du site
  <svg aria-hidden="true" focusable="false"><!-- icône external-link --></svg>
</a>
```

```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

### Lien de téléchargement (RGAA 13.3)
```html
<a href="document.pdf" download
   aria-label="Télécharger le rapport annuel (PDF, 1,8 Mo)">
  Télécharger le rapport annuel
  <span aria-hidden="true">(PDF, 1,8 Mo)</span>
</a>

<!-- Fichier en langue étrangère -->
<a href="report.pdf" download hreflang="en"
   aria-label="Download the annual report, PDF 2.4 MB, in English">
  Download the annual report
  <span aria-hidden="true">(PDF, 2.4 MB)</span>
</a>
```

### Lien avec intitulé ambigu (WCAG 2.4.6)
```html
<!-- ❌ Intitulé non explicite hors contexte -->
<a href="/habilitations/1">Consulter</a>

<!-- ✅ Complété avec aria-label -->
<a href="/habilitations/1"
   aria-label="Consulter l'habilitation API Particulier — DINUM">
  Consulter
</a>

<!-- ✅ Complété avec sr-only dans le texte -->
<a href="/habilitations/1">
  Consulter
  <span class="sr-only"> l'habilitation API Particulier — DINUM</span>
</a>

<!-- ✅ Complété avec aria-describedby (intitulé + contexte séparés) -->
<tr>
  <th id="hab-name">API Particulier — DINUM</th>
  <td>
    <a href="/habilitations/1" aria-describedby="hab-name">Consulter</a>
  </td>
</tr>
```

---

## Images (WCAG 1.1.1 / RGAA Thème 1)

```html
<!-- Image informative -->
<img src="logo.png" alt="DataPass — Plateforme de gestion des habilitations">

<!-- Image décorative -->
<img src="decoration.png" alt="">

<!-- Image complexe avec description longue -->
<figure>
  <img src="chart.png"
       alt="Graphique de répartition des habilitations"
       aria-describedby="chart-desc">
  <figcaption id="chart-desc">
    72% validées (145), 17% refusées (34), 11% en attente (22).
  </figcaption>
</figure>

<!-- SVG décoratif -->
<svg aria-hidden="true" focusable="false" width="16" height="16">
  <use href="#icon-arrow"></use>
</svg>

<!-- SVG informatif -->
<svg role="img" aria-labelledby="svg-title">
  <title id="svg-title">Statut : validé</title>
  <use href="#icon-check"></use>
</svg>

<!-- Image-lien : l'alt décrit la destination, pas l'image -->
<a href="/accueil">
  <img src="logo.png" alt="Retour à l'accueil">
</a>
```

---

## Boutons (WCAG 4.1.2)

```html
<!-- Bouton texte -->
<button type="button">Enregistrer les modifications</button>

<!-- Bouton icône seul : aria-label obligatoire -->
<button type="button" aria-label="Fermer la fenêtre">
  <svg aria-hidden="true" focusable="false">
    <use href="#icon-close"></use>
  </svg>
</button>

<!-- Bouton toggle -->
<button type="button" aria-expanded="false" aria-controls="details-id">
  Voir les détails
</button>
<div id="details-id" hidden>
  Contenu des détails
</div>

<!-- Bouton désactivé avec explication -->
<button type="submit" aria-disabled="true" aria-describedby="submit-reason">
  Soumettre
</button>
<p id="submit-reason" class="sr-only">
  Le formulaire contient des erreurs à corriger avant de soumettre.
</p>
```

---

## Formulaires (WCAG 1.3.1, 3.3.1, 3.3.2 / RGAA Thème 11)

### Champ complet avec hint et erreur
```html
<div>
  <label for="email">
    Adresse e-mail
    <span aria-hidden="true">*</span>
  </label>
  <p id="email-hint">Format attendu : nom@domaine.fr</p>
  <input type="email" id="email" name="email"
         required
         aria-required="true"
         aria-describedby="email-hint email-error"
         aria-invalid="true"
         autocomplete="email">
  <p id="email-error" role="alert">
    L'adresse e-mail est invalide. Exemple : nom@domaine.fr
  </p>
</div>

<!-- Note sur les champs obligatoires (en début de formulaire) -->
<p>Les champs marqués d'un <span aria-hidden="true">*</span>
   <span class="sr-only">astérisque</span> sont obligatoires.</p>
```

### Groupe radio / checkbox
```html
<fieldset>
  <legend>Fréquence d'appels <span aria-hidden="true">*</span></legend>
  <div>
    <input type="radio" id="freq-low" name="frequency" value="low" required>
    <label for="freq-low">Moins de 100 appels par jour</label>
  </div>
  <div>
    <input type="radio" id="freq-high" name="frequency" value="high">
    <label for="freq-high">Plus de 100 appels par jour</label>
  </div>
</fieldset>
```

### Récapitulatif d'erreurs (WCAG 3.3.1)
```html
<!-- Placé en haut du formulaire, focus déclenché après soumission -->
<div role="alert" aria-labelledby="error-summary-title" tabindex="-1" id="error-summary">
  <h2 id="error-summary-title">2 erreurs à corriger</h2>
  <ul>
    <li><a href="#email">L'adresse e-mail est obligatoire</a></li>
    <li><a href="#siret">Le SIRET doit comporter 14 chiffres</a></li>
  </ul>
</div>
```

```javascript
// Après soumission avec erreurs
document.getElementById('error-summary').focus()
```

---

## Tableaux (WCAG 1.3.1 / RGAA Thème 5)

### Tableau simple
```html
<table>
  <caption>Habilitations par statut au 1er janvier 2024</caption>
  <thead>
    <tr>
      <th scope="col">Statut</th>
      <th scope="col">Nombre</th>
      <th scope="col">Pourcentage</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Validées</th>
      <td>145</td>
      <td>72 %</td>
    </tr>
  </tbody>
</table>
```

### Tableau complexe avec en-têtes multiples
```html
<table>
  <caption>Budget par département et trimestre</caption>
  <thead>
    <tr>
      <td></td><!-- cellule vide en haut à gauche -->
      <th scope="col" id="q1">T1</th>
      <th scope="col" id="q2">T2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row" id="dep-a">Département A</th>
      <td headers="dep-a q1">10 000 €</td>
      <td headers="dep-a q2">12 000 €</td>
    </tr>
  </tbody>
</table>
```

---

## Navigation (WCAG 2.4 / RGAA Thème 12)

### Liens d'évitement
```html
<!-- Premier élément du body -->
<a href="#main-content" class="skip-link">Aller au contenu principal</a>
<a href="#main-nav" class="skip-link">Aller à la navigation</a>
```

```css
.skip-link {
  position: absolute;
  top: -100%;
  left: 0;
  background: #000;
  color: #fff;
  padding: 0.5rem 1rem;
  z-index: 9999;
}
.skip-link:focus {
  top: 0;
}
```

### Navigation avec aria-current
```html
<nav aria-label="Navigation principale" id="main-nav">
  <ul>
    <li><a href="/" aria-current="page">Accueil</a></li>
    <li><a href="/habilitations">Habilitations</a></li>
    <li><a href="/profil">Mon profil</a></li>
  </ul>
</nav>
```

### Fil d'Ariane (WCAG 2.4.8)
```html
<nav aria-label="Fil d'Ariane">
  <ol>
    <li><a href="/">Accueil</a></li>
    <li><a href="/habilitations">Habilitations</a></li>
    <li aria-current="page">API Particulier — DINUM</li>
  </ol>
</nav>
```

### Pagination
```html
<nav aria-label="Pagination">
  <ul>
    <li>
      <a href="?page=1" aria-label="Page précédente" rel="prev">Précédente</a>
    </li>
    <li><a href="?page=1" aria-label="Page 1">1</a></li>
    <li><a href="?page=2" aria-label="Page 2, page actuelle" aria-current="page">2</a></li>
    <li><a href="?page=3" aria-label="Page 3">3</a></li>
    <li>
      <a href="?page=3" aria-label="Page suivante" rel="next">Suivante</a>
    </li>
  </ul>
</nav>
```

---

## Composants dynamiques — patterns ARIA

### Accordéon (WAI-ARIA APG)
```html
<div>
  <h3>
    <button type="button"
            aria-expanded="false"
            aria-controls="section-1-content"
            id="section-1-header">
      Cadre juridique
    </button>
  </h3>
  <div id="section-1-content"
       role="region"
       aria-labelledby="section-1-header"
       hidden>
    <p>Contenu de la section...</p>
  </div>
</div>
```

### Onglets (WAI-ARIA APG)
```html
<div>
  <div role="tablist" aria-label="Sections de l'habilitation">
    <button role="tab" aria-selected="true"
            aria-controls="panel-general" id="tab-general"
            tabindex="0">
      Informations générales
    </button>
    <button role="tab" aria-selected="false"
            aria-controls="panel-donnees" id="tab-donnees"
            tabindex="-1">
      Données demandées
    </button>
  </div>

  <div role="tabpanel" id="panel-general" aria-labelledby="tab-general">
    <!-- Contenu onglet 1 -->
  </div>
  <div role="tabpanel" id="panel-donnees" aria-labelledby="tab-donnees" hidden>
    <!-- Contenu onglet 2 -->
  </div>
</div>
```

```javascript
// Navigation clavier dans les onglets (flèches)
tablist.addEventListener('keydown', (e) => {
  const tabs = [...tablist.querySelectorAll('[role="tab"]')]
  const current = tabs.indexOf(document.activeElement)

  if (e.key === 'ArrowRight') {
    tabs[(current + 1) % tabs.length].focus()
  } else if (e.key === 'ArrowLeft') {
    tabs[(current - 1 + tabs.length) % tabs.length].focus()
  } else if (e.key === 'Home') {
    tabs[0].focus()
  } else if (e.key === 'End') {
    tabs[tabs.length - 1].focus()
  }
})
```

### Modale / Dialog (WAI-ARIA APG)
```html
<dialog id="confirm-modal"
        aria-labelledby="modal-title"
        aria-describedby="modal-desc">
  <h2 id="modal-title">Supprimer l'habilitation</h2>
  <p id="modal-desc">
    Cette action est irréversible.
  </p>
  <div>
    <button type="button" id="modal-cancel">Annuler</button>
    <button type="button" id="modal-confirm">Confirmer</button>
  </div>
  <button type="button" aria-label="Fermer" id="modal-close">✕</button>
</dialog>
```

```javascript
// Gestion native avec <dialog> (recommandée)
const modal = document.getElementById('confirm-modal')
const trigger = document.getElementById('open-modal')

trigger.addEventListener('click', () => modal.showModal())

modal.addEventListener('close', () => trigger.focus())

// Fermeture sur backdrop
modal.addEventListener('click', (e) => {
  if (e.target === modal) modal.close()
})
```

### Alertes et régions live (WCAG 4.1.3)
```html
<!-- role="alert" = aria-live:"assertive" implicite — pour erreurs urgentes -->
<div role="alert">
  Erreur : impossible de sauvegarder. Vérifiez votre connexion.
</div>

<!-- role="status" = aria-live:"polite" implicite — pour confirmations -->
<div role="status">
  Vos modifications ont été enregistrées.
</div>

<!-- Région live persistente (vide au départ, remplie en JS) -->
<div id="announcer"
     role="status"
     aria-live="polite"
     aria-atomic="true"
     class="sr-only">
</div>
```

```javascript
// Astuce : vider puis remplir pour forcer la vocalisation
function announce (message) {
  const region = document.getElementById('announcer')
  region.textContent = ''
  requestAnimationFrame(() => { region.textContent = message })
}
```

### Menu déroulant / Disclosure (WAI-ARIA APG)
```html
<div>
  <button type="button"
          aria-expanded="false"
          aria-controls="dropdown-menu"
          id="dropdown-trigger">
    Actions
  </button>
  <ul id="dropdown-menu" role="list" hidden>
    <li><a href="/edit">Modifier</a></li>
    <li>
      <button type="button">Supprimer</button>
    </li>
  </ul>
</div>
```

```javascript
const trigger = document.getElementById('dropdown-trigger')
const menu = document.getElementById('dropdown-menu')

trigger.addEventListener('click', () => {
  const expanded = trigger.getAttribute('aria-expanded') === 'true'
  trigger.setAttribute('aria-expanded', !expanded)
  menu.hidden = expanded
})

// Fermeture sur Escape et clic extérieur
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && !menu.hidden) {
    menu.hidden = true
    trigger.setAttribute('aria-expanded', 'false')
    trigger.focus()
  }
})
```

---

## Médias

### Vidéo (WCAG 1.2.x / RGAA Thème 4)
```html
<video controls>
  <source src="video.mp4" type="video/mp4">
  <track kind="captions" src="captions-fr.vtt" srclang="fr"
         label="Sous-titres français" default>
  <track kind="descriptions" src="descriptions-fr.vtt" srclang="fr"
         label="Audiodescription">
  <p>
    Votre navigateur ne supporte pas la vidéo.
    <a href="video.mp4" download>Télécharger la vidéo (MP4, 45 Mo)</a>
  </p>
</video>
<a href="transcription.html">Lire la transcription textuelle</a>
```

### Iframe (RGAA Thème 2)
```html
<!-- iframe informatif : title obligatoire -->
<iframe src="map.html" title="Carte interactive — localisation de nos bureaux"
        width="600" height="400">
</iframe>

<!-- iframe décoratif : title vide + aria-hidden -->
<iframe src="tracking.html" title="" aria-hidden="true" tabindex="-1">
</iframe>
```

---

## Langue (RGAA 8.3, 8.7, 8.8)

```html
<!-- Langue de la page -->
<html lang="fr">

<!-- Passage en langue étrangère -->
<p>Ce rapport suit les principes du <span lang="en">responsive design</span>.</p>

<!-- Changement de langue sur un élément entier -->
<blockquote lang="en">
  <p>"The web is for everyone."</p>
  <footer>— Tim Berners-Lee</footer>
</blockquote>
```

---

## Focus et navigation clavier (WCAG 2.4.3, 2.4.7)

```css
/* Focus visible systématique */
:focus-visible {
  outline: 2px solid #005fcc;
  outline-offset: 2px;
  border-radius: 2px;
}

/* Ne jamais supprimer le focus sans alternative */
/* ❌ */ :focus { outline: none; }
/* ✅ */ :focus:not(:focus-visible) { outline: none; } /* masque le focus souris seulement */
```

```javascript
// Gestion du focus après suppression d'un élément
function deleteItem (item) {
  const next = item.nextElementSibling || item.previousElementSibling
  item.remove()
  next?.focus() ?? document.getElementById('list-container').focus()
}

// tabindex="-1" : permet le focus programmatique sans apparaître dans le tab order
document.getElementById('error-summary').focus()
```

---

## Tooltip accessible (WCAG 1.4.13)

WCAG 1.4.13 impose que tout contenu apparu au survol ou au focus soit :
- **Hoverable** — la souris peut se déplacer dessus sans le faire disparaître
- **Dismissible** — `Escape` le ferme sans déplacer le focus
- **Persistent** — reste visible tant que le focus/survol est actif

```html
<div class="tooltip-wrapper" data-controller="tooltip">
  <button type="button"
          aria-describedby="tip-1"
          data-tooltip-target="trigger"
          data-action="mouseenter->tooltip#show mouseleave->tooltip#startHideDelay
                       focus->tooltip#show blur->tooltip#hide
                       keydown.esc->tooltip#hide">
    Aide
  </button>

  <div id="tip-1"
       role="tooltip"
       data-tooltip-target="content"
       hidden>
    Le format attendu est : JJ/MM/AAAA
  </div>
</div>
```

```css
[role="tooltip"] {
  position: absolute;
  z-index: 100;
  background: #1a1a1a;
  color: #fff;
  padding: 0.5rem 0.75rem;
  border-radius: 4px;
  max-width: 20rem;
  font-size: 0.875rem;
}

[role="tooltip"][hidden] { display: none; }
```

```javascript
// app/javascript/controllers/tooltip_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['trigger', 'content']

  connect () {
    this.hideTimeout = null
  }

  show () {
    clearTimeout(this.hideTimeout)
    this.contentTarget.hidden = false
  }

  hide () {
    this.contentTarget.hidden = true
  }

  startHideDelay () {
    // Délai pour permettre à la souris de se déplacer sur le tooltip (hoverable)
    this.hideTimeout = setTimeout(() => this.hide(), 300)
  }

  // Annule le masquage si la souris entre dans le tooltip
  // Ajouter data-action="mouseenter->tooltip#cancelHide" sur [role="tooltip"]
  cancelHide () {
    clearTimeout(this.hideTimeout)
  }
}
```

**Règles clés :**
- `role="tooltip"` + `aria-describedby` sur le déclencheur — le tooltip complète le label, il ne le remplace pas
- Ne pas mettre d'éléments interactifs (liens, boutons) dans un tooltip — utiliser une modale ou un popover à la place
- Le délai de masquage (`startHideDelay`) est obligatoire pour satisfaire "hoverable"
- `Escape` ferme le tooltip sans déplacer le focus (géré par `keydown.esc->tooltip#hide`)

---

## Animations (WCAG 2.3.3)

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* Mode contraste élevé Windows */
@media (forced-colors: active) {
  /* Vérifier que les indicateurs (focus, bordures) restent visibles */
  :focus-visible {
    outline: 3px solid ButtonText;
  }
}
```