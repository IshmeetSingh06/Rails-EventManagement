class User < ApplicationRecord
  enum role: { admin: 0, guest: 1 }

  has_many :registrations
  has_many :organized_events, class_name: 'Event', foreign_key: 'organizer_id'
  has_many :attended_events, through: :registrations, source: :event, -> { Event.active }

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :first_name, presence: true
  validates :last_name, presence: false, allow_nil: true
  validates :password, presence: true
  validates :role, presence: true
end
