class Traveler < ActiveRecord::Base

  validates :first_name, :last_name, :country, :date_of_birth, :gender, presence: true
  validates :gender, inclusion: {in: ['MALE', 'FEMALE']}

  belongs_to :user
  has_many :travels, through: :participations
  has_many :participations

  def set_params(params)
    self.first_name = params[:first_name]
    self.last_name = params[:last_name]
    self.country = params[:country]
    self.date_of_birth = params[:date_of_birth]
    self.gender = params[:gender]
    self.avatar = params[:avatar]
  end

  def get_age
    age = Date.today.year - self.date_of_birth.year
  end

  def set_first_traveler(user)
    self.first_name = user.first_name
    self.last_name = user.last_name
    self.country = user.country
    self.date_of_birth = user.date_of_birth
    self.gender = user.gender
    self.avatar = user.avatar
  end

end
