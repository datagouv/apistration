RSpec.describe ANTS::ExtraitImmatriculationVehicule::ValidateResponse, type: :validate_response do
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

    describe 'when response body indicated found' do
      describe 'when response body matches the personne physique' do
        let(:body) { read_payload_file('ants/found_siv.xml') }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      describe 'when response body doesnt match the personne physique' do
        let(:body) { read_payload_file('ants/found_personne_morale_siv.xml') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
      end
    end

    describe 'when response body has no match' do
      let(:body) { read_payload_file('ants/found_personne_morale_siv.xml') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    describe 'when response body indicates not found' do
      let(:body) { read_payload_file('ants/not_found.xml') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end
  end

  context 'with an http 500' do
    let(:response) { instance_double(Net::HTTPServerError, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
