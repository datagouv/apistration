require 'rails_helper'

RSpec.describe 'Simple pages', app: :api_particulier do
  it_behaves_like 'static pages feature',
    check_root_content: true,
    check_newsletter_content: true,
    check_account_page: true,
    developers_content: 'Quotient familial',
    expected_api_name: 'API Particulier',
    unexpected_api_name: 'API Entreprise'

  context 'with RGAA 9.2/12.6/12.7 layout landmarks' do
    before { visit root_path }

    it 'has a main landmark targeting #main-content' do
      expect(page).to have_css('main#main-content')
    end

    it 'has a banner landmark on the header' do
      expect(page).to have_css('header[role="banner"]')
    end

    it 'has a skip link to main content' do
      expect(page).to have_css('.fr-skiplinks a[href="#main-content"]')
    end

    it 'has a skip link to navigation' do
      expect(page).to have_css('.fr-skiplinks a[href="#navigation-header-menu"]')
    end

    it 'has a skip link to footer' do
      expect(page).to have_css('.fr-skiplinks a[href="#footer"]')
    end
  end
end
