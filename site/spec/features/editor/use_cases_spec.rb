RSpec.describe 'Editor: use cases', app: :api_particulier do
  let(:editor) { create(:editor, name: 'Cantine Soft', apis: %w[particulier]) }
  let(:user) { create(:user, editor:) }
  let(:quotient_familial_scopes) { %w[cnaf_adresse cnaf_allocataires cnaf_enfants cnaf_quotient_familial] }

  before do
    stub_datapass_referential
    login_as(user)
  end

  def add_use_case(label, software:)
    visit new_editor_use_case_path
    select label, from: 'Démarche DataPass'
    click_on 'Continuer'
    fill_in 'Nom du logiciel', with: software
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
      fill_in 'Durée de conservation', with: '24'
      fill_in 'Destinataires des données', with: 'Service restauration scolaire'
      fill_in 'Instructions de configuration du jeton', with: 'Menu Paramètres > API'
    end

    expect(page).to have_css('#editor-profile-use_cases[aria-selected="true"]')
    expect(editor.use_cases.sole).to have_attributes(
      scopes: %w[cnaf_quotient_familial],
      data_retention_months: 24,
      data_recipients: 'Service restauration scolaire',
      setup_instructions: 'Menu Paramètres > API',
      form_uid: nil
    )
  end

  it 'describes the software with its presentation page, which must be a web address' do
    add_use_case('Tarification des transports', software: 'Cantine Soft') do
      fill_in 'Description du logiciel', with: 'Gestion des abonnements de transport'
      fill_in 'Page de présentation du logiciel', with: 'exemple.fr/logiciel'
    end

    expect(page).to have_text('doit être une adresse web commençant par https://')

    fill_in 'Page de présentation du logiciel', with: 'https://exemple.fr/logiciel'
    click_on 'Enregistrer'

    expect(editor.use_cases.sole).to have_attributes(
      software_description: 'Gestion des abonnements de transport',
      software_url: 'https://exemple.fr/logiciel'
    )
  end

  it 'folds the data of the API that the DataPass forms of the use case never ask for' do
    visit new_editor_use_case_path(use_case: 'tarification_eaje')

    expect(page).to have_checked_field('editor_use_case_scopes_cnav_participation_familiale_eaje_allocataires')
    within('#editor-use-case-other-scopes') do
      expect(page).to have_css('.editor-scopes-group--muted', text: 'Quotient familial')
      expect(page).to have_unchecked_field('editor_use_case_scopes_cnaf_quotient_familial')
    end
  end

  it 'keeps the scopes of a use case when DataPass does not answer' do
    use_case = create(:editor_use_case, editor:, scopes: %w[cnaf_quotient_familial])
    stub_datapass_unavailable('api_particulier')

    visit edit_editor_use_case_path(use_case)
    fill_in 'Nom du logiciel', with: 'Cantine Soft 2'
    click_on 'Enregistrer'

    expect(use_case.reload).to have_attributes(software: 'Cantine Soft 2', scopes: %w[cnaf_quotient_familial])
  end

  it 'does not keep an unexpected DataPass answer once DataPass answers again' do
    use_case = create(:editor_use_case, editor:, scopes: %w[cnaf_quotient_familial])
    stub_datapass_definition('api_particulier', forms: [], definition: { 'scopes' => 'unexpected' })

    visit edit_editor_use_case_path(use_case)
    expect(page).to have_checked_field('editor_use_case_scopes_cnaf_quotient_familial')
    expect(page).to have_no_field('editor_use_case_scopes_cnaf_enfants')

    stub_datapass_referential
    visit edit_editor_use_case_path(use_case)
    expect(page).to have_unchecked_field('editor_use_case_scopes_cnaf_enfants')
  end

  it 'does not bring back the scopes of the DataPass form once the editor has unchecked them all' do
    stub_datapass_referential(particulier_forms: [{ 'uid' => 'api-particulier-abelium', 'data' => { 'scopes' => %w[cnaf_quotient_familial] } }])
    use_case = create(:editor_use_case, editor:, form_uid: 'api-particulier-abelium', scopes: [])

    visit edit_editor_use_case_path(use_case)
    uncheck 'editor_use_case_scopes_cnaf_quotient_familial'
    click_on 'Enregistrer'
    visit edit_editor_use_case_path(use_case)

    expect(page).to have_unchecked_field('editor_use_case_scopes_cnaf_quotient_familial')
  end

  it 'pre-fills a use case backfilled from a DataPass form with the scopes of that form' do
    use_case = create(:editor_use_case, editor:, form_uid: 'api-particulier-abelium', scopes: [])

    visit edit_editor_use_case_path(use_case)

    expect(page).to have_checked_field('editor_use_case_scopes_cnaf_quotient_familial')
    expect(page).to have_unchecked_field('editor_use_case_scopes_cnaf_enfants')
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

  describe 'the security accreditation of a use case' do
    let(:use_case) { create(:editor_use_case, editor:, security_accreditation: nil) }

    before { visit edit_editor_use_case_path(use_case) }

    it 'records its validity period and its MonServiceSécurisé link' do
      choose 'editor_use_case_security_accreditation_true'
      fill_in 'Date de début', with: '2026-01-01'
      fill_in 'Date de fin', with: '2029-01-01'
      fill_in 'Lien vers l’homologation MonServiceSécurisé', with: 'https://monservicesecurise.cyber.gouv.fr/service/42'
      click_on 'Enregistrer'

      expect(use_case.reload).to have_attributes(
        security_accreditation: true,
        security_accreditation_begin_date: Date.new(2026, 1, 1),
        security_accreditation_end_date: Date.new(2029, 1, 1),
        mon_service_securise_url: 'https://monservicesecurise.cyber.gouv.fr/service/42'
      )
    end

    it 'refuses an accreditation ending before it begins' do
      choose 'editor_use_case_security_accreditation_true'
      fill_in 'Date de début', with: '2029-01-01'
      fill_in 'Date de fin', with: '2026-01-01'
      click_on 'Enregistrer'

      expect(use_case.reload.security_accreditation).to be_nil
      expect(page).to have_text('doit être postérieure à la date de début')
    end

    it 'refuses a MonServiceSécurisé link that is not a web address' do
      fill_in 'Lien vers l’homologation MonServiceSécurisé', with: 'https:///missing-host'
      click_on 'Enregistrer'

      expect(use_case.reload.mon_service_securise_url).to be_nil
      expect(page).to have_text('doit être une adresse web commençant par https://')
    end

    it 'forgets the accreditation period once the editor answers it has none' do
      use_case.update!(security_accreditation: true, security_accreditation_begin_date: Date.new(2026, 1, 1), security_accreditation_end_date: Date.new(2029, 1, 1))
      visit edit_editor_use_case_path(use_case)

      choose 'editor_use_case_security_accreditation_false'
      click_on 'Enregistrer'

      expect(use_case.reload).to have_attributes(security_accreditation: false, security_accreditation_begin_date: nil, security_accreditation_end_date: nil)
    end

    it 'asks the accreditation dates only once the editor answers it has one', :js do
      expect(page).to have_no_field('Date de début')
      choose 'editor_use_case_security_accreditation_true', allow_label_click: true
      expect(page).to have_field('Date de début')
      choose 'editor_use_case_security_accreditation_false', allow_label_click: true
      expect(page).to have_no_field('Date de début')
    end

    it 'counts a use case without an accreditation answer among the ones to complete' do
      visit editor_settings_path

      expect(page).to have_link('1 démarche à compléter')
    end
  end
end
