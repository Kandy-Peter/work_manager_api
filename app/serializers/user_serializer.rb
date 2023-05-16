class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name,
              :username, :salary,
              :bio, :created_at, :updated_at, :avatar,:current_sign_in_at, :last_sign_in_at,
              :current_sign_in_ip, :last_sign_in_ip, :sign_in_count, :role, :country, :city, :phone_number,
              :zip, :positions, :departments

  DEFAULT_AVATAR = 'https://res-2.cloudinary.com/dhatgaadw/image/upload/v1661765174/e0eiopj9eqt5dwnt5n2v.jpg'

  def avatar
    if object.avatar.url.present?
      object.avatar.url
    else
      DEFAULT_AVATAR
    end
  end

  def attributes(*args)
    data = super
    data[:actual_salary] = instance_options[:actual_salary] if instance_options.key?(:actual_salary)
    data
  end
end
