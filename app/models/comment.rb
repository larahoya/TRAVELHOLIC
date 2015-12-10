class Comment < ActiveRecord::Base

  validates :description, :name, presence: true 

  belongs_to :user
  belongs_to :travel
  
end
