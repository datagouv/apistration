require 'rails_helper'

RSpec.shared_examples 'an authorization request mailer' do
  let(:authorization_request) { create(:authorization_request, :with_all_contacts, intitule: 'Marchés publics') }
  let(:to) { 'anything@email.com' }
  let(:cc) { 'anything2@email.com' }

  %w[demande_recue embarquement_modifications_demandees embarquement_demande_refusee demande_validee].each do |method|
    describe "##{method}" do
      [false, true].each do |update|
        context(update ? 'on an update' : 'on a first demande') do
          subject(:generate_email) { described_class.send(method, { to:, cc:, authorization_request:, update: }) }

          it 'displays the authorization_request external id in both parts' do
            expect(generate_email.html_part.decoded).to include(authorization_request.external_id)
            expect(generate_email.text_part.decoded).to include(authorization_request.external_id)
          end

          it 'mentions the update only on an update' do
            expect(generate_email.subject.include?('mise à jour') || generate_email.subject.include?('Mise à jour')).to eq(update)
          end
        end
      end
    end
  end

  describe '#demande_validee' do
    subject(:mail) { described_class.demande_validee({ to: [to], authorization_request:, update: false }) }

    context 'without editor' do
      it 'invites the contacts to create their token' do
        expect(mail.text_part.decoded).to include('Vous pouvez créer votre jeton')
        expect(mail.html_part.decoded).to include('Créer mon jeton')
      end
    end

    context 'when the demande is delegated to an editor using its own tokens' do
      let(:editor) { create(:editor, :delegable, name: 'Marchés Online') }

      before { create(:editor_delegation, editor:, authorization_request:) }

      it 'says the editor handles everything, without asking for a token' do
        expect(mail.subject).to end_with('✅ Demande validée ')
        expect(mail.text_part.decoded).to include("déléguée à l'éditeur Marchés Online")
        expect(mail.text_part.decoded).not_to include('créer votre jeton')
      end
    end

    context 'when the software editor of the form lets the client manage the token' do
      before { create(:editor, name: 'Logiciel Mairie', role: 'client_manages_token', form_uids: [authorization_request.demarche]) }

      let(:authorization_request) { create(:authorization_request, :with_all_contacts, demarche: 'logiciel-mairie') }

      it 'asks to paste the token in the software' do
        expect(mail.text_part.decoded).to include('saisissez-le dans le logiciel Logiciel Mairie')
      end
    end

    context 'on an update' do
      subject(:mail) { described_class.demande_validee({ to: [to], authorization_request:, update: true }) }

      it 'says the tokens remain valid' do
        expect(mail.text_part.decoded).to include('Vos jetons restent valables')
      end
    end
  end
end
