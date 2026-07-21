RSpec.describe APIParticulier::CNOUS::EtudiantBoursier::V5, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNOUS::BuildResource.call(response:, params:).bundled_data }

  let(:params) { {} }

  let(:response) { OpenStruct.new(body: cnous_valid_payload('ine').to_json) }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with cnous_ine scope' do
    let(:scopes) { %w[cnous_ine] }

    it 'exposes the INE' do
      expect(subject[:data][:ine]).to eq('012345678GD')
    end

    context 'when the call was made with an INE' do
      let(:params) { { ine: '012345678GD' } }

      it 'exposes the INE' do
        expect(subject[:data][:ine]).to eq('012345678GD')
      end
    end
  end

  context 'without cnous_ine scope' do
    let(:scopes) { %w[cnous_identite cnous_statut_boursier] }

    it 'does not have ine' do
      expect(subject[:data]).not_to have_key(:ine)
    end

    it 'keeps the v4 attributes' do
      expect(subject[:data]).to have_key(:identite)
      expect(subject[:data]).to have_key(:statut_boursier)
    end
  end
end
