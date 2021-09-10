RSpec.describe SIADE::V2::Requests::CertificatsOPQIBI, type: :provider_request do
  subject { described_class.new(siren).perform }

  context 'bad formated request' do
    let(:siren) { not_a_siret }

    its(:http_code) { is_expected.to eq(422) }
    its(:errors) { is_expected.to have_error(invalid_siren_error_message) }
  end

  context 'well formated siren', vcr: { cassette_name: 'opqibi_with_valid_siren' } do
    let(:siren) { valid_siren(:opqibi) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end
end
