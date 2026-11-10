# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIEntreprise::AuthorizationRequestMailer do
  it_behaves_like 'an authorization request mailer',
    email_methods: %w[
      embarquement_demande_refusee
      update_embarquement_demande_refusee
      embarquement_modifications_demandees
      update_embarquement_modifications_demandees
      embarquement_valide_to_editeur
      embarquement_valide_to_demandeur_is_tech_is_metier
      embarquement_valide_to_demandeur_seulement
      embarquement_valide_to_metier_cc_demandeur_tech
      embarquement_valide_to_demandeur_is_metier_not_tech
      embarquement_valide_to_demandeur_is_tech_not_metier
      embarquement_valide_to_tech_cc_demandeur_metier
      update_embarquement_valide_to_demandeur
      demande_recue
      update_demande_recue
    ],
    test_scopes: true,
    scope_test_method: 'embarquement_valide_to_demandeur_is_metier_not_tech',
    scope_label: I18n.t('api_entreprise.tokens.token.scope.entreprises.label')

  describe 'editor delegation request mails' do
    let(:authorization_request) { create(:authorization_request, :with_all_contacts, scopes: ['entreprises']) }

    before do
      create(:editor_delegation_request, authorization_request:, editor_use_case: create(:editor_use_case, editor: create(:editor, name: 'Omnikles ')))
    end

    {
      'delegation_editeur_demande_recue' => 'a bien été soumise',
      'delegation_editeur_demande_validee' => 'a été validée',
      'delegation_editeur_demande_refusee' => 'a été refusée'
    }.each do |method, status|
      describe "##{method}" do
        subject(:mail) { described_class.public_send(method, { to: 'demandeur@saint-exemple.fr', authorization_request: }) }

        it 'tells the demandeur what happens to the access through the editor' do
          body = mail.html_part.decoded

          expect(mail.to).to eq(['demandeur@saint-exemple.fr'])
          expect(mail.subject).to include(authorization_request.external_id)
          expect(body).to include(status)
          expect(body).to include('Omnikles')
        end

        it 'does not mention any token' do
          expect(mail.html_part.decoded).not_to match(/jeton|clé d'accès/i)
        end
      end
    end
  end
end
