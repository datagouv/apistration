# frozen_string_literal: true

RSpec.shared_examples 'a changelogs feature' do
  describe 'index' do
    subject(:visit_changelogs) { visit changelogs_path }

    it 'does not raise error' do
      expect { visit_changelogs }.not_to raise_error
    end

    it 'renders the page title' do
      visit_changelogs

      expect(page).to have_text(I18n.t('shared.changelogs.index.title'))
    end

    it 'renders entries relevant to the API' do
      visit_changelogs

      ChangelogEntry.for(api).first(3).each do |entry|
        expect(page).to have_text(entry.title)
      end
    end
  end
end
