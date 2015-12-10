require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  describe 'validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.create(:comment)).to be_valid
    end

    it 'is invalid without a description' do
      expect(FactoryGirl.build(:comment, description: nil)).not_to be_valid
    end

    it 'is invalid without a name' do
      expect(FactoryGirl.build(:comment, name: nil)).not_to be_valid
    end
  end

end