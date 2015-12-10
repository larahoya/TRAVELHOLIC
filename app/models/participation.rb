class Participation < ActiveRecord::Base

  belongs_to :travel
  belongs_to :traveler
  
end
