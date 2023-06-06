class UserSerializer < ActiveModel::Serializer
  attributes  :id, :email, :first_name, :last_name, :username, :salary,
              :bio, :role, :country, :city, :phone_number, :personal_email, :address, :is_company_owner,
              :zip, :departments, :organization_id,
              :created_at, :updated_at, :avatar,:current_sign_in_at, :last_sign_in_at,
              :current_sign_in_ip, :last_sign_in_ip, :sign_in_count, :age, :nationality,
              :marital_status, :gender, :national_id, :date_of_birth, :length_of_service,
              :status, :level_of_education, :field_of_study, :university, :employee_numero

  DEFAULT_AVATAR = 'https://res-2.cloudinary.com/dhatgaadw/image/upload/v1661765174/e0eiopj9eqt5dwnt5n2v.jpg'

  def avatar
    if object.avatar.url.present?
      object.avatar.url
    else
      DEFAULT_AVATAR
    end
  end

  belongs_to :organization, serializer: OrganizationSerializer, if: -> { object.organization_id.present? }

end
