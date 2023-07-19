class Api::V1::OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :update, :destroy]
  load_and_authorize_resource

  # include AccessDeniedHandler

  def index
    # Check user role and retrieve organizations accordingly
    if current_user.super_admin?
      @organizations = Organization.all
    elsif current_user.admin?
      @organizations = Organization.where(id: current_user.organization_id)
    end

    if @organizations
      render_paginated_response(@organizations)
    else
      render json: { errors: @organizations.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if(params[:id] != current_user.organization_id && !current_user.super_admin?)
      error_response('You are not authorized to view this organization', nil, :unauthorized)
    else
      success_response('Organization retrieved successfully', @organization.as_json(include: [:users]), :ok)
    end
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
    @organization = current_user.super_admin? ? Organization.find(params[:id]) : Organization.find_by(id: current_user.organization_id)
  end

  def organization_params
    params.require(:organization).permit(:name, :country, :organization_type)
  end
end
