require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'PUT #update' do
    let!(:user1) { create(:user) }
    let!(:user2) { build(:user) }

    let(:params) do
      {
        id: user1.id,
        user: {
          first_name: user2.first_name,
          last_name: user2.last_name,
          age: user2.age,
          date_of_birth: user2.date_of_birth,
          email: user2.email,
          password: user2.password
        }
      }
    end

    subject { put :update, params:, format: :json }

    context 'with valid parameters' do
      it 'returns the response in JSON format' do
        subject
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns the ok status' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'updates the user with valid parameters' do
        user2.first_name = 'Updated'
        user2.last_name = 'Name'
        user2.email = 'updated@example.com'
        subject
        json = json(response)
        expect(json['first_name']).to eq('Updated')
        expect(json['last_name']).to eq('Name')
        expect(json['email']).to eq('updated@example.com')
      end
    end

    context 'with the invalid parameters' do
      it 'returns an unprocessable entity error for invalid email' do
        user2.email = 'invalidemail'
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json(response)['errors']).to include('Email is invalid')
      end

      it 'returns an unprocessable entity error for invalid password' do
        user2.password = 'short'
        subject
        expect(json(response)['errors']).to include('Password is too short (minimum is 6 characters)')
      end

      it 'returns an unprocessable entity error for invalid age' do
        user2.age = -1
        subject
        expect(json(response)['errors']).to include('Age must be greater than 0')
      end

      it 'returns an unprocessable entity error for invalid date of birth' do
        user2.date_of_birth = '01/01/9999'
        subject
        expect(json(response)['errors']).to include('Date of birth must be in the past')
      end

      it 'does not update the user' do
        user2.first_name = nil
        subject
        user1.reload
        expect(user1.first_name).not_to be_nil
      end

      it 'returns an error if the user is not found' do
        user1.id = 999_999_999
        subject
        expect(response).to have_http_status(:not_found)
        expect(json(response)['error']).to eq('User not found')
      end
    end

  end
end
