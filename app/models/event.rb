class Event < ApplicationRecord
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  has_many :registrations
  has_many :attendees, through: :registrations, source: :user

  validates_presence_of :name, :description, :location, :organizer_id
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validate :already_cancelled, on: :update
  validate :time_format

  scope :active, -> { where cancelled: false }
  scope :upcoming, -> { where 'time > ?', Time.current }

  private def already_cancelled
    self.errors.add(:base, 'Event is already cancelled') if self.cancelled_in_database
  end

  private def time_format
    unless Time.parse(self.time.to_s).strftime("%R") > Time.current
      self.errors.add(:time, "is not in a valid format(dd/mm/yyyy hh:mm:ss)")
    end
  end
end

