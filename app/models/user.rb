class User < ApplicationRecord
  has_secure_password
  enum role: { admin: 0, guest: 1 }

  has_many :registrations
  has_many :organized_events, class_name: 'Event', foreign_key: 'organizer_id'
  has_many :attended_events, -> { Event.active }, through: :registrations, source: :event

  validates :username, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :first_name, presence: true, length: { in: 2..10 }
  validates :last_name, presence: false, allow_nil: true, length: { in: 2..10 }
  validates :password, presence: true, length: { in: 5..20 }
  # validates :role, presence: true, inclusion: { in: role.keys }
end
