class ChangePasswordForm
  include ActiveModel::Model

  attr_accessor :object, :new_password, :new_password_confirmation

  validates :new_password, presence: true, confirmation: true
  validates :new_password_confirmation, presence: true

  def save
    if valid?
      object.password = new_password
      object.save!
    end
  end
end
