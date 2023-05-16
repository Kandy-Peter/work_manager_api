class Salary < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :amount, :date, presence: true

  def self.employee_salary(id: nil, month: nil, year: nil, organization_id: nil)
    salaries = Salary.where(user_id: id, organization_id: organization_id).order(date: :asc)
    array = []
  
    if month.present? && year.present?
      salaries = salaries.where("extract(month from date) = ? AND extract(year from date) = ?", month, year)
    elsif month.present?
      salaries = salaries.where("extract(month from date) = ?", month)
    elsif year.present?
      salaries = salaries.where("extract(year from date) = ?", year)
    end
  
    salaries.each do |salary|
      hash = {
        id: salary.id,
        user_id: salary.user_id,
        amount: salary.amount,
        date: salary.date,
        organization_id: salary.organization_id
      }
      array << hash
    end
  
    array
  end

  # List all users salaries

  def self.users_last_salaries(organization_id, day: nil, month: nil, year: nil, search: nil)
    salaries = Salary.where(organization_id: organization_id)
    salaries = salaries.where("extract(day from date) = ?", day) if day.present?
    salaries = salaries.where("extract(month from date) = ?", month) if month.present?
    salaries = salaries.where("extract(year from date) = ?", year) if year.present?
    salaries = salaries.joins(:user).where("users.username ILIKE ?", "%#{search}%") if search.present?

    last_salaries = []
    users = User.where(id: salaries.select(:user_id).distinct)
    users.each do |user|
      last_salary = salaries.where(user_id: user.id).order(date: :desc).first
      next unless last_salary

      user_hash = {
        username: user.username,
        last_salary: {
          amount: last_salary.amount,
          date: last_salary.date
        }
      }
      last_salaries << user_hash
    end

    last_salaries
  end

  def self.last_salary(id: nil, organization_id: nil)
    salary = Salary.where(user_id: id, organization_id: organization_id).order(date: :desc).first
    return 0.00 unless salary

    salary.amount
  end

end
