# Contrastes et couleurs — RGAA / WCAG 2.1

## Ratios minimaux (RGAA 3.2 / WCAG 1.4.3 et 1.4.11)

| Contexte | Ratio minimum | Critère RGAA |
|----------|---------------|--------------|
| Texte normal (< 18pt ou < 14pt gras) | **4.5:1** | 3.2 |
| Grand texte (≥ 18pt ou ≥ 14pt gras) | **3:1** | 3.2 |
| Texte sur image | **4.5:1** (ou 3:1 si grand texte) | 3.2 |
| Composants UI actifs (bordures champs, boutons) | **3:1** | 3.3 |
| Icônes informatives | **3:1** | 3.3 |
| États focus (outline) | **3:1** sur fond adjacent | 3.3 |
| Texte désactivé (`disabled`) | Exempté | — |
| Logos / texte décoratif | Exempté | — |

> **Rappel** : Le ratio se calcule entre la couleur du texte et la couleur de fond immédiat.
> Un ratio de 21:1 = noir sur blanc (maximum). Un ratio de 1:1 = couleurs identiques.

---

## Tokens DSFR — contrastes garantis en thème clair

Le DSFR garantit les contrastes en **thème clair** pour ses tokens de couleur. En **thème sombre**, certains états au survol sont insuffisants (ex: accordéon en survol ouvert = 2.6:1).

### Textes
| Token DSFR | Usage | Contraste sur blanc |
|------------|-------|---------------------|
| `--text-default-grey` | Texte courant | ~12:1 |
| `--text-mention-grey` | Texte secondaire | ~5.5:1 |
| `--text-disabled-grey` | Texte désactivé | < 3:1 (exempté) |
| `--text-action-high-blue-france` | Liens | ~4.8:1 |

### À éviter sans vérification
```css
/* ❌ Ces combinaisons risquent d'être insuffisantes */
color: var(--text-mention-grey); /* ~5.5:1 ok, mais vérifier le fond */
background: var(--background-alt-grey); /* fond légèrement gris → recalculer */

/* ✅ Combinaisons sûres */
color: var(--text-default-grey); /* sur fond blanc ou --background-default-grey */
```

---

## Règle : couleur seule ≠ information (RGAA 3.1)

Ne jamais transmettre une information **uniquement** par la couleur. Toujours ajouter un second vecteur.

```html
<!-- ❌ Erreur uniquement par couleur (bordure rouge) -->
<input type="text" class="input-error"> <!-- bordure rouge en CSS -->

<!-- ✅ Erreur avec couleur + icône + texte -->
<div class="fr-input-group fr-input-group--error">
  <input class="fr-input fr-input--error" aria-invalid="true">
  <p class="fr-error-text">
    <!-- Le DSFR ajoute une icône via CSS ::before, le texte est le vecteur principal -->
    Veuillez remplir ce champ.
  </p>
</div>

<!-- ❌ Statut uniquement par couleur de badge -->
<span class="fr-badge fr-badge--success">✓</span>

<!-- ✅ Statut avec texte explicite -->
<span class="fr-badge fr-badge--success">Validée</span>

<!-- ❌ Graphique avec légende uniquement par couleur -->
<canvas id="chart"></canvas>
<ul class="legend">
  <li><span style="color: green"></span> Validées</li>
  <li><span style="color: red"></span> Refusées</li>
</ul>

<!-- ✅ Graphique avec motifs + couleurs + légende textuelle -->
<canvas id="chart" aria-label="Répartition des habilitations par statut">
  <!-- Utiliser Chart.js avec patterns en plus des couleurs -->
</canvas>
<p>En 2024 : 145 validées (72%), 34 refusées (17%), 22 en attente (11%).</p>
```

---

## Cas limites fréquents

### Texte sur image de fond
```css
/* ❌ Risque : contraste non garanti selon l'image */
.hero {
  background-image: url('photo.jpg');
  color: white;
}

/* ✅ Ajouter un overlay semi-opaque pour garantir le contraste */
.hero::before {
  content: '';
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.6); /* overlay sombre */
}
/* Ou utiliser text-shadow */
.hero-text {
  text-shadow: 0 0 8px rgba(0,0,0,0.8);
}
```

### Placeholder de champ de formulaire
```css
/* Les placeholders sont souvent trop clairs */
input::placeholder {
  /* ❌ Valeur navigateur par défaut ≈ 3:1 (insuffisant pour texte normal) */
  color: #6c757d; /* ratio ~4.6:1 sur blanc → limite, à vérifier */
}

/* Le DSFR gère cela via --text-mention-grey (~5.5:1) */
```

### Focus outline
```css
/* ❌ Supprimer le focus sans alternative */
:focus { outline: none; }

/* ✅ Focus DSFR (géré automatiquement) */
/* Le DSFR utilise un outline bleu (#0a76f6) de 2px avec offset */
/* Ne jamais écraser sans remplacer par une alternative visible */

/* ✅ Focus personnalisé conforme */
:focus-visible {
  outline: 2px solid #0a76f6;
  outline-offset: 2px;
}
```

### Liens dans du texte — distinction sans couleur seule
```css
/* ❌ Lien distingué uniquement par la couleur (RGAA 3.1) */
a { color: blue; text-decoration: none; }

/* ✅ Lien distingué par couleur + soulignement (défaut navigateur) */
a { color: #0a76f6; text-decoration: underline; }

/* ✅ Alternative : couleur + bordure inférieure toujours visible */
a {
  color: #0a76f6;
  border-bottom: 1px solid currentColor;
}
```

### Mode sombre (prefers-color-scheme)
```css
@media (prefers-color-scheme: dark) {
  /* Recalculer tous les contrastes — les tokens DSFR le font automatiquement */
  /* Si vous ajoutez des couleurs custom, revérifier chaque contraste */
}
```

### Graphiques Chart.js — accessibilité couleur
```javascript
// Palettes accessibles pour daltoniens (éviter rouge/vert seuls)
const accessibleColors = [
  '#0a76f6', // bleu
  '#f95c5e', // rouge-rose
  '#ffca00', // jaune
  '#009081', // teal
  '#8585f6', // violet
]

// Ajouter des patterns en plus des couleurs
// Bibliothèque : chartjs-plugin-datalabels ou patternomaly
import pattern from 'patternomaly'

const datasets = data.map((d, i) => ({
  backgroundColor: pattern.draw(['circle', 'dash', 'cross', 'zigzag'][i % 4], accessibleColors[i % accessibleColors.length]),
}))
```

---

## Outils de test des contrastes

### Outils en local (recommandés)

| Outil | Plateforme | Usage |
|-------|------------|-------|
| **Colour Contrast Analyser** (TPGi) | macOS / Windows | Pipette sur n'importe quel pixel de l'écran — le plus fiable pour tester le rendu réel |
| **Colour Contrast Checker** (Paciello Group) | macOS / Windows | Vérification rapide par valeurs hex/RGB |

**Téléchargement** : https://www.tpgi.com/color-contrast-checker/

### Extensions navigateur

| Extension | Navigateur | Usage |
|-----------|------------|-------|
| **axe DevTools** | Chrome / Firefox | Audit global incluant contrastes |
| **WAVE** | Chrome / Firefox | Visualisation des erreurs de contraste en overlay |
| **Colour Contrast Analyser** | Chrome | Pipette dans le navigateur |
| **Accessible Color Picker** | Chrome | Suggère des couleurs conformes à partir d'une couleur donnée |

### Outils en ligne

| Outil | URL | Points forts |
|-------|-----|--------------|
| **WebAIM Contrast Checker** | https://webaim.org/resources/contrastchecker/ | Simple, référence WCAG AA/AAA |
| **Coolors Contrast Checker** | https://coolors.co/contrast-checker | Interface claire, palettes |
| **Accessible Colors** | https://accessible-colors.com/ | Suggère la couleur la plus proche conforme |
| **Who Can Use** | https://www.whocanuse.com/ | Simule l'impact par type de déficience visuelle |
| **Contrast Ratio** (Lea Verou) | https://contrast-ratio.com/ | Calcul live, supporte rgba/hsla |
| **APCA Contrast Calculator** | https://www.myndex.com/APCA/ | Algorithme WCAG 3.0 (futur standard) |

### Dans les DevTools Chrome / Firefox

```
1. Ouvrir DevTools → Inspecter un élément texte
2. Cliquer sur la pastille de couleur dans "color:" (panneau Styles)
3. Le ratio de contraste s'affiche directement
4. Indicateurs : ✓ AA (4.5:1) / ✓ AAA (7:1)
```

```
DevTools → Rendering → Emulate vision deficiency :
- Blurred vision
- Protanopia (rouge-vert)
- Deuteranopia (rouge-vert, plus fréquent)
- Tritanopia (bleu-jaune)
- Achromatopsia (monochromie)
```

### Dans Figma (design)

- Plugin **Contrast** (Figma) : vérifie automatiquement les couches sélectionnées
- Plugin **A11y - Color Contrast Checker** : audit du fichier entier
- Plugin **Stark** : audit complet (contraste + simulation daltonisme)

---

## Vérification rapide en CSS (dev only)

```css
/* Snippet à ajouter temporairement pour détecter les problèmes */
/* Signale les éléments avec outline: none sans :focus-visible */
*:focus:not(:focus-visible) { outline: 2px solid orange !important; }
*:focus-visible { outline: 2px solid lime !important; }
```

```javascript
// Console DevTools — lister tous les textes avec contraste insuffisant (via axe-core)
// Installer axe-core : https://github.com/dequelabs/axe-core
const results = await axe.run({ runOnly: ['color-contrast'] })
console.table(results.violations.flatMap(v => v.nodes.map(n => ({
  element: n.target[0],
  message: n.failureSummary
}))))
```

---

---

## Target Size — WCAG 2.5.8 (AA, WCAG 2.2)

Taille minimale de cible interactive : **24×24 CSS px** (sauf si inline dans un texte ou si l'espacement compense).
Recommandé pour le tactile : **44×44 CSS px** (WCAG 2.5.5 AAA + bonne pratique mobile).

```css
/* Garantit 24×24 minimum sur boutons-icônes, tags, pagination */
.fr-btn--icon-only,
.fr-btn--close,
.fr-pagination__link,
.fr-tag--sm {
  min-width: 24px;
  min-height: 24px;
}

/* Recommandé : 44×44 sur écrans tactiles */
@media (pointer: coarse) {
  .fr-btn--icon-only,
  .fr-btn--close,
  .fr-pagination__link {
    min-width: 44px;
    min-height: 44px;
  }
}

/* Exception légitime : lien inline dans un paragraphe */
p a { min-height: auto; }
```

**Test** : DevTools → Inspecter → vérifier que `width` et `height` calculés ≥ 24px sur tout élément cliquable.

---

## Focus Not Obscured — WCAG 2.4.11 (AA, WCAG 2.2)

L'élément ayant le focus ne doit pas être **entièrement masqué** par un élément sticky (header, cookie banner, chat widget).

```css
/* Compenser un header sticky en réservant du scroll-padding */
html {
  scroll-padding-top: 5rem; /* = hauteur du header sticky */
}

/* Marge de scroll autour de l'élément focusé */
:focus-visible {
  scroll-margin-top: 5rem;
  scroll-margin-bottom: 2rem;
}
```

**Test manuel** : Tab à travers la page entière. Chaque élément focusé doit être visible à 100%, non masqué par un header, footer sticky, bannière cookies ou widget.

---

## Checklist couleurs

- [ ] Texte courant : ratio ≥ 4.5:1 vérifié avec un outil (pas estimé)
- [ ] Grand texte (≥ 24px ou ≥ 18.67px gras) : ratio ≥ 3:1
- [ ] Bordures de champs de formulaire : ratio ≥ 3:1 sur le fond
- [ ] Icônes informatives : ratio ≥ 3:1
- [ ] Focus visible : ratio ≥ 3:1 de l'outline sur le fond adjacent
- [ ] Placeholder : ratio ≥ 4.5:1 (souvent insuffisant par défaut)
- [ ] Liens dans texte : distinguables sans la couleur seule (soulignement)
- [ ] Aucune information transmise uniquement par la couleur
- [ ] Mode sombre testé si implémenté
- [ ] Daltonisme simulé (Chrome DevTools → Rendering)