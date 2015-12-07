require 'rails_helper'

RSpec.describe Travel, type: :model do

  describe 'validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.create(:travel)).to be_valid
    end

    it 'is invalid without a title' do
      expect(FactoryGirl.build(:travel, title: nil)).not_to be_valid
    end

    it 'is invalid without a initial date' do
      expect(FactoryGirl.build(:travel, initial_date: nil)).not_to be_valid
    end

    it 'is invalid without a final date' do
      expect(FactoryGirl.build(:travel, final_date: nil)).not_to be_valid
    end

    it 'has an integer as maximum_people' do
      expect(FactoryGirl.build(:travel, maximum_people: 'four')).not_to be_valid
    end

    it 'has an integer as people' do
      expect(FactoryGirl.build(:travel, people: 'four')).not_to be_valid
    end

    it 'has high, medium or low as budget value' do
      expect(FactoryGirl.build(:travel, budget: 'very high')).not_to be_valid
    end
  end

end
