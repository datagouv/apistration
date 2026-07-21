RSpec.describe 'Editor: OpenAPI', app: :api_entreprise do
  it 'renders the redoc page without requiring a login' do
    visit editor_openapi_path

    expect(page).to have_current_path(editor_openapi_path)
    expect(page).to have_css('#redoc_container')
    expect(page).to have_text('API Éditeur')
  end

  it 'serves the editor OpenAPI definition as YAML' do
    visit editor_openapi_definition_path

    expect(page).to have_text('openapi')
    expect(page).to have_text('/editeur/api/v1/delegations')
  end
end
