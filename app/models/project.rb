class Project < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { in: 1..50 }
end