class Api::V1::Reports::JourneysController < ApplicationController
  before_action :set_user, only: %i[show]
  before_action :convert_dates, only: %i[show]

  def show
    args = { user: @user, start_date: @start_date, end_date: @end_date }
    journeys = GenerateJourneysReport.for(args)
    
    if journeys.empty?
      render json: { message: 'No journeys found for the user' }, status: :not_found
    else
      is_authorized = current_user.organization_id == @user.organization_id

      if (current_user.admin? || current_user.manager? || current_user == @user) && is_authorized || current_user.super_admin?
        render json: serialize(journeys)
        puts current_user[:role]  # Assuming you want to print the current user's role in the console
      else
        render json: { error: 'Unauthorized Access' }, status: :unauthorized
      end
    end
  end

  private

  def serialize(journeys)
    journeys.map do |journey|
      Reports::JourneySerializer.new(journey).as_json
    end.to_json
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def convert_dates
    @start_date = DateTime.parse params[:start_date]
    @end_date = DateTime.parse params[:end_date]
  end
end
