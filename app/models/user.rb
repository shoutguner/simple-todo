class User < ActiveRecord::Base
  has_many :projects, dependent: :destroy

  # Include default devise modules.
  # devise :database_authenticatable, :registerable,
  #         :recoverable, :rememberable, :trackable, :validatable,
  #         :confirmable, :omniauthable, omniauth_providers: [:facebook]

  devise :database_authenticatable, :registerable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  include DeviseTokenAuth::Concerns::User

end