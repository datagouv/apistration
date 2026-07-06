RSpec.describe ANTS::ExtraitImmatriculationVehicule::ValidateHTTPResponse, type: :validate_response do
  subject { described_class.call(response:) }

  context 'with a http ok' do
    describe 'when response indicates success' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body: { code: 0, libelle: 'Succès', listeDossiers: [{}] }.to_json) }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    describe 'when response indicates the immatriculation was not found (code 60)' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body: { code: 60, libelle: 'Aucune réponse trouvée.', listeDossiers: nil }.to_json) }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    describe 'when response indicates the identity does not match (code 64)' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body: { code: 64, libelle: "Le numéro d'immatriculation n'est pas cohérent avec la personne.", listeDossiers: nil }.to_json) }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    describe 'when response has an unrecognized code' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body: { code: 99, libelle: 'Erreur inconnue', listeDossiers: nil }.to_json) }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with an http 500' do
    let(:response) { instance_double(Net::HTTPServerError, code: '500') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end
