class User < ApplicationRecord
  include StringNormalizer

  mount_uploader :user_image, ImageUploader

  attr_accessor :remember_token, :reset_token

  has_many :todos, dependent: :destroy
  has_many :shortcuts, dependent: :destroy
  has_many :routines, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  before_save :email_downcase
  before_validation do
    self.username = normalize_as_text(username)
    self.email = normalize_as_email(email)
  end

  validates :username,
            presence: true,
            length: { maximum: 20 }
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password

  private def email_downcase
    email.downcase!
  end

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def find_or_create_from_oauth(auth)
      provider = auth[:provider]
      uid = auth[:uid]
      name = auth[:info][:name]
      email = auth[:info][:email]
      image = auth[:extra][:raw_info][:profile_image_url_https]

      user = User.find_by(provider: provider, uid: uid)

      unless user
        puts 'ユーザーを作成します'
        user = User.create!(
          username: name,
          email: email,
          twitter_profile_image: image,
          password: new_token,
          provider: provider,
          uid: uid
        )
      end
      user
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
end
