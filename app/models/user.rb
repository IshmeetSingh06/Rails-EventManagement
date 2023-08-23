class User < ApplicationRecord
  has_secure_password

  before_create :generate_token

  has_many :registrations
  has_many :organized_events, class_name: 'Event', foreign_key: 'organizer_id'
  has_many :attended_events, through: :registrations, source: :event

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates_presence_of :first_name, :password, :role

  enum role: { admin: 0, guest: 1 }

  # def errors
  #   super.tap { |errors| errors.delete(:password, :blank) if self.admin? }
  # end

  def serializable_hash(options = nil)
    super(options).except('authentication_token')
  end

  private
  def generate_token
    self.authentication_token = SecureRandom.hex(6)
  end
end
