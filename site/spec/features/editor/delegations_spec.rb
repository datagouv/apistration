RSpec.describe 'Editor: delegations', app: :api_entreprise do
  let(:user) { create(:user, editor:) }

  before do
    login_as(user)
  end

  describe 'index' do
    context 'when delegations are enabled' do
      let(:editor) { create(:editor, :delegable) }
      let!(:active_delegation) do
        create(:editor_delegation, editor:,
          authorization_request: create(:authorization_request, :validated, :with_demandeur,
            api: 'entreprise',
            scopes: %w[unites_legales_etablissements_insee associations]))
      end
      let!(:revoked_delegation) do
        create(:editor_delegation, editor:, revoked_at: 1.day.ago,
          authorization_request: create(:authorization_request, :validated, :with_demandeur,
            api: 'entreprise', scopes: []))
      end

      it 'displays the delegations tab in header' do
        visit editor_delegations_path

        expect(page).to have_link('Vos délégations')
      end

      it 'displays delegations with status badges' do
        visit editor_delegations_path

        expect(page).to have_css('.delegation', count: 2)
        expect(page).to have_css('.fr-badge--green-emeraude', text: 'Actif')
        expect(page).to have_css('.fr-badge--pink-tuile', text: 'Révoqué')
      end

      it 'does not display delegations from another api' do
        particulier_delegation = create(:editor_delegation, editor:,
          authorization_request: create(:authorization_request, :validated, :with_demandeur,
            api: 'particulier', scopes: []))

        visit editor_delegations_path

        expect(page).to have_css('.delegation', count: 2)
        expect(page).to have_no_css("##{dom_id(particulier_delegation)}")
      end

      it 'displays the delegation UUID per row' do
        visit editor_delegations_path

        within "##{dom_id(active_delegation)}" do
          expect(page).to have_text(active_delegation.id)
        end
      end

      it 'displays the creation date for each delegation' do
        active_delegation.update!(created_at: Time.zone.local(2026, 3, 14, 12))

        visit editor_delegations_path

        within "##{dom_id(active_delegation)}" do
          expect(page).to have_css('.delegation-created-at', text: '14/03/2026')
        end
      end
    end

    context 'when the editor does not serve the current api' do
      let(:editor) { create(:editor, :delegable, apis: %w[particulier]) }

      it 'denies access to the editor space' do
        visit editor_delegations_path

        expect(page).to have_current_path(root_path)
      end
    end

    context 'when editor tokens are disabled' do
      let(:editor) { create(:editor) }

      it 'still displays the delegations tab in header' do
        visit editor_authorization_requests_path

        expect(page).to have_link('Habilitations & jetons clients')
        expect(page).to have_link('Vos délégations', href: editor_delegations_path)
      end

      it 'still allows accessing the delegations page' do
        visit editor_delegations_path

        expect(page).to have_current_path(editor_delegations_path)
      end
    end
  end
end
