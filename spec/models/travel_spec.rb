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

    it 'is invalid without a maximum_people' do
      expect(FactoryGirl.build(:travel, maximum_people: nil)).not_to be_valid
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

  describe '#check_maximum_people' do
    it 'returns false if the maximum_people is equal than the people' do
      @travel = FactoryGirl.create(:travel, maximum_people: 10, people: 10)
      expect(@travel.check_maximum_people).to be false
    end
    it 'returns true if the maximum_people is greater than the people' do
      @travel = FactoryGirl.create(:travel, maximum_people: 10, people: 8)
      expect(@travel.check_maximum_people).to be true
    end
  end

  describe '#check_age' do

    context 'only young people requirement' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @travel.requirement_list.add('only young people')
      end
  
      it 'returns true if the traveler satisfies the requirement' do
        @traveler = FactoryGirl.create(:traveler, date_of_birth: Date.new(2000,12,12))
        expect(@travel.check_age(@traveler)).to be true
      end

      it 'returns false if the traveler doesn´t satisfy the requirement' do
        @traveler = FactoryGirl.create(:traveler, date_of_birth: Date.new(1980,12,12))
        expect(@travel.check_age(@traveler)).to be false
      end
    end

    context 'not young people requirement' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @travel.requirement_list.add('not young people')
      end
  
      it 'returns true if the traveler satisfies the requirement' do
        @traveler = FactoryGirl.create(:traveler, date_of_birth: Date.new(2000,12,12))
        expect(@travel.check_age(@traveler)).to be false
      end

      it 'returns false if the traveler doesn´t satisfy the requirement' do
        @traveler = FactoryGirl.create(:traveler, date_of_birth: Date.new(1980,12,12))
        expect(@travel.check_age(@traveler)).to be true
      end
    end

  end

  describe '#check_gender' do

    context 'only women' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @travel.requirement_list.add('only women')
      end

      it 'returns true if the traveler satisfies the requirement' do
        @traveler = FactoryGirl.create(:traveler, gender: 'FEMALE')
        expect(@travel.check_gender(@traveler)).to be true
      end

      it 'returns false if the traveler doesn´t satisfy the requirement' do
        @traveler = FactoryGirl.create(:traveler, gender: 'MALE')
        expect(@travel.check_gender(@traveler)).to be false
      end
    end

    context 'only men' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @travel.requirement_list.add('only men')
      end

      it 'returns true if the traveler satisfies the requirement' do
        @traveler = FactoryGirl.create(:traveler, gender: 'FEMALE')
        expect(@travel.check_gender(@traveler)).to be false
      end

      it 'returns false if the traveler doesn´t satisfy the requirement' do
        @traveler = FactoryGirl.create(:traveler, gender: 'MALE')
        expect(@travel.check_gender(@traveler)).to be true
      end
    end

  end

  describe '#check_children' do
    before (:each) do
      @travel = FactoryGirl.create(:travel)
      @travel.requirement_list.add('not children')
    end

    it 'returns true if the traveler satisfies the requirement' do
      @traveler = FactoryGirl.create(:traveler, date_of_birth: Date.new(1980,12,12))
      expect(@travel.check_children(@traveler)).to be true
    end

    it 'returns false if the traveler doesn´t satisfy the requirement' do
      @traveler = FactoryGirl.create(:traveler, date_of_birth: Date.new(2010,12,12))
      expect(@travel.check_children(@traveler)).to be false
    end
  end

  describe '#check_country' do
    before (:each) do
      @user = FactoryGirl.create(:user, country: 'Spain')
      @travel = FactoryGirl.create(:travel, user_id: @user.id)
      @travel.requirement_list.add('only people from my country')
    end

    it 'returns true if the traveler is from the same country' do
      @traveler = FactoryGirl.create(:traveler, country: 'Spain')
      expect(@travel.check_country(@traveler)).to be true
    end

    it 'returns false if the traveler is from other country' do
      @traveler = FactoryGirl.create(:traveler, country: 'France')
      expect(@travel.check_country(@traveler)).to be false
    end
  end

  describe '#check_requirements' do
    before (:each) do
      @user = FactoryGirl.create(:user, country: 'Spain')
      @travel = FactoryGirl.create(:travel, user_id: @user.id, maximum_people: 10)
    end

    it 'returns true if the traveler satisfies all the requirements' do
      @travel.requirement_list.add(['only people from my country','not children'])
      @traveler = FactoryGirl.create(:traveler, country: 'Spain', date_of_birth: Date.new(1980,12,12))
      expect(@travel.check_requirements(@traveler)).to be true
    end

    it 'returns false if the traveler doesn´t satisfy all the requirements' do
      @travel.requirement_list.add(['only people from my country','not children'])
      @traveler = FactoryGirl.create(:traveler, country: 'France', date_of_birth: Date.new(1980,12,12))
      expect(@travel.check_requirements(@traveler)).to be false
    end

    it 'returns false if the traveler doesn´t satisfy all the requirements' do
      @travel.requirement_list.add(['only people from my country','not children'])
      @traveler = FactoryGirl.create(:traveler, country: 'Spain', date_of_birth: Date.new(2010,12,12))
      expect(@travel.check_requirements(@traveler)).to be false
    end

    it 'returns false if the travel is full' do
      @travel.requirement_list.add(['only people from my country','not children'])
      @travel.people = 10
      @travel.save
      @traveler = FactoryGirl.create(:traveler, country: 'Spain', date_of_birth: Date.new(1980,12,12))
      expect(@travel.check_requirements(@traveler)).to be false
    end
    
  end

  describe 'filter methods to search' do

    describe '::filter_by_country' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @travel.add_countries('Spain')
        @travel.save
      end
      it 'return the travel if the country is tagged in the travel' do
        expect(Travel.filter_by_country({'country': 'Spain'}, Travel.all)).to match_array([@travel])
      end
      it 'return an empty array if the country is not tagged in the travel' do
        expect(Travel.filter_by_country({'country': 'France'}, Travel.all)).to match_array([])
      end
    end

    describe '::filter_by_place' do
      before (:each) do
        @travel = FactoryGirl.create(:travel)
        @travel.add_places('Madrid')
        @travel.save
      end
      it 'return the travel if the place is tagged in the travel' do
        expect(Travel.filter_by_place({'initial_date': '','final_date': '','country': '','place': 'Madrid', 'budget': ''}, Travel.all)).to match_array([@travel])
      end
      it 'return an empty array if the place is not tagged in the travel' do
        expect(Travel.filter_by_place({'place' => 'Barcelona'}, Travel.all)).to match_array([])
      end
    end

    describe '::filter_by_budget' do
      before (:each) do
        @travel = FactoryGirl.create(:travel, budget: 'medium')
      end
      it 'return the travel if the budget is the same' do
        expect(Travel.filter_by_budget({'initial_date': '','final_date': '','country': '','place': 'Madrid', 'budget': 'medium'}, Travel.all)).to match_array([@travel])
      end
      it 'return an empty array if the budget is not the same' do
        expect(Travel.filter_by_budget({'initial_date': '','final_date': '','country': '','place': 'Madrid', 'budget': 'low'}, Travel.all)).to match_array([])
      end
    end

    describe '::filter_by_initial_date' do
      before (:each) do
        @travel = FactoryGirl.create(:travel, initial_date: Date.new(2010,10,10))
      end
      it 'return the travel if initial date is after the initial date of the travel' do
        expect(Travel.filter_by_initial_date({'initial_date': Date.today,'final_date': '','country': '','place': '', 'budget': ''}, Travel.all)).to match_array([@travel])
      end
      it 'return an empty array if the initial date is before the initial date of the travel' do
        expect(Travel.filter_by_initial_date({'initial_date': Date.new(2010,10,10),'final_date': '','country': '','place': '', 'budget': ''}, Travel.all)).to match_array([])
      end
    end

    describe '::filter_by_final_date' do
      before (:each) do
        @travel = FactoryGirl.create(:travel, final_date: Date.new(2010,10,10))
      end
      it 'return the travel if the final date is before the final date of the travel' do
        expect(Travel.filter_by_final_date({'initial_date': '','final_date': Date.new(2010,10,10),'country': '','place': '', 'budget': ''}, Travel.all)).to match_array([@travel])
      end
      it 'return an empty array if the final date is after the final date of the travel' do
        expect(Travel.filter_by_final_date({'initial_date': '','final_date': Date.today,'country': '','place': '', 'budget': ''}, Travel.all)).to match_array([])
      end
    end

    describe '::filter_by_tags' do
      before (:each) do
        @travel = FactoryGirl.create(:travel, final_date: Date.new(2010,10,10))
      end
      it 'return the travel if the tag is tagged in the travel' do
        @travel.add_tags(['cruise'])
        @travel.save
        expect(Travel.filter_by_tags({'initial_date': '','final_date': '','country': '','place': 'Madrid', 'budget': '', 'tags': ['cruise']}, Travel.all)).to match_array([@travel])
      end
      it 'return the travel if the tags are tagged in the travel' do
        @travel.add_tags(['cruise','adventure'])
        @travel.save
        expect(Travel.filter_by_tags({'initial_date': '','final_date': '','country': '','place': 'Madrid', 'budget': '', 'tags': ['cruise', 'adventure']}, Travel.all)).to match_array([@travel])
      end
      it 'return an empty array if the tag is not tagged in the travel' do
        @travel.add_tags(['adventure'])
        @travel.save
        expect(Travel.filter_by_tags({'initial_date': '','final_date': '','country': '','place': 'Madrid', 'budget': '', 'tags': ['cruise']}, Travel.all)).to match_array([])
      end
      it 'return an empty array if one of the tags is not tagged in the travel' do
        @travel.add_tags(['cruise'])
        @travel.save
        expect(Travel.filter_by_tags({'initial_date': '','final_date': '','country': '','place': 'Madrid', 'budget': '', 'tags': ['cruise', 'adventure']}, Travel.all)).to match_array([])
      end
    end

    describe '::filter' do
      before (:each) do
        @travel = FactoryGirl.create(:travel, final_date: Date.new(2010,10,10), budget: 'medium', initial_date: Date.new(2010,10,10))
        @travel.add_places('Madrid')
        @travel.add_countries('Spain')
        @travel.save
      end
      it'returns all the travels if there is no parameters' do
        expect(Travel.filter({'initial_date': '', 'final_date': '','country': '','place': '', 'budget': 'medium'}, Travel.all)).to match_array([@travel])
      end
      it 'returns the travel if it satisfies all the parameters' do
        expect(Travel.filter({'initial_date': Date.today,'final_date': Date.new(2000,10,10),'country': 'Spain','place': 'Madrid', 'budget': 'medium'}, Travel.all)).to match_array([@travel])
      end
      it 'returns an empty array if it doens´t satisfy all the parameters' do
        expect(Travel.filter({'budget' => 'medium','initial_date' => '','country' => '','place' => 'Barcelona','final_date' => Date.new(2000,10,10)}, Travel.all)).to match_array([])
      end
    end
  end

end
