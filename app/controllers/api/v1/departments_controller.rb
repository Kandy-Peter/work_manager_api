class Api::V1::DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :update, :destroy]
  before_action :set_organization, only: [:index, :create]
  authorize_resource

  def index
    # the is a search query
    if params[:q].present?
      @departments = Department.search(params[:q]).where(organization_id: @organization)
    else
      @departments = Department.where(organization_id: current_user.organization_id)
    end
    render json: @departments, include: :positions
  end

  def show
    render json: @department, include: :positions
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      render json: @department, status: :created
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

  def set_organization
    @organization = Organization.friendly.find(params[:organization_id])
  end

  def department_params
    params.require(:department).permit(:name, :description, :organization_id)
  end
end
