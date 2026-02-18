RSpec.describe MEN::ScolaritesPerimetre::ValidatePerimetre, type: :validate_param_interactor do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        codes_cog_insee_communes:,
        codes_bcn_men_departements:,
        codes_bcn_men_regions:,
        identifiants_siren_intercommunalites:
      }
    end

    let(:codes_cog_insee_communes) { nil }
    let(:codes_bcn_men_departements) { nil }
    let(:codes_bcn_men_regions) { nil }
    let(:identifiants_siren_intercommunalites) { nil }

    context 'with one commune perimetre' do
      let(:codes_cog_insee_communes) { %w[75056] }

      it { is_expected.to be_a_success }

      it 'sets perimetre_type' do
        expect(subject.perimetre_type).to eq('commune')
      end

      it 'sets perimetre_valeurs' do
        expect(subject.perimetre_valeurs).to eq(%w[75056])
      end
    end

    context 'with one departement perimetre' do
      let(:codes_bcn_men_departements) { %w[075] }

      it { is_expected.to be_a_success }

      it 'sets perimetre_type' do
        expect(subject.perimetre_type).to eq('departement')
      end
    end

    context 'with one region perimetre' do
      let(:codes_bcn_men_regions) { %w[11] }

      it { is_expected.to be_a_success }

      it 'sets perimetre_type' do
        expect(subject.perimetre_type).to eq('region')
      end
    end

    context 'with one intercommunalite perimetre' do
      let(:identifiants_siren_intercommunalites) { %w[200054781] }

      it { is_expected.to be_a_success }

      it 'sets perimetre_type' do
        expect(subject.perimetre_type).to eq('communaute_commune')
      end
    end

    context 'with no perimetre provided' do
      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with two perimetres provided' do
      let(:codes_cog_insee_communes) { %w[75056] }
      let(:codes_bcn_men_departements) { %w[075] }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(UnprocessableEntityError)) }
    end

    context 'with empty array perimetre' do
      let(:codes_cog_insee_communes) { [] }

      it { is_expected.to be_a_failure }
    end

    context 'with array containing blank value' do
      let(:codes_cog_insee_communes) { [''] }

      it { is_expected.to be_a_failure }
    end
  end
end
