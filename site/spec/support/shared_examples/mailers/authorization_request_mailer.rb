require 'rails_helper'

RSpec.shared_examples 'an authorization request mailer' do |options = {}|
  let(:authorization_request) { create(:authorization_request, :with_all_contacts) }
  let(:to) { 'anything@email.com' }
  let(:cc) { 'anything2@email.com' }

  # Use the email methods provided in options or use an empty array as fallback
  # This allows API-specific email method lists
  email_methods = options[:email_methods] || []

  email_methods.each do |method|
    describe "##{method}" do
      subject(:generate_email) { described_class.send(method, { to:, cc:, authorization_request: }) }

      it 'generates an email' do
        expect { generate_email }.not_to raise_error
      end

      it 'display authorization_request external id' do
        expect(subject.html_part.decoded).to include(authorization_request.external_id)
      end

      it 'has a text part mentioning the authorization_request external id' do
        expect(subject.text_part.decoded).to include(authorization_request.external_id)
      end
    end
  end

  describe '#embarquement_demande_refusee text part' do
    subject(:text) { described_class.embarquement_demande_refusee({ to:, cc:, authorization_request: }).text_part.decoded }

    it 'tells the demandeur where to check eligibility and ask for a review, like the html part' do
      expect(text).to include("Vous pensez qu'il s'agit d'une erreur ?")
      expect(text).to include('#conditions-d-utilisation-de-l-api-')
      expect(text).to include('page FAQ et support')
    end
  end

  describe 'help blocks of the html part in the text part' do
    def text_of(method)
      described_class.send(method, { to:, cc:, authorization_request: }).text_part.decoded
    end

    it 'guides the demandeur to complete a received demande' do
      expect(text_of('demande_recue')).to include('Quelles informations me seront demandées ?')
    end

    it 'points every validation mail to the catalogue and the FAQ' do
      email_methods.grep(/\Aembarquement_valide_/).each do |method|
        expect(text_of(method)).to include('/catalogue/', '/faq'), method
      end
    end

    it 'points technical contacts and editors to the production kit' do
      email_methods.grep(/\Aembarquement_valide_to_(demandeur_is_tech|editeur|tech_cc)/).each do |method|
        expect(text_of(method)).to include('#kit-de-mise-en-production'), method
      end
    end
  end

  # Only include the scopes test if specified in options
  if options[:test_scopes]
    let(:scope_label) { options[:scope_label] }

    describe 'scopes in mails' do
      subject(:generate_email) { described_class.send(options[:scope_test_method], { to:, cc:, authorization_request: }) }

      describe 'when there is no token' do
        it 'doesnt display scopes' do
          expect(subject.html_part.decoded).not_to include('Cette habilitation donne accès aux API suivantes')
          expect(subject.html_part.decoded).not_to include(scope_label)
        end
      end

      describe 'when there is a token' do
        let(:authorization_request) { create(:authorization_request, :with_all_contacts, :with_tokens, scopes: ['entreprises']) }

        it 'display scopes' do
          expect(subject.html_part.decoded).to include('Cette habilitation donne accès aux API suivantes')
          expect(subject.html_part.decoded).to include(scope_label)
        end
      end
    end
  end
end
