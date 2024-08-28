RSpec.describe INSEE::CommuneINSEECode::ValidateDepartementCode do
  subject { described_class.call(params: { code_cog_insee_departement_de_naissance: }) }

  context 'with corse departement code' do
    let(:code_cog_insee_departement_de_naissance) { '2A' }

    it { is_expected.to be_success }
  end

  context 'with dom tom departement code' do
    let(:code_cog_insee_departement_de_naissance) { '971' }

    it { is_expected.to be_success }
  end

  context 'with metropole departement code' do
    let(:code_cog_insee_departement_de_naissance) { '01' }

    it { is_expected.to be_success }

    context 'when not formatted well' do
      let(:code_cog_insee_departement_de_naissance) { '1' }

      it { is_expected.to be_a_failure }
    end
  end

  context 'with invalid departement code' do
    let(:code_cog_insee_departement_de_naissance) { '999' }

    it { is_expected.to be_a_failure }
  end
end
