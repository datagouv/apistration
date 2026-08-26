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

    context 'when the provider rejected the cached token' do
      let(:id) { valid_siren }
      let(:token) { 'stale_data_subvention_token' }

      let!(:stubbed_rejected_request) { stub_datasubvention_subventions_stale_token(id:) }
      let!(:stubbed_authenticate) { stub_datasubvention_subventions_authenticate }
      let!(:stubbed_request) { stub_datasubvention_subventions_valid(id:) }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }

      it 'replays the call once with a freshly retrieved token' do
        subject

        expect(stubbed_rejected_request).to have_been_made.once
        expect(stubbed_authenticate).to have_been_made.once
        expect(stubbed_request).to have_been_made.once
      end
    end

    context 'when the provider keeps rejecting a freshly retrieved token' do
      let(:id) { valid_siren }
      let(:token) { 'stale_data_subvention_token' }

      let!(:stubbed_authenticate) { stub_datasubvention_subventions_authenticate }
      let!(:stubbed_rejected_request) { stub_datasubvention_subventions_stale_token(id:) }
      let!(:stubbed_rejected_retry) { stub_datasubvention_subventions_stale_token(id:, token: 'data_subvention_token') }

      it 'does not loop over authentication' do
        subject

        expect(stubbed_authenticate).to have_been_made.once
        expect(stubbed_rejected_request).to have_been_made.once
        expect(stubbed_rejected_retry).to have_been_made.once
      end

      its(:response) { is_expected.to be_a(Net::HTTPUnauthorized) }
    end
  end
end
