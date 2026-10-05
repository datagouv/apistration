RSpec.describe 'token pages escape user names', app: :api_particulier do
  let!(:authenticated_user) { create(:user, :demandeur, :contact_technique, :contact_metier) }
  let(:demandeur) { create(:user, first_name: '<i>Mallory</i>') }
  let(:contact_technique) { create(:user, first_name: '<i>Trudy</i>') }
  let!(:authorization_request) do
    create(
      :authorization_request,
      :with_demandeur,
      :with_contact_technique,
      :with_contact_metier,
      demandeur:,
      contact_technique:,
      contact_metier: authenticated_user,
      api: 'entreprise',
      status: 'validated'
    )
  end

  before do
    login_as(authenticated_user)
  end

  describe 'when the token cannot be shown' do
    let!(:token) { create(:token, authorization_request:) }

    before do
      visit api_particulier_token_path(id: token.id)
    end

    it 'displays the names as text' do
      expect(page).to have_text('<i>Mallory</i>')
      expect(page).to have_text('<i>Trudy</i>')
      expect(page).to have_no_css('i', text: 'Mallory')
      expect(page).to have_no_css('i', text: 'Trudy')
    end

    it 'keeps the markup of the translations' do
      expect(page).to have_css('strong', text: 'Contact technique')
    end
  end

  describe 'when asking the demandeur for a prolongation' do
    let!(:token) { create(:token, authorization_request:, exp: 83.days.from_now.to_i) }

    before do
      visit api_particulier_token_ask_for_prolongation_path(id: token.id)
    end

    it 'displays the demandeur name as text' do
      expect(page).to have_text('<i>Mallory</i>')
      expect(page).to have_no_css('i', text: 'Mallory')
    end

    it 'keeps the markup of the translations' do
      expect(page).to have_css('strong', text: 'Écrivez-lui')
    end
  end
end
