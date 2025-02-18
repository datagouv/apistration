RSpec.describe Civility::ValidateCodeCogINSEECommuneNaissance, type: :validate_param_interactor do
  subject { described_class.call(params: { code_cog_insee_commune_naissance: }) }

  context 'when attribute is missing' do
    let(:code_cog_insee_commune_naissance) { nil }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when attribute is present' do
    context 'when it is 5 valid digits' do
      let(:code_cog_insee_commune_naissance) { '12345' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 5 valid digits as integer' do
      let(:code_cog_insee_commune_naissance) { 12_345 }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 6 digits' do
      let(:code_cog_insee_commune_naissance) { '123456' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 4 digits' do
      let(:code_cog_insee_commune_naissance) { '1234' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 5 chars non digits' do
      let(:code_cog_insee_commune_naissance) { '9953A' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is corse' do
      let(:code_cog_insee_commune_naissance) { '2A004' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end
  end
end
