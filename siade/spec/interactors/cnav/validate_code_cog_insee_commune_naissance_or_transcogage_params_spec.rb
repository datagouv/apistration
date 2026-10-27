RSpec.describe CNAV::ValidateCodeCogINSEECommuneNaissanceOrTranscogageParams, type: :validate_param_interactor do
  subject { described_class.call(params:) }

  describe 'with code insee lieu de naissance' do
    let(:params) { { code_cog_insee_commune_naissance:, code_cog_insee_pays_naissance: '99100' } }

    context 'when it is not provided' do
      let(:code_cog_insee_commune_naissance) { nil }

      it { is_expected.to be_a_success }
    end

    context 'when it is provided but invalid' do
      let(:code_cog_insee_commune_naissance) { 'invalid' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is valid' do
      let(:code_cog_insee_commune_naissance) { '12345' }

      it { is_expected.to be_a_success }
    end
  end

  describe 'with transcogage params' do
    let(:params) do
      {
        nom_commune_naissance: 'Gennevilliers',
        annee_date_naissance:,
        code_cog_insee_departement_naissance: '92',
        code_cog_insee_pays_naissance: '99100'
      }
    end

    context 'when it is valid' do
      let(:annee_date_naissance) { '2000' }

      it { is_expected.to be_a_success }
    end

    context 'when it is not valid' do
      let(:annee_date_naissance) { 'invalid' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when the departement code is not valid' do
      let(:annee_date_naissance) { '2000' }
      let(:params) do
        {
          nom_commune_naissance: 'Gennevilliers',
          annee_date_naissance:,
          code_cog_insee_departement_naissance: '99',
          code_cog_insee_pays_naissance: '99100'
        }
      end

      it { is_expected.to be_a_failure }

      it 'points at the departement code' do
        expect(subject.errors.first.code).to eq('00428')
      end
    end
  end

  describe 'with incomplete transcogage params' do
    let(:params) do
      {
        nom_commune_naissance: 'Gennevilliers',
        annee_date_naissance: '2007',
        code_cog_insee_pays_naissance:
      }
    end

    context 'when born in France' do
      let(:code_cog_insee_pays_naissance) { '99100' }

      it { is_expected.to be_a_failure }

      it 'points at the missing departement code' do
        expect(subject.errors.map(&:code)).to eq(['00428'])
      end
    end

    context 'when born in France with only the departement code' do
      let(:params) { { code_cog_insee_departement_naissance: '92', annee_date_naissance: '2007', code_cog_insee_pays_naissance: '99100' } }

      it { is_expected.to be_a_failure }

      it 'points at the missing commune name' do
        expect(subject.errors.map(&:code)).to eq(['00317'])
      end
    end

    context 'when born abroad' do
      let(:code_cog_insee_pays_naissance) { '99345' }

      it { is_expected.to be_a_success }
    end
  end

  describe 'with nor code insee lieu de naissance nor transcogage params' do
    describe 'when in france' do
      let(:params) { { code_cog_insee_pays_naissance: '99100' } }

      it { is_expected.to be_a_success }
    end

    describe 'when not in france' do
      let(:params) { { code_cog_insee_pays_naissance: '99345' } }

      it { is_expected.to be_a_success }
    end
  end
end
