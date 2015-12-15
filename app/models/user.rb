class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :avatar, :gender, :country, :date_of_birth, presence: true 

  has_many :travels
  has_many :comments
  has_many :travelers

  def get_user_travels
    user_travels = []
    self.travelers.each do |traveler|
      Participation.where('traveler_id = ?', traveler.id).each do |p|
        user_travels << p.travel_id
      end
    end
    return user_travels.uniq
  end

  def set_first_traveler
    traveler = self.travelers.new
    traveler.first_name = self.first_name
    traveler.last_name = self.last_name
    traveler.country = self.country
    traveler.date_of_birth = self.date_of_birth
    traveler.gender = self.gender
    traveler.avatar = self.avatar
    traveler.save
  end


end
