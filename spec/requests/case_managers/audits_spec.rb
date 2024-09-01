require 'rails_helper'

RSpec.describe "CaseManagers::Audits", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/case_managers/audits/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show_users" do
    it "returns http success" do
      get "/case_managers/audits/show_users"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show_avatars" do
    it "returns http success" do
      get "/case_managers/audits/show_avatars"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show_cases" do
    it "returns http success" do
      get "/case_managers/audits/show_cases"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show_notes" do
    it "returns http success" do
      get "/case_managers/audits/show_notes"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show_appointments" do
    it "returns http success" do
      get "/case_managers/audits/show_appointments"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show_communication" do
    it "returns http success" do
      get "/case_managers/audits/show_communication"
      expect(response).to have_http_status(:success)
    end
  end

end
