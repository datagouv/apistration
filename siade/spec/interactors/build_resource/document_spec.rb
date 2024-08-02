RSpec.describe BuildResource::Document do
  let(:params) do
    {
      url: 'dummy_url',
      expires_in: 2.days.to_i
    }
  end

  describe 'resource' do
    subject { described_class.call(params).bundled_data.data }

    its(:document_url) { is_expected.to eq('dummy_url') }
    its(:expires_in) { is_expected.to eq(2.days.to_i) }
  end
end
