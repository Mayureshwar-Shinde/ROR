require 'rails_helper'

RSpec.describe Case, type: :model do
  let!(:curr_case) { create(:case) }

  context 'case is valid' do
    it 'with the valid attributes' do
      expect(curr_case).to be_valid
    end

    it 'has default status of open' do
      expect(curr_case.status).to eq('open')
    end

    it 'generates a case_number with the alphanumeric format of size 6' do
      expect(curr_case.case_number).to match(/^#[0-9A-F]{6}$/)
    end
  end

  context 'case is not valid' do
    it 'when title is not present' do
      curr_case.title = nil
      expect(curr_case).not_to be_valid
    end

    it 'when description is not present' do
      curr_case.description = nil
      expect(curr_case).not_to be_valid
    end
  end
end
