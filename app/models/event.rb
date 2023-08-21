class Event < ApplicationRecord
  belongs_to :user, foreign_key: 'organizer_id'
  has_many :registrations
  has_many :users, through: :registrations

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :date_time, presence: true
  validates :organizer, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
end
