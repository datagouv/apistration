RSpec.describe 'Self-service tokens', app: :api_entreprise do
  include ActiveJob::TestHelper

  let(:demandeur) { create(:user, email: 'demandeur@example.org') }
  let(:contact_technique) { create(:user, email: 'technique@example.org') }
  let(:contact_metier) { create(:user, email: 'metier@example.org', first_name: 'Camille', last_name: 'Martin') }
  let(:status) { 'validated' }
  let!(:authorization_request) do
    create(
      :authorization_request,
      :with_demandeur,
      :with_contact_technique,
      :with_contact_metier,
      demandeur:,
      contact_technique:,
      contact_metier:,
      status:,
      validated_at: 1.month.ago,
      scopes: %w[entreprises etablissements]
    )
  end

  def create_token(name:, lifetime: nil)
    visit authorization_request_path(authorization_request)
    click_on 'Créer un jeton'
    fill_in 'Nom du jeton', with: name
    select lifetime, from: 'Durée de validité' if lifetime
    perform_enqueued_jobs { click_on 'Créer le jeton' }
  end

  def revoke_token(token)
    visit authorization_request_path(authorization_request)
    find("##{dom_id(token, :revocation_link)}").click
    perform_enqueued_jobs { click_on 'Révoquer le jeton' }
  end

  describe 'a contact métier creates a token' do
    before { login_as(contact_metier) }

    it 'creates a named token carrying every scope of the demande, valid 18 months by default' do
      create_token(name: 'Production')

      token = authorization_request.tokens.find_by!(name: 'Production')
      expect(page).to have_css('.fr-alert--success', text: 'Le jeton « Production » a été créé')
      expect(page).to have_css("##{dom_id(token)}", text: 'Production')
      expect(token.scopes).to eq(%w[entreprises etablissements])
      expect(token.creator).to eq(contact_metier)
      expect(Time.zone.at(token.exp)).to be_within(1.minute).of(18.months.from_now)
    end

    it 'opens the creation form with an empty name' do
      visit authorization_request_path(authorization_request)
      click_on 'Créer un jeton'

      expect(find_field('Nom du jeton').value).to be_blank
    end

    it 'creates a token valid for the chosen duration' do
      create_token(name: 'Recette', lifetime: '3 mois')

      token = authorization_request.tokens.find_by!(name: 'Recette')
      expect(Time.zone.at(token.exp)).to be_within(1.minute).of(3.months.from_now)
    end

    it 'sends a single mail to the other contacts, naming the author and the token' do
      create_token(name: 'Production')

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to contain_exactly('demandeur@example.org', 'technique@example.org')
      expect(mail.subject).to eq("🔑 Jeton \"Production\" créé sur votre demande n°#{authorization_request.external_id}")
      expect(mail.text_part.decoded).to include("#{contact_metier.full_name} a créé le jeton « Production »")
    end

    it 'can reveal the value of the token' do
      create_token(name: 'Production')
      token = authorization_request.tokens.find_by!(name: 'Production')

      visit token_path(id: token.id)

      expect(page).to have_css('#' << dom_id(token, :copy_token_button))
    end
  end

  describe 'naming rules' do
    before do
      login_as(demandeur)
      create(:token, authorization_request:, name: 'Production')
    end

    it 'refuses a name already used by an active token of the demande' do
      expect { create_token(name: 'Production') }.not_to change(Token, :count)

      expect(page).to have_css('.fr-alert--error', text: "Le jeton n'a pas pu être créé")
    end

    it 'accepts the name of a revoked token' do
      authorization_request.tokens.find_by!(name: 'Production').revoke!

      expect { create_token(name: 'Production') }.to change(Token, :count).by(1)
    end

    it 'refuses a blank name' do
      expect { create_token(name: ' ') }.not_to change(Token, :count)
    end
  end

  describe 'limit of 5 active tokens' do
    before do
      login_as(demandeur)
      create_list(:token, 4, authorization_request:) { |token, index| token.name = "Jeton #{index}" }
    end

    it 'allows the fifth active token' do
      expect { create_token(name: 'Cinquième') }.to change(Token, :count).by(1)
    end

    context 'when 5 tokens are active' do
      before { create(:token, authorization_request:, name: 'Jeton 5') }

      it 'hides the creation and explains the limit' do
        visit authorization_request_path(authorization_request)

        expect(page).to have_css('#active_tokens_limit_reached', text: 'plafond de 5 jetons actifs')
        expect(page).to have_no_link('Créer un jeton')
      end

      it 'refuses a creation sent anyway' do
        page.driver.post authorization_request_tokens_path(authorization_request_id: authorization_request.id), token: { name: 'Sixième', lifetime_in_months: 18 }

        expect(authorization_request.tokens.active.count).to eq(5)
      end

      it 'allows a new token once one is revoked' do
        authorization_request.tokens.find_by!(name: 'Jeton 5').revoke!

        expect { create_token(name: 'Remplaçant') }.to change(Token, :count).by(1)
      end
    end
  end

  describe 'revocation' do
    let!(:token) { create(:token, authorization_request:, name: 'Recette') }

    before { login_as(contact_metier) }

    it 'labels the confirmation button' do
      visit authorization_request_path(authorization_request)
      find("##{dom_id(token, :revocation_link)}").click

      expect(page).to have_button('Révoquer le jeton', class: 'fr-btn')
      expect(page).to have_no_button(class: 'fr-icon-close-circle-line')
    end

    it 'warns about the cache before revoking' do
      visit authorization_request_path(authorization_request)
      find("##{dom_id(token, :revocation_link)}").click

      expect(page).to have_text('Le jeton « Recette » sera révoqué immédiatement')
      expect(page).to have_text('pendant 1 heure au plus')
    end

    it 'revokes the token and lists it with the inactive ones' do
      revoke_token(token)

      expect(token.reload).to be_blacklisted
      expect(page).to have_css('.fr-alert--success', text: 'Le jeton « Recette » a été révoqué')
      within('#inactive_tokens') do
        expect(page).to have_css("##{dom_id(token)}", text: 'Révoqué')
        expect(page).to have_css("##{dom_id(token, :stats_link)}")
        expect(page).to have_no_css("##{dom_id(token, :revocation_link)}")
      end
    end

    it 'sends a single mail to the other contacts' do
      revoke_token(token)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to contain_exactly('demandeur@example.org', 'technique@example.org')
      expect(mail.text_part.decoded).to include("#{contact_metier.full_name} a révoqué le jeton « Recette »")
    end
  end

  describe 'a demande where tokens cannot be created' do
    before { login_as(demandeur) }

    %w[revoked archived].each do |closed_status|
      context "when the demande is #{closed_status}" do
        let(:status) { closed_status }

        it 'hides the creation and refuses it' do
          visit authorization_request_path(authorization_request)

          expect(page).to have_css('#authorization_request_tokens .fr-alert--info')
          expect(page).to have_no_link('Créer un jeton')

          page.driver.post authorization_request_tokens_path(authorization_request_id: authorization_request.id), token: { name: 'Production', lifetime_in_months: 18 }

          expect(authorization_request.tokens.count).to eq(0)
        end
      end
    end
  end

  describe 'a user who is not a contact of the demande' do
    let(:stranger) { create(:user) }
    let!(:token) { create(:token, authorization_request:, name: 'Recette') }

    before { login_as(stranger) }

    it 'can neither create nor revoke a token' do
      page.driver.post authorization_request_tokens_path(authorization_request_id: authorization_request.id), token: { name: 'Intrus', lifetime_in_months: 18 }
      page.driver.post token_revoke_path(id: token.id)

      expect(authorization_request.tokens.count).to eq(1)
      expect(token.reload).not_to be_blacklisted
    end
  end
end
