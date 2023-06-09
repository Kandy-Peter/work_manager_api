class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Devise configurations
  #**********************
  devise :database_authenticatable, :registerable, :validatable, :recoverable, :rememberable, :trackable,
        :jwt_authenticatable, jwt_revocation_strategy: self

  before_validation :default_role, on: :create
  after_initialize :update_user_salary, :age, if: :new_record?


  # **** ENUMS *****
  enum role: { employee: 0, manager: 1, admin: 2, super_admin: 3 }
  enum status: { active: 0, inactive: 1, suspended: 2 }

  mount_uploader :avatar, ImageUploader

  #***SCOPES******

  scope :search, ->(query) { query.present? ? where("username ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%") : none }
  
  #******* RELATIONSHIPS *********
  has_and_belongs_to_many :departments
  belongs_to :organization, optional: true
  has_many :activities
  has_many :work_days
  has_many :salaries
  has_many :assistances

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

  def update_user_salary
    salary = Salary.last_salary(id: self.id, organization_id: self.organization_id)
    self.salary = salary || 0
  end

  def generate_jwt_token
    payload = {
      user_id: id,
      jti: jti,
      exp: 24.hours.from_now.to_i
    }

    JWT.encode(payload, secret_key)
  end

  def generate_reset_password_token
    self.reset_password_token = generate_jwt_token.gsub(/\./, '-')
    self.reset_password_token_expires_at = 1.day.from_now
    save(validate: false)
  end

  def reset_password_token_valid?
    reset_password_token_expires_at > Time.now
  end

  def reset_password(password, password_confirmation)
    puts "password: #{password}"
    puts "password_confirmation: #{password_confirmation}"
    if(password != password_confirmation)
      return false
    end
    update(
      password: password,
      password_confirmation: password_confirmation,
      reset_password_token: nil,
      reset_password_token_expires_at: nil
    )
  end

  private

  def secret_key
    Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
  end

  def default_role
    self.role ||= :employee
  end

  # get age from birthdate
  def age
    now = Time.now.utc.to_date
    if self.date_of_birth.nil?
      return nil
    end
    now.year - self.date_of_birth.year - (self.date_of_birth.to_date.change(year: now.year) > now ? 1 : 0)
  end

  def length_of_service
    now = Time.now.utc.to_date
    if self.employment_date.nil?
      return nil
    end
    year = (now.year - self.employment_date.year).to_s
    month = (now.month - self.employment_date.month).to_s
  end
end
