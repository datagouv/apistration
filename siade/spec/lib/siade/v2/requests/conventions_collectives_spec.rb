RSpec.describe SIADE::V2::Requests::ConventionsCollectives, type: :provider_request do
  context 'bad formated request' do
    context 'invalid siret' do
      subject { described_class.new(invalid_siret).perform }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error(invalid_siret_error_message) }
    end
  end

  context 'well formated request', vcr: { cassette_name: 'fabrique_numerique_ministeres_sociaux/conventions_collectives/valid_siret' } do
    subject { described_class.new(valid_siret(:conventions_collectives)).perform }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end
end
