require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'DELETE #destroy' do
    before do
      @user = create(:user)
    end

    let(:token) { Token.create }

    context 'when the user exists' do
      it 'deletes the user' do
        expect do
          delete "/api/v1/users/#{@user.id}", headers: { 'Authorization' => token.value }
        end.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the user does not exist' do
      it 'returns a not found error' do
        delete "/api/v1/users/9999", headers: { 'Authorization' => token.value }

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User not found')
      end
    end
  end
end
