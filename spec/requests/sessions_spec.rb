require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'POST /login' do
    context 'when credentials are valid' do
      let!(:user) do
        create(:user, email: 'login@example.com', password: 'password123')
      end

      it 'redirects to root' do
        post '/login', params: { session: { email: 'login@example.com', password: 'password123' } }
        expect(response).to redirect_to(root_path)
      end

      it 'sets session[:user_id]' do
        post '/login', params: { session: { email: 'login@example.com', password: 'password123' } }
        expect(session[:user_id]).to eq(user.id)
      end

      it 'authenticates with an uppercase email' do
        post '/login', params: { session: { email: 'LOGIN@EXAMPLE.COM', password: 'password123' } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the email does not exist' do
      it 'returns 422 Unprocessable Entity' do
        post '/login', params: { session: { email: 'nonexistent@example.com', password: 'password123' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'sets flash[:alert]' do
        post '/login', params: { session: { email: 'nonexistent@example.com', password: 'password123' } }
        expect(flash[:alert]).to be_present
      end

      it 'does not set session[:user_id]' do
        post '/login', params: { session: { email: 'nonexistent@example.com', password: 'password123' } }
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when the password is wrong' do
      before { create(:user, email: 'login@example.com', password: 'password123') }

      it 'returns 422 Unprocessable Entity' do
        post '/login', params: { session: { email: 'login@example.com', password: 'wrongpassword' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'sets flash[:alert]' do
        post '/login', params: { session: { email: 'login@example.com', password: 'wrongpassword' } }
        expect(flash[:alert]).to be_present
      end

      it 'does not set session[:user_id]' do
        post '/login', params: { session: { email: 'login@example.com', password: 'wrongpassword' } }
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when the email param is blank' do
      it 'returns 422 Unprocessable Entity' do
        post '/login', params: { session: { email: '', password: 'password123' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the password param is blank' do
      before { create(:user, email: 'login@example.com', password: 'password123') }

      it 'returns 422 Unprocessable Entity' do
        post '/login', params: { session: { email: 'login@example.com', password: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /logout' do
    context 'when logged in' do
      let!(:user) { create(:user) }

      before { post '/login', params: { session: { email: user.email, password: 'password123' } } }

      it 'redirects to the login page' do
        delete '/logout'
        expect(response).to redirect_to(login_path)
      end

      it 'clears session[:user_id]' do
        delete '/logout'
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        delete '/logout'
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
