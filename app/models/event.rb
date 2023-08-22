class Event < ApplicationRecord
  scope :active, -> { where cancelled: false }

  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  has_many :registrations
  has_many :attendees, through: :registrations, source: :user

  validates :name, presence: true, length: { in: 6..20 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :location, presence: true, length: { in: 6..20 }
  validates :date_time, presence: true, date_time: true
  validates :organizer_id, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
end
