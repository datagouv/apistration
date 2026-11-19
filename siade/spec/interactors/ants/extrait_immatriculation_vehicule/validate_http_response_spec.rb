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

    describe 'when response has an unrecognized code' do
      let(:response) { instance_double(Net::HTTPOK, code: '200', body: { code: 99, libelle: 'Erreur inconnue', listeDossiers: nil }.to_json) }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with a success code but no dossier' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: { code: 0, libelle: 'Succès', listeDossiers: [] }.to_json) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with an http 500' do
    let(:response) { instance_double(Net::HTTPServerError, code: '500', body: '', to_hash: {}) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with an http 401 and an empty body' do
    let(:response) { instance_double(Net::HTTPUnauthorized, code: '401', body: '', to_hash: {}) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with an http 200 and a non-JSON body' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body: '<html>oops</html>', to_hash: {}) }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  [502, 503, 504].each do |status|
    context "with an http #{status} and an HTML body" do
      let(:response) { instance_double(Net::HTTPBadGateway, code: status.to_s, body: '<html>gateway</html>') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnavailable)) }
    end
  end

  context 'with an http 429' do
    let(:response) { instance_double(Net::HTTPTooManyRequests, code: '429', body: '') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderRateLimitingError)) }
  end
end
