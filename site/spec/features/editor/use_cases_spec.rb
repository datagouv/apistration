RSpec.describe 'Editor: use cases', app: :api_particulier do
  let(:editor) { create(:editor, name: 'Cantine Soft', apis: %w[particulier]) }
  let(:user) { create(:user, editor:) }
  let(:quotient_familial_scopes) { %w[cnaf_adresse cnaf_allocataires cnaf_enfants cnaf_quotient_familial] }

  before do
    create(:datapass_form, uid: 'api-particulier-tarification-municipale-enfance', use_case: 'tarification_municipale_enfance', scopes: quotient_familial_scopes)
    create(:datapass_form, uid: 'api-particulier-abelium', use_case: 'tarification_municipale_enfance', scopes: %w[cnaf_quotient_familial], data: { 'description' => 'Abelium' })
    create(:datapass_form, uid: 'api-particulier-tarification-eaje', use_case: 'tarification_eaje', scopes: %w[cnav_participation_familiale_eaje_enfants])
    %w[ccas stationnement_residentiel tarification_transports].each do |use_case|
      create(:datapass_form, uid: "api-particulier-#{use_case.dasherize}", use_case:, scopes: [])
    end
    quotient_familial_scopes.each { |value| create(:datapass_scope, value:, group: 'Quotient familial') }
    create(:datapass_scope, value: 'cnav_participation_familiale_eaje_enfants', group: 'EAJE')

    login_as(user)
  end

  def add_use_case(label, software:)
    visit new_editor_use_case_path
    select label, from: "Cas d'usage DataPass"
    click_on 'Continuer'
    fill_in 'Logiciel', with: software
    yield if block_given?
    click_on 'Enregistrer'
  end

  it 'lets an editor declare the five use cases its single software implements' do
    [
      'Tarification sociale des services municipaux à l’enfance',
      'Tarification d’accueil du jeune enfant (EAJE, PSU)',
      'Aides sociales des CCAS',
      'Tarification du stationnement résidentiel',
      'Tarification des transports'
    ].each { |label| add_use_case(label, software: 'Cantine Soft Pro') }

    expect(editor.use_cases.pluck(:software)).to eq(['Cantine Soft Pro'] * 5)
    expect(editor.use_cases.pluck(:use_case)).to contain_exactly(
      'tarification_municipale_enfance', 'tarification_eaje', 'ccas', 'stationnement_residentiel', 'tarification_transports'
    )
  end

  it 'pre-checks the scopes of the generic DataPass form and keeps only the ones the editor leaves checked' do
    add_use_case('Tarification sociale des services municipaux à l’enfance', software: 'Cantine Soft') do
      quotient_familial_scopes.each { |scope| expect(page).to have_checked_field("editor_use_case_scopes_#{scope}") }

      (quotient_familial_scopes - %w[cnaf_quotient_familial]).each { |scope| uncheck "editor_use_case_scopes_#{scope}" }
      fill_in 'Durée de conservation (mois)', with: '24'
      fill_in 'Destinataires des données', with: 'Service restauration scolaire'
    end

    expect(page).to have_css('#editor-profile-use_cases[aria-selected="true"]')
    expect(editor.use_cases.sole).to have_attributes(
      scopes: %w[cnaf_quotient_familial],
      data_retention_months: 24,
      data_recipients: 'Service restauration scolaire',
      form_uid: nil
    )
  end

  it 'only shows the use cases of the editor, even when another editor shares its SIRET' do
    editor.update!(siret: '12345678901234')
    other_editor = create(:editor, name: 'Cantine Soft Crèche', siret: '12345678901234', apis: %w[particulier])
    create(:editor_use_case, editor: other_editor, software: 'Logiciel crèche')
    create(:editor_use_case, editor:, software: 'Logiciel cantine')

    visit editor_settings_path(onglet: 'use_cases')

    within('#editor-profile-use_cases-panel') do
      expect(page).to have_text('Logiciel cantine')
      expect(page).to have_no_text('Logiciel crèche')
    end
  end

  describe 'the DataPass form of a use case, which drives automatic delegations' do
    let!(:use_case) { create(:editor_use_case, editor:, form_uid: 'api-particulier-cantine-soft') }

    it 'cannot be set by the editor when adding a use case' do
      page.driver.submit :post, editor_use_cases_path, editor_use_case: {
        use_case: 'tarification_eaje', software: 'Cantine Soft', integration_status: 'production', form_uid: 'api-particulier-abelium'
      }

      expect(editor.use_cases.find_by(use_case: 'tarification_eaje').form_uid).to be_nil
      expect(Editor.for_demarche('api-particulier-abelium')).to be_empty
    end

    it 'cannot be changed by the editor' do
      page.driver.submit :patch, editor_use_case_path(use_case), editor_use_case: { software: 'Renamed', form_uid: 'api-particulier-abelium' }

      expect(use_case.reload).to have_attributes(software: 'Renamed', form_uid: 'api-particulier-cantine-soft')
    end

    it 'cannot be dropped by the editor by removing its use case' do
      page.driver.submit :delete, editor_use_case_path(use_case), {}

      expect(use_case.reload).to be_persisted
      expect(editor.form_uids).to eq(%w[api-particulier-cantine-soft])
    end

    it 'cannot be reached through the use case of another editor' do
      other_use_case = create(:editor_use_case, editor: create(:editor), form_uid: 'api-particulier-other')

      page.driver.submit :patch, editor_use_case_path(other_use_case), editor_use_case: { software: 'Hijacked' }

      expect(other_use_case.reload.software).to eq('Logiciel enfance')
    end
  end
end
