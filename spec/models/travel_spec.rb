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
    before (:each) { @travel = FactoryGirl.build(:travel, maximum_people: nil)}

    it 'sets it to 0 if there is no input' do
      n = nil
      @travel.set_maximum_people(n)

      expect(@travel.maximum_people).to eq(0)
    end

    it 'sets it to 0 if the input is not a number' do
      n = 'string'
      @travel.set_maximum_people(n)

      expect(@travel.maximum_people).to eq(0)
    end

    it 'sets it to a number if there is an input' do
      n = '10'
      @travel.set_maximum_people(n)

      expect(@travel.maximum_people).to eq(10)
    end
  end

  describe '#add_tags' do
    before (:each) { @travel = FactoryGirl.create(:travel) }

    it 'does nothing if there are no selected values' do
      array = nil
      @travel.add_tags(array)

      expect(@travel.tag_list.length).to eq(0)
    end

    it 'add one tag from an array with one value' do
      array = ['Cruise']
      @travel.add_tags(array)

      expect(@travel.tag_list.length).to eq(1)
    end

    it 'add two tags from an array with two values' do
      array = ['Cruise', 'Romantic']
      @travel.add_tags(array)

      expect(@travel.tag_list.length).to eq(2)
    end
  end

  describe '#add_requirements' do
    before (:each) { @travel = FactoryGirl.create(:travel) }

    it 'does nothing if there are no selected values' do
      array = nil
      @travel.add_requirements(array)

      expect(@travel.requirement_list.length).to eq(0)
    end

    it 'add one requirement from an array with one value' do
      array = ['Age']
      @travel.add_requirements(array)

      expect(@travel.requirement_list.length).to eq(1)
    end

    it 'add two requirements from an array with two values' do
      array = ['Age', 'Children']
      @travel.add_requirements(array)

      expect(@travel.requirement_list.length).to eq(2)
    end
  end

  describe '#add_places' do
    before (:each) { @travel = FactoryGirl.create(:travel) }

    it 'add nothing from an empty string' do
      string = ''
      @travel.add_places(string)

      expect(@travel.place_list.length).to eq(0)
    end

    it 'add one requirement from a string with one value' do
      string = 'Toledo'
      @travel.add_places(string)

      expect(@travel.place_list.length).to eq(1)
    end

    it 'add two requirements from a string with two values' do
      string = 'Toledo,Sevilla'
      @travel.add_places(string)

      expect(@travel.place_list.length).to eq(2)
    end
  end

  describe '#add_countries' do
    before (:each) { @travel = FactoryGirl.create(:travel) }

    it 'add nothing from an empty string' do
      string = ''
      @travel.add_countries(string)

      expect(@travel.country_list.length).to eq(0)
    end

    it 'add one requirement from a string with one value' do
      string = 'France'
      @travel.add_countries(string)

      expect(@travel.country_list.length).to eq(1)
    end

    it 'add two requirements from a string with two values' do
      string = 'France,Italy'
      @travel.add_countries(string)

      expect(@travel.country_list.length).to eq(2)
    end
  end

  describe '#get_tags' do
    before (:each) { @travel = FactoryGirl.create(:travel) }
    it 'returns an empty string is there is no tags' do
      expect(@travel.get_tags).to eq('')
    end

    it 'returns an string with the one tag' do
      @travel.add_tags(['adventure'])
      expect(@travel.get_tags).to eq('adventure')
    end

    it 'returns an string with the tags' do
      @travel.add_tags(['adventure', 'cruise'])
      expect(@travel.get_tags).to eq('adventure,cruise')
    end
  end

  describe '#get_requirements' do
    before (:each) { @travel = FactoryGirl.create(:travel) }

    it 'returns an empty string is there is no tags' do
      expect(@travel.get_requirements).to eq('')
    end

    it 'returns an string with the one tag' do
      @travel.add_requirements(['age'])
      expect(@travel.get_requirements).to eq('age')
    end

    it 'returns an string with the tags' do
      @travel.add_requirements(['age', 'gender'])
      expect(@travel.get_requirements).to eq('age,gender')
    end
  end

  describe '#get_places' do
    before (:each) { @travel = FactoryGirl.create(:travel) }

    it 'returns an empty string is there is no tags' do
      expect(@travel.get_places).to eq('')
    end

    it 'returns an string with the one tag' do
      @travel.add_places(['Madrid'])
      expect(@travel.get_places).to eq('Madrid')
    end

    it 'returns an string with the tags' do
      @travel.add_places(['Madrid', 'Barcelona'])
      expect(@travel.get_places).to eq('Madrid,Barcelona')
    end
  end

  describe '#get_countries' do
    before (:each) { @travel = FactoryGirl.create(:travel) }

    it 'returns an empty string is there is no tags' do
      expect(@travel.get_countries).to eq('')
    end

    it 'returns an string with the one tag' do
      @travel.add_countries(['Spain'])
      expect(@travel.get_countries).to eq('Spain')
    end

    it 'returns an string with the tags' do
      @travel.add_countries(['Spain', 'France'])
      expect(@travel.get_countries).to eq('Spain,France')
    end
  end

  describe '#clean_all_tags' do
    before (:each) do 
      @travel = FactoryGirl.create(:travel)
    end

    it 'stays the same if there is no tags' do
      @travel.clean_all_tags
      expect(@travel.tags.count).to eq(0)
    end

    it 'clean all the tags of one class' do
      @travel.tag_list.add('adventure', 'cruise')
      @travel.clean_all_tags
      expect(@travel.tags.count).to eq(0)
    end

    it 'clean all the tags of all classes' do
      @travel.tag_list.add('adventure', 'cruise')
      @travel.requirement_list.add('adventure', 'cruise')
      @travel.country_list.add('adventure', 'cruise')
      @travel.place_list.add('adventure', 'cruise')
      
      expect(@travel.tags.count).to eq(0)
      expect(@travel.requirements.count).to eq(0)
      expect(@travel.countries.count).to eq(0)
      expect(@travel.places.count).to eq(0)
    end
  end

end
