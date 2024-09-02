require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'PUT #update' do
    before do
      @user = create(:user)
    end

    let(:valid_attributes) do
      {
        id: @user.id,
        user: {
          first_name: 'Updated',
          last_name: 'Name',
          email: 'updated@example.com'
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the user' do
        put :update, params: valid_attributes, format: :json

        @user.reload
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(@user.id)
        expect(json_response['first_name']).to eq('Updated')
        expect(json_response['last_name']).to eq('Name')
        expect(json_response['email']).to eq('updated@example.com')
      end
    end

    context 'with the invalid parameters' do
      it 'returns a not found error' do
        put :update, params: { id: 9999, user: { first_name: 'NonExistent' } }, format: :json

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User not found')
      end
    end
  end
end
