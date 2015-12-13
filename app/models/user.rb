class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :avatar, :gender, :country, :date_of_birth, presence: true 

  has_many :travels
  has_many :comments
  has_many :travelers

end
