RSpec.describe PROBTP::ConformitesCotisationsRetraite::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, code:, body:) }

    context 'when it is ok and conforme', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_eligible_siret' } do
      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params: { siret: eligible_siret(:probtp) })
          .response
          .body
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is ok and not conforme', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_non_eligible_siret' } do
      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params: { siret: non_eligible_siret(:probtp) })
          .response
          .body
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when siret is not found', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_not_found_siret' } do
      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params: { siret: not_found_siret(:probtp) })
          .response
          .body
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
    end

    context 'when there is an internal error from PROBTP (expected valid JSON error)' do
      let(:code) { 200 }
      let(:body) { '{"entete":{"code":"4","message":"Une erreur est survenue, merci de bien vouloir renouveler votre demande ultérieurement"}}' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }

      it 'adds error message do ProviderInternalServerError' do
        expect(subject.errors).to have_error('Erreur fournisseur: Une erreur est survenue, merci de bien vouloir renouveler votre demande ultérieurement')
      end
    end
  end
end
