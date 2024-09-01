require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #show' do

    let(:user) { create(:user) }

    before { get :show, params: { id: user.id }, format: :json }

    context 'when user exists' do
      it 'returns the response in JSON format' do
        expect(response.content_type).to eq 'application/json; charset=utf-8'
      end

      it 'returns the ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns valid user details' do
        json = json(response)
        expect(json['id']).to eq(user.id)
        expect(json['first_name']).to eq(user.first_name)
        expect(json['last_name']).to eq(user.last_name)
        expect(json['email']).to eq(user.email)
        response_created_at = DateTime.parse(json['created_at']).strftime('%Y-%m-%d %H:%M:%S')
        expect(response_created_at).to eq(user.created_at.strftime('%Y-%m-%d %H:%M:%S'))
      end
    end

    context 'when user does not exist' do
      it 'returns a not found status' do
        get :show, params: { id: 9999 }, format: :json
        expect(response).to have_http_status(:not_found)
        expect(json(response)['error']).to eq('User not found')
      end
    end

  end
end
