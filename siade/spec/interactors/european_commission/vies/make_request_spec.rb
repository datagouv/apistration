RSpec.describe EuropeanCommission::VIES::MakeRequest, type: :make_request do
  describe '.call' do
    subject(:make_call) { described_class.call(tva_number:) }

    let(:tva_number) { danone_tva_number }
    let(:tva_number_without_fr) { danone_tva_number[2..] }

    let!(:stubbed_request) do
      stub_request(:get, "#{Siade.credentials[:european_commission_vies_url]}/#{tva_number_without_fr}")
    end

    it { is_expected.to be_a_success }

    it 'calls stubbed request' do
      make_call

      expect(stubbed_request).to have_been_requested
    end
  end
end
