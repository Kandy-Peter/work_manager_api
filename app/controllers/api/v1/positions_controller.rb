class Api::V1::PositionsController < ApplicationController
  before_action :set_position, only: [:show, :update, :destroy]
  authorize_resource

  def index
    @positions = Position.all()
    render json: @positions
  end

  # GET /api/positions/:id
  # def show
  #   render json: @position
  # end

  # POST /api/positions
  def create
    @position = Position.new(position_params)

    if @position.save
      render json: @position, status: :created
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/positions/:id
  def update
    if @position.update(position_params)
      render json: @position
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/positions/:id
  def destroy
    @position.destroy
    head :no_content
  end

  private

  def set_position
    @position = Position.find(params[:id])
  end

  def position_params
    params.require(:position).permit(:name, :department_id)
  end
end
