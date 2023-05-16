class Api::V1::SalariesController < ApplicationController
  load_and_authorize_resource

  def index
    id = params[:id]
    month = params[:month]
    year = params[:year]
    organization_id = current_user.organization_id
    salaries = []

    if id && month && year
      salaries = Salary.employee_salary(id: id, month: month, year: year, organization_id: organization_id)
    elsif id && month
      salaries = Salary.employee_salary(id: id, month: month, organization_id: organization_id)
    elsif id && year
      salaries = Salary.employee_salary(id: id, year: year, organization_id: organization_id)
    elsif id
      salaries = Salary.employee_salary(id: id, organization_id: organization_id)
    end
    render json: salaries, status: :ok
  end

  def user_salaries
    organization_id = current_user.organization_id
    day = params[:day]
    month = params[:month]
    year = params[:year]
    search = params[:search]
  
    last_salaries = Salary.users_last_salaries(organization_id, day: day, month: month, year: year, search: search)
  
    render json: last_salaries, status: :ok
  end
end
