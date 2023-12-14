class User < ApplicationRecord
  include StringNormalizer

  mount_uploader :user_image, ImageUploader

  attr_accessor :remember_token, :reset_token, :activation_token, :confirmation_token

  has_many :todos, dependent: :destroy
  has_many :shortcuts, dependent: :destroy
  has_many :labels, dependent: :destroy

  before_save :email_downcase!
  before_create :set_activation_digest!
  before_validation :normalize_text

  validates :username,
            presence: true,
            length: { maximum: 20 }
  validates :email,
            presence: true,
            length: { maximum: 255 },
            email: true,
            uniqueness: { case_sensitive: false }
  validates :unconfirmed_email,
            presence: true,
            email: true,
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false },
            allow_nil: true
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :password, length: { minimum: 6, maximum: 99 }, confirmation: true, allow_blank: true
  validate :uniqueness_unconfirmed_eamil_with_email

  has_secure_password

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def activate!
    update(activated: true, activated_at: Time.zone.now)
  end

  def remember!
    self.remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    attributes = %i(remember reset activation confirmation)
    return unless attributes.include?(attribute)

    digest = send("#{attribute}_digest")
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget!
    update(remember_digest: nil)
  end

  def create_reset_digest!
    self.reset_token = User.new_token
    update(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def expired?(attribute)
    published_time = send("#{attribute}_sent_at")
    published_time < 2.hours.ago
  end

  def update_new_email
    update(email: unconfirmed_email, unconfirmed_email: nil)
  end

  def cancel_oauth!(provider)
    provider = "google" if provider == "google_oauth2"
    provider_uid = "#{provider}_uid".to_sym
    update_attribute(provider_uid, nil)
  end

  def set_activation_digest!
    self.activation_token =  User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  private

  def normalize_text
    self.username = normalize_as_text(username)
    self.email = normalize_as_text(email)
    self.unconfirmed_email = normalize_as_text(unconfirmed_email)
  end

  def email_downcase!
    email.downcase!
    unconfirmed_email.downcase! if unconfirmed_email
  end

  def uniqueness_unconfirmed_eamil_with_email
    if User.exists?(email: unconfirmed_email)
      errors.add(:unconfirmed_email, I18n.t("errors.messages.taken"))
    end
  end
end
