# Patterns accessibilité — Rails / ERB / ViewComponent / Stimulus

## ERB — Attributs ARIA

### aria: hash dans les helpers Rails
```erb
<%# aria-label sur un lien %>
<%= link_to 'Consulter', resource_path(@resource),
    aria: { label: "Consulter #{@resource.title}" } %>

<%# aria-expanded dynamique %>
<%= tag.button 'Menu', type: 'button',
    aria: { expanded: @menu_open, controls: 'nav-menu' } %>

<%# aria-describedby sur un champ %>
<%= f.text_field :email,
    aria: { describedby: 'email-hint email-error',
            required: true,
            invalid: @form.errors[:email].any? } %>
```

### data- et aria- combinés (Stimulus)
```erb
<div data-controller="toggle"
     data-toggle-target="container">
  <button type="button"
          data-action="toggle#toggle"
          aria-expanded="false"
          aria-controls="content-id"
          data-toggle-expanded-value="false">
    Afficher les détails
  </button>
  <div id="content-id" hidden data-toggle-target="content">
    Contenu...
  </div>
</div>
```

---

## DSFRFormBuilder — Champs accessibles

Le projet utilise `DSFRFormBuilder`. Les helpers génèrent automatiquement les classes DSFR mais **les attributs ARIA doivent être ajoutés manuellement**.

### Champ texte avec hint et erreur
```erb
<div class="fr-input-group <%= 'fr-input-group--error' if f.object.errors[:nom].any? %>">
  <%= f.label :nom, class: 'fr-label' do %>
    Nom de famille
    <% if f.object.errors[:nom].any? %>
      <span class="fr-hint-text">
        <%= f.object.errors[:nom].first %>
      </span>
    <% else %>
      <span class="fr-hint-text">Tel qu'il apparaît sur vos documents officiels</span>
    <% end %>
  <% end %>
  <%= f.text_field :nom,
      class: "fr-input #{'fr-input--error' if f.object.errors[:nom].any?}",
      aria: {
        required: true,
        invalid: f.object.errors[:nom].any?,
        describedby: f.object.errors[:nom].any? ? 'nom-error' : nil
      },
      autocomplete: 'family-name' %>
  <% if f.object.errors[:nom].any? %>
    <p id="nom-error" class="fr-error-text" role="alert">
      <%= f.object.errors[:nom].first %>
    </p>
  <% end %>
</div>
```

### Fieldset radio/checkbox
```erb
<fieldset class="fr-fieldset <%= 'fr-fieldset--error' if f.object.errors[:role].any? %>">
  <legend class="fr-fieldset__legend">
    Rôle
    <span class="fr-hint-text">Sélectionnez votre rôle dans l'organisation</span>
  </legend>
  <div class="fr-fieldset__content">
    <% Authorization::ROLES.each do |role| %>
      <div class="fr-radio-group">
        <%= f.radio_button :role, role, id: "role_#{role}" %>
        <%= f.label :role, t("roles.#{role}"), for: "role_#{role}", class: 'fr-label' %>
      </div>
    <% end %>
  </div>
  <% if f.object.errors[:role].any? %>
    <p class="fr-fieldset__messages">
      <span class="fr-error-text" role="alert">
        <%= f.object.errors[:role].first %>
      </span>
    </p>
  <% end %>
</fieldset>
```

---

## ViewComponent — Bonnes pratiques

### Composant avec label accessible
```ruby
# app/components/atoms/icon_button_component.rb
class Atoms::IconButtonComponent < ViewComponent::Base
  def initialize(icon:, label:, url: nil, method: nil, **html_options)
    @icon = icon
    @label = label
    @url = url
    @method = method
    @html_options = html_options
  end
end
```

```erb
<%# app/components/atoms/icon_button_component.html.erb %>
<% if @url %>
  <%= link_to @url, method: @method, aria: { label: @label }, **@html_options do %>
    <span class="<%= @icon %>" aria-hidden="true"></span>
  <% end %>
<% else %>
  <button type="button" aria-label="<%= @label %>" <%= tag_options(@html_options) %>>
    <span class="<%= @icon %>" aria-hidden="true"></span>
  </button>
<% end %>
```

### Composant badge avec contexte lecteur d'écran
```ruby
class Atoms::StatusBadgeComponent < ViewComponent::Base
  STATUS_CLASSES = {
    validated: 'fr-badge--success',
    refused: 'fr-badge--error',
    pending: 'fr-badge--info'
  }.freeze

  def initialize(status:, sr_prefix: nil)
    @status = status.to_sym
    @sr_prefix = sr_prefix
  end

  def badge_class
    "fr-badge #{STATUS_CLASSES.fetch(@status, '')}"
  end

  def label
    I18n.t("statuses.#{@status}")
  end
end
```

```erb
<span class="<%= badge_class %>">
  <% if @sr_prefix %>
    <span class="fr-sr-only"><%= @sr_prefix %> : </span>
  <% end %>
  <%= label %>
</span>
```

```erb
<%# Utilisation dans un tableau %>
<%= render Atoms::StatusBadgeComponent.new(
      status: authorization.status,
      sr_prefix: 'Statut'
    ) %>
```

### Composant de notification dynamique
```ruby
class Molecules::FlashMessageComponent < ViewComponent::Base
  ALERT_ROLES = {
    'alert' => 'alert',
    'error' => 'alert',
    'notice' => 'status',
    'success' => 'status'
  }.freeze

  def initialize(type:, message:)
    @type = type
    @message = message
  end

  def role
    ALERT_ROLES.fetch(@type, 'status')
  end

  def type_label
    I18n.t("flash.types.#{@type}")
  end
end
```

```erb
<%# role="alert" implique aria-live="assertive", role="status" implique aria-live="polite" %>
<div class="fr-alert fr-alert--<%= @type %>"
     role="<%= role %>"
     aria-atomic="true">
  <p class="fr-alert__title">
    <span class="fr-sr-only"><%= type_label %> — </span>
    <%= @message %>
  </p>
</div>
```

---

## Stimulus — Accessibilité

### Controller toggle (accordéon, dropdown)
```javascript
// app/javascript/controllers/toggle_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['button', 'content']
  static values = { expanded: Boolean }

  toggle () {
    this.expandedValue = !this.expandedValue
  }

  expandedValueChanged () {
    this.buttonTarget.setAttribute('aria-expanded', this.expandedValue)
    this.contentTarget.hidden = !this.expandedValue
  }
}
```

### Controller modal avec gestion du focus
```javascript
// app/javascript/controllers/modal_controller.js
import { Controller } from '@hotwired/stimulus'

const FOCUSABLE = 'a[href], button:not([disabled]), input, select, textarea, [tabindex]:not([tabindex="-1"])'

export default class extends Controller {
  static targets = ['dialog']

  connect () {
    this.triggerElement = null
  }

  open (event) {
    this.triggerElement = event.currentTarget
    this.dialogTarget.showModal()
    this.trapFocus()
  }

  close () {
    this.dialogTarget.close()
    this.triggerElement?.focus()
  }

  closeOnBackdrop (event) {
    if (event.target === this.dialogTarget) this.close()
  }

  trapFocus () {
    const focusable = [...this.dialogTarget.querySelectorAll(FOCUSABLE)]
    if (focusable.length) focusable[0].focus()
  }

  keydown (event) {
    if (event.key === 'Escape') this.close()
  }
}
```

```erb
<div data-controller="modal">
  <button type="button"
          data-action="modal#open"
          aria-haspopup="dialog">
    Ouvrir la modale
  </button>

  <dialog data-modal-target="dialog"
          aria-labelledby="modal-title"
          aria-modal="true"
          data-action="click->modal#closeOnBackdrop keydown->modal#keydown">
    <h2 id="modal-title">Titre de la modale</h2>
    <button type="button" data-action="modal#close" aria-label="Fermer">
      <span class="fr-icon-close-line" aria-hidden="true"></span>
    </button>
  </dialog>
</div>
```

### Controller notifications live
```javascript
// app/javascript/controllers/live_region_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { message: String, role: { type: String, default: 'status' } }

  announce (message) {
    this.element.textContent = ''
    requestAnimationFrame(() => {
      this.element.textContent = message
    })
  }
}
```

```erb
<%# Région live réutilisable %>
<div data-controller="live-region"
     role="status"
     aria-live="polite"
     aria-atomic="true"
     class="fr-sr-only">
</div>
```

### Navigation clavier dans une liste (flèches)
```javascript
// app/javascript/controllers/listbox_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['option']

  keydown (event) {
    const current = this.optionTargets.indexOf(document.activeElement)

    if (event.key === 'ArrowDown') {
      event.preventDefault()
      this.optionTargets[Math.min(current + 1, this.optionTargets.length - 1)]?.focus()
    } else if (event.key === 'ArrowUp') {
      event.preventDefault()
      this.optionTargets[Math.max(current - 1, 0)]?.focus()
    } else if (event.key === 'Home') {
      event.preventDefault()
      this.optionTargets[0]?.focus()
    } else if (event.key === 'End') {
      event.preventDefault()
      this.optionTargets[this.optionTargets.length - 1]?.focus()
    }
  }
}
```

---

## I18n — Textes accessibles

### Structure recommandée pour les labels et descriptions
```yaml
# config/locales/fr.yml
fr:
  authorization_requests:
    form:
      email:
        label: "Adresse e-mail"
        hint: "Format : nom@domaine.fr"
        error:
          blank: "L'adresse e-mail est obligatoire"
          invalid: "Le format de l'adresse e-mail est invalide. Exemple : nom@domaine.fr"
      submit: "Soumettre la demande d'habilitation"

  statuses:
    validated: "Validée"
    refused: "Refusée"
    pending: "En attente"

  flash:
    types:
      notice: "Information"
      success: "Succès"
      alert: "Erreur"
      warning: "Attention"

  accessibility:
    external_link_title: "%{label} - nouvelle fenêtre"
    loading: "Chargement en cours…"
    sr_only:
      status_prefix: "Statut"
      actions: "Actions pour %{name}"
```

### Mapping `autocomplete` pour les champs DataPass (RGAA 11.13 / WCAG 1.3.5)

RGAA 11.13 (niveau AA) exige l'attribut `autocomplete` sur tout champ collectant **les données personnelles de l'utilisateur connecté**.

> **Distinction clé** : si le champ sert à saisir les données d'une **autre personne** (ex : email d'un utilisateur à bannir, email d'un destinataire), le critère ne s'applique pas — utiliser `autocomplete: 'off'` pour éviter que le navigateur propose les données de l'utilisateur courant, ce qui serait trompeur.

DataPass collecte fréquemment les champs suivants :

```erb
<%# Identité %>
<%= f.text_field :given_name,   autocomplete: 'given-name' %>
<%= f.text_field :family_name,  autocomplete: 'family-name' %>
<%= f.text_field :full_name,    autocomplete: 'name' %>

<%# Contact %>
<%= f.email_field :email,       autocomplete: 'email' %>
<%= f.tel_field   :phone,       autocomplete: 'tel' %>

<%# Organisation %>
<%= f.text_field :organization_name, autocomplete: 'organization' %>

<%# Adresse (si collectée) %>
<%= f.text_field :address,      autocomplete: 'street-address' %>
<%= f.text_field :city,         autocomplete: 'address-level2' %>
<%= f.text_field :postal_code,  autocomplete: 'postal-code' %>

<%# Identifiants techniques — pas de valeur autocomplete standard %>
<%# SIRET, SIREN, numéro RNA → autocomplete: 'off' (ou omis) %>
<%= f.text_field :siret,        autocomplete: 'off', inputmode: 'numeric' %>
```

**Valeurs `autocomplete` à connaître :**

| Champ | Valeur autocomplete |
|-------|---------------------|
| Prénom | `given-name` |
| Nom de famille | `family-name` |
| Nom complet | `name` |
| E-mail | `email` |
| Téléphone | `tel` |
| Intitulé de poste | `organization-title` |
| Nom d'organisation | `organization` |
| Adresse complète | `street-address` |
| Ville | `address-level2` |
| Code postal | `postal-code` |
| Pays | `country-name` |
| Mot de passe actuel | `current-password` |
| Nouveau mot de passe | `new-password` |

> **Identifiants spécifiques** (SIRET, SIREN, RNA, numéro de dossier) : aucune valeur `autocomplete` standard — utiliser `autocomplete: 'off'` pour éviter des suggestions erronées.

---

### Helper pour lien externe
Suit la recommandation DSFR : `title` + `rel="noopener external"` + `target="_blank"` (RGAA 13.2).

```ruby
# app/helpers/accessibility_helper.rb
module AccessibilityHelper
  def external_link_to(label, url, **options)
    title = t('accessibility.external_link_title', label:)
    link_to label, url, target: '_blank', rel: 'noopener external', title:, **options
  end

  def sr_only(text)
    tag.span(text, class: 'fr-sr-only')
  end

  def icon_button(icon_class, label, **options)
    tag.button(type: 'button', aria: { label: }, **options) do
      tag.span('', class: icon_class, aria: { hidden: true })
    end
  end

  # Tri de tableau accessible — génère aria-sort="ascending|descending|none" sur <th>
  # Usage : <%= tag.th scope: 'col', **aria_sort_for(:date, @sort_col, @sort_dir) %>
  def aria_sort_for(column, current_column, current_direction)
    return { aria: { sort: 'none' } } unless column.to_s == current_column.to_s

    { aria: { sort: current_direction == 'asc' ? 'ascending' : 'descending' } }
  end

  # Lien de tri — bascule asc/desc, accessible au clavier
  def sort_link_for(column, label, path_helper: request.path)
    direction = (params[:sort_column] == column.to_s && params[:sort_direction] == 'asc') ? 'desc' : 'asc'
    icon = params[:sort_column] == column.to_s ? (direction == 'asc' ? '↓' : '↑') : '↕'
    link_to "#{label} #{icon}", "#{path_helper}?sort_column=#{column}&sort_direction=#{direction}",
            aria: { label: "Trier par #{label} #{direction == 'asc' ? 'croissant' : 'décroissant'}" }
  end
end
```

---

## RSpec — Tester l'accessibilité

### Tester la présence d'attributs ARIA
```ruby
RSpec.describe Atoms::StatusBadgeComponent, type: :component do
  subject { render_inline(described_class.new(status: 'validated', sr_prefix: 'Statut')) }

  it 'indique le statut pour les lecteurs d\'écran' do
    expect(subject).to have_css('.fr-sr-only', text: 'Statut :')
  end

  it 'affiche le badge avec la bonne classe de couleur' do
    expect(subject).to have_css('.fr-badge.fr-badge--success')
  end
end
```

### Cucumber — scénarios d'accessibilité clavier
```gherkin
# features/accessibility/keyboard_navigation.feature
Fonctionnalité: Navigation au clavier

  Scénario: Fermer une modale avec Escape
    Quand j'ouvre la modale de confirmation
    Et j'appuie sur la touche "Escape"
    Alors la modale est fermée
    Et le focus est sur le bouton déclencheur
```

---

## Turbo — Accessibilité avec Hotwire

Turbo Drive, Turbo Frames et Turbo Streams remplacent du DOM sans rechargement de page.
Les lecteurs d'écran ne sont **pas automatiquement notifiés** de ces changements.

### Turbo Drive — Titre de page
Turbo Drive met à jour le `<title>` automatiquement, mais certains lecteurs d'écran ne
l'annoncent pas. Ajouter une annonce explicite via une live region :

```javascript
// app/javascript/controllers/page_title_announcer_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    document.addEventListener('turbo:render', this.announce.bind(this))
  }

  disconnect () {
    document.removeEventListener('turbo:render', this.announce.bind(this))
  }

  announce () {
    this.element.textContent = ''
    requestAnimationFrame(() => {
      this.element.textContent = document.title
    })
  }
}
```

```erb
<%# Dans le layout application.html.erb — après les liens d'évitement %>
<div data-controller="page-title-announcer"
     role="status"
     aria-live="polite"
     aria-atomic="true"
     class="fr-sr-only">
</div>
```

### Turbo Frames — Gestion du focus
Quand un Turbo Frame se met à jour, le focus reste là où il était (parfois dans du contenu
qui n'existe plus). Il faut gérer le focus manuellement.

```erb
<%# Option 1 : tabindex="-1" + focus JS via turbo:frame-render (recommandée) %>
<%# Note : autofocus HTML ne fonctionne que sur les éléments interactifs, pas sur <h2> %>
<turbo-frame id="authorization-details">
  <h2 tabindex="-1" id="frame-title">
    Détails de l'habilitation
  </h2>
  <!-- contenu -->
</turbo-frame>
```

```javascript
// Option 2 : via Turbo events
document.addEventListener('turbo:frame-render', (event) => {
  const frame = event.target
  const firstHeading = frame.querySelector('h1, h2, h3, [tabindex="-1"]')
  firstHeading?.focus()
})
```

```erb
<%# Option 3 : data-turbo-action="advance" + scroll -->
<turbo-frame id="results"
             data-turbo-action="advance"
             aria-live="polite"
             aria-busy="false">
  <%= render @authorizations %>
</turbo-frame>
```

### Turbo Streams — Annoncer les changements
Turbo Streams modifient le DOM silencieusement. Utiliser `aria-live` sur le conteneur cible.

```erb
<%# Dans la vue : conteneur avec aria-live %>
<div id="flash-messages"
     role="status"
     aria-live="polite"
     aria-atomic="true">
</div>

<%# Turbo Stream qui cible ce conteneur %>
<%# app/views/authorization_requests/update.turbo_stream.erb %>
<%= turbo_stream.update 'flash-messages' do %>
  <div class="fr-alert fr-alert--success">
    <p class="fr-alert__title">
      <span class="fr-sr-only">Succès — </span>
      Habilitation mise à jour.
    </p>
  </div>
<% end %>
```

```erb
<%# Pour des listes mises à jour dynamiquement — prepend/append %>
<%# Annoncer le changement via une live region séparée %>
<div id="results-list" aria-label="Liste des habilitations">
  <%= render @authorizations %>
</div>

<div id="results-announcement"
     role="status"
     aria-live="polite"
     class="fr-sr-only">
</div>

<%# Dans le turbo stream %>
<%= turbo_stream.update 'results-announcement' do %>
  <%= @authorizations.count %> habilitations chargées.
<% end %>
<%= turbo_stream.prepend 'results-list' do %>
  <%= render @new_authorization %>
<% end %>
```

### Turbo Streams — aria-busy pendant le chargement
```erb
<%# Marquer le contenu comme en cours de chargement %>
<div id="content-area"
     aria-busy="false"
     aria-live="polite">
</div>
```

```javascript
document.addEventListener('turbo:before-fetch-request', () => {
  document.getElementById('content-area')?.setAttribute('aria-busy', 'true')
})
document.addEventListener('turbo:render', () => {
  document.getElementById('content-area')?.setAttribute('aria-busy', 'false')
})
```

---

## Tests automatisés — axe-core en Cucumber

### Installation
```ruby
# Gemfile
gem 'axe-core-capybara', group: :test
gem 'axe-core-rspec', group: :test
```

### Step Cucumber générique
```ruby
# features/step_definitions/accessibility_steps.rb
require 'axe-capybara'

Then('la page est accessible') do
  expect(page).to be_axe_clean
end

Then('la page est accessible selon le RGAA') do
  expect(page).to be_axe_clean.according_to(:wcag21aa)
end

Then('la région {string} est accessible') do |region|
  expect(page).to be_axe_clean.within(region)
end
```

### Utilisation dans les features
```gherkin
# features/accessibility/authorization_form.feature
Fonctionnalité: Accessibilité du formulaire d'habilitation

  Scénario: Le formulaire est accessible
    Étant donné que je suis connecté en tant que "user@yopmail.com"
    Quand je visite la page de création d'habilitation
    Alors la page est accessible selon le RGAA

  Scénario: Les erreurs de formulaire sont accessibles
    Étant donné que je suis connecté en tant que "user@yopmail.com"
    Quand je soumets le formulaire sans remplir les champs obligatoires
    Alors la page est accessible selon le RGAA
```

### Intégration RSpec component
```ruby
# spec/support/axe_helper.rb
require 'axe-rspec'

RSpec.configure do |config|
  config.include Axe::RSpec::Matchers, type: :system
end

# spec/system/authorization_requests_spec.rb
RSpec.describe 'Formulaire d\'habilitation', type: :system do
  it 'est accessible' do
    visit new_authorization_request_path
    expect(page).to be_axe_clean.according_to(:wcag21aa)
  end
end
```

---

## Accessibilité des iframes (RGAA Thème 2)

```html
<!-- Tout iframe doit avoir un title descriptif -->
<iframe src="/document-preview" title="Prévisualisation du document PDF"></iframe>

<!-- iframe décoratif ou vide -->
<iframe src="..." title="" aria-hidden="true" tabindex="-1"></iframe>
```

```erb
<%# En ERB %>
<iframe src="<%= document_preview_path(@document) %>"
        title="Prévisualisation : <%= @document.filename %>"
        class="document-preview">
</iframe>
```

---

## Changements de langue (RGAA 8.7 / 8.8)

```html
<!-- Passage en langue étrangère -->
<p>Consulter la <span lang="en">privacy policy</span> pour plus de détails.</p>

<!-- Lien externe en langue étrangère -->
<a href="https://example.com" lang="en" hreflang="en"
   target="_blank" rel="noopener external"
   title="Example site - new window">
  Example site
  <span class="fr-sr-only"> - nouvelle fenêtre</span>
</a>

<!-- Document téléchargeable en langue étrangère -->
<a hreflang="en" download href="report.pdf" class="fr-link fr-link--download">
  Télécharger le rapport
  <span class="fr-link__detail">PDF – 2,4 Mo - Anglais</span>
</a>
```

```ruby
# Helper pour les abréviations (RGAA 9.4) — fréquentes dans DataPass
module AccessibilityHelper
  ABBREVIATIONS = {
    'API' => 'Application Programming Interface',
    'DINUM' => 'Direction Interministérielle du Numérique',
    'RGAA' => 'Référentiel Général d\'Amélioration de l\'Accessibilité',
    'SIRET' => 'Système d\'Identification du Répertoire des Établissements',
    'WCAG' => 'Web Content Accessibility Guidelines'
  }.freeze

  def abbr_tag(abbreviation)
    title = ABBREVIATIONS[abbreviation]
    return abbreviation unless title

    tag.abbr(abbreviation, title:)
  end
end
```

```erb
<%# Utilisation — première occurrence seulement %>
<p>Votre demande d'accès à l'<%= abbr_tag('API') %> a été validée.</p>
```

---

## Tri de tableau accessible

### Controller Rails (pattern RESTful)
```ruby
# app/controllers/resources_controller.rb
def index
  @sort_column = params[:sort_column].presence_in(%w[title date status]) || 'date'
  @sort_direction = params[:sort_direction] == 'asc' ? 'asc' : 'desc'
  @resources = Resource.order(@sort_column => @sort_direction)

  # Annonce pour les lecteurs d'écran
  direction_label = @sort_direction == 'asc' ? 'croissant' : 'décroissant'
  column_label = t("columns.#{@sort_column}")
  @sort_announcement = "Liste triée par #{column_label}, ordre #{direction_label}"
end
```

Voir `examples-dsfr.md` §Tableau triable pour le HTML complet avec `aria_sort_for` et l'annonce live.

---

## WCAG 3.3.7 Redundant Entry — Ne jamais redemander une info déjà saisie

Dans un formulaire multi-étapes, pré-remplir automatiquement toute donnée déjà connue — depuis le profil utilisateur ou les étapes précédentes stockées en session.

```ruby
# app/controllers/steps_controller.rb
def show
  @form = StepForm.new
  prefill_from_session   # données des étapes précédentes
  prefill_from_profile   # données du profil utilisateur (WCAG 3.3.7)
end

private

def prefill_from_session
  @form.assign_attributes(session[:wizard_data] || {})
end

def prefill_from_profile
  @form.contact_email    ||= current_user.email
  @form.contact_phone    ||= current_user.phone
  @form.organization     ||= current_user.organization_name
end
```

```erb
<%# Les champs sont pré-remplis — l'utilisateur peut les modifier mais ne doit pas les ressaisir %>
<%= f.email_field :contact_email,
    value: @form.contact_email,
    autocomplete: 'email',
    aria: { describedby: 'email-hint' } %>
<p id="email-hint" class="fr-hint-text">
  Pré-rempli depuis votre profil — modifiez si nécessaire.
</p>
```

**Règle** : si l'utilisateur a déjà saisi une information (email, nom, organisation) à une étape précédente ou lors d'une session antérieure, la pré-remplir. Ne pas la vider entre les étapes. Stocker les données de wizard en session entre chaque `POST`.