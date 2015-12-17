class User < ActiveRecord::Base
  has_many :projects, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  include DeviseTokenAuth::Concerns::User

end