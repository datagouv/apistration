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

  context 'with the footer brand block' do
    before { visit root_path }

    it 'links to the datagouv ecosystem products' do
      expect(page).to have_css('#footer .fr-footer__brand a[href="https://www.data.gouv.fr/products"]', text: 'Produit de l’écosystème datagouv')
    end

    it 'links to numerique.gouv with its signature as alternative text' do
      expect(page).to have_css('#footer .fr-footer__brand a[href="https://www.numerique.gouv.fr/"] img[alt="numerique.gouv - L’alliance du numérique de l’État"]')
    end
  end

  context 'with the current status frame' do
    before do
      allow_any_instance_of(StatusPage).to receive(:current_status).and_return(:up) # rubocop:todo RSpec/AnyInstance
    end

    it 'opens no new tab exposing window.opener' do
      visit api_particulier_current_status_path

      expect(page).not_to expose_window_opener
    end
  end
end
