class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :messages
  validates :username, :image_url, :email, presence: true
  validates :email, uniquness: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
