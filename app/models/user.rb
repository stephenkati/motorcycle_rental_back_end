class User < ApplicationRecord
  has_secure_password

  has_many :reservations, dependent: :destroy

  validates :password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'is not a valid email format' }
end
