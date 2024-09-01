require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'GET #index' do

    let(:token) { Token.create }

    context 'when there are users' do
      before do
        create_list(:user, 3)
      end
      it 'returns a list of all users' do
        get '/api/v1/users', headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(3)
      end
    end

    context 'when there are no users' do
      it 'returns an empty list' do
        get '/api/v1/users', headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end

    context 'filtering capabilities' do
      let!(:user1) { create(:user, first_name: 'John', last_name: 'Doe', email: 'john@example.com') }
      let!(:user2) { create(:user, first_name: 'Jane', last_name: 'Smith', email: 'jane@example.com') }
      let!(:user3) { create(:user, first_name: 'John', last_name: 'Smith', email: 'johnsmith@example.com') }

      it 'returns users with matching first_name' do
        get '/api/v1/users', params: { first_name: 'John' }, headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response.map { |user| user['first_name'] }).to all(eq('John'))
      end

      it 'returns users with matching last_name' do
        get '/api/v1/users', params: { last_name: 'Smith' }, headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response.map { |user| user['last_name'] }).to all(eq('Smith'))
      end

      it 'returns users with matching email' do
        get '/api/v1/users', params: { email: 'john@example.com' }, headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(1)
        expect(json_response.first['email']).to eq('john@example.com')
      end

      it 'returns users with multiple filters' do
        get '/api/v1/users', params: { first_name: 'John', last_name: 'Smith' }, headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(1)
        expect(json_response.first['first_name']).to eq('John')
        expect(json_response.first['last_name']).to eq('Smith')
      end

      it 'returns no users with no matching filters' do
        get '/api/v1/users', params: { first_name: 'Nonexistent', last_name: 'User' }, headers: { 'Authorization' => token.value }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end
  end
end
