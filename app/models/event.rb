class Event < ApplicationRecord
  scope :active, -> { where cancelled: false }

  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  has_many :registrations
  has_many :attendees, through: :registrations, source: :user

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :date_time, presence: true
  validates :organizer_id, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
end
