RSpec.describe SIADE::V2::Requests::MarquesINPI, type: :provider_request do
  subject { described_class.new(siren).perform }

  context 'bad formated request' do
    let(:siren) { not_a_siren }

    its(:http_code) { is_expected.to eq(422) }
    its(:errors) { is_expected.to have_error(invalid_siren_error_message) }
  end

  context 'well formated request', vcr: { cassette_name: 'marques_inpi_with_valid_siren' } do
    let(:siren) { valid_siren(:inpi) }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end
end
