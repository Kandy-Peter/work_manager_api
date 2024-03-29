module Api
  module V1
    class UsersController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      before_action :set_user, only: [ :show, :update, :destroy, :show_by_username, :organization_team, :update_role]
      before_action :set_user_by_username, only: [:show_by_username]
      before_action :set_organization, only: [:profile, :organization_team, :update_role, :update]
      load_and_authorize_resource

      def profile
        if current_user && current_user.organization_id == @organization.id
          puts @organization.inspect
          render json: current_user, serializer: UserSerializer, status: :ok
        else
          render json: { status: { code: 404, message: "User not found for this organization" }}, status: :not_found
        end
      end

      def organization_team
        @users = User.where(organization_id: @organization.id)
        render json: @users, each_serializer: UserSerializer, status: :ok
      end

      def show
        render json: @user, serializer: UserSerializer, status: :ok
      end

      def show_by_username
        if @user
          render json: @user, serializer: UserSerializer, status: :ok
        else
          render json: {
            message: "User not found"
          }, status: :not_found
        end
      end

      def search
        @users = User.search(params[:username])
        render json: @users, each_serializer: UserSerializer, status: :ok
      end

      def update
        user_attributes = user_params.except(:departments_attributes)

        if @user.update(user_attributes)
          if params[:user] && params[:user][:departments_attributes]
            update_departments(params[:user][:departments_attributes])
          end

          render json: @user, serializer: UserSerializer, status: :ok
        else
          render_error(@user, message: 'User could not be updated', status: :unprocessable_entity)
        end
      end

      def update_role
        @user = User.find(params[:id])
        if @user.update(role: params[:role])
          render json: @user, serializer: UserSerializer, status: :ok
        else
          render_error(@user, :unprocessable_entity)
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
        puts('user', @user.inspect)
      end

      def set_user_by_username
        @user = User.find_by(username: params[:username])
        puts('user names', @user.inspect)
      end

      def set_organization
        puts 'organization', params[:organization_id]
        @organization = Organization.friendly.find(params[:organization_id])
      end

      def update_departments(departments_attributes)
        departments_attributes.each do |department_attributes|
          department = Department.find(department_attributes[:id])
          if department && department.user_ids.include?(@user.id)
            department.update(position: department_attributes[:position])
          end
        end
      end

      def not_found
        render json: {status: { code: 404, error: 'Record Not Found' }}, status: :not_found
      end

      # Render error message
      def render_error(object, status)
        render json: {
          errors: object.errors.full_messages
        }, status: status
      end

      def user_params
        params.require(:user).permit(
          :id,
          :first_name,
          :last_name,
          :email,
          :avatar,
          :username,
          :bio,
          :password,
          :city,
          :country,
          :phone_number,
          :zip,
          :address,
          :personal_email,
          :level_of_education,
          :field_of_study,
          :university,
          :date_of_birth,
          :national_id,
          :nationality,
          :marital_status,
          :gender,
          :organization_id,
          :employment_date,
          :length_of_service,
          :departments_attributes => [:id, :position],
        )
      end
    end
  end
end
