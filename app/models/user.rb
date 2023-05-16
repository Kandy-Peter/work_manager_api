class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Devise configurations
  #**********************
  devise :database_authenticatable, :registerable, :validatable, :recoverable, :rememberable, :trackable,
        :jwt_authenticatable, jwt_revocation_strategy: self

  before_validation :default_role, on: :create

  # **** ENUMS *****
  enum role: { employee: 0, manager: 1, admin: 2, super_admin: 3 }

  mount_uploader :avatar, ImageUploader

  #***SCOPES******

  scope :search, ->(query) { query.present? ? where("username ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%") : none }
  
  #******* RELATIONSHIPS *********

  has_and_belongs_to_many :positions
  has_and_belongs_to_many :departments
  belongs_to :organisation, optional: true

  #*********VALIDATIONS***********

  validates :first_name, :last_name, :username, :email, :role, presence: true
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 50 }
  validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}\z/, 
                              message: 
                              "must be at least 8 characters and include one uppercase letter, one lowercase letter, and one digit" 
                              },
                              if: :password_required?
  #***** AUTH METHODES *******
  def after_jwt_authentication
    self.role = :super_admin
  end

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

  def default_role
    self.role ||= :employee
  end
end
