RSpec.describe MarkdownInterpolator do
  subject(:html) { described_class.new(content).perform }

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
