class User < ApplicationRecord
  enum role: { admin: 0, guest: 1 }
  has_many :event
  has_many :event, through: :registration
  has_many :registrations

  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: false, allow_nil: true
  validates :password, presence: true
  validates :role, presence: true
end
