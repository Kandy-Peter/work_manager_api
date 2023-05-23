class Api::V1::AssistancesController < ApplicationController
  load_and_authorize_resource

  before_action :set_employee, only: %i[index create]

  def index
    @assistances = @employee.assistances.by_day(params[:start_date], params[:end_date])
    
    render_paginated_response(@assistances)
  end

  def create
    @assistance = @employee.assistances.new(assistance_params)
    if @assistance.save
      render json: @assistance, status: :created
    else
      render json: { errors: @assistance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def assistance_params
    params.permit(:kind, :happened_at, :user_id)
  end

  def set_employee
    @employee = User.find(params[:user_id])
  end
end
