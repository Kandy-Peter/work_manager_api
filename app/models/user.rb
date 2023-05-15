class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable, :recoverable, :rememberable, :trackable,
        :jwt_authenticatable, jwt_revocation_strategy: self

  validates :first_name, :last_name, :username, :email, presence: true
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 50 }
  # validate password strength with a regex
  validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}\z/, message: "must be at least 8 characters and include one uppercase letter, one lowercase letter, and one digit" }, if: :password_required?

  mount_uploader :avatar, ImageUploader

  scope :search, ->(query) { query.present? ? where("username ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%") : none }

  def generate_jwt_token
    payload = {
      user_id: id,
      jti: jti,
      exp: 48.hours.from_now.to_i
    }

    JWT.encode(payload, secret_key)
  end

  private

  def secret_key
    Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
  end
end
