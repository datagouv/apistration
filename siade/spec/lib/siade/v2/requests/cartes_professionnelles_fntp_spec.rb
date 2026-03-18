RSpec.describe SIADE::V2::Requests::CartesProfessionnellesFNTP, type: :provider_request do
  subject { described_class.new(siren).perform }

  context 'invalid siren request' do
    let(:siren) { invalid_siren }

    its(:http_code) { is_expected.to eq(422) }
    its(:errors) { is_expected.to have_error(invalid_siren_error_message) }
  end

  context 'good request', vcr: { cassette_name: 'fntp_with_valid_siren' } do
    let(:siren) { valid_siren(:fntp) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end
end
