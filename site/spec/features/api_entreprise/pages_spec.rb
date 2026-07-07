require 'rails_helper'

RSpec.describe 'Simple pages', app: :api_entreprise do
  it_behaves_like 'static pages feature',
    developers_content: 'siret',
    expected_api_name: 'API Entreprise'

  context 'with RGAA 9.2/12.6/12.7 layout landmarks' do
    before { visit root_path }

    it 'has a main landmark targeting #contenu' do
      expect(page).to have_css('main#contenu')
    end

    it 'has a banner landmark on the header' do
      expect(page).to have_css('header[role="banner"]')
    end

    it 'has a skip link to main content' do
      expect(page).to have_css('.fr-skiplinks a[href="#contenu"]')
    end

    it 'has a skip link to navigation' do
      expect(page).to have_css('.fr-skiplinks a[href="#navigation-header-menu"]')
    end

    it 'has a skip link to footer' do
      expect(page).to have_css('.fr-skiplinks a[href="#footer"]')
    end
  end
end
