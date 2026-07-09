RSpec.describe 'Editor: tokens', app: :api_entreprise do
  let(:editor) { create(:editor) }
  let(:user) { create(:user, editor:) }

  before do
    login_as(user)
  end

  describe 'index' do
    let!(:active_token) { create(:editor_token, editor:, allowed_ips: ['203.0.113.0/24']) }
    let!(:revoked_token) { create(:editor_token, :blacklisted, editor:) }
    let!(:expired_token) { create(:editor_token, :expired, editor:) }
    let!(:other_editor_token) { create(:editor_token) }

    before do
      visit editor_tokens_path
    end

    it 'lists only the current editor tokens with status badges' do
      expect(page).to have_text(active_token.id.first(8))
      expect(page).to have_text(revoked_token.id.first(8))
      expect(page).to have_text(expired_token.id.first(8))
      expect(page).to have_no_text(other_editor_token.id.first(8))
      expect(page).to have_css('.fr-badge', text: 'Actif')
      expect(page).to have_css('.fr-badge', text: 'Révoqué')
      expect(page).to have_css('.fr-badge', text: 'Expiré')
    end

    it 'displays allowed IPs' do
      expect(page).to have_text('203.0.113.0/24')
    end

    it 'shows the generate button and the nav entry' do
      expect(page).to have_button('Générer un nouveau jeton éditeur')
      expect(page).to have_link('Jetons éditeurs')
    end
  end

  context 'when the user is not an editor' do
    let(:user) { create(:user) }

    it 'redirects to root' do
      visit editor_tokens_path

      expect(page).to have_current_path(root_path, ignore_query: true)
    end
  end
end
