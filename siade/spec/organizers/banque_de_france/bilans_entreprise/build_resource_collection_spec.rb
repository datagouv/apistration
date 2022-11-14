RSpec.describe BanqueDeFrance::BilansEntreprise::BuildResourceCollection, type: :build_resource, vcr: { cassette_name: 'dgfip/dictionaries/2020_and_2021' } do
  subject { organizer }

  let(:organizer) { described_class.call(response:) }

  let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }
  let(:body) { build_banque_de_france_response(json_body) }

  let(:json_body) { open_payload_file('banque_de_france/bilans_entreprise_valid_data.json').read }

  it { is_expected.to be_a_success }

  it 'builds valid resources' do
    expect(organizer.bundled_data.data).to all be_a(Resource)
  end

  describe 'declarations item' do
    subject { organizer.bundled_data.data.first.declarations }

    it 'has augmented information from dictionaries' do
      imprime_2051 = subject.find { |declaration| declaration[:numero_imprime] == '2051' }

      codes_nref_with_augmented_data = %w[300438 300476]

      imprime_2051[:donnees].each do |datum|
        if codes_nref_with_augmented_data.include?(datum[:code_nref])
          expect(datum).to have_key(:code_absolu)
        else
          expect(datum).not_to have_key(:code_absolu)
        end
      end
    end
  end
end
