# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  password_digest :string(255)
#  token           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  admin           :boolean
#

class User < ActiveRecord::Base
  attr_reader :password
  validates :username, :password_digest, :token, :presence => true
  validates :password, :length => { minimum: 6, allow_nil: true }
  validates :username, :token, :uniqueness => true

  has_many :goals, :inverse_of => :user
  before_validation :set_token, :admin_default

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.generate_token
    SecureRandom.urlsafe_base64(16)
  end

  def reset_token!
    self.token = User.generate_token
    self.save!
    self.token
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.is_password?(password) ? user : nil
  end

  private

    def set_token
      self.token ||= User.generate_token
    end

    def admin_default
      self.admin ||= false
      true
    end
end
