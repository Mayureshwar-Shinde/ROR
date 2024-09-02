require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }

    subject { delete :destroy, params: { id: user.id }, format: :json }

    context 'when the user exists' do
      it 'deletes the user and returns no content status' do
        expect { subject }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the user does not exist' do
      before { user.destroy }

      it 'returns a valid response' do
        expect(subject).to have_http_status(:not_found)
        expect(response.content_type).to include('application/json')
      end

      it 'returns a not found error' do
        expect(json(subject)['error']).to eq('User not found')
      end
    end
  end
end
