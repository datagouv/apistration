RSpec.describe EditorUseCase do
  it 'has a valid factory' do
    expect(build(:editor_use_case)).to be_valid
  end

  it 'is unique per editor and DataPass formulaire' do
    existing = create(:editor_use_case)

    expect(build(:editor_use_case, editor: existing.editor)).not_to be_valid
    expect(build(:editor_use_case)).to be_valid
  end

  describe '#datapass_data' do
    subject(:datapass_data) { editor_use_case.datapass_data }

    let(:editor_use_case) { build(:editor_use_case, data: { 'intitule' => 'Omnikles', 'scopes' => %w[entreprises] }) }

    before { stub_datapass_formulaires }

    it 'overrides the DataPass formulaire data with the editor data' do
      expect(datapass_data).to include(
        'cadre_juridique_nature' => 'Marchés publics',
        'intitule' => 'Omnikles',
        'scopes' => %w[entreprises]
      )
    end
  end
end
