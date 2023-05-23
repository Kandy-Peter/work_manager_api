class Api::V1::Reports::JourneysController < ApplicationController
  before_action :set_user, only: %i[show]
  before_action :convert_dates, only: %i[show]

  def show
    args = { user: @user, start_date: @start_date, end_date: @end_date }
    journeys = GenerateJourneysReport.for(args)
    render json: serialize(journeys), status: :ok
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
