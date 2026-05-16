require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /signup' do
    let(:valid_params) do
      {
        user: {
          email: 'newuser@example.com',
          username: 'newuser',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    context 'when params are valid' do
      it 'creates a new user' do
        expect { post '/signup', params: valid_params }.to change(User, :count).by(1)
      end

      it 'redirects to root' do
        post '/signup', params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it 'sets session[:user_id]' do
        post '/signup', params: valid_params
        expect(session[:user_id]).to eq(User.find_by(email: 'newuser@example.com').id)
      end
    end

    context 'when the email is already taken' do
      before { create(:user, email: 'duplicate@example.com') }

      let(:duplicate_params) do
        {
          user: {
            email: 'duplicate@example.com',
            username: 'newuser',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      it 'returns 422 Unprocessable Entity' do
        post '/signup', params: duplicate_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a user' do
        expect { post '/signup', params: duplicate_params }.not_to change(User, :count)
      end

      it 'does not set session[:user_id]' do
        post '/signup', params: duplicate_params
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when password confirmation does not match' do
      let(:mismatch_params) do
        {
          user: {
            email: 'newuser@example.com',
            username: 'newuser',
            password: 'password123',
            password_confirmation: 'different123'
          }
        }
      end

      it 'returns 422 Unprocessable Entity' do
        post '/signup', params: mismatch_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a user' do
        expect { post '/signup', params: mismatch_params }.not_to change(User, :count)
      end

      it 'does not set session[:user_id]' do
        post '/signup', params: mismatch_params
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when email is blank' do
      let(:blank_email_params) do
        { user: { email: '', username: 'newuser', password: 'password123', password_confirmation: 'password123' } }
      end

      it 'returns 422 Unprocessable Entity' do
        post '/signup', params: blank_email_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when username is blank' do
      let(:blank_username_params) do
        { user: { email: 'newuser@example.com', username: '', password: 'password123', password_confirmation: 'password123' } }
      end

      it 'returns 422 Unprocessable Entity' do
        post '/signup', params: blank_username_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when password is too short' do
      let(:short_password_params) do
        { user: { email: 'newuser@example.com', username: 'newuser', password: 'short', password_confirmation: 'short' } }
      end

      it 'returns 422 Unprocessable Entity' do
        post '/signup', params: short_password_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with username at the maximum length boundary' do
      let(:base_user_params) do
        { email: 'newuser@example.com', password: 'password123', password_confirmation: 'password123' }
      end

      it 'creates a user when username is exactly 20 characters' do
        post '/signup', params: { user: base_user_params.merge(username: 'a' * 20) }
        expect(response).to redirect_to(root_path)
      end

      it 'returns 422 when username is 21 characters' do
        post '/signup', params: { user: base_user_params.merge(username: 'a' * 21) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
