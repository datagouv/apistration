require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      head :ok
    end
  end

  let(:user) { create(:user) }

  context 'when a user is signed in' do
    before { session[:current_user_id] = user.id }

    context 'with activity within the inactivity window' do
      before { session[:last_seen_at] = 1.hour.ago.to_i }

      it 'keeps the user signed in' do
        get :index

        expect(response).to have_http_status(:ok)
        expect(session[:current_user_id]).to eq(user.id)
      end

      it 'refreshes the last activity timestamp on each request' do
        get :index

        expect(session[:last_seen_at]).to be_within(5).of(Time.current.to_i)
      end
    end

    context 'with no activity for longer than the inactivity window' do
      before { session[:last_seen_at] = 13.hours.ago.to_i }

      it 'invalidates the session and redirects to login' do
        get :index

        expect(response).to redirect_to('/compte/se-connecter')
        expect(session[:current_user_id]).to be_nil
      end

      it 'flashes an expiration message' do
        get :index

        expect(flash[:info]['title']).to be_present
      end
    end

    context 'across interactions that each stay within the window' do
      include ActiveSupport::Testing::TimeHelpers

      it 'extends the session on every interaction, surviving well past the initial login window' do
        login_time = Time.current
        session[:last_seen_at] = login_time.to_i

        travel_to(login_time + 11.hours) do
          get :index

          expect(response).to have_http_status(:ok)
          expect(session[:current_user_id]).to eq(user.id)
        end

        travel_to(login_time + 22.hours) do
          get :index

          expect(response).to have_http_status(:ok)
          expect(session[:current_user_id]).to eq(user.id)
        end

        travel_to(login_time + 35.hours) do
          get :index

          expect(response).to redirect_to('/compte/se-connecter')
          expect(session[:current_user_id]).to be_nil
        end
      end
    end

    context 'with a legacy session predating inactivity tracking' do
      before { session.delete(:last_seen_at) }

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
