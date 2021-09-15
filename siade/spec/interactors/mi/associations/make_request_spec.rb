RSpec.describe MI::Associations::MakeRequest, type: :make_request do
  subject { described_class.call(params: params) }

  let(:params) do
    {
      id: rna_id,
    }
  end

  describe 'happy path', vcr: { cassette_name: 'mi/associations/with_valid_rna_id' } do
    let(:rna_id) { valid_rna_id }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
