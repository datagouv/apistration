RSpec.describe MI::SIAF::Fondations::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren_or_siret_or_rnf:
      }
    end

    let(:siren_or_siret_or_rnf) { valid_rnf_id }

    it_behaves_like 'a make request with working mocking_params'

    it 'matches the staging mocks, keyed on the downcased call key' do
      expect(described_class.new(params:).send(:mocking_params)).to eq(siren_or_siret_or_rnf: valid_rnf_id.downcase)
    end

    context 'with an RNF id given in lowercase' do
      let(:siren_or_siret_or_rnf) { valid_rnf_id.downcase }
      let!(:stubbed_request) { stub_siaf_fondation(path: valid_rnf_id) }

      it 'requests the fondation by its uppercased RNF id, the only case the provider knows' do
        subject

        expect(stubbed_request).to have_been_requested
      end
    end

    context 'when the MI certificate chain file cannot be loaded' do
      before do
        stub_siaf_fondation
        stub_credential(:siaf_certificate_chain_path, Rails.root.join('tmp/missing_chain.pem').to_s)
      end

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(SSLCertificateError)) }
    end

    context 'with a siret' do
      let(:siren_or_siret_or_rnf) { fondation_siret }
      let!(:stubbed_request) { stub_siaf_fondation(path: "by_siret/#{fondation_siret}") }

      it 'requests the fondation by siret' do
        subject

        expect(stubbed_request).to have_been_requested
      end
    end

    context 'with a siren' do
      let(:siren_or_siret_or_rnf) { fondation_siren }
      let!(:stubbed_request) { stub_siaf_fondation(path: "by_siren/#{fondation_siren}") }

      it 'requests the fondation by siren' do
        subject

        expect(stubbed_request).to have_been_requested
      end
    end
  end
end
