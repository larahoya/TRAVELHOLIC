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

  describe '#get_user_travels' do
    before (:each) do
      @user = FactoryGirl.create(:user)
      @traveler = FactoryGirl.create(:traveler, user_id: @user.id)
      @traveler2 = FactoryGirl.create(:traveler, user_id: @user.id)
      @travel = FactoryGirl.create(:travel)
      @travel2 = FactoryGirl.create(:travel)
    end

    it 'returns an array with the travels of the user' do
      @travel.travelers << @traveler
      expect(@user.get_user_travels.length).to eq(1)
    end

    it 'returns an array with the travels of the user' do
      @travel.travelers << @traveler
      @travel2.travelers << @traveler2
      expect(@user.get_user_travels.length).to eq(2)
    end

    it 'returns an empty array if there is not travels' do
      expect(@user.get_user_travels.length).to eq(0)
    end

  end

  describe '#set_first_traveler' do
    before (:each) do
      @user = FactoryGirl.create(:user, first_name: 'Prueba')
      @user.set_first_traveler
    end
    it 'create a new traveler' do
      expect(Traveler.count).to eq(1)
    end
    it 'create a new traveler that belongs to the user' do
      expect(@user.travelers.count).to eq(1)
    end
    it 'creates a new traveler with the same first_name than the user' do
      expect(Traveler.last.first_name).to eq('Prueba')
    end
  end
end
