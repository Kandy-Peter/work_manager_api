class Api::V1::Requests::DemoRequestsController < ApplicationController
  skip_before_action :authenticate_user_with_token, except: [:create]
  load_and_authorize_resource

  # GET /demo_requests
  def index
    @demo_requests = if params[:status].present?
                        validate_status_query(params[:status])
                        DemoRequest.where(status: params[:status])
                      else
                        DemoRequest.all
                      end

    if @demo_requests
      success_response('Demo requests retrieved successfully', @demo_requests, :ok)
    else
      error_response('Demo requests not found', nil, :not_found)
    end
  end

  # GET /demo_requests/1
  def show
    if @demo_request
      success_response('Demo request retrieved successfully', @demo_request, :ok)
    else
      error_response('Demo request not found', nil, :not_found)
    end
  end

  # POST /demo_requests
  def create
    @demo_request = DemoRequest.new(demo_request_params)
  
    if @demo_request.save
      success_response('Demo request created successfully', @demo_request, :created)
    else
      # check if the name of the company already exists
      if DemoRequest.where(company_name: @demo_request.company_name).exists?
        error_response('Demo request not created, company name already exists', :unprocessable_entity)
      else
        error_response('Demo request not created', @demo_request.errors, :unprocessable_entity)
      end
    end
  end

  # PATCH/PUT /demo_requests/1
  def update
    if @demo_request.update(demo_request_params)
      success_response('Demo request updated successfully', @demo_request, :ok)
    else
      error_response('Demo request not updated', @demo_request.errors, :unprocessable_entity)
    end
  end

  def update_demo_request_status
    if @demo_request.update(status: params[:status])
      success_response('Demo request status updated successfully', @demo_request, :ok)
    else
      error_response('Demo request status not updated', @demo_request.errors, :unprocessable_entity)
    end
  end

  # DELETE /demo_requests/1
  def destroy
    if @demo_request.destroy
      success_response('Demo request deleted successfully', nil, :ok)
    else
      error_response('Demo request not deleted', @demo_request.errors, :unprocessable_entity)
    end
  end

  def destroy_multiple
    if params[:ids].present?
      DemoRequest.where(id: params[:ids]).destroy_all
      success_response('Demo requests deleted successfully', nil, :ok)
    else
      error_response('Demo requests not deleted', nil, :unprocessable_entity)
    end
  end

  private

  def validate_status_query(status)
    unless DemoRequest.statuses.keys.include?(status)
      error_response('Invalid status query', nil, :unprocessable_entity)
    end
  end

  # Only allow a list of trusted parameters through.
  def demo_request_params
    params.require(:demo_request).permit(:full_name, :email, :phone_number, :company_name, :company_website, :how_did_you_hear_about_us)
  end
end
