require 'rails_helper'

RSpec.describe EditorProfileBackfillService do
  subject(:service) { described_class.new }

  def set_legacy_columns(editor, sql)
    Editor.where(id: editor.id).update_all(sql)
  end

  describe '#fill_missing_apis' do
    it 'gives an editor without API the ones named by the prefix of its DataPass forms' do
      editor = create(:editor, apis: %w[entreprise])
      set_legacy_columns(editor, "apis = '{}', form_uids = ARRAY['api-particulier-abelium', 'api-entreprise-mgdis']::varchar[]")

      service.fill_missing_apis

      expect(editor.reload.apis).to match_array(%w[entreprise particulier])
    end

    it 'gives an editor without API nor form the API of the back-office it was created from' do
      editor = create(:editor, apis: %w[entreprise])
      set_legacy_columns(editor, "apis = '{}'")
      create(:admin_activity, name: 'editor_created', namespace: 'particulier', entity: editor)

      service.fill_missing_apis

      expect(editor.reload.apis).to eq(%w[particulier])
    end

    it 'leaves the APIs of the other editors alone' do
      editor = create(:editor, apis: %w[entreprise])
      set_legacy_columns(editor, "form_uids = ARRAY['api-particulier-abelium']::varchar[]")

      service.fill_missing_apis

      expect(editor.reload.apis).to eq(%w[entreprise])
    end
  end

  describe '#create_use_cases_from_form_uids' do
    let(:editor) { create(:editor, name: 'Abelium', apis: %w[particulier]) }

    before do
      set_legacy_columns(editor,
        "form_uids = ARRAY['api-particulier-abelium', 'api-particulier-abelium-petite-enfance', 'api-particulier-unknown']::varchar[], " \
        "setup_instructions = 'Menu Paramètres > API'")
      service.create_use_cases_from_form_uids
    end

    it 'keeps every DataPass form of the editor, the delegation link' do
      expect(editor.reload.form_uids).to eq(%w[api-particulier-abelium api-particulier-abelium-petite-enfance api-particulier-unknown])
    end

    it 'gives each known form its DataPass use case, and leaves the unknown ones to complete' do
      expect(editor.use_cases.pluck(:form_uid, :use_case)).to contain_exactly(
        %w[api-particulier-abelium tarification_municipale_enfance],
        %w[api-particulier-abelium-petite-enfance tarification_eaje],
        ['api-particulier-unknown', nil]
      )
    end

    it 'carries the editor name as software and its token setup instructions to each use case' do
      expect(editor.use_cases.pluck(:software, :setup_instructions).uniq).to eq([['Abelium', 'Menu Paramètres > API']])
    end
  end

  describe '#move_contacts_to_technical_contacts' do
    it 'turns the former contact email and phone of an editor into a technical contact' do
      editor = create(:editor)
      set_legacy_columns(editor, "contact_email = 'legacy@editor.com', contact_phone = '0611111111'")

      service.move_contacts_to_technical_contacts

      expect(editor.contacts.pluck(:role, :email, :phone)).to eq([%w[technical legacy@editor.com 0611111111]])
    end

    it 'creates no contact for an editor without contact email nor phone' do
      editor = create(:editor)

      service.move_contacts_to_technical_contacts

      expect(editor.contacts).to be_empty
    end
  end
end
