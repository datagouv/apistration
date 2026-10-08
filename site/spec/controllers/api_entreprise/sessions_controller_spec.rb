require 'rails_helper'

RSpec.describe APIEntreprise::SessionsController do
  describe 'GET #create_from_oauth' do
    let(:user) { create(:user) }
    let(:valid_provider) { 'proconnect_api_entreprise' }
    let(:acr) { 'eidas1-mfa' }
    let(:omniauth_auth_data) do
      OmniAuth::AuthHash.new(
        info: {
          'email' => user.email,
          'first_name' => 'John',
          'last_name' => 'Doe',
          'uid' => '123456'
        },
        extra: { acr:, raw_info: { 'idp_id' => 'idp-uuid' } }
      )
    end

    before do
      allow(MonitoringService.instance).to receive(:track)
    end

    context 'with valid provider and omniauth data' do
      before do
        request.env['omniauth.auth'] = omniauth_auth_data
      end

      it 'allows the oauth callback' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(response).to redirect_to(authorization_requests_path)
      end

      it 'emits a successful login attempt' do
        expect {
          get :create_from_oauth, params: { provider: valid_provider }
        }.to emit_security_event('auth.login.attempted').with(
          actor: { email: user.email, role: 'user' },
          target: { type: 'user', id: user.id },
          details: { method: 'proconnect', idp: 'idp-uuid', mfa: true, acr: }
        )
      end

      it 'does not track security events' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(MonitoringService.instance).not_to have_received(:track)
      end

      it 'creates user session' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(session[:current_user_id]).to eq(user.id)
      end

      it 'stamps the session with the last activity timestamp' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(session[:last_seen_at]).to be_within(5).of(Time.current.to_i)
      end

      it 'sets an absolute session deadline' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(session[:absolute_expires_at]).to be_within(5).of(24.hours.from_now.to_i)
      end

      it 'rotates the session on sign in to prevent fixation' do
        session[:pre_login_fixation_marker] = 'attacker-fixed-value'

        get :create_from_oauth, params: { provider: valid_provider }

        expect(session[:pre_login_fixation_marker]).to be_nil
      end

      it 'preserves the ProConnect tokens through the rotation' do
        session['omniauth.pc.id_token'] = 'must-survive-for-logout'

        get :create_from_oauth, params: { provider: valid_provider }

        expect(session['omniauth.pc.id_token']).to eq('must-survive-for-logout')
      end

      context 'when a return_to location was stored before login' do
        it 'redirects to the originally requested page' do
          session[:return_to] = '/compte/jetons/42'

          get :create_from_oauth, params: { provider: valid_provider }

          expect(response).to redirect_to('/compte/jetons/42')
        end

        it 'ignores a non-local return_to to prevent open redirects' do
          session[:return_to] = 'https://evil.example.com/phishing'

          get :create_from_oauth, params: { provider: valid_provider }

          expect(response).to redirect_to(authorization_requests_path)
        end

        it 'ignores a protocol-relative return_to to prevent open redirects' do
          session[:return_to] = '//evil.example.com/phishing'

          get :create_from_oauth, params: { provider: valid_provider }

          expect(response).to redirect_to(authorization_requests_path)
        end
      end
    end

    context 'when ProConnect did not perform MFA' do
      let(:acr) { 'eidas1' }

      before do
        request.env['omniauth.auth'] = omniauth_auth_data
      end

      it 'redirects to login path' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(response).to redirect_to(login_path)
      end

      it 'does not create user session' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(session[:current_user_id]).to be_nil
      end

      it 'tells the user that MFA is required' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(flash[:error]['title']).to include('double authentification')
      end

      it 'emits a denied login attempt' do
        expect {
          get :create_from_oauth, params: { provider: valid_provider }
        }.to emit_security_event('auth.login.attempted').with(
          actor: { email: user.email, role: 'anonymous' },
          target: { type: 'user', id: nil },
          details: { method: 'proconnect', idp: 'idp-uuid', mfa: false, acr:, reason: 'mfa_missing', outcome: 'denied' }
        )
      end

      it 'tracks the missing MFA' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(MonitoringService.instance).to have_received(:track).with(
          'OAuth security: Missing MFA',
          level: 'error',
          context: {
            provider: valid_provider,
            acr:
          }
        )
      end
    end

    context 'with valid provider but missing omniauth data' do
      before do
        request.env['omniauth.auth'] = nil
      end

      it 'redirects to login path' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(response).to redirect_to(login_path)
      end

      it 'emits a denied login attempt' do
        expect {
          get :create_from_oauth, params: { provider: valid_provider }
        }.to emit_security_event('auth.login.attempted').with(
          actor: { email: nil, role: 'anonymous' },
          target: { type: 'user', id: nil },
          details: { method: 'proconnect', reason: 'missing_omniauth_data', outcome: 'denied' }
        )
      end

      it 'tracks missing omniauth data' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(MonitoringService.instance).to have_received(:track).with(
          'OAuth security: Missing OmniAuth data',
          level: 'info',
          context: {
            provider: valid_provider,
            ip: request.remote_ip
          }
        )
      end

      it 'does not create user session' do
        get :create_from_oauth, params: { provider: valid_provider }

        expect(session[:current_user_id]).to be_nil
      end
    end

    describe 'provider whitelist validation' do
      before do
        request.env['omniauth.auth'] = omniauth_auth_data
      end

      it 'allows proconnect_api_entreprise' do
        get :create_from_oauth, params: { provider: 'proconnect_api_entreprise' }

        expect(response).to redirect_to(authorization_requests_path)
      end

      it 'allows proconnect_api_particulier' do
        get :create_from_oauth, params: { provider: 'proconnect_api_particulier' }

        expect(response).to redirect_to(authorization_requests_path)
      end
    end
  end

  describe 'GET #destroy' do
    let(:user) { create(:user) }

    before do
      session[:current_user_id] = user.id
      session[:last_seen_at] = Time.current.to_i
      session[:absolute_expires_at] = 1.hour.from_now.to_i
    end

    it 'emits a closed session security event' do
      expect { get :destroy }.to emit_security_event('auth.session.closed').with(
        actor: { email: user.email, role: 'user' },
        target: { type: 'user', id: user.id },
        details: { reason: 'logout' }
      )
    end

    context 'when nobody is signed in' do
      before { session[:current_user_id] = nil }

      it 'does not emit a closed session security event' do
        expect { get :destroy }.not_to emit_security_event('auth.session.closed')
      end
    end

    context 'when an admin impersonates the user' do
      let(:admin) { create(:user, :admin) }

      before do
        session[:current_user_id] = admin.id
        session[:impersonated_user_id] = user.id
      end

      it 'tells which admin closed the session' do
        expect { get :destroy }.to emit_security_event('auth.session.closed').with(
          actor: { email: user.email, role: 'user' },
          details: { reason: 'logout', impersonated_by: admin.email }
        )
      end
    end
  end

  describe 'GET #dev_login' do
    shared_examples 'allows bypass login' do
      context 'when user exists' do
        let!(:user) { create(:user, email: 'test@example.com') }

        it 'emits a successful dev login attempt' do
          expect {
            get :dev_login, params: { email: 'test@example.com' }
          }.to emit_security_event('auth.login.attempted').with(
            actor: { email: user.email, role: 'user' },
            target: { type: 'user', id: user.id },
            details: { method: 'dev_login' }
          )
        end

        it 'signs in the user and redirects to authorization_requests_path' do
          get :dev_login, params: { email: 'test@example.com' }

          expect(session[:current_user_id]).to eq(user.id)
          expect(response).to redirect_to(authorization_requests_path)
        end

        it 'handles case-insensitive emails' do
          get :dev_login, params: { email: 'TEST@EXAMPLE.COM' }

          expect(session[:current_user_id]).to eq(user.id)
        end
      end

      context 'when user does not exist' do
        it 'emits a denied dev login attempt' do
          expect {
            get :dev_login, params: { email: 'nonexistent@example.com' }
          }.to emit_security_event('auth.login.attempted').with(
            details: { method: 'dev_login', reason: 'unknown_user', outcome: 'denied' }
          )
        end

        it 'redirects to root with error message' do
          get :dev_login, params: { email: 'nonexistent@example.com' }

          expect(session[:current_user_id]).to be_nil
          expect(response).to redirect_to(root_path)
          expect(flash[:error]['title']).to eq('Compte introuvable')
        end
      end

      context 'when email is not provided' do
        it 'redirects to root with error message' do
          get :dev_login

          expect(session[:current_user_id]).to be_nil
          expect(response).to redirect_to(root_path)
        end
      end
    end

    %w[development staging sandbox].each do |env|
      context "when in #{env} environment" do
        before do
          allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new(env))
        end

        it_behaves_like 'allows bypass login'
      end
    end

    context 'when in production environment' do
      before do
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
      end

      it 'redirects to root without signing in' do
        create(:user, email: 'test@example.com')

        get :dev_login, params: { email: 'test@example.com' }

        expect(session[:current_user_id]).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
