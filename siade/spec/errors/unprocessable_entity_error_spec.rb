RSpec.describe UnprocessableEntityError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:siren) }
  end

  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:gip_mds_too_many_individus) }
  end
end
