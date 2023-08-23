class Event < ApplicationRecord
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  has_many :registrations
  has_many :attendees, through: :registrations

  validates_presence_of :name, :description, :location, :organizer_id, :time
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where cancelled: false }
end
