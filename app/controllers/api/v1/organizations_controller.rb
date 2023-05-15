class Api::V1::OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :update]
  authorize_resource

  def index
    @organizations = Organization.all
    render json: @organizations
  end

  def show
    # Retrieve the organization
    render json: @organization
  end

  def update
    # Update organization information
    if @organization.update(organization_params)
      render json: @organization
    else
      render json: { errors: @organization.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    # Create a new organization
    @organization = Organization.new(organization_params)
    # current_user should be super admin
    if current_user.super_admin?
      if @organization.save
        render json: @organization, status: :created
      else
        render json: { errors: @organization.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: "You are not authorized to create an organization" }, status: :unauthorized
    end
  end

  def destroy
    # Delete an organization
    @organization = Organization.find(params[:id])
    if current_user.super_admin?
      @organization.destroy
      head :no_content
    else
      render json: { errors: "You are not authorized to delete an organization" }, status: :unauthorized
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :address, :description)
  end
end
