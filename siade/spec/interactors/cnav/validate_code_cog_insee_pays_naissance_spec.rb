RSpec.describe CNAV::ValidateCodeCogINSEEPaysNaissance, type: :validate_param_interactor do
  subject { described_class.call(params: { code_cog_insee_pays_naissance: }) }

  context 'when attribute is missing' do
    let(:code_cog_insee_pays_naissance) { nil }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when attribute is valid' do
    let(:code_cog_insee_pays_naissance) { '99100' }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when attribute is present but invalid' do
    let(:code_cog_insee_pays_naissance) { '12345' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
  end
end
