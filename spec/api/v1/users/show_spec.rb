require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'GET #show' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
    end

    let(:token) { Token.create }

    context 'when the user exists' do
      it 'returns the user details' do
        get "/api/v1/users/#{@user1.id}", headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(@user1.id)
        expect(json_response['first_name']).to eq(@user1.first_name)
        expect(json_response['last_name']).to eq(@user1.last_name)
        expect(json_response['email']).to eq(@user1.email)
      end
    end

    context 'when the user does not exist' do
      it 'returns a not found error' do
        get '/api/v1/users/9999', headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User not found')
      end
    end
  end
end
