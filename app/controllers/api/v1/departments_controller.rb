class Api::V1::DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :update, :destroy]
  authorize_resource

  def index
    @departments = Department.where(organization_id: current_user.organization_id)

    render json: @departments
  end

  def show
    render json: @department
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      render json: @department, status: :created, location: api_v1_department_url(@department)
    else
      render json: @department.errors, status: :unprocessable_entity
    end
  end

  def update
    if @department.update(department_params)
      render json: @department
    else
      render json: @department.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @department.destroy
  end

  def search
    @departments = Department.search(params[:q])

    render json: @departments
  end

  private
    def set_department
      @department = Department.friendly.find(params[:id])
    end

    def department_params
      params.require(:department).permit(:name, :description, :organization_id)
    end
end
