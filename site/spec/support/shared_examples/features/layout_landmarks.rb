require 'rails_helper'

RSpec.shared_examples 'layout landmarks' do |path_helpers = [:root_path]|
  Array(path_helpers).each do |path_helper|
    describe "RGAA 9.2/12.6/12.7 on #{path_helper}" do
      before { visit send(path_helper) }

      it 'has a main landmark targeting #contenu' do
        expect(page).to have_css('main#contenu')
      end

      it 'has a single main landmark' do
        expect(page).to have_css('main', count: 1)
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
end
