require 'rails_helper'

RSpec.describe Traveler, type: :model do

  describe 'validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.create(:traveler)).to be_valid
    end

    it 'is invalid without a first_name' do
      expect(FactoryGirl.build(:traveler, first_name: nil)).not_to be_valid
    end

    it 'is invalid without a last name' do
      expect(FactoryGirl.build(:traveler, last_name: nil)).not_to be_valid
    end

    it 'is invalid without a country' do
      expect(FactoryGirl.build(:traveler, country: nil)).not_to be_valid
    end

    it 'is invalid without the date of birth' do
      expect(FactoryGirl.build(:traveler, date_of_birth: nil)).not_to be_valid
    end

    it 'is invalid without the gender' do
      expect(FactoryGirl.build(:traveler, gender: nil)).not_to be_valid
    end

    it 'is valid with FEMALE or MALE gender only' do
      expect(FactoryGirl.build(:traveler, gender: 'mujer')).not_to be_valid
    end

  end

  describe '#get_age' do

    it 'returns the age of the traveler' do
      @traveler = FactoryGirl.create(:traveler, date_of_birth: Date.new(1985,10,10))
      expect(@traveler.get_age).to eq(31)
    end
  end

end
