RSpec.describe PROBTP::ConformitesCotisationsRetraite::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, code:, body:) }

    context 'when it is ok and conforme' do
      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params: { siret: eligible_siret(:probtp) })
          .response
          .body
      end

      # `around` (not `before`) so the stub is registered ahead of the
      # `config.before(type: :validate_response)` hook, which forces `response`
      # to be evaluated (and thus the real HTTP call to fire) before any
      # example-level `before(:each)` hook would run.
      around do |example|
        stub_probtp_conformite_eligible
        example.run
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is ok and not conforme' do
      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params: { siret: non_eligible_siret(:probtp) })
          .response
          .body
      end

      around do |example|
        stub_probtp_conformite_non_eligible
        example.run
      end

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when siret is not found' do
      let(:code) { 200 }
      let(:body) do
        PROBTP::ConformitesCotisationsRetraite::MakeRequest
          .call(params: { siret: not_found_siret(:probtp) })
          .response
          .body
      end

      around do |example|
        stub_probtp_conformite_not_found
        example.run
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
