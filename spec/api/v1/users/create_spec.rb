require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'POST #create' do
    let(:valid_attributes) do
      {
        user: {
          first_name: 'Bob',
          last_name: 'Smith',
          age: 20,
          date_of_birth: '2000-01-10',
          email: 'bob@smith.com',
          password: 'password'
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          first_name: 'Bob',
          last_name: 'Smith',
          age: 20,
          date_of_birth: 'hello',
          email: 'bob@smith.com',
          password: 'password'
        }
      }
    end

    let(:token) { Token.create }

    context 'with valid parameters' do
      it 'creates a new user' do
        expect do
          post '/api/v1/users', params: valid_attributes, headers: { 'Authorization' => token.value }
        end.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['first_name']).to eq('Bob')
        expect(json_response['last_name']).to eq('Smith')
        expect(json_response['email']).to eq('bob@smith.com')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect do
          post '/api/v1/users', params: invalid_attributes, headers: { 'Authorization' => token.value }
        end.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Date of birth is not a valid date")
      end
    end

  end
end

