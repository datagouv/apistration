require 'rails_helper'

RSpec.describe UserAuthorizationRequestRole do
  let(:demandeur) { create(:user) }
  let(:contact_technique) { create(:user) }
  let(:contact_metier) { create(:user) }

  describe 'role uniqueness per authorization request' do
    let(:authorization_request) { create(:authorization_request) }

    before do
      create(:user_authorization_request_role, :contact_technique, authorization_request:)
    end

    it 'rejects a second user on the same role' do
      expect(build(:user_authorization_request_role, :contact_technique, authorization_request:)).not_to be_valid
    end

    it 'enforces it at the database level' do
      expect {
        build(:user_authorization_request_role, :contact_technique, authorization_request:).save!(validate: false)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'accepts another role on the same authorization request' do
      expect(build(:user_authorization_request_role, :contact_metier, authorization_request:)).to be_valid
    end
  end

  describe 'factory' do
    let(:user) { create(:user) }

    describe 'demandeur association' do
      subject { create(:user_authorization_request_role, :demandeur, user:) }

      it 'returns demandeur' do
        expect(subject.demandeur).to eq(user)
      end
    end

    describe 'contact_technique association' do
      subject { create(:user_authorization_request_role, :contact_technique, user:) }

      it 'returns contact technique' do
        expect(subject.contact_technique).to eq(user)
      end
    end

    describe 'contact_metier association' do
      subject { create(:user_authorization_request_role, :contact_metier, user:) }

      it 'returns contact metier' do
        expect(subject.contact_metier).to eq(user)
      end
    end
  end
end
