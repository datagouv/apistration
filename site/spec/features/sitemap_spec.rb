require 'rails_helper'

RSpec.describe 'Sitemap page' do
  context 'when on API Entreprise', app: :api_entreprise do
    it 'renders every link without error' do
      expect { visit sitemap_path }.not_to raise_error

      expect(page).to have_text('Plan du site')
    end
  end

  context 'when on API Particulier', app: :api_particulier do
    it 'renders every link without error' do
      expect { visit api_particulier_sitemap_path }.not_to raise_error

      expect(page).to have_text('Plan du site')
    end
  end
end
