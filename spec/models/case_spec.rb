require 'rails_helper'

RSpec.describe Case, type: :model do
  let(:user) { create(:user) }
  let(:curr_case) { create(:case, user:) }

  context 'case is valid' do
    it ' with the valid attributes' do
      expect(curr_case).to be_valid
    end

    it 'if has default status of open' do
      expect(curr_case.status).to eq('open')
    end
  end

  context 'case is invalid' do
    it 'with empty title or description' do
      curr_case.title = nil
      curr_case.description = nil
      curr_case.user_id = nil
      curr_case.assigned_to_id = nil
      expect(curr_case). not_to be_valid
      errors = curr_case.errors
      expect(errors[:title]).to include("can't be blank")
      expect(errors[:description]).to include("can't be blank")
      expect(errors[:user_id]).to include("can't be blank")
    end

    it 'if duplicate case_numbers' do
      duplicate_case = build(:case, user:)
      duplicate_case.case_number = curr_case.case_number
      expect(duplicate_case).not_to be_valid
      expect(duplicate_case.errors[:case_number]).to include("has already been taken")
    end
  end
  
end
