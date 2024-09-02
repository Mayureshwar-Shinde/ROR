require 'rails_helper'

describe Api::V1::UsersController, type: :request do

  let!(:users) { create_list(:user, 10) }

  before { get api_v1_users_path }

  describe 'GET /api/v1/users' do

    it 'responds with ok status' do
      expect(response).to have_http_status :ok
    end

    it 'returns a JSON response' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'returns a list of users' do
      expect(json(response).size).to eq(10)
    end

    it 'returns a list of users with the correct attributes' do
      expect(json(response).first.keys).to eq(%w[id first_name last_name email age date_of_birth created_at updated_at])
    end

    it 'returns a list of users with the correct data types' do
      json = json(response).first
      expect(json['id']).to be_a(Integer)
      expect(json['first_name']).to be_a(String)
      expect(json['last_name']).to be_a(String)
      expect(json['email']).to be_a(String)
      expect(json['created_at']).to be_a(String)
    end

    it 'returns an empty list when there are no users' do
      User.delete_all
      get api_v1_users_path
      expect(json(response)).to be_empty
    end
  end

end
