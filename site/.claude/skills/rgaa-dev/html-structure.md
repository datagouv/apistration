# Tester la structure HTML

La structure HTML est la colonne vertébrale de l'accessibilité. Un lecteur d'écran navigue
principalement via les titres, les landmarks et les listes — pas via le visuel.

---

## Outils de validation

### W3C Markup Validator
**URL** : https://validator.w3.org/

Valide la conformité HTML. Les erreurs de balisage cassent souvent l'interprétation
par les lecteurs d'écran.

```bash
# Validation en ligne de commande (CI/CD)
npx html-validate "app/views/**/*.html.erb"

# ou via curl sur une page servie localement
curl -s --data-urlencode "fragment=$(curl -s http://localhost:3000/habilitations)" \
  "https://validator.nu/?out=json" | jq '.messages[] | select(.type == "error")'
```

### Extensions navigateur — Structure visuelle

| Extension | Navigateur | Ce qu'elle montre |
|-----------|------------|-------------------|
| **HeadingsMap** | Chrome / Firefox | Arborescence des titres h1→h6, erreurs de hiérarchie |
| **Landmarks** (TPGi) | Chrome / Firefox | Overlay des regions ARIA et HTML5 landmarks |
| **WAVE** | Chrome / Firefox | Erreurs structure + landmarks + titres en overlay |
| **axe DevTools** | Chrome / Firefox | Audit complet incluant structure |
| **ARC Toolkit** | Chrome | Audit RGAA avec détail par critère |

### Arbre d'accessibilité dans Chrome DevTools

```
DevTools → Elements → Onglet "Accessibility" (panneau latéral)
→ Cocher "Enable full-page accessibility tree"
→ Icône arbre en haut du panneau Elements
```

Permet de voir exactement ce que le lecteur d'écran perçoit : rôle, nom, état de chaque nœud.

### Inspection rapide dans la console

```javascript
// Lister tous les titres et leur niveau
document.querySelectorAll('h1, h2, h3, h4, h5, h6').forEach(h => {
  console.log(`${h.tagName}: ${h.textContent.trim()}`)
})

// Vérifier la présence des landmarks obligatoires
const required = ['main', '[role="main"]', 'nav', 'header', 'footer']
required.forEach(sel => {
  const el = document.querySelector(sel)
  console.log(`${sel}: ${el ? '✓' : '❌ ABSENT'}`)
})

// Lister les landmarks avec leur label
document.querySelectorAll('main, nav, header, footer, aside, section[aria-label], [role]').forEach(el => {
  const label = el.getAttribute('aria-label') || el.getAttribute('aria-labelledby') || '(sans label)'
  console.log(`${el.tagName}[${el.getAttribute('role') || ''}]: ${label}`)
})

// Détecter les images sans alt
document.querySelectorAll('img:not([alt])').forEach(img => {
  console.warn('Image sans alt:', img.src)
})

// Détecter les champs sans label associé
document.querySelectorAll('input, select, textarea').forEach(field => {
  const id = field.id
  const label = id ? document.querySelector(`label[for="${id}"]`) : null
  const ariaLabel = field.getAttribute('aria-label') || field.getAttribute('aria-labelledby')
  if (!label && !ariaLabel) {
    console.warn('Champ sans label:', field)
  }
})
```

---

## Checklist structure HTML

### Titres (RGAA 9.1)
- [ ] Un seul `<h1>` par page, cohérent avec le `<title>`
- [ ] Hiérarchie sans saut (h1 → h2 → h3, jamais h1 → h3)
- [ ] Titres utilisés pour structurer le contenu, pas pour le style
- [ ] Vérifier avec HeadingsMap ou DevTools
- [ ] En ERB : le niveau de titre est paramétrable si le composant est réutilisable

```erb
<%# ✅ Composant avec niveau de titre configurable %>
<%= render Molecules::SectionComponent.new(title: "Cadre légal", heading_level: 3) %>
```

```ruby
class Molecules::SectionComponent < ViewComponent::Base
  def initialize(title:, heading_level: 2)
    @title = title
    @heading_level = heading_level.clamp(1, 6)
  end

  def heading_tag
    "h#{@heading_level}"
  end
end
```

```erb
<%# app/components/molecules/section_component.html.erb %>
<section>
  <%= content_tag(heading_tag, @title, class: 'fr-h3') %>
  <%= content %>
</section>
```

### Landmarks / Régions (RGAA 12.6)
- [ ] `<header>` (ou `role="banner"`) — en-tête du site
- [ ] `<nav aria-label="...">` — navigation(s)
- [ ] `<main>` (ou `role="main"`) — contenu principal, unique par page
- [ ] `<footer>` (ou `role="contentinfo"`) — pied de page
- [ ] Plusieurs `<nav>` → labels distincts (`aria-label` différents)
- [ ] `<aside aria-label="...">` si contenu complémentaire
- [ ] Pas de `<section>` sans `aria-label` (sinon invisible aux lecteurs d'écran)

```html
<!-- ❌ Section sans nom = landmark générique ignoré -->
<section>
  <h2>Habilitations en cours</h2>
</section>

<!-- ✅ Section nommée = landmark region identifiable -->
<section aria-labelledby="section-title">
  <h2 id="section-title">Habilitations en cours</h2>
</section>
```

### Listes (RGAA 9.3)
- [ ] Listes d'éléments → `<ul>` ou `<ol>` + `<li>`
- [ ] Listes de définitions → `<dl>` + `<dt>` + `<dd>`
- [ ] Pas de `<ul>` vides
- [ ] Pas de fausse liste (divs avec tirets visuels)
- [ ] Navigation → `<ul>` de `<li>` contenant les liens (pattern standard)

```html
<!-- ❌ Fausse liste (perd la sémantique) -->
<div class="list">
  <div>— Élément 1</div>
  <div>— Élément 2</div>
</div>

<!-- ✅ Liste sémantique -->
<ul>
  <li>Élément 1</li>
  <li>Élément 2</li>
</ul>

<!-- ✅ Liste de définitions (propriétés d'une habilitation) -->
<dl>
  <dt>API</dt>
  <dd>API Particulier</dd>
  <dt>Statut</dt>
  <dd>Validée</dd>
  <dt>Date de création</dt>
  <dd><time datetime="2024-01-15">15 janvier 2024</time></dd>
</dl>
```

### Tableaux (RGAA 5.x)
- [ ] `<caption>` présent
- [ ] `<th scope="col">` pour en-têtes de colonnes
- [ ] `<th scope="row">` pour en-têtes de lignes (si applicable)
- [ ] Pas de tableau pour la mise en page

### Formulaires (RGAA 11.x)
- [ ] `<label for="id">` sur chaque champ
- [ ] `<fieldset>` + `<legend>` pour les groupes radio/checkbox
- [ ] Pas de `<table>` pour aligner les champs

### Éléments sémantiques
- [ ] Utiliser les bons éléments HTML (pas de `<div>` cliquable à la place de `<button>`)
- [ ] `<button>` pour les actions, `<a>` pour les navigations
- [ ] `<time datetime="...">` pour les dates
- [ ] `<address>` pour les coordonnées
- [ ] `<abbr title="...">` pour les abréviations (première occurrence)
- [ ] `<strong>` pour l'importance, `<em>` pour l'emphase (pas pour le style)
- [ ] `<blockquote>` pour les citations

```html
<!-- ❌ Div cliquable (non accessible au clavier, pas de rôle) -->
<div class="btn" onclick="submit()">Envoyer</div>

<!-- ✅ Bouton natif -->
<button type="button" onclick="submit()">Envoyer</button>

<!-- ❌ Span pour texte important -->
<span class="bold">Attention</span>

<!-- ✅ Élément sémantique -->
<strong>Attention</strong>
```

---

## Tester avec les outils navigateur — pas à pas

### HeadingsMap (titres)
1. Installer l'extension HeadingsMap
2. Ouvrir la page à tester
3. Cliquer sur l'icône HeadingsMap → onglet "Headings"
4. Vérifier : hiérarchie sans saut, h1 unique, tous les titres pertinents

### Landmarks (TPGi)
1. Installer l'extension Landmarks
2. Ouvrir la page → cliquer l'icône
3. Vérifier : présence de `main`, `nav`, `header`, `footer`
4. Chaque landmark a un label distinct si plusieurs du même type

### Arbre d'accessibilité Chrome
1. DevTools → Elements
2. Onglet "Accessibility" dans le panneau latéral
3. Activer "Enable full-page accessibility tree"
4. Cliquer l'icône en forme d'arbre en haut du panneau Elements
5. Naviguer dans l'arbre et vérifier rôles, noms, états

### Test rapide avec Tab uniquement
1. Fermer la souris
2. Utiliser uniquement Tab / Shift+Tab / Enter / Espace / Flèches
3. Vérifier : focus visible, ordre logique, tous les éléments interactifs atteignables

---

## Validation HTML dans les tests RSpec

```ruby
# spec/support/html_validation.rb
require 'w3c_validators'

module HtmlValidation
  include W3CValidators

  def validate_html(html)
    validator = MarkupValidator.new
    results = validator.validate_text(html)
    errors = results.errors.reject { |e| e.message.include?('Obsolete') }
    expect(errors).to be_empty, errors.map(&:message).join("\n")
  end
end

RSpec.configure do |config|
  config.include HtmlValidation, type: :component
end
```

```ruby
# spec/components/molecules/authorization_card_component_spec.rb
RSpec.describe Molecules::AuthorizationCardComponent, type: :component do
  subject { render_inline(described_class.new(authorization: authorization)) }

  let(:authorization) { Authorization.find(1) } # objet réel depuis seeds

  it 'produit du HTML valide' do
    validate_html(subject.to_html)
  end

  it 'a un titre de niveau cohérent' do
    expect(subject).to have_css('h3', text: authorization.intitule)
    expect(subject).not_to have_css('h1, h2') # composant = pas de h1/h2
  end
end
```

---

## Erreurs HTML fréquentes dans Rails/ERB

### IDs dupliqués (très fréquent avec `.each`)
```erb
<%# ❌ IDs dupliqués si plusieurs cartes sur la page %>
<% @authorizations.each do |authorization| %>
  <div id="authorization-card">
    <p id="status">...</p>
  </div>
<% end %>

<%# ✅ IDs uniques avec dom_id %>
<% @authorizations.each do |authorization| %>
  <div id="<%= dom_id(authorization) %>">
    <p id="<%= dom_id(authorization, :status) %>">...</p>
  </div>
<% end %>
```

### `aria-describedby` pointant vers un ID inexistant
```erb
<%# ❌ L'ID n'existe que si erreur présente %>
<%= f.text_field :email, aria: { describedby: 'email-error' } %>
<% if @form.errors[:email].any? %>
  <p id="email-error">...</p>
<% end %>

<%# ✅ L'attribut n'est ajouté que si l'élément cible existe %>
<%= f.text_field :email,
    aria: { describedby: @form.errors[:email].any? ? 'email-error' : nil } %>
```

### Labels avec `for` pointant vers un ID inexistant
```erb
<%# ❌ Rails génère field_id différemment selon le contexte %>
<label for="email">Email</label>
<%= f.text_field :email %>  <%# génère id="authorization_request_email" %>

<%# ✅ Utiliser le helper label de Rails %>
<%= f.label :email, 'Email' %>  <%# génère for="authorization_request_email" %>
<%= f.text_field :email %>
```

### Boutons sans type dans un formulaire
```erb
<%# ❌ Type par défaut = "submit" → soumet le formulaire involontairement %>
<button onclick="toggleSection()">Voir plus</button>

<%# ✅ Type explicite %>
<button type="button" onclick="toggleSection()">Voir plus</button>
```