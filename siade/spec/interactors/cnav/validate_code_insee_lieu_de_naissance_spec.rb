RSpec.describe CNAV::ValidateCodeINSEELieuDeNaissance, type: :validate_param_interactor do
  subject { described_class.call(params: { code_insee_lieu_de_naissance:, code_pays_lieu_de_naissance: }) }

  let(:code_pays_lieu_de_naissance) { nil }

  context 'when attribute is missing' do
    let(:code_insee_lieu_de_naissance) { nil }

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_empty }
  end

  context 'when attribute is present' do
    context 'when it is 5 valid digits' do
      let(:code_insee_lieu_de_naissance) { '12345' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 5 valid digits as integer' do
      let(:code_insee_lieu_de_naissance) { 12_345 }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'when it is 6 digits' do
      let(:code_insee_lieu_de_naissance) { '123456' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 4 digits' do
      let(:code_insee_lieu_de_naissance) { '1234' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is 5 chars non digits' do
      let(:code_insee_lieu_de_naissance) { '9953A' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is corse' do
      let(:code_insee_lieu_de_naissance) { '2A004' }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end
  end

  describe 'non regression test' do
    context 'when it is empty and code_pays_lieu_de_naissance is France' do
      let(:code_pays_lieu_de_naissance) { '99100' }
      let(:code_insee_lieu_de_naissance) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end
end
