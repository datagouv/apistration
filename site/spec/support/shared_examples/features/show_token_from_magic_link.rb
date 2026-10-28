# frozen_string_literal: true

RSpec.shared_examples 'a show token from magic link feature' do |magic_link_path_method|
  subject do
    visit send(magic_link_path_method, access_token: magic_token)
  end

  let!(:user) { create(:user, email: email) }
  let(:email) { 'any-email@data.gouv.fr' }
  let(:token) { create(:token) }

  # No before block here - specific setups should be in the specs

  context 'when the magic link token does not exist' do
    let(:magic_token) { 'wrong-token' }

    it_behaves_like 'display alert', :error

    it 'redirects to the login page' do
      subject
      expect(page).to have_current_path(login_path)
    end

    it 'emits a denied access to an unknown shared link' do
      expect { subject }.to emit_security_event('token.api_token.shared_link_accessed').with(
        actor: { email: nil, role: 'anonymous' },
        target: { type: 'token', id: nil },
        details: { reason: 'unknown', outcome: 'denied' }
      )
    end
  end

  context 'when the magic link token exists' do
    let!(:magic_link) { create(:magic_link, email: email, token: token) }
    let(:magic_token) { magic_link.access_token }

    context 'when the magic token is still active' do
      it 'shows the token details' do
        subject
        expect(page).to have_css("input[value='#{token.rehash}']")
      end

      it 'emits an anonymous access to the shared token' do
        expect { subject }.to emit_security_event('token.api_token.shared_link_accessed').with(
          actor: { email: nil, role: 'anonymous' },
          target: { type: 'token', id: token.id },
          details: { datapass_id: token.authorization_request.external_id, expires_at: magic_link.expires_at }
        )
      end

      it 'has a button to copy the token hash' do
        subject
        expect(page).to have_css("##{dom_id(token, :copy_token_button)}")
      end

      describe 'click on the copy button', :js do
        def record_copied_text
          page.execute_script(<<~JS)
            document.addEventListener('copy', () => {
              const element = document.activeElement
              window.copiedText = element.value.substring(element.selectionStart, element.selectionEnd)
            })
          JS
        end

        it 'copies the token hash' do
          subject
          record_copied_text

          click_on dom_id(token, :copy_token_button)

          expect(page.evaluate_script('window.copiedText')).to eq(token.rehash)
        end
      end
    end

    context 'when the magic link has expired' do
      before { Timecop.freeze((MagicLink::DEFAULT_EXPIRATION_DELAY + 1.hour).from_now) }
      after { Timecop.return }

      it_behaves_like 'display alert', :error

      it 'redirects to the login page' do
        subject
        expect(page).to have_current_path(login_path)
      end

      it 'emits a denied access to an expired shared link' do
        expect { subject }.to emit_security_event('token.api_token.shared_link_accessed').with(
          target: { type: 'token', id: token.id },
          details: hash_including(reason: 'expired', outcome: 'denied')
        )
      end
    end
  end
end
