class Travel < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :tags, :countries, :places, :requirements 
  validates :title, :initial_date, :final_date,  presence: true
  validates :maximum_people, :people, numericality: true
  validates :budget, inclusion: {in: ['high', 'medium', 'low']}

  def add_tags(hash)
    hash.each do |key, value|
      self.tag_list.add(value)
    end
  end

  def add_requirements(hash)
    hash.each do |key, value|
      self.requirement_list.add(value)
    end
  end

  def add_places(string)
    string.split(',').each do |value|
      self.place_list.add(value)
    end
  end

  def add_countries(string)
    string.split(',').each do |value|
      self.country_list.add(value)
    end
  end


end
