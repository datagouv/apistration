RSpec.shared_examples 'a make request with working mocking_params' do
  describe '#mocking_params' do
    subject { described_class.new(params:).send(:mocking_params) }

    it { is_expected.to be_a(Hash) }
  end
end
