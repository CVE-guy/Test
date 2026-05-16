class User < ApplicationRecord
  has_secure_password

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 20 }
  validates :password, length: { minimum: 8 }, allow_nil: true
end
