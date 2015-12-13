require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe 'validations' do
      it 'has a valid factory' do
      expect(FactoryGirl.create(:user)).to be_valid
    end

    it 'is invalid without a first_name' do
      expect(FactoryGirl.build(:user, first_name: nil)).not_to be_valid
    end

    it 'is invalid without a last name' do
      expect(FactoryGirl.build(:user, last_name: nil)).not_to be_valid
    end

    it 'is invalid without a gender' do
      expect(FactoryGirl.build(:user, gender: nil)).not_to be_valid
    end

    it 'is invalid without a country' do
      expect(FactoryGirl.build(:user, country: nil)).not_to be_valid
    end

    it 'is invalid without a date of birth' do
      expect(FactoryGirl.build(:user, date_of_birth: nil)).not_to be_valid
    end

    it 'is invalid without a date of birth' do
      expect(FactoryGirl.build(:user, date_of_birth: nil)).not_to be_valid
    end
  end
end
