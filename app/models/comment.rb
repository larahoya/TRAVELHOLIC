class Comment < ActiveRecord::Base

  validates :description, presence: true 

  belongs_to :user
  belongs_to :travel
end
