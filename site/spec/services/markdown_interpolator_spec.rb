RSpec.describe MarkdownInterpolator do
  subject(:html) { described_class.new(content).perform }

  context 'with a Markdown table tagged as a DSFR table' do
    let(:content) { "{:.fr-table}\n| A | B |\n| - | - |\n| 1 | 2 |\n" }

    it 'renders the table inside the markup DSFR 1.15 styles' do
      expect(html).to include('<div class="fr-table fr-table--bordered fr-table--multiline">', 'fr-table__wrapper', 'fr-table__container', 'fr-table__content')
    end

    it 'keeps the DSFR class off the table element itself' do
      expect(html).to include('<table>')
    end
  end

  context 'with an untagged Markdown table' do
    let(:content) { "| A | B |\n| - | - |\n| 1 | 2 |\n" }

    it 'leaves the table as it is' do
      expect(html).not_to include('fr-table')
    end
  end

  context 'with a Markdown link opening in a new tab' do
    let(:content) { '[Légifrance](https://www.legifrance.gouv.fr){:target="_blank"}' }

    it 'prevents the opened page from reaching window.opener' do
      expect(html).to include('rel="noopener noreferrer"')
    end
  end

  context 'with an HTML link opening in a new tab' do
    let(:content) { '<a href="https://www.legifrance.gouv.fr" target="_blank">Légifrance</a>' }

    it 'prevents the opened page from reaching window.opener' do
      expect(html).to include('rel="noopener noreferrer"')
    end
  end

  context 'with a link opening in the same tab' do
    let(:content) { '[Légifrance](https://www.legifrance.gouv.fr)' }

    it 'leaves the link untouched' do
      expect(html).not_to include('rel=')
    end
  end
end
