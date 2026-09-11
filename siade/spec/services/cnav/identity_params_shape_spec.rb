RSpec.describe CNAV::IdentityParamsShape, type: :service do
  subject(:shape) { described_class.new(params).to_h }

  context 'with plain identity params' do
    let(:params) do
      {
        nom_naissance: 'CHAMPION',
        prenoms: %w[JEAN-PASCAL MARIE],
        code_cog_insee_commune_naissance: '17300',
        code_cog_insee_pays_naissance: '99100'
      }
    end

    it 'describes each value by its length and character traits, never its content' do
      expect(shape).to eq(
        nom_naissance: '8:',
        prenoms: '11:hyphen | 5:',
        code_cog_insee_commune_naissance: '5:17',
        code_cog_insee_pays_naissance: '5:99'
      )
    end
  end

  context 'with the characters the gateway may refuse' do
    let(:params) do
      {
        nom_naissance: " D'ARC",
        nom_usage: 'de la  Tour 2',
        prenoms: ['Jean-Noël', 'Ξένια', 'O.BRIEN'],
        code_cog_insee_commune_naissance: '2A004',
        code_cog_insee_departement_naissance: '00'
      }
    end

    it 'names them' do
      expect(shape).to eq(
        nom_naissance: '6:apostrophe,edge_space',
        nom_usage: '13:inner_space,double_space,digit,lowercase',
        prenoms: '9:hyphen,lowercase,accent | 5:lowercase,non_transliterable | 7:other',
        code_cog_insee_commune_naissance: '5:2A',
        code_cog_insee_departement_naissance: '2:00'
      )
    end
  end

  context 'with string keys' do
    let(:params) { { 'nom_naissance' => 'X' } }

    it { is_expected.to eq(nom_naissance: '1:') }
  end

  context 'without params' do
    let(:params) { nil }

    it { is_expected.to eq({}) }
  end
end
