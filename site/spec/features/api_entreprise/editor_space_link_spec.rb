require 'rails_helper'

RSpec.describe 'Editor space link in the main header', app: :api_entreprise do
  before { login_as(user) }

  context 'when the editor serves this API' do
    let(:editor) { create(:editor, apis: %w[entreprise]) }
    let(:user) { create(:user, editor:) }

    it 'shows the editor space link' do
      visit root_path

      expect(page).to have_link('Espace éditeurs', href: editor_path)
    end
  end

  context 'when the editor only serves the other API' do
    let(:editor) { create(:editor, apis: %w[particulier]) }
    let(:user) { create(:user, editor:) }

    it 'hides the editor space link' do
      visit root_path

      expect(page).to have_css('#homepage')
      expect(page).to have_no_link('Espace éditeurs')
    end
  end

  context 'when the user is not an editor' do
    let(:user) { create(:user) }

    it 'hides the editor space link' do
      visit root_path

      expect(page).to have_css('#homepage')
      expect(page).to have_no_link('Espace éditeurs')
    end
  end
end
