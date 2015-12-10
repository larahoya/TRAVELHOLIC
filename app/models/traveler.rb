class Traveler < ActiveRecord::Base

  validates :first_name, :last_name, :country, :date_of_birth, :gender, presence: true
  validates :gender, inclusion: {in: ['MALE', 'FEMALE']}

  belongs_to :user
  has_many :travels, through: :participations
  has_many :participations

end
