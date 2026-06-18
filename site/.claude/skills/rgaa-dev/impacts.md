# Impacts des défauts d'accessibilité par type de handicap

Source : https://ideance-a11y.github.io/rgaa4-impacts-utilisateurs/

## Cécité et malvoyance sévère

**Outils** : Lecteurs d'écran (NVDA, JAWS, VoiceOver, TalkBack)

| Défaut | Impact |
|--------|--------|
| Image sans `alt` | L'image est ignorée ou le nom de fichier est lu (incompréhensible) |
| Lien "Cliquez ici" | Impossible de comprendre la destination sans lire le contexte entier |
| Formulaire sans `<label>` | Le champ est annoncé sans indication de son rôle |
| Tableau sans `scope`/`headers` | Les données sont lues sans contexte de colonne/ligne |
| Contenu dynamique sans `aria-live` | Les mises à jour ne sont pas annoncées |
| Modale sans piège à focus | Le focus s'échappe de la modale, le contenu derrière est accessible |
| Titre absent ou mal hiérarchisé | Impossible de naviguer par titres (raccourci lecteur d'écran) |
| Landmark absent | Impossible de sauter à la zone de contenu souhaitée |

## Malvoyance (vision partielle, basse vision)

**Outils** : Agrandisseurs d'écran (ZoomText), zoom navigateur (200-400%)

| Défaut | Impact |
|--------|--------|
| Contraste insuffisant (< 4.5:1) | Texte illisible ou très difficile à lire |
| Mise en page cassée au zoom | Contenu coupé, superposé, inaccessible |
| Info transmise uniquement par couleur | Invisible pour personnes daltoniennes |
| Texte en image | Ne peut pas être agrandi/refonté par les outils d'assistance |
| Taille de cible trop petite (< 44x44px) | Difficile à cliquer/toucher avec précision réduite |

## Daltonisme

| Défaut | Impact |
|--------|--------|
| Statut en rouge/vert sans autre indicateur | Impossible de distinguer succès/erreur |
| Graphique sans légende textuelle | Les catégories sont indistinguables |
| Lien distingué uniquement par la couleur | Impossible de l'identifier dans le texte |

## Handicap moteur (navigation clavier uniquement)

**Outils** : Clavier seul, contacteurs, eye-tracking

| Défaut | Impact |
|--------|--------|
| Focus non visible (`outline: none`) | Impossible de savoir où on est dans la page |
| Composant non accessible au clavier | Fonctionnalité inaccessible |
| Ordre de focus incohérent | Navigation confuse, impossible de comprendre le parcours |
| Pas de liens d'évitement | Obligé de traverser toute la navigation à chaque page |
| Piège à focus non géré (modale) | Impossible de sortir du composant |
| Zones de clic trop petites | Impossible d'activer avec précision limitée |

## Troubles cognitifs et dyslexie

| Défaut | Impact |
|--------|--------|
| Messages d'erreur vagues ("Erreur 422") | Impossible de comprendre quoi corriger |
| Pas de suggestion de correction | Obligé de deviner le format attendu |
| Session expirée sans avertissement | Perte de données saisies, stress |
| Mise en page instable (animations) | Perturbation, maux de tête, déconcentration |
| Vocabulaire complexe ou jargon | Incompréhension |
| Absence de structure (titres, listes) | Lecture linéaire obligatoire, surcharge cognitive |

## Surdité et malentendance

| Défaut | Impact |
|--------|--------|
| Vidéo sans sous-titres | Contenu inaccessible |
| Audio sans transcription | Contenu inaccessible |
| Alerte sonore sans équivalent visuel | Information manquée |
| Langue complexe | Certaines personnes sourdes ont le français écrit comme seconde langue |

## Épilepsie et sensibilité aux animations

| Défaut | Impact |
|--------|--------|
| Contenu clignotant > 3 fois/seconde | Risque de crise épileptique |
| Animation impossible à désactiver | Nausées, vertiges, crise |

```css
/* Respecter la préférence système */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Priorités de correction (ratio impact/effort)

### Priorité 1 — Bloquant total pour certains utilisateurs
- Alternatives textuelles aux images informatives
- Labels sur tous les champs de formulaire
- Accessibilité clavier de tous les composants interactifs
- Focus visible
- Liens d'évitement

### Priorité 2 — Difficultés majeures
- Contraste texte ≥ 4.5:1
- Hiérarchie de titres cohérente
- Messages d'erreur explicites avec suggestion
- `aria-live` pour les mises à jour dynamiques
- Structure landmarks (nav, main, header, footer)

### Priorité 3 — Amélioration significative
- Breadcrumb / fil d'Ariane
- `aria-current="page"` sur la navigation
- Descriptions longues pour contenus complexes (graphiques)
- Sous-titres vidéo
- `prefers-reduced-motion`