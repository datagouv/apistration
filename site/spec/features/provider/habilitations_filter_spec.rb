RSpec.describe 'Provider: habilitations status filter', app: :api_entreprise do
  let(:user) { create(:user, provider_uids: %w[insee]) }

  before do
    login_as(user)

    create(:authorization_request, :with_organization,
      intitule: 'Demande validée', external_id: 'AR-VALIDATED', api: 'entreprise',
      siret: '13002526500013', scopes: ['unites_legales_etablissements_insee'],
      first_submitted_at: 1.day.ago, status: :validated)
    create(:authorization_request, :with_organization,
      intitule: 'Demande refusée', external_id: 'AR-REFUSED', api: 'entreprise',
      siret: '13002526500013', scopes: ['unites_legales_etablissements_insee'],
      first_submitted_at: 1.day.ago, status: :refused)
  end

  it 'offers a status select next to the habilitations table' do
    visit provider_dashboard_habilitations_path(provider_uid: 'insee')

    expect(page).to have_select('filter[statuses][]', with_options: ['Tous les statuts', 'Validée', 'Refusée'])
    expect(page).to have_text('Demande validée')
    expect(page).to have_text('Demande refusée')
  end

  it 'narrows the table to the selected status' do
    visit provider_dashboard_habilitations_path(provider_uid: 'insee', filter: { statuses: ['refused'] })

    expect(page).to have_text('Demande refusée')
    expect(page).to have_no_text('Demande validée')
  end

  it 'keeps filtering when toggling the select repeatedly', :js do
    visit provider_dashboard_path(provider_uid: 'insee')
    page.execute_script('window.scrollTo(0, document.body.scrollHeight)')

    expect(page).to have_text('Demande refusée', wait: 10)
    expect(page).to have_text('Demande validée')

    select 'Refusée', from: 'filter[statuses][]'
    expect(page).to have_text('Demande refusée', wait: 10)
    expect(page).to have_no_text('Demande validée', wait: 10)

    select 'Validée', from: 'filter[statuses][]'
    expect(page).to have_text('Demande validée', wait: 10)
    expect(page).to have_no_text('Demande refusée', wait: 10)

    select 'Tous les statuts', from: 'filter[statuses][]'
    expect(page).to have_text('Demande validée', wait: 10)
    expect(page).to have_text('Demande refusée', wait: 10)
  end
end
