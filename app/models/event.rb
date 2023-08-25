class Event < ApplicationRecord
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  has_many :registrations
  has_many :attendees, through: :registrations, source: :user

  validates_presence_of :name, :description, :location, :organizer_id
  validates_presence_of :time, message: "Invalid"
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validate :already_cancelled, on: :update
  validate :time_to_be_future

  scope :active, -> { where cancelled: false }
  scope :upcoming, -> { where 'time > ?', Time.current }

  private def already_cancelled
    errors.add(:base, 'Event is already cancelled') if cancelled_in_database
  end

  private def time_to_be_future
    if time&.past?
      errors.add(:base, "Time should not be in past")
    end
  end
end

