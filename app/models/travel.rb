class Travel < ActiveRecord::Base

  acts_as_taggable
  acts_as_taggable_on :tags, :countries, :places, :requirements

  validates :title, :initial_date, :final_date,  presence: true
  validates :maximum_people, :people, numericality: true
  validates :budget, inclusion: {in: ['high', 'medium', 'low']}

  belongs_to :user
  has_many :comments
  has_many :travelers, through: :participations
  has_many :participations


  def set_maximum_people(string)
    if string != ''
      self.maximum_people = string.to_i
    else
      self.maximum_people = 0
    end
  end

# Create and update

  def set_params(params)
    self.title = (params['title']) if params['title']
    self.initial_date = params['initial_date'] if params['initial_date']
    self.final_date = params['final_date'] if params['final_date']
    self.description = params['description'] if params['description']
    self.budget = (params['budget'] || 'medium')
    self.set_maximum_people(params['maximum_people']) if params['maximum_people']
    self.people = 1

    self.clean_all_tags

    self.add_tags(params['tags'])
    self.add_requirements(params['requirements'])
    self.add_countries(params['countries'])
    self.add_places(params['places'])
  end

# Clean, add and get tags

  def clean_all_tags
    self.tags.destroy_all
    self.countries.destroy_all
    self.requirements.destroy_all
    self.places.destroy_all
  end

  def add_tags(array)
    array.each {|value| self.tag_list.add(value)} if array
  end

  def add_requirements(array)
    array.each {|value| self.requirement_list.add(value)} if array
  end

  def add_places(string)
    string.split(',').each {|value| self.place_list.add(value)} if string != '' && string != nil
  end

  def add_countries(string)
    string.split(',').each {|value| self.country_list.add(value)} if string != '' && string != nil
  end

  def get_tags
    result = self.tag_list.reduce('') do |result, tag|
      result += tag + ','
    end
    result[0..-2]
  end

  def get_requirements
    result = self.requirement_list.reduce('') do |result, tag|
      result += tag + ','
    end
    result[0..-2]
  end

  def get_places
    result = self.place_list.reduce('') do |result, tag|
      result += tag + ','
    end
    result[0..-2]
  end

  def get_countries
    result = self.country_list.reduce('') do |result, tag|
      result += tag + ','
    end
    result[0..-2]
  end

# Check requirements to join a traveler

  def check_age(traveler)
    validation = true
    validation = false if self.requirement_list.include?('only young people') && traveler.get_age > 25 || self.requirement_list.include?('not young people') && traveler.get_age < 25
    return validation
  end

  def check_children(traveler)
    validation = true
    return false if self.requirement_list.include?('not children') && traveler.get_age < 18
    return validation
  end

  def check_gender(traveler)
    validation = true
    return false if self.requirement_list.include?('only women') && traveler.gender == 'MALE' || self.requirement_list.include?('only men') && traveler.gender == 'FEMALE'
    return validation
  end

  def check_country(traveler)
    validation = true
    travel_user = User.find_by(id: self.user_id)
    validation = false if self.requirement_list.include?('only people from my country') && traveler.country != travel_user.country
    return validation
  end

  def check_requirements(traveler)
    return self.check_age(traveler) && self.check_children(traveler) && self.check_gender(traveler) && self.check_country(traveler)
  end

# Filter travels
  
  def self.filter_by_country(params, travels)
    params['country'] != '' ? travels.tagged_with(params['country']) : travels
  end

  def self.filter_by_place(params, travels)
    params['place'] != '' ? travels.tagged_with(params['place']) : travels
  end

  def self.filter_by_budget(params, travels)
    params['budget'] != '' ? travels.where("budget = ?", params['budget']) : travels
  end

  def self.filter_by_initial_date(params, travels)
    params['initial_date'] != '' ? travels.where("initial_date <= ?", params['initial_date']) : travels
  end

  def self.filter_by_final_date(params, travels)
    params['final_date'] != '' ? travels.where("final_date >= ?", params['final_date']) : travels
  end

  def self.filter_by_tags(params, travels)
    params['tags'] != '' ? travels.tagged_with(params['tags']) : travels

  end

  def self.filter(params, travels)
    result = travels.filter_by_country(params, Travel.all)
    result = Travel.filter_by_place(params, result)
    result = Travel.filter_by_budget(params, result)
    result = Travel.filter_by_initial_date(params, result)
    result = Travel.filter_by_final_date(params, result)
    result = Travel.filter_by_tags(params, result)
  end

end
