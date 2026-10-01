RSpec.describe EditorDelegationRequest do
  it 'has a valid factory' do
    expect(build(:editor_delegation_request)).to be_valid
    expect(build(:editor_delegation_request, :with_authorization_request)).to be_valid
    expect(build(:editor_delegation_request, :submitted)).to be_valid
  end

  it 'requires a 14 digits siret' do
    expect(build(:editor_delegation_request, siret: '213401821')).not_to be_valid
  end

  it 'is unique per editor use case and siret' do
    existing = create(:editor_delegation_request)

    expect(build(:editor_delegation_request, editor_use_case: existing.editor_use_case, siret: existing.siret)).not_to be_valid
    expect(build(:editor_delegation_request, siret: existing.siret)).to be_valid
  end

  describe 'invitation token' do
    let(:editor_delegation_request) { create(:editor_delegation_request) }

    it 'resolves the request' do
      token = editor_delegation_request.generate_token_for(:invitation)

      expect(described_class.find_by_token_for(:invitation, token)).to eq(editor_delegation_request)
    end

    it 'is stable, so that links can be generated again' do
      token = editor_delegation_request.generate_token_for(:invitation)

      expect(described_class.find(editor_delegation_request.id).generate_token_for(:invitation)).to eq(token)
    end

    it 'rejects a forged token' do
      expect(described_class.find_by_token_for(:invitation, 'forged')).to be_nil
    end
  end

  describe '#datapass_data' do
    subject(:datapass_data) { editor_delegation_request.datapass_data }

    let(:editor_use_case) { build(:editor_use_case, data: { 'intitule' => 'Omnikles', 'delegue_protection_donnees_email' => 'editor@omnikles.fr' }) }
    let(:editor_delegation_request) { build(:editor_delegation_request, :with_dpo, editor_use_case:) }

    before { stub_datapass_formulaires }

    it 'merges DataPass formulaire, editor use case and client data, from the most generic to the most specific' do
      expect(datapass_data).to include(
        'cadre_juridique_nature' => 'Marchés publics',
        'intitule' => 'Omnikles',
        'delegue_protection_donnees_email' => 'dpo@saint-exemple.fr'
      )
    end
  end

  describe 'data protection officer' do
    subject(:editor_delegation_request) { build(:editor_delegation_request, :with_dpo) }

    it 'is valid with the five DataPass contact fields' do
      expect(editor_delegation_request).to be_valid(:data_protection_officer)
    end

    it 'requires every field' do
      EditorDelegationRequest::DATA_PROTECTION_OFFICER_ATTRIBUTES.each do |attribute|
        editor_delegation_request.public_send(:"#{attribute}=", ' ')

        expect(editor_delegation_request).not_to be_valid(:data_protection_officer)
        expect(editor_delegation_request.errors[attribute]).to be_present
      end
    end

    it 'requires a valid email' do
      editor_delegation_request.delegue_protection_donnees_email = 'not an email'

      expect(editor_delegation_request).not_to be_valid(:data_protection_officer)
    end

    it 'normalizes values like DataPass' do
      editor_delegation_request.delegue_protection_donnees_email = ' DPO@Saint-Exemple.fr '
      editor_delegation_request.delegue_protection_donnees_given_name = ' Dominique '

      expect(editor_delegation_request.delegue_protection_donnees_email).to eq('dpo@saint-exemple.fr')
      expect(editor_delegation_request.delegue_protection_donnees_given_name).to eq('Dominique')
    end

    it 'is not required outside of this step' do
      expect(build(:editor_delegation_request)).to be_valid
    end
  end

  describe '#submitted?' do
    it { expect(build(:editor_delegation_request)).not_to be_submitted }
    it { expect(build(:editor_delegation_request, :submitted)).to be_submitted }
  end

  describe '#editor' do
    it 'is the editor of the use case' do
      editor_delegation_request = build(:editor_delegation_request)

      expect(editor_delegation_request.editor).to eq(editor_delegation_request.editor_use_case.editor)
    end
  end
end
