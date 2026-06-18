# Fallbacks et dérogations — Quand l'idéal n'est pas atteignable

Quand un critère RGAA ne peut pas être satisfait, trois actions sont attendues :
1. Implémenter le meilleur fallback disponible
2. Documenter la non-conformité dans la déclaration d'accessibilité
3. Prévoir une voie de recours (contact, alternative)

---

## Composant tiers non accessible

Un composant JS tiers (datepicker, carte interactive, éditeur riche…) peut ne pas exposer les bonnes API ARIA.

**Stratégie :**
```html
<!-- Cacher le composant non accessible aux technologies d'assistance -->
<div aria-hidden="true" class="fancy-datepicker">
  <!-- composant tiers -->
</div>

<!-- Fournir un champ natif accessible en parallèle -->
<label for="date-native">Date de début</label>
<input type="date" id="date-native" name="date_start"
       aria-describedby="date-hint">
<p id="date-hint" class="fr-hint-text">Format : JJ/MM/AAAA</p>
```

**Si le composant est incontournable et non corrigeable** (widget fourni par un prestataire, SDK externe) :
- Signaler la non-conformité au prestataire
- Documenter dans la déclaration d'accessibilité : critère concerné, impact, date prévue de correction
- Proposer une alternative (formulaire simplifié, contact téléphonique)

---

## Charge disproportionnée (RGAA — dérogation légale)

Le RGAA permet de **déroger** à certains critères si leur mise en conformité représente une charge disproportionnée par rapport aux bénéfices pour les utilisateurs handicapés.

**Ce n'est pas une excuse générale** — c'est une dérogation encadrée légalement qui doit être :
- **Justifiée** par une analyse coût/bénéfice documentée
- **Limitée** dans le temps (plan de mise en conformité)
- **Compensée** par une alternative (contact humain, autre canal)
- **Publiée** dans la déclaration d'accessibilité

**Exemples légitimes :**
- Sous-titrage d'une vidéo d'archive antérieure à 2020 rarement consultée
- Remédiation d'un PDF généré par un système tiers en cours de remplacement
- Composant cartographique complexe sans équivalent accessible disponible

**Exemples non légitimes :**
- « C'est compliqué » / « on n'a pas le temps »
- Contenus publiés après septembre 2020 sans alternative
- Fonctionnalités principales du service

**Dans la déclaration d'accessibilité :**
```
Critère 4.1 — Sous-titres vidéo
Non-conformité. Justification : les vidéos de présentation datent de 2019
et sont en cours de remplacement (Q3 2026). Alternative : transcription
textuelle disponible sur chaque page vidéo.
```

---

## PDF non remediable

Les PDF générés dynamiquement (attestations, contrats) doivent être balisés.
Les PDF fournis par des tiers peuvent être impossibles à corriger.

**Ordre de préférence :**

1. **HTML accessible** — toujours préférable à un PDF
2. **PDF remédié** — balisage correct (ordre de lecture, titres, alt texte, langue)
3. **PDF + alternative HTML** — proposer les deux
4. **PDF non accessible + contact** — dernier recours, avec voie de recours explicite

```html
<!-- Option 3 : PDF + alternative HTML -->
<a href="/rapport.pdf" download class="fr-link fr-link--download">
  Télécharger le rapport
  <span class="fr-link__detail">PDF – 2,1 Mo</span>
</a>
<a href="/rapport" class="fr-link">
  Consulter la version HTML accessible
</a>

<!-- Option 4 : PDF non accessible + contact -->
<a href="/document-tiers.pdf" download class="fr-link fr-link--download">
  Télécharger le document
  <span class="fr-link__detail">PDF – 500 Ko</span>
</a>
<p>
  Ce document n'est pas encore accessible.
  <a href="mailto:contact@service.gouv.fr">Contactez-nous</a>
  pour en recevoir une version accessible.
</p>
```

---

## Vidéo sans sous-titres disponibles

**Ordre de préférence :**

1. **Sous-titres `<track>`** — idéal, fichier `.vtt`
2. **Transcription textuelle** — acceptable si la vidéo est informative et non interactive
3. **Audiodescription** — obligatoire si le contenu visuel est informatif et non décrit verbalement
4. **Retrait de la vidéo** — si aucune alternative n'est possible et que le contenu est redondant

```html
<!-- Minimum acceptable si sous-titres indisponibles -->
<video controls aria-label="Présentation du service">
  <source src="video.mp4" type="video/mp4">
</video>
<details>
  <summary>Transcription textuelle</summary>
  <p>[00:00] Bonjour et bienvenue. Ce service vous permet de...</p>
  <p>[00:15] Pour commencer, cliquez sur le bouton « Créer une demande »...</p>
</details>
```

---

## Contenu en langue étrangère non traduit

Si un document source ne peut pas être traduit (document officiel, contenu tiers) :

```html
<!-- Indiquer la langue du contenu -->
<a href="/terms.pdf" lang="en" hreflang="en" download
   class="fr-link fr-link--download">
  Terms of Service
  <span class="fr-link__detail">PDF – 300 Ko · Anglais</span>
</a>
<p>
  <a href="/conditions-utilisation">Consulter les conditions en français</a>
</p>
```

---

## Fonctionnalité uniquement accessible par geste complexe

Tout glisser-déposer, pinch, rotation doit avoir une alternative clavier ou bouton.

```html
<!-- Réordonnancement par drag&drop -->
<ul id="sortable-list">
  <li>
    <span aria-hidden="true">⠿</span> <!-- handle visuel -->
    Élément A
    <button type="button" aria-label="Monter Élément A"
            onclick="moveUp(this)">↑</button>
    <button type="button" aria-label="Descendre Élément A"
            onclick="moveDown(this)">↓</button>
  </li>
</ul>
```

**Règle** : les boutons ↑/↓ doivent toujours exister, que le drag&drop soit implémenté ou non.

---

## Déclarer les non-conformités

Toute non-conformité non résolue doit apparaître dans la déclaration d'accessibilité avec :
- Le critère RGAA concerné (numéro + intitulé)
- La nature de la non-conformité
- L'impact utilisateur
- La justification (charge disproportionnée, contenu tiers, en cours de correction)
- La date de correction prévue si applicable
- L'alternative proposée

Générateur officiel DINUM : https://betagouv.github.io/a11y-generateur-declaration/