class UserForm
  include ActiveModel::Model

  validate :promote_validation

  attr_reader :user, :changed_email

  def initialize(user, params)
    @params = params
    @user = user
    @changed_email = params.has_key?(:email) && user.email != params[:email]
  end

  def save
    return false if invalid?

    user.save
  end

  private

  def promote_validation
    user.attributes = generate_params
    return if user.valid?

    user.errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def generate_params
    @params[:sns_profile_image] = nil if ActiveRecord::Type::Boolean.new.cast(@params[:remove_user_image]) && @params[:remove_user_image]
    unconfirmed_email_params = @changed_email ? generate_unconfirmed_email_params : {}
    delete_no_change_params(@params.merge(unconfirmed_email_params))
  end

  def delete_no_change_params(params)
    no_change_columns = [:email]
    params.delete_if { |key, _value| no_change_columns.include?(key) }
    params
  end

  def generate_unconfirmed_email_params
    confirmation_token = User.new_token
    {
      unconfirmed_email: @params[:email],
      confirmation_token: confirmation_token,
      confirmation_digest: User.digest(confirmation_token),
      confirmation_sent_at: Time.zone.now
    }
  end
end
