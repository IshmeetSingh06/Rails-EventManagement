class Event < ApplicationRecord
  before_update :destroy_registrations, if: :cancelled_changed?

  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  has_many :registrations
  has_many :attendees, through: :registrations, source: :user

  validates_presence_of :name, :description, :location, :organizer_id, :time
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where cancelled: false }
  scope :upcoming, -> { where 'time > ?', DateTime.now }

  private def destroy_registrations
    registrations.destroy_all
  end
end
