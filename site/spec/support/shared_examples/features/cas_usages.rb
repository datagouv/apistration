# frozen_string_literal: true

RSpec.shared_examples 'a cas usages feature' do |api_module, path_prefix = nil|
  let(:fiches_pratiques_class) { api_module::FichePratique }
  let(:index_path_method) { path_prefix ? "#{path_prefix}_cas_usages_path" : 'cas_usages_path' }
  let(:show_path_method) { path_prefix ? "#{path_prefix}_cas_usage_path" : 'cas_usage_path' }

  describe 'index' do
    it 'does not raise error' do
      expect {
        visit send(index_path_method)
      }.not_to raise_error
    end
  end

  describe 'show' do
    it 'does not raise error' do
      fiches_pratiques_class.all.each do |fiche_pratique|
        visit send(show_path_method, uid: fiche_pratique.uid)
        expect(page).to have_current_path(send(show_path_method, fiche_pratique.uid), ignore_query: true)
      end
    end

    it 'redirects to root path when cas_usage is not found' do
      visit send(show_path_method, uid: '0123456789')
      expect(page).to have_current_path root_path
    end
  end
end
