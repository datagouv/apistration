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

  describe 'create' do
    before do
      visit editor_tokens_path
      click_button 'Générer un nouveau jeton éditeur'
    end

    it 'creates a token and displays its JWT once with a copy warning' do
      editor_token = editor.tokens.sole

      expect(page).to have_field(readonly: true, with: editor_token.rehash)
      expect(page).to have_text('Copiez ce jeton maintenant')
    end

    it 'never displays the JWT again afterwards' do
      editor_token = editor.tokens.sole

      visit editor_tokens_path

      expect(page).to have_text(editor_token.id.first(8))
      expect(page).to have_no_field(with: editor_token.rehash)
      expect(page).to have_no_text(editor_token.rehash)
    end
  end

  describe 'edit allowed IPs' do
    let!(:editor_token) { create(:editor_token, editor:) }

    before do
      visit editor_tokens_path
      click_link 'Modifier les IPs'
    end

    it 'updates the whitelist, normalizing exact IPs to /32' do
      fill_in 'editor_token[allowed_ips_text]', with: "203.0.113.10\n198.51.100.0/24"
      click_button 'Enregistrer'

      expect(page).to have_current_path(editor_tokens_path)
      expect(page).to have_text('203.0.113.10/32, 198.51.100.0/24')
    end

    it 'rejects invalid entries with an error message' do
      fill_in 'editor_token[allowed_ips_text]', with: '10.0.0.1'
      click_button 'Enregistrer'

      expect(page).to have_text('plage privée ou réservée')
      expect(editor_token.reload.allowed_ips).to be_empty
    end
  end

  describe 'rotate' do
    let!(:editor_token) { create(:editor_token, editor:, allowed_ips: ['203.0.113.0/24']) }

    it 'revokes the old token and shows the new JWT once, copying IPs' do
      visit editor_tokens_path
      click_button 'Renouveler'

      new_token = editor.tokens.order(:created_at).last
      expect(editor_token.reload).to be_blacklisted
      expect(new_token.allowed_ips).to eq(editor_token.allowed_ips)
      expect(page).to have_field(readonly: true, with: new_token.rehash)
      expect(page).to have_text('Copiez ce jeton maintenant')
    end
  end

  describe 'revoke' do
    let!(:editor_token) { create(:editor_token, editor:) }

    it 'blacklists the token and offers no further actions on it' do
      visit editor_tokens_path
      click_button 'Révoquer'

      expect(editor_token.reload).to be_blacklisted
      expect(page).to have_css('.fr-badge', text: 'Révoqué')
      expect(page).to have_no_button('Révoquer')
    end
  end

  describe 'delegations page' do
    let!(:editor_token) { create(:editor_token, editor:) }
    let(:editor) { create(:editor, :delegable) }

    it 'no longer exposes the JWT' do
      visit editor_delegations_path

      expect(page).to have_text('Délégations')
      expect(page).to have_no_text(editor_token.rehash)
      expect(page).to have_no_button('Copier le jeton')
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
