RSpec.describe Datapass::SyncReferentialJob do
  subject(:sync) { described_class.perform_now }

  let(:url) { 'https://datapass.example.test/api/v1' }
  let(:json_headers) { { 'Content-Type' => 'application/json' } }

  before do
    stub_credential(:datapass_api, url:, client_id: 'datapass_client_id', client_secret: 'datapass_client_secret')
    stub_request(:post, "#{url}/oauth/token")
      .to_return(status: 200, headers: json_headers, body: { access_token: 'token', token_type: 'Bearer', expires_in: 7200 }.to_json)
    stub_definition('api_entreprise', forms: [], definition: { 'scopes' => [] })
    stub_definition('api_particulier', forms: fixture('formulaires_api_particulier'), definition: fixture('definition_api_particulier'))
  end

  def fixture(name)
    JSON.parse(Rails.root.join("spec/fixtures/datapass_api/#{name}.json").read)
  end

  def stub_definition(definition_id, forms:, definition:)
    stub_request(:get, "#{url}/definitions/#{definition_id}/formulaires")
      .to_return(status: 200, headers: json_headers, body: forms.to_json)
    stub_request(:get, "#{url}/definitions/#{definition_id}")
      .to_return(status: 200, headers: json_headers, body: definition.to_json)
  end

  it 'stores the DataPass forms of each API with their use case and pre-checked scopes' do
    sync

    expect(DatapassForm.find_by(uid: 'api-particulier-abelium')).to have_attributes(
      api: 'particulier',
      use_case: 'tarification_municipale_enfance',
      scopes: %w[cnaf_quotient_familial],
      data_retention_months: 36,
      data_recipients: 'Agents du service enfance'
    )
  end

  it 'stores the scope catalogue of each API' do
    sync

    expect(DatapassScope.for_api('particulier').find_by(value: 'cnaf_quotient_familial'))
      .to have_attributes(name: 'Quotient familial CAF & MSA', group: 'Quotient familial', deprecated: false)
  end

  it 'proposes the use cases of the API with the scopes of their generic form' do
    sync

    use_case = DatapassUseCase.for_api('particulier').find { |candidate| candidate.key == 'tarification_municipale_enfance' }

    expect(use_case.default_scopes).to eq(%w[cnaf_adresse cnaf_allocataires cnaf_enfants cnaf_quotient_familial])
  end

  it 'removes the forms DataPass no longer lists' do
    create(:datapass_form, uid: 'api-particulier-removed', api: 'particulier', synced_at: 1.day.ago)

    sync

    expect(DatapassForm.find_by(uid: 'api-particulier-removed')).to be_nil
  end

  context 'when DataPass is unavailable for an API' do
    before do
      create(:datapass_form, uid: 'api-particulier-abelium', api: 'particulier', use_case: 'tarification_municipale_enfance', synced_at: 1.day.ago)
      stub_request(:get, "#{url}/definitions/api_particulier/formulaires").to_return(status: 404, headers: json_headers, body: { error: 'Not Found' }.to_json)
    end

    it 'keeps the referential already synchronized' do
      expect { sync }.not_to raise_error

      expect(DatapassForm.find_by(uid: 'api-particulier-abelium')).to be_present
    end
  end

  describe 'use cases backfilled from the DataPass forms of editors' do
    let(:editor) { create(:editor, name: 'Abelium', apis: %w[particulier]) }

    before do
      require Rails.root.join('db/migrate/20261125092100_backfill_editor_use_cases_from_form_uids')

      Editor.where(id: editor.id).update_all("form_uids = ARRAY['api-particulier-abelium', 'api-particulier-abelium-petite-enfance']::varchar[]")
      ActiveRecord::Migration.suppress_messages { BackfillEditorUseCasesFromFormUids.new.up }
    end

    it 'keeps every DataPass form of the editor, even before DataPass answers' do
      expect(editor.reload.form_uids).to eq(%w[api-particulier-abelium api-particulier-abelium-petite-enfance])
    end

    it 'gives each form its DataPass use case once synchronized' do
      sync

      expect(editor.use_cases.pluck(:form_uid, :use_case)).to contain_exactly(
        %w[api-particulier-abelium tarification_municipale_enfance],
        %w[api-particulier-abelium-petite-enfance tarification_eaje]
      )
    end

    it 'pre-fills the use case with the scopes and personal data answers of its form, and the editor name as software' do
      sync

      expect(editor.use_cases.find_by(form_uid: 'api-particulier-abelium')).to have_attributes(
        software: 'Abelium',
        scopes: %w[cnaf_quotient_familial],
        data_retention_months: 36,
        data_recipients: 'Agents du service enfance',
        integration_status: 'production'
      )
    end
  end
end
