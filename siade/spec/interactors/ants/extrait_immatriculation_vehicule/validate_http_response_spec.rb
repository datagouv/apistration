RSpec.describe ANTS::ExtraitImmatriculationVehicule::ValidateHTTPResponse, type: :validate_response do
  subject { described_class.call(response:, params:) }

  let(:params) do
    {
      nom_naissance: 'DUPONT',
      prenoms: ['JEAN'],
      sexe_etat_civil: 'M',
      annee_date_naissance: 1955,
      mois_date_naissance: 12,
      jour_date_naissance: 8,
      code_cog_insee_commune_naissance: '59001'
    }
  end

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    describe 'when response body indicates found' do
      let(:body) { read_payload_file('ants/found_siv.xml') }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    describe 'when response body indicates not found' do
      let(:body) { read_payload_file('ants/not_found.xml') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

      context 'with binary encoding (ASCII-8BIT)' do
        let(:body) { read_payload_file('ants/not_found.xml').force_encoding('ASCII-8BIT') }

        it 'handles encoding compatibility without error' do
          expect { subject }.not_to raise_error
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end
  end

  context 'with an http 500' do
    let(:response) { instance_double(Net::HTTPServerError, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
