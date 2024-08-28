RSpec.describe CNAV::ValidateCodeCogINSEECommuneDeNaissanceOrTranscogageParams, type: :validate_param_interactor do
  subject { described_class.call(params:) }

  describe 'with code insee lieu de naissance' do
    let(:params) { { code_cog_insee_commune_de_naissance:, code_pays_lieu_de_naissance: '99100' } }

    context 'when it is not valid' do
      let(:code_cog_insee_commune_de_naissance) { nil }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'when it is valid' do
      let(:code_cog_insee_commune_de_naissance) { '12345' }

      it { is_expected.to be_a_success }
    end
  end

  describe 'with transcogage params' do
    let(:params) do
      {
        nom_commune_naissance: 'Gennevilliers',
        annee_date_de_naissance:,
        code_cog_insee_departement_de_naissance: '92',
        code_pays_lieu_de_naissance: '99100'
      }
    end

    context 'when it is valid' do
      let(:annee_date_de_naissance) { '2000' }

      it { is_expected.to be_a_success }
    end

    context 'when it is not valid' do
      let(:annee_date_de_naissance) { 'invalid' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end
  end

  describe 'with nor code insee lieu de naissance nor transcogage params' do
    describe 'when in france' do
      let(:params) { { code_pays_lieu_de_naissance: '99100' } }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    describe 'when not in france' do
      let(:params) { { code_pays_lieu_de_naissance: '99345' } }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end
  end
end
