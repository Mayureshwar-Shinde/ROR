require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST /api/v1/users' do
    let(:valid_attributes) do
      { user:
        {
          first_name: 'Test',
          last_name: 'User',
          age: 25, date_of_birth: '1999-01-01',
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end
    let(:token) { Token.create }

    context 'when the request is authorized' do
      it 'creates a new User' do
        expect do
          post '/api/v1/users', params: valid_attributes, headers: { 'Authorization' => token.value }
        end.to change(User, :count).by(1)
      end

      it 'returns a created status' do
        post '/api/v1/users', params: valid_attributes, headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is not authorized' do
      it 'returns an unauthorized status if no token is provided' do
        post '/api/v1/users', params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an unauthorized status if an invalid token is provided' do
        post '/api/v1/users', params: valid_attributes, headers: { 'Authorization' => 'invalid_token' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an unauthorized status if an expired token is provided' do
        expired_token = token
        expired_token.update(expired_at: Date.today)
        post '/api/v1/users', params: valid_attributes, headers: { 'Authorization' => expired_token.value }
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end
end