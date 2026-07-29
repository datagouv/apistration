RSpec.describe Editor do
  it 'has a valid factory' do
    expect(build(:editor)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:editor_delegations).dependent(:destroy) }
    it { is_expected.to have_many(:tokens).class_name('EditorToken').dependent(:destroy) }
  end

  describe 'apis validation' do
    it { expect(build(:editor, apis: %w[entreprise particulier])).to be_valid }
    it { expect(build(:editor, apis: [])).to be_valid }
    it { expect(build(:editor, apis: %w[entreprise wrong])).not_to be_valid }
  end

  describe 'allowed_ips validation' do
    it { expect(build(:editor, allowed_ips: [])).to be_valid }
    it { expect(build(:editor, allowed_ips: ['203.0.113.10', '198.51.100.0/24'])).to be_valid }

    it 'rejects private ranges, which would make editor token generation fail' do
      editor = build(:editor, allowed_ips: ['192.168.1.1'])

      expect(editor).not_to be_valid
      expect(editor.errors[:allowed_ips]).to be_present
    end

    it 'rejects ranges wider than /24' do
      expect(build(:editor, allowed_ips: ['203.0.113.0/16'])).not_to be_valid
    end

    it 'rejects garbage entries' do
      expect(build(:editor, allowed_ips: ['not-an-ip'])).not_to be_valid
    end

    it 'leaves legacy records untouched as long as allowed_ips is not edited' do
      editor = build(:editor, allowed_ips: ['192.168.1.1'])
      editor.save!(validate: false)

      expect(editor.reload.update(name: 'Renamed')).to be(true)
    end
  end

  describe '.for_api' do
    let!(:entreprise_editor) { create(:editor, apis: %w[entreprise]) }
    let!(:particulier_editor) { create(:editor, apis: %w[particulier]) }
    let!(:both_editor) { create(:editor, apis: %w[entreprise particulier]) }

    it 'returns editors serving the given api' do
      expect(described_class.for_api('entreprise')).to contain_exactly(entreprise_editor, both_editor)
      expect(described_class.for_api('particulier')).to contain_exactly(particulier_editor, both_editor)
    end
  end

  describe '#serves_api?' do
    let(:editor) { build(:editor, apis: %w[entreprise]) }

    it { expect(editor.serves_api?('entreprise')).to be(true) }
    it { expect(editor.serves_api?('particulier')).to be(false) }
  end

  describe '.delegable' do
    let!(:delegable_editor) { create(:editor, :delegable) }
    let!(:non_delegable_editor) { create(:editor) }

    it 'returns only editors with editor_tokens_enabled' do
      expect(described_class.delegable).to contain_exactly(delegable_editor)
    end
  end

  describe 'authorization_requests association' do
    subject { editor.authorization_requests(api:) }

    let(:editor) { create(:editor, form_uids: %w[form1 form2]) }
    let(:api) { 'entreprise' }

    let!(:valid_authorization_requests) do
      [
        create(:authorization_request, api: 'entreprise', demarche: 'form1'),
        create(:authorization_request, api: 'entreprise', demarche: 'form2')
      ]
    end

    let!(:invalid_authorization_requests) do
      [
        create(:authorization_request, api: 'entreprise', demarche: 'wrong_form'),
        create(:authorization_request, api: 'particulier', demarche: 'form1')
      ]
    end

    it { is_expected.to match_array(valid_authorization_requests) }
    it { is_expected.to be_a(ActiveRecord::Relation) }
  end
end
