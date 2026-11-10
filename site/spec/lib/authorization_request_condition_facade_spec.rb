require 'rails_helper'

RSpec.describe AuthorizationRequestConditionFacade do
  describe 'non regression test: when AuthorizationRequest doesnt have a contact technique' do
    let(:authorization_request) { create(:authorization_request, :with_demandeur) }
    let(:facade) { described_class.new(authorization_request) }

    let(:methods) do
      %i[
        not_editor_and_demandeur_different_to_other_contacts?
        not_editor_and_all_contacts_have_the_same_email?
        not_editor_and_user_is_contact_technique_and_not_contact_metier?
        not_editor_and_user_is_contact_metier_and_not_contact_technique?
      ]
    end

    it 'does not raise an error' do
      methods.each do |method|
        expect { facade.public_send(method) }.not_to raise_error
      end
    end
  end

  describe 'editor delegation requests' do
    let(:facade) { described_class.new(authorization_request) }
    let(:authorization_request) { create(:authorization_request, :with_demandeur, demarche: 'api-entreprise-marches-publics') }

    context 'when the authorization request comes from an editor delegation request' do
      before { create(:editor_delegation_request, authorization_request:) }

      it 'is only eligible to the editor delegation request mails' do
        expect(facade).to be_editor_delegation_request
        expect(facade).not_to be_not_editor_delegation_request
        expect(facade).not_to be_editor_authorization_request
        expect(facade).not_to be_not_editor_authorization_request
        expect(facade).not_to be_not_editor_and_all_contacts_have_the_same_email
      end
    end

    context 'when the authorization request does not come from an editor delegation request' do
      it 'is not eligible to the editor delegation request mails' do
        expect(facade).not_to be_editor_delegation_request
        expect(facade).to be_not_editor_delegation_request
        expect(facade).to be_not_editor_authorization_request
      end
    end
  end
end
