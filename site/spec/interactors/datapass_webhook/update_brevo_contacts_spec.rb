# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatapassWebhook::UpdateBrevoContacts, type: :interactor do
  subject { described_class.call(authorization_request:) }

  let(:authorization_request) { create(:authorization_request) }
  let(:entreprise_list_id) { 3 }

  before do
    stub_brevo_contacts_upsert
  end

  it { is_expected.to be_a_success }

  describe 'with only a demandeur' do
    let(:authorization_request) { create(:authorization_request, :with_demandeur) }

    it 'adds the demandeur to the API Entreprise list with its name and roles, without touching its subscription status' do
      subject

      expect(
        brevo_contact_upsert(
          email: authorization_request.demandeur.email,
          attributes: {
            'PRENOM' => authorization_request.demandeur.first_name,
            'NOM' => authorization_request.demandeur.last_name,
            'CONTACT_DEMANDEUR' => true,
            'CONTACT_METIER' => false,
            'CONTACT_TECHNIQUE' => false
          },
          list_id: entreprise_list_id
        )
      ).to have_been_made.once
    end
  end

  context 'with valid contacts' do
    let(:authorization_request) { create(:authorization_request, :with_demandeur, :with_contact_metier, :with_contact_technique) }

    it 'adds each contact once, flagged with its own role' do
      subject

      expect(a_request(:post, BrevoAPIMocks::BREVO_CONTACTS_URL)).to have_been_made.times(3)
      [
        [authorization_request.demandeur, { 'CONTACT_DEMANDEUR' => true, 'CONTACT_METIER' => false, 'CONTACT_TECHNIQUE' => false }],
        [authorization_request.contact_metier, { 'CONTACT_DEMANDEUR' => false, 'CONTACT_METIER' => true, 'CONTACT_TECHNIQUE' => false }],
        [authorization_request.contact_technique, { 'CONTACT_DEMANDEUR' => false, 'CONTACT_METIER' => false, 'CONTACT_TECHNIQUE' => true }]
      ].each do |contact, roles|
        expect(
          brevo_contact_upsert(email: contact.email, attributes: hash_including(roles), list_id: entreprise_list_id)
        ).to have_been_made.once
      end
    end

    context 'when contact technique is the same as demandeur' do
      let(:authorization_request) { create(:authorization_request, :with_contact_metier, :with_roles, roles: %i[demandeur contact_technique]) }

      it 'sends the shared contact once with both roles' do
        subject

        expect(a_request(:post, BrevoAPIMocks::BREVO_CONTACTS_URL)).to have_been_made.twice
        expect(
          brevo_contact_upsert(
            email: authorization_request.demandeur.email,
            attributes: hash_including('CONTACT_DEMANDEUR' => true, 'CONTACT_METIER' => false, 'CONTACT_TECHNIQUE' => true),
            list_id: entreprise_list_id
          )
        ).to have_been_made.once
      end
    end

    context 'when all contacts emails are the same' do
      let(:authorization_request) { create(:authorization_request, :with_roles, roles: %i[demandeur contact_metier contact_technique]) }

      it 'sends a single contact with every role' do
        subject

        expect(a_request(:post, BrevoAPIMocks::BREVO_CONTACTS_URL)).to have_been_made.once
        expect(
          brevo_contact_upsert(
            email: authorization_request.users.first.email,
            attributes: hash_including('CONTACT_DEMANDEUR' => true, 'CONTACT_METIER' => true, 'CONTACT_TECHNIQUE' => true),
            list_id: entreprise_list_id
          )
        ).to have_been_made.once
      end
    end
  end

  describe 'when on API Particulier' do
    let(:authorization_request) { create(:authorization_request, :with_demandeur, :with_contact_technique, api: 'particulier') }

    it 'adds contacts to the API Particulier list, without the contact métier attribute' do
      subject

      [
        [authorization_request.demandeur, true, false],
        [authorization_request.contact_technique, false, true]
      ].each do |contact, demandeur, technique|
        expect(
          brevo_contact_upsert(
            email: contact.email,
            attributes: {
              'PRENOM' => contact.first_name,
              'NOM' => contact.last_name,
              'CONTACT_DEMANDEUR' => demandeur,
              'CONTACT_TECHNIQUE' => technique
            },
            list_id: 4
          )
        ).to have_been_made.once
      end
    end
  end

  describe 'when Brevo rejects the contact' do
    let(:authorization_request) { create(:authorization_request, :with_demandeur) }

    before do
      stub_brevo_contacts_upsert(status: 400)
    end

    it 'raises, so that the DataPass webhook fails as it did with Mailjet' do
      expect { subject }.to raise_error(Faraday::BadRequestError)
    end
  end

  describe 'when the authorization request comes from an editor delegation request' do
    let(:authorization_request) { create(:authorization_request, :with_demandeur) }

    before { create(:editor_delegation_request, authorization_request:) }

    it 'does not subscribe its contacts' do
      subject

      expect(a_request(:post, BrevoAPIMocks::BREVO_CONTACTS_URL)).not_to have_been_made
    end
  end
end
