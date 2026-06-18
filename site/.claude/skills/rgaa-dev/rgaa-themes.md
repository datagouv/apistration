# Critères RGAA 4.1.2 — Thèmes et exemples

Référence des 13 thèmes RGAA avec exemples de code.
Pour les exemples avec DSFR → [examples-dsfr.md](examples-dsfr.md)
Pour les exemples universels → [examples-html.md](examples-html.md)

---

## Thème 1 — Images

```html
<!-- Image porteuse de sens -->
<img src="logo.png" alt="Description concise du contenu de l'image">

<!-- Image décorative : alt="" suffit, role="presentation" est inutile -->
<img src="decoration.png" alt="">

<!-- Image-lien : alt décrit la destination, pas l'image -->
<a href="/accueil">
  <img src="logo.png" alt="Retour à l'accueil">
</a>

<!-- SVG décoratif -->
<svg aria-hidden="true" focusable="false">...</svg>

<!-- SVG porteur de sens -->
<svg role="img" aria-labelledby="svg-title">
  <title id="svg-title">Statut : validé</title>
</svg>
```

### 1.8 — Images texte (critère AA)

Ne jamais utiliser une image contenant du texte quand le même rendu peut être obtenu en HTML+CSS. Les images texte ne s'adaptent pas au zoom, aux préférences de contraste ni aux lecteurs d'écran.

```html
<!-- ❌ Texte dans une image (inaccessible, non zoomable, non traduisible) -->
<img src="titre-bienvenue.png" alt="Bienvenue sur DataPass">

<!-- ✅ Texte HTML stylisé -->
<h1 class="fr-h1">Bienvenue sur DataPass</h1>
```

```css
/* Exception légitime : logo d'organisation avec charte graphique imposée -->
/* → fournir un alt descriptif et ne pas dupliquer le texte visible */
```

---

## Thème 2 — Cadres (iframes)

```html
<!-- Tout iframe informatif doit avoir un title descriptif -->
<iframe src="/document-preview"
        title="Prévisualisation du document PDF — Rapport 2024"></iframe>

<!-- iframe décoratif ou utilitaire : title vide + aria-hidden -->
<iframe src="tracking.html" title="" aria-hidden="true" tabindex="-1"
        style="display:none"></iframe>

<!-- iframe vidéo externe (YouTube nocookie) -->
<iframe
  src="https://www.youtube-nocookie.com/embed/ID"
  title="Tutoriel : comment faire une demande d'habilitation"
  allow="autoplay; encrypted-media; fullscreen"
  loading="lazy"
  width="560" height="315">
</iframe>
<p>
  <a href="/transcriptions/tutoriel">Lire la transcription textuelle du tutoriel</a>
</p>
```

```erb
<%# En ERB %>
<iframe src="<%= document_preview_path(@document) %>"
        title="Prévisualisation : <%= @document.filename %>">
</iframe>
<p id="pdf-fallback">
  <a href="<%= @document.url %>" download>
    Télécharger le document (PDF, <%= @document.size_mb %> Mo)
  </a>
</p>
```

---

## Thème 3 — Couleurs

- Contraste texte normal : **≥ 4.5:1**
- Contraste grand texte (≥ 18pt ou 14pt gras) : **≥ 3:1**
- Contraste composants UI (boutons, champs, icônes informatives, outline focus) : **≥ 3:1**
- Ne jamais transmettre une info par la couleur seule (ajouter icône, texte, motif)

Voir [colors.md](colors.md) pour les cas limites, tokens DSFR, target size et outils de test.

---

## Thème 4 — Multimédia

```html
<!-- Vidéo avec sous-titres et audiodescription -->
<video controls aria-label="Tutoriel de demande d'habilitation">
  <source src="tutoriel.mp4" type="video/mp4">
  <track kind="captions" src="captions-fr.vtt" srclang="fr"
         label="Sous-titres français" default>
  <track kind="descriptions" src="descriptions-fr.vtt" srclang="fr"
         label="Audiodescription">
  <p>
    Votre navigateur ne supporte pas la vidéo HTML5.
    <a href="tutoriel.mp4" download>Télécharger la vidéo (MP4)</a>
  </p>
</video>
<a href="/transcriptions/tutoriel">Lire la transcription textuelle</a>

<!-- Audio avec transcription -->
<audio controls aria-label="Message d'accueil">
  <source src="accueil.mp3" type="audio/mpeg">
</audio>
<p><a href="/transcriptions/accueil">Lire la transcription</a></p>
```

**Règles clés :**
- Pas de lecture automatique — ou bouton Pause en premier élément de la page
- Sous-titres obligatoires pour toute vidéo avec parole (critère 4.1)
- Transcription textuelle pour tout contenu audio ou vidéo (critère 4.7)
- Audiodescription si le contenu visuel est informatif et non décrit verbalement (critère 4.3)
- Contrôles du lecteur accessibles au clavier

---

## Thème 5 — Tableaux

```html
<!-- Tableau de données simple -->
<table>
  <caption>Récapitulatif des habilitations par statut</caption>
  <thead>
    <tr>
      <th scope="col">Nom</th>
      <th scope="col">Statut</th>
      <th scope="col">Date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Habilitation A</th>
      <td>Validée</td>
      <td><time datetime="2024-01-15">15 janvier 2024</time></td>
    </tr>
  </tbody>
</table>

<!-- Tableau complexe avec en-têtes multiples -->
<table>
  <caption>Budget par département et trimestre</caption>
  <thead>
    <tr>
      <td></td>
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

Voir [examples-dsfr.md](examples-dsfr.md) §Tableau triable pour le pattern tri interactif ERB complet.

---

## Thème 6 — Liens

**Règles clés :**
- L'intitulé doit être **explicite hors contexte** (pas de « Cliquez ici », « En savoir plus »)
- Lien externe → `target="_blank"` + `title="... - nouvelle fenêtre"` + `rel="noopener external"`
- Lien de téléchargement → indiquer format, poids, langue si différente
- Lien ambigu → compléter avec `.fr-sr-only` ou `.sr-only`
- Distinguer visuellement les liens du texte courant (ne pas supprimer le soulignement)

```html
<!-- Lien ambigu complété -->
<a href="/resources/1">
  Consulter
  <span class="sr-only"> le document Rapport annuel 2024</span>
</a>

<!-- Lien externe -->
<a href="https://example.com" target="_blank" rel="noopener external"
   title="Nom du site - nouvelle fenêtre">
  Nom du site
</a>
```

Voir [examples-html.md](examples-html.md) §Liens et [examples-dsfr.md](examples-dsfr.md) §Liens pour les cas complets.

---

## Thème 7 — Scripts et composants dynamiques

```html
<!-- Bouton toggle -->
<button type="button" aria-expanded="false" aria-controls="menu-id">Menu</button>
<ul id="menu-id" hidden>...</ul>

<!-- Alerte dynamique (role="alert" implique aria-live="assertive") -->
<div role="alert">Message d'erreur critique</div>

<!-- Statut (role="status" implique aria-live="polite") -->
<div role="status">Sauvegarde réussie</div>

<!-- Dialog / Modal -->
<dialog aria-labelledby="dialog-title" aria-describedby="dialog-desc">
  <h2 id="dialog-title">Confirmation</h2>
  <p id="dialog-desc">Voulez-vous supprimer cet élément ?</p>
</dialog>
```

Voir [examples-html.md](examples-html.md) §Composants dynamiques pour les patterns complets (modale, onglets, accordéon, dropdown, combobox, tooltip).

---

## Thème 8 — Éléments obligatoires

```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Titre de la page — Nom du service</title><!-- Unique et pertinent -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Pas de user-scalable=no : bloque le zoom navigateur -->
</head>
```

Changement de langue dans le contenu (RGAA 8.7) :
```html
<p>Ce service respecte le <span lang="en">GDPR compliance framework</span>.</p>
```

---

## Thème 9 — Structuration

```html
<!-- Hiérarchie de titres (jamais sauter un niveau) -->
<h1>Titre principal (1 seul par page)</h1>
  <h2>Section principale</h2>
    <h3>Sous-section</h3>

<!-- Landmarks HTML5 -->
<header>En-tête du site</header>
<nav aria-label="Navigation principale">...</nav>
<main>Contenu principal</main>
<aside aria-label="Informations complémentaires">...</aside>
<footer>Pied de page</footer>
<!-- Si plusieurs <nav> : labels distincts obligatoires -->

<!-- Listes sémantiques -->
<ul><!-- liste non ordonnée --></ul>
<ol><!-- liste ordonnée --></ol>
<dl><dt>Terme</dt><dd>Définition</dd></dl>

<!-- Citations (RGAA 9.5) -->
<blockquote cite="https://source.example.com">
  <p>« Texte de la citation. »</p>
</blockquote>
```

---

## Thème 10 — Présentation de l'information

- **10.1** : ne pas utiliser CSS `content:` pour véhiculer une information textuelle
- **10.7** : le focus clavier est toujours visible
- **10.11** : pas de scroll horizontal à 320px de large (zoom 400%)
- **10.12 (WCAG 1.4.12)** : espacement de texte modifiable sans perte de contenu

```css
/* ❌ Information portée uniquement par CSS */
.required::after { content: ' *'; }

/* ✅ Information dans le HTML */
/* <span aria-hidden="true"> *</span><span class="sr-only">(obligatoire)</span> */

/* ❌ Suppression du focus */
:focus { outline: none; }

/* ✅ Focus personnalisé visible */
:focus-visible { outline: 2px solid #0a76f6; outline-offset: 2px; }
```

Voir [checklist.md](checklist.md) §Text Spacing pour le bookmarklet de test 1.4.12.

---

## Thème 11 — Formulaires

```html
<!-- Label explicite -->
<label for="email">Adresse e-mail <span aria-hidden="true">*</span></label>
<input type="email" id="email" name="email" required
       aria-required="true"
       autocomplete="email"
       aria-describedby="email-hint email-error">
<p id="email-hint">Format : nom@domaine.fr</p>
<p id="email-error" role="alert" hidden>
  Veuillez saisir une adresse e-mail valide.
</p>

<!-- Groupe de champs liés -->
<fieldset>
  <legend>Civilité</legend>
  <label><input type="radio" name="civility" value="m"> M.</label>
  <label><input type="radio" name="civility" value="mme"> Mme</label>
</fieldset>

<!-- Indication champs obligatoires en début de formulaire -->
<p>Les champs marqués d'un <span aria-hidden="true">*</span>
   <span class="sr-only">astérisque</span> sont obligatoires.</p>
```

**WCAG 3.3.7 Redundant Entry** : ne jamais redemander une information déjà saisie dans une étape précédente. Pré-remplir automatiquement depuis les données déjà connues. Voir [rails-patterns.md](rails-patterns.md) §Redundant Entry.

**WCAG 1.3.5 Identify Input Purpose** : attribut `autocomplete` obligatoire sur tout champ collectant les données personnelles de l'utilisateur connecté. Voir [rails-patterns.md](rails-patterns.md) §Autocomplete.

Voir [examples-dsfr.md](examples-dsfr.md) §Formulaires et §Stepper pour les patterns complets.

---

## Thème 12 — Navigation

```html
<!-- Liens d'évitement (premier élément de la page) -->
<nav aria-label="Accès rapide">
  <a href="#main">Aller au contenu principal</a>
  <a href="#nav">Aller à la navigation</a>
</nav>

<!-- Navigation avec aria-current -->
<nav aria-label="Navigation principale">
  <ul>
    <li><a href="/accueil" aria-current="page">Accueil</a></li>
    <li><a href="/resources">Ressources</a></li>
  </ul>
</nav>

<!-- Fil d'Ariane -->
<nav aria-label="Fil d'Ariane">
  <ol>
    <li><a href="/">Accueil</a></li>
    <li><a href="/resources">Ressources</a></li>
    <li aria-current="page">Détail ressource</li>
  </ol>
</nav>
```

---

## Thème 13 — Consultation

### 13.1 Session et limites de temps

```html
<!-- Avertissement d'expiration de session -->
<div id="session-warning" role="alertdialog" aria-modal="true"
     aria-labelledby="session-title" hidden>
  <h2 id="session-title">Votre session va expirer</h2>
  <p>Votre session expire dans <span id="countdown">5</span> minutes.</p>
  <button type="button" id="extend-session">Prolonger la session</button>
</div>
```

### 13.3 / 13.4 — Documents bureautiques (PDF)

Si un PDF est proposé en téléchargement, proposer également une alternative HTML accessible :

```html
<a href="/document.pdf" download class="fr-link fr-link--download">
  Télécharger le rapport
  <span class="fr-link__detail">PDF – 1,2 Mo</span>
</a>
<a href="/document" class="fr-link">
  Consulter la version HTML accessible
</a>
```

Les PDF générés dynamiquement (tickets, attestations) doivent être balisés (ordre de lecture, langue, titres, alternatives textuelles aux images).

### 13.9 — Orientation

```css
/* Ne jamais bloquer l'orientation portrait ou paysage */
/* ❌ */ @media (orientation: portrait) { body { display: none; } }
/* ✅ Le contenu s'adapte aux deux orientations via responsive */
```

### 13.7 / 13.8 — Contenu en mouvement et mise à jour automatique

**13.7** : tout contenu qui bouge, clignote ou défile pendant plus de 5 secondes doit pouvoir être mis en pause, arrêté ou masqué.
**13.8** : tout contenu qui se met à jour automatiquement doit pouvoir être contrôlé par l'utilisateur.

```html
<!-- Carrousel / contenu animé — bouton pause obligatoire (13.7) -->
<div aria-label="Actualités" aria-roledescription="carousel">
  <button type="button" id="carousel-pause" aria-pressed="false">
    <span class="sr-only">Mettre en pause le défilement</span>
    ⏸
  </button>
  <div aria-live="off" id="carousel-slides">
    <!-- slides -->
  </div>
</div>
```

```css
/* Respecter prefers-reduced-motion — arrêter toutes les animations (13.7) */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

```javascript
// Mise à jour automatique — permettre à l'utilisateur de la contrôler (13.8)
// Ex : tableau de données rafraîchi toutes les 30s
const autoRefresh = {
  interval: null,
  paused: false,

  start () {
    this.interval = setInterval(() => this.refresh(), 30_000)
  },

  toggle () {
    this.paused = !this.paused
    this.paused ? clearInterval(this.interval) : this.start()
    document.getElementById('refresh-btn').setAttribute('aria-pressed', this.paused)
  },

  refresh () {
    // fetch et mise à jour du DOM
    // Annoncer aux lecteurs d'écran
    document.getElementById('refresh-status').textContent = 'Données mises à jour.'
  }
}
```

```html
<!-- Bouton de contrôle du rafraîchissement automatique -->
<button type="button" id="refresh-btn" aria-pressed="false"
        onclick="autoRefresh.toggle()">
  Pause du rafraîchissement automatique
</button>
<div id="refresh-status" role="status" class="sr-only"></div>
```

**Règle** : ne jamais utiliser `<meta http-equiv="refresh">` sans offrir une alternative de contrôle. Préférer du JS contrôlable.

### 13.10 / 13.11 — Gestes complexes et actions au pointeur

- Toute fonctionnalité accessible par glisser-déposer doit avoir une alternative (boutons, clavier)
- Les actions au clic sur le `mousedown` doivent être annulables (utiliser `click`, pas `mousedown`)