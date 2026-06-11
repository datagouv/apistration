require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      head :ok
    end
  end

  let(:user) { create(:user) }

  context 'when a user is signed in' do
    before do
      session[:current_user_id] = user.id
      session[:last_seen_at] = 1.minute.ago.to_i
      session[:absolute_expires_at] = 23.hours.from_now.to_i
    end

    context 'with activity within both the idle window and the absolute cap' do
      it 'keeps the user signed in' do
        get :index

        expect(response).to have_http_status(:ok)
        expect(session[:current_user_id]).to eq(user.id)
      end

      it 'slides the idle window on each request' do
        session[:last_seen_at] = 1.hour.ago.to_i

        get :index

        expect(session[:last_seen_at]).to be_within(5).of(Time.current.to_i)
      end

      it 'never pushes the absolute deadline further' do
        deadline = 23.hours.from_now.to_i
        session[:absolute_expires_at] = deadline

        get :index

        expect(session[:absolute_expires_at]).to eq(deadline)
      end
    end

    context 'when idle for longer than the inactivity window' do
      before { session[:last_seen_at] = 13.hours.ago.to_i }

      it 'invalidates the session and redirects to login' do
        get :index

        expect(response).to redirect_to('/compte/se-connecter')
        expect(session[:current_user_id]).to be_nil
      end

      it 'flashes the inactivity message' do
        get :index

        expect(flash[:info]['title']).to eq(I18n.t('concerns.sessions_management.session_expired.idle', hours: 12))
      end
    end

    context 'when the absolute cap is reached despite recent activity' do
      before do
        session[:last_seen_at] = 1.minute.ago.to_i
        session[:absolute_expires_at] = 1.minute.ago.to_i
      end

      it 'invalidates the session and redirects to login' do
        get :index

        expect(response).to redirect_to('/compte/se-connecter')
        expect(session[:current_user_id]).to be_nil
      end

      it 'flashes the maximum-duration message' do
        get :index

        expect(flash[:info]['title']).to eq(I18n.t('concerns.sessions_management.session_expired.absolute', hours: 24))
      end
    end

    context 'with continuous activity spanning more than the idle window' do
      include ActiveSupport::Testing::TimeHelpers

      it 'stays alive while sliding, until the absolute cap fires even under activity' do
        login_time = Time.current
        session[:last_seen_at] = login_time.to_i
        session[:absolute_expires_at] = (login_time + 24.hours).to_i

        travel_to(login_time + 11.hours) do
          get :index

          expect(session[:current_user_id]).to eq(user.id)
        end

        travel_to(login_time + 22.hours) do
          get :index

          expect(session[:current_user_id]).to eq(user.id)
        end

        travel_to(login_time + 24.hours + 30.minutes) do
          get :index

          expect(response).to redirect_to('/compte/se-connecter')
          expect(session[:current_user_id]).to be_nil
        end
      end
    end

    context 'with a legacy session predating timeout tracking' do
      before do
        session.delete(:last_seen_at)
        session.delete(:absolute_expires_at)
      end

      it 'invalidates the session and redirects to login' do
        get :index

        expect(response).to redirect_to('/compte/se-connecter')
        expect(session[:current_user_id]).to be_nil
      end
    end
  end

  context 'when no user is signed in' do
    it 'does not interfere with the request' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
