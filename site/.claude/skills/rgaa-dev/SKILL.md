---
name: rgaa-dev
description: |
  Accessibilité numérique (a11y) — RGAA 4.1.2 / WCAG 2.2 AA / WAI-ARIA 1.2.
  Invoquer quand le code concerne : HTML sémantique, ARIA, formulaires (label,
  erreur, autocomplete, stepper), liens, navigation, composants interactifs
  (modale, onglets, accordéon, dropdown, tooltip, upload, combobox),
  ViewComponent, Stimulus, Turbo, ERB, contraste, couleurs, focus clavier,
  lecteur d'écran, screen reader, axe-core, zoom 200%, target size,
  RGAA, WCAG, ARIA, a11y, handicap, accessibility.
  Fonctionne avec ou sans DSFR (détection automatique dans le projet).
paths:
  - "app/views/**/*.erb"
  - "app/components/**/*.rb"
  - "app/components/**/*.erb"
  - "app/javascript/**/*.js"
  - "app/helpers/**/*.rb"
---

# Accessibilité Numérique — Guide RGAA / WCAG / ARIA

> **Versions couvertes** : RGAA 4.1.2 · WCAG 2.2 (AA) · DSFR 1.x · WAI-ARIA 1.2
> **Dernière mise à jour** : avril 2026

---

> **Navigation** : utiliser des Read ciblés (offset/limit). Ne pas faire de grep exploratoire — les tableaux de ce fichier font foi sur les sections à consulter.

## Détection du contexte projet

Avant de produire du code, détecter si le projet utilise le DSFR :
1. Rechercher des classes `fr-*` dans `app/views/**` ou `app/components/**`
2. Vérifier `package.json` pour `@gouvfr/dsfr`
3. Vérifier `Gemfile` pour `DSFRFormBuilder`

**DSFR détecté** → utiliser `examples-dsfr.md` et les classes `fr-*` / `fr-sr-only`.
**DSFR absent** → utiliser `examples-html.md` et la classe `.sr-only` (CSS custom).
En cas de doute, demander à l'utilisateur.

---

## Quel fichier lire selon la tâche

| Tâche | Fichiers à consulter |
|-------|----------------------|
| Créer/modifier un formulaire | [rgaa-themes.md](rgaa-themes.md) §Formulaires + [examples-dsfr.md](examples-dsfr.md) §Formulaires + [rails-patterns.md](rails-patterns.md) §DSFRFormBuilder |
| Créer un composant interactif (modale, onglets, accordéon, tooltip, combobox) | [examples-dsfr.md](examples-dsfr.md) + [examples-html.md](examples-html.md) §ARIA + [rails-patterns.md](rails-patterns.md) §Stimulus |
| Formulaire multi-étapes (stepper) | [examples-dsfr.md](examples-dsfr.md) §Stepper + [rails-patterns.md](rails-patterns.md) §Redundant Entry |
| Créer/modifier de la navigation ou des liens | [rgaa-themes.md](rgaa-themes.md) §Navigation + [examples-dsfr.md](examples-dsfr.md) §Liens |
| Tableau triable / filtrable | [examples-dsfr.md](examples-dsfr.md) §Tableau triable + [rails-patterns.md](rails-patterns.md) |
| Liste filtrée / recherche dynamique (annonce de résultats, live region) | [examples-dsfr.md](examples-dsfr.md) §Filtrage dynamique (+ §Champ de recherche avec suggestions si autocomplete) |
| Auditer ou faire la review d'une page | [checklist.md](checklist.md) du type de page + [html-structure.md](html-structure.md) §Outils |
| Travailler avec Turbo / Hotwire | [rails-patterns.md](rails-patterns.md) §Turbo |
| Question sur contrastes, target size, focus | [colors.md](colors.md) |
| Question sur upload de fichiers | [examples-dsfr.md](examples-dsfr.md) §Upload |
| Comprendre l'impact d'un défaut | [impacts.md](impacts.md) |
| Critères RGAA par thème avec exemples | [rgaa-themes.md](rgaa-themes.md) |
| *(si DSFR)* Règles spécifiques composants DSFR | [examples-dsfr.md](examples-dsfr.md) §Règles DSFR |
| Composant tiers, PDF, vidéo, charge disproportionnée | [fallbacks.md](fallbacks.md) |
| Ressources, outils, déclaration | [resources.md](resources.md) |

---

## Workflow quotidien — accessibility-first

Applique l'accessibilité **pendant** l'implémentation, pas après :

1. **Structure HTML sémantique d'abord** — titres, landmarks, listes, éléments natifs
2. **Attributs ARIA sur les éléments interactifs** — `aria-expanded`, `aria-controls`, labels
3. **Checklist du type de page** avant le commit — [checklist.md](checklist.md)
4. **Test clavier rapide** — Tab, Shift+Tab, Enter, Escape, flèches dans les composants
5. **Test zoom 200%** — `Cmd++` × 6, vérifier qu'aucun contenu n'est coupé
6. **axe-core en CI** — les steps Cucumber `Then la page est accessible` détectent les régressions

---

## Contexte légal

Le **RGAA 4.1.2** est le standard légal français basé sur **WCAG 2.2** du W3C. Il s'applique à tous les services publics numériques (loi 2005-102, décret 2019-768). L'**European Accessibility Act (EAA)** rend WCAG 2.2 AA obligatoire dans l'UE depuis le 28 juin 2025.

Non-conformité = exclusion réelle :
- Cécité / malvoyance → lecteurs d'écran (NVDA, JAWS, VoiceOver)
- Motricité réduite → navigation clavier uniquement
- Surdité → sous-titres, transcriptions
- Troubles cognitifs → clarté, structure, prévisibilité

---

## Règles d'or

1. **Tout élément interactif est accessible au clavier** (Tab, Enter, Espace, flèches)
2. **Tout contenu non-textuel a un équivalent textuel** (`alt`, `aria-label`, `aria-labelledby`)
3. **Le focus est toujours visible et non masqué** (ne jamais faire `outline: none` sans alternative, et ne pas masquer avec un header sticky)
4. **Les couleurs ne sont pas le seul vecteur d'information** (contraste ≥ 4.5:1, target size ≥ 24×24px)
5. **La structure sémantique est correcte** (titres hiérarchiques, landmarks, listes)
6. **Les formulaires sont labellisés** (`<label for>` ou `aria-labelledby`)
7. **Les erreurs sont identifiées** et suggèrent une correction
8. **Le contenu peut être agrandi à 200%** sans perte d'information (RGAA 10.4)

## Règles des 5 ARIA (W3C)

1. Utiliser le HTML natif en premier — pas d'ARIA si un élément sémantique natif existe
2. Ne pas modifier la sémantique native inutilement
3. Tous les contrôles ARIA doivent être utilisables au clavier
4. Les éléments focusables ont un rôle, état et propriété visibles
5. Les éléments interactifs ont un nom accessible

---

## Anti-patterns ARIA — À ne jamais faire

```html
<!-- ❌ tabindex > 0 : casse l'ordre naturel de navigation -->
<button tabindex="3">Soumettre</button>

<!-- ❌ <div> cliquable : pas de rôle, pas de clavier -->
<div onclick="submit()">Envoyer</div>
<!-- ✅ --> <button type="button">Envoyer</button>

<!-- ❌ aria-label ≠ texte visible (viole WCAG 2.5.3 Label in Name) -->
<button aria-label="Supprimer">Enlever</button>
<!-- ✅ aria-label doit contenir le texte visible -->
<button aria-label="Supprimer le fichier rapport.pdf">Supprimer</button>

<!-- ❌ role="presentation" sur élément interactif -->
<button role="presentation">Valider</button>

<!-- ❌ role="alert" + aria-live="assertive" : redondant -->
<div role="alert" aria-live="assertive">Erreur</div>
<!-- ✅ role="alert" implique déjà aria-live="assertive" -->
<div role="alert">Erreur</div>
```

## Patterns ARIA essentiels

| Pattern | Role | States/Properties clés |
|---------|------|------------------------|
| Bouton toggle | `button` | `aria-expanded`, `aria-controls` |
| Menu déroulant | `menu`, `menuitem` | `aria-haspopup`, `aria-expanded` |
| Onglets | `tablist`, `tab`, `tabpanel` | `aria-selected`, `aria-controls` |
| Accordéon | `button` | `aria-expanded`, `aria-controls` |
| Modal | `dialog` | `aria-modal`, `aria-labelledby` |
| Alerte | `alert` | `aria-live="assertive"` implicite |
| Statut | `status` | `aria-live="polite"` implicite |
| Combobox | `combobox` | `aria-expanded`, `aria-autocomplete`, `aria-activedescendant` |
| Barre de progression | `progressbar` | `aria-valuenow`, `aria-valuemin`, `aria-valuemax` |
| Tooltip | `tooltip` | `aria-describedby` |
| Stepper | `progressbar` ou `nav` | `aria-current="step"`, `aria-valuenow` |

**Référence complète** : https://www.w3.org/WAI/ARIA/apg/

---

## Navigation clavier — Comportements attendus

| Touche | Comportement |
|--------|-------------|
| `Tab` | Passer au prochain élément focusable |
| `Shift+Tab` | Élément focusable précédent |
| `Enter` | Activer lien/bouton |
| `Espace` | Activer bouton/checkbox |
| `Flèches` | Naviguer dans composants (menu, tabs, select, combobox) |
| `Escape` | Fermer modal/menu/tooltip |
| `Home`/`End` | Premier/dernier élément d'une liste |

**Piège à focus** : Les modales doivent piéger le focus (tab cycle dans la modale). Voir [examples-html.md](examples-html.md) §Modale.

---

## Texte pour lecteurs d'écran uniquement

```css
/* DSFR : fr-sr-only  |  Universel : .sr-only */
.sr-only, .fr-sr-only {
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

```html
<!-- Utilisation : compléter un intitulé ambigu -->
<button>
  <span aria-hidden="true">✕</span>
  <span class="fr-sr-only">Fermer la modale</span>
</button>
```

---

## Fichiers de ce skill

| Fichier | Contenu |
|---------|---------|
| `rgaa-themes.md` | Critères RGAA par thème avec exemples de code |
| `examples-dsfr.md` | Exemples HTML+DSFR + règles spécifiques DSFR |
| `examples-html.md` | Référence universelle HTML/WCAG/ARIA sans framework |
| `checklist.md` | Checklists par type de page + zoom + text spacing |
| `rails-patterns.md` | ERB, DSFRFormBuilder, ViewComponent, Stimulus, Turbo, axe-core |
| `colors.md` | Contrastes, target size, focus, tokens DSFR, outils |
| `fallbacks.md` | Alternatives quand l'idéal est impossible — charge disproportionnée, PDF, vidéo, composants tiers |
| `html-structure.md` | Titres, landmarks, erreurs Rails fréquentes, DevTools |
| `resources.md` | Liens RGAA/WCAG 2.2/ARIA, outils, déclaration |
| `impacts.md` | Impact des défauts par type de handicap |