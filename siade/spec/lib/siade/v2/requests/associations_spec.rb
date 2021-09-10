RSpec.describe SIADE::V2::Requests::Associations, type: :provider_request do
  context 'bad formated request' do
    context 'invalid siret' do
      subject { described_class.new(invalid_siret).perform }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error('Le numéro de siret ou le numéro d\'association indiqué n\'est pas correctement formatté') }
    end

    context 'invalid rna id' do
      subject { described_class.new(invalid_rna_id).perform }

      its(:http_code) { is_expected.to eq(422) }
      its(:errors) { is_expected.to have_error('Le numéro de siret ou le numéro d\'association indiqué n\'est pas correctement formatté') }
    end
  end

  context 'well formated request', vcr: { cassette_name: 'rna_association/42135938100033' } do
    subject { described_class.new(valid_siret(:rna)).perform }

    its(:http_code) { is_expected.to eq(200) }
    its(:errors) { is_expected.to be_empty }
  end
end
