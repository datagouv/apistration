# Checklists d'audit accessibilité

Checklists rapides par type de page pour la review de code. Cocher chaque point avant de merger.

---

## Checklist universelle (toute page)

### Structure et sémantique
- [ ] `<html lang="fr">` présent
- [ ] `<title>` unique et descriptif (format : « Titre de page — DataPass »)
- [ ] Un seul `<h1>` par page
- [ ] Hiérarchie de titres cohérente (pas de saut h1→h3)
- [ ] Landmarks présents : `<header>`, `<nav>`, `<main>`, `<footer>`
- [ ] Plusieurs `<nav>` → chacun a un `aria-label` distinct
- [ ] Liens d'évitement en premier élément du `<body>`

### Images
- [ ] Toute `<img>` a un attribut `alt`
- [ ] Images décoratives : `alt=""` suffit (`role="presentation"` est inutile)
- [ ] Images porteuses de sens : `alt` décrit le contenu (pas le nom de fichier)
- [ ] `<svg>` décoratifs : `aria-hidden="true" focusable="false"`
- [ ] Icônes DSFR dans boutons : `aria-hidden="true"` + label sur le bouton

### Navigation clavier
- [ ] Tous les éléments interactifs sont atteignables au clavier (Tab)
- [ ] Focus visible sur tous les éléments focusables
- [ ] Ordre de focus logique (suit le flux visuel)
- [ ] Pas de `outline: none` sans alternative visible

### Couleurs et contrastes
- [ ] Texte courant : ratio ≥ 4.5:1
- [ ] Grand texte (≥ 18pt ou 14pt gras) : ratio ≥ 3:1
- [ ] Composants UI (bordures champs, boutons) : ratio ≥ 3:1
- [ ] Aucune info transmise uniquement par la couleur

### Liens
- [ ] Intitulé explicite hors contexte (pas de « Cliquez ici », « En savoir plus »)
- [ ] Liens ambigus → complétés avec `fr-sr-only`
- [ ] Liens externes → `target="_blank"` + `title="... - nouvelle fenêtre"` + `rel="noopener external"`
- [ ] Liens de téléchargement → format + poids dans `fr-link__detail`

---

## Checklist — Page formulaire

### Labels et champs
- [ ] Chaque champ a un `<label for="id">` associé (ou `aria-labelledby`)
- [ ] Pas de placeholder comme seul label (disparaît à la saisie)
- [ ] Champs obligatoires : `aria-required="true"` + indication visuelle en début de formulaire
- [ ] Groupes de champs liés (radio, checkbox) : `<fieldset>` + `<legend>`
- [ ] Indications de format dans `fr-hint-text` (lié via `aria-describedby`)

### Erreurs
- [ ] Erreurs identifiées individuellement (pas juste « Le formulaire contient des erreurs »)
- [ ] Message d'erreur suggère une correction (ex: « Format attendu : JJ/MM/AAAA »)
- [ ] Champ en erreur : `aria-invalid="true"` + `aria-describedby` pointant vers le message
- [ ] Message d'erreur : `role="alert"` ou `aria-live="polite"` si ajouté dynamiquement
- [ ] Le focus revient sur le premier champ en erreur après soumission

### Bouton de soumission
- [ ] Intitulé explicite (pas juste « Envoyer »)
- [ ] État désactivé (`disabled`) indique pourquoi si possible
- [ ] Loading state annoncé aux lecteurs d'écran (`aria-busy`, `aria-live`)

### Autocomplete
- [ ] Champs de données personnelles ont `autocomplete` approprié :
  - `autocomplete="given-name"` / `family-name`
  - `autocomplete="email"`
  - `autocomplete="tel"`
  - `autocomplete="organization"`

---

## Checklist — Page liste / tableau

### Tableaux de données
- [ ] `<caption>` présent et descriptif
- [ ] En-têtes `<th>` avec `scope="col"` ou `scope="row"`
- [ ] Pas de tableau pour la mise en page (utiliser CSS)
- [ ] Tableau complexe → `headers` + `id` sur les cellules

### Liste de résultats
- [ ] Nombre de résultats annoncé (`aria-live="polite"` si filtrage dynamique)
- [ ] Filtres/tri → changement annoncé aux lecteurs d'écran
- [ ] État vide explicite et accessible

### Pagination
- [ ] `<nav aria-label="Pagination">` entoure la pagination
- [ ] Page courante : `aria-current="page"`
- [ ] Liens de page : `aria-label="Page 3"` (pas juste « 3 »)
- [ ] Liens précédent/suivant : `aria-label` explicite

### Tri de tableau
- [ ] Colonne triée : `aria-sort="ascending"` ou `"descending"` sur le `<th>`
- [ ] Colonne triable mais non triée : `aria-sort="none"`
- [ ] Changement de tri annoncé (ex: `aria-live="polite"`)

---

## Checklist — Composants dynamiques

### Modale
- [ ] `role="dialog"` + `aria-modal="true"`
- [ ] `aria-labelledby` pointant vers le titre de la modale
- [ ] Focus piégé dans la modale (Tab cycle)
- [ ] `Escape` ferme la modale
- [ ] À la fermeture : focus revient sur l'élément déclencheur
- [ ] Contenu derrière la modale : `aria-hidden="true"`

### Menu / Dropdown
- [ ] Bouton déclencheur : `aria-expanded` + `aria-controls`
- [ ] Navigation dans le menu : flèches haut/bas
- [ ] `Escape` ferme le menu
- [ ] Focus revient sur le bouton déclencheur à la fermeture

### Onglets
- [ ] `role="tablist"` sur le conteneur + `aria-label`
- [ ] `role="tab"` + `aria-selected` + `aria-controls` sur chaque onglet
- [ ] `role="tabpanel"` + `aria-labelledby` sur chaque panneau
- [ ] Navigation : flèches gauche/droite entre onglets
- [ ] Panneau inactif : `hidden` ou `tabindex="-1"`

### Accordéon
- [ ] Bouton : `aria-expanded` + `aria-controls`
- [ ] Zone contrôlée : `id` correspondant + `hidden` si fermée
- [ ] Titre `hx` cohérent avec la hiérarchie de la page

### Notifications dynamiques
- [ ] Succès/info → `role="status"` (implique `aria-live="polite"` — pas besoin de l'ajouter)
- [ ] Erreur/avertissement → `role="alert"` (implique `aria-live="assertive"` — pas besoin de l'ajouter)
- [ ] Type indiqué textuellement dans le contenu (pas uniquement par icône/couleur)
- [ ] Pas de toast qui disparaît automatiquement

---

## Checklist — Médias

### Images complexes (graphiques, diagrammes)
- [ ] `alt` court + description longue dans `<figcaption>` ou `aria-describedby`

### Vidéo
- [ ] Sous-titres (`<track kind="captions">`)
- [ ] Transcription textuelle disponible
- [ ] Audiodescription si le contenu visuel est informatif
- [ ] Contrôles accessibles au clavier

### Audio
- [ ] Transcription textuelle disponible
- [ ] Pas de lecture automatique (ou bouton pause en premier élément)

---

## Checklist — Animations et mouvements (RGAA 13.7 / 13.8)

- [ ] `prefers-reduced-motion` respecté — toutes les animations s'arrêtent
- [ ] Pas de contenu clignotant > 3 fois/seconde (RGAA 13.7)
- [ ] Tout contenu animé > 5s : bouton pause visible et accessible au clavier
- [ ] Pas de `<meta http-equiv="refresh">` sans contrôle utilisateur (RGAA 13.8)
- [ ] Contenu mis à jour automatiquement (flux, tableau) : bouton pause ou fréquence contrôlable
- [ ] Le changement annoncé aux lecteurs d'écran via `role="status"` après rafraîchissement

---

## Checklist — Text Spacing (WCAG 1.4.12)

**Pourquoi** : les utilisateurs qui modifient l'espacement de texte (dyslexie, malvoyance) ne doivent pas perdre de contenu.

**Test avec le bookmarklet** — coller dans la barre d'adresse :

```javascript
javascript:(function(){const s=document.createElement('style');s.innerHTML='* { line-height: 1.5 !important; letter-spacing: 0.12em !important; word-spacing: 0.16em !important; } p { margin-bottom: 2em !important; }';document.head.appendChild(s);})();
```

### Ce qui doit rester intact après modification d'espacement
- [ ] Aucun texte tronqué ou coupé
- [ ] Aucun chevauchement de texte
- [ ] Aucune perte de fonctionnalité (boutons, liens toujours cliquables)
- [ ] Les formulaires restent utilisables

### CSS à éviter (cause des problèmes au text spacing)
```css
/* ❌ Hauteur fixe sur conteneur de texte */
.card { height: 120px; overflow: hidden; }

/* ✅ Hauteur minimale */
.card { min-height: 120px; height: auto; }

/* ❌ Taille de texte fixe en px */
font-size: 12px;

/* ✅ Taille relative */
font-size: 0.75rem;
```

---

## Checklist — Focus Not Obscured (WCAG 2.4.11)

- [ ] Tab à travers toute la page : chaque élément focusé est 100 % visible
- [ ] Pas masqué par un header sticky (ajouter `scroll-padding-top` si nécessaire)
- [ ] Pas masqué par un cookie banner, chat widget ou modale
- [ ] Les éléments en bas de page ne sont pas masqués par un footer sticky

Voir [colors.md](colors.md) §Focus Not Obscured pour le CSS.

---

## Checklist — Target Size (WCAG 2.5.8)

- [ ] Tout élément cliquable fait ≥ 24×24 CSS px (DevTools → taille calculée)
- [ ] Boutons-icônes DSFR (`fr-btn--close`, `fr-btn--icon-only`) : vérifier la taille
- [ ] Liens de pagination : vérifier la taille
- [ ] Tags et badges cliquables : vérifier la taille
- [ ] Sur mobile (pointer: coarse) : recommandé ≥ 44×44 CSS px

---

## Checklist — Zoom 200% (RGAA 10.4 / WCAG 1.4.4)

**Comment tester** : `Cmd++` (macOS) ou `Ctrl++` (Windows) × 6 dans le navigateur pour atteindre 200%.

### Contenu et mise en page
- [ ] Aucun texte coupé ou tronqué (`overflow: hidden` sans hauteur fixe)
- [ ] Pas de scroll horizontal apparu (sauf contenu qui en nécessite un, ex: tableau large)
- [ ] Tous les textes restent lisibles (pas de chevauchement)
- [ ] Les formulaires restent utilisables (labels et champs alignés ou empilés)
- [ ] Les modales et overlays restent accessibles et fermables
- [ ] Les menus déroulants restent dans la fenêtre (pas coupés hors-écran)

### CSS à éviter
```css
/* ❌ Hauteur fixe en px sur des conteneurs de texte */
.card { height: 120px; overflow: hidden; }

/* ✅ Hauteur minimale + auto */
.card { min-height: 120px; height: auto; }

/* ❌ Taille de texte fixe en px */
font-size: 12px;

/* ✅ Taille relative (rem ou em) */
font-size: 0.75rem; /* = 12px si base 16px, mais s'adapte aux préférences */

/* ❌ Positionnement absolu qui peut se chevaucher au zoom */
.tooltip { position: absolute; top: 30px; }

/* ✅ Préférer position: relative avec overflow visible */
```

### Responsive et zoom
```css
/* Toujours inclure viewport meta sans user-scalable=no */
/* ❌ Bloque le zoom navigateur */
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">

/* ✅ Autorise le zoom */
<meta name="viewport" content="width=device-width, initial-scale=1">
```

### Niveaux de zoom à tester
| Zoom | Raccourci | Équivalent |
|------|-----------|------------|
| 100% | Ctrl+0 / Cmd+0 | Base |
| 150% | Ctrl++ × 3 | Malvoyance légère |
| **200%** | Ctrl++ × 6 | **Seuil RGAA obligatoire** |
| 400% | Ctrl++ × 12 | WCAG 1.4.10 (reflow) |

> **WCAG 1.4.10 Reflow (niveau AA)** : à 400% de zoom (320px de large), tout le contenu doit être accessible sans scroll horizontal. C'est l'équivalent d'un affichage mobile en portrait.