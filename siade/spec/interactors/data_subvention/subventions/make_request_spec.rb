RSpec.describe DataSubvention::Subventions::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, token:) }

    let(:token) { 'data_subvention_token' }
    let(:params) do
      {
        siren_or_siret_or_rna: id
      }
    end

    context 'when it works' do
      let!(:stubbed_request) do
        stub_datasubvention_subventions_valid(id:)
      end

      let(:id) { valid_siren }

      it { is_expected.to be_a_success }

      it 'calls the right endpoint' do
        subject

        expect(stubbed_request).to have_been_made.once
      end

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
