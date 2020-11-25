class ChangePasswordForm
  include ActiveModel::Model

  attr_accessor :object, :password, :password_confirmation

  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

  def save
    if valid?
      object.password = password
      object.save!
    end
  end
end
