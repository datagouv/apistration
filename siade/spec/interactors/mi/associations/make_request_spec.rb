RSpec.describe MI::Associations::MakeRequest, type: :make_request do
  subject { described_class.call(params:) }

  let(:rna_id) { valid_rna_id }
  let(:params) do
    {
      id: rna_id
    }
  end

  it_behaves_like 'a make request with working mocking_params'

  describe 'happy path' do
    before { stub_mi_associations_valid_rna }

    it { is_expected.to be_a_success }

    its(:response) { is_expected.to be_a(Net::HTTPOK) }
  end
end
