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

  describe '#set_maximum_people' do
    it 'sets it to 0 if there is no input' do
      @travel = FactoryGirl.build(:travel, maximum_people: nil)
      n = nil
      @travel.set_maximum_people(n)

      expect(@travel.maximum_people).to eq(0)
    end

    it 'sets it to 0 if the input is not a number' do
      @travel = FactoryGirl.build(:travel, maximum_people: nil)
      n = 'string'
      @travel.set_maximum_people(n)

      expect(@travel.maximum_people).to eq(0)
    end

    it 'sets it to a number if there is an input' do
      @travel = FactoryGirl.build(:travel, maximum_people: nil)
      n = '10'
      @travel.set_maximum_people(n)

      expect(@travel.maximum_people).to eq(10)
    end
  end

  describe '#add_tags' do
    it 'does nothing if there are no selected values' do
      @travel = FactoryGirl.create(:travel)
      array = nil
      @travel.add_tags(array)

      expect(@travel.tag_list.length).to eq(0)
    end

    it 'add one tag from an array with one value' do
      @travel = FactoryGirl.create(:travel)
      array = ['Cruise']
      @travel.add_tags(array)

      expect(@travel.tag_list.length).to eq(1)
    end

    it 'add two tags from a hash with two values' do
      @travel = FactoryGirl.create(:travel)
      array = ['Cruise', 'Romantic']
      @travel.add_tags(array)

      expect(@travel.tag_list.length).to eq(2)
    end
  end

  describe '#add_requirements' do
    it 'does nothing if there are no selected values' do
      @travel = FactoryGirl.create(:travel)
      array = nil
      @travel.add_requirements(array)

      expect(@travel.requirement_list.length).to eq(0)
    end

    it 'add one requirement from a hash with one value' do
      @travel = FactoryGirl.create(:travel)
      array = ['Age']
      @travel.add_requirements(array)

      expect(@travel.requirement_list.length).to eq(1)
    end

    it 'add two requirements from a hash with two values' do
      @travel = FactoryGirl.create(:travel)
      array = ['Age', 'Children']
      @travel.add_requirements(array)

      expect(@travel.requirement_list.length).to eq(2)
    end
  end

  describe '#add_places' do
    it 'add nothing from an empty string' do
      @travel = FactoryGirl.create(:travel)
      string = ''
      @travel.add_places(string)

      expect(@travel.place_list.length).to eq(0)
    end

    it 'add one requirement from a string with one value' do
      @travel = FactoryGirl.create(:travel)
      string = 'Toledo'
      @travel.add_places(string)

      expect(@travel.place_list.length).to eq(1)
    end

    it 'add two requirements from a string with two values' do
      @travel = FactoryGirl.create(:travel)
      string = 'Toledo,Sevilla'
      @travel.add_places(string)

      expect(@travel.place_list.length).to eq(2)
    end
  end

  describe '#add_countries' do
    it 'add nothing from an empty string' do
      @travel = FactoryGirl.create(:travel)
      string = ''
      @travel.add_countries(string)

      expect(@travel.country_list.length).to eq(0)
    end

    it 'add one requirement from a string with one value' do
      @travel = FactoryGirl.create(:travel)
      string = 'France'
      @travel.add_countries(string)

      expect(@travel.country_list.length).to eq(1)
    end

    it 'add two requirements from a string with two values' do
      @travel = FactoryGirl.create(:travel)
      string = 'France,Italy'
      @travel.add_countries(string)

      expect(@travel.country_list.length).to eq(2)
    end
  end

  describe '#get_tags' do
    it 'returns an empty string is there is no tags' do
      @travel = FactoryGirl.create(:travel)
      expect(@travel.get_tags).to eq('')
    end

    it 'returns an string with the one tag' do
      @travel = FactoryGirl.create(:travel)
      @travel.add_tags(['adventure'])
      expect(@travel.get_tags).to eq('adventure')
    end

    it 'returns an string with the tags' do
      @travel = FactoryGirl.create(:travel)
      @travel.add_tags(['adventure', 'cruise'])
      expect(@travel.get_tags).to eq('adventure,cruise')
    end
  end

  describe '#get_requirements' do
    it 'returns an empty string is there is no tags' do
      @travel = FactoryGirl.create(:travel)
      expect(@travel.get_requirements).to eq('')
    end

    it 'returns an string with the one tag' do
      @travel = FactoryGirl.create(:travel)
      @travel.add_requirements(['age'])
      expect(@travel.get_requirements).to eq('age')
    end

    it 'returns an string with the tags' do
      @travel = FactoryGirl.create(:travel)
      @travel.add_requirements(['age', 'gender'])
      expect(@travel.get_requirements).to eq('age,gender')
    end
  end

  describe '#get_places' do
    it 'returns an empty string is there is no tags' do
      @travel = FactoryGirl.create(:travel)
      expect(@travel.get_places).to eq('')
    end

    it 'returns an string with the one tag' do
      @travel = FactoryGirl.create(:travel)
      @travel.add_places(['Madrid'])
      expect(@travel.get_places).to eq('Madrid')
    end

    it 'returns an string with the tags' do
      @travel = FactoryGirl.create(:travel)
      @travel.add_places(['Madrid', 'Barcelona'])
      expect(@travel.get_places).to eq('Madrid,Barcelona')
    end
  end

  describe '#get_countries' do
    it 'returns an empty string is there is no tags' do
      @travel = FactoryGirl.create(:travel)
      expect(@travel.get_countries).to eq('')
    end

    it 'returns an string with the one tag' do
      @travel = FactoryGirl.create(:travel)
      @travel.add_countries(['Spain'])
      expect(@travel.get_countries).to eq('Spain')
    end

    it 'returns an string with the tags' do
      @travel = FactoryGirl.create(:travel)
      @travel.add_countries(['Spain', 'France'])
      expect(@travel.get_countries).to eq('Spain,France')
    end
  end

end
