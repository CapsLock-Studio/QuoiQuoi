class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter]

  has_many :orders, dependent: :destroy
  has_many :user_gifts, dependent: :destroy
  has_many :payments
  has_many :messages

  def self.find_or_create_by_oauth2(auth)
    user = User.find_by_email(auth.info.email)
    unless user
      user = User.new
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.save!
    end

    user
  end

  def self.find_or_create_by_twitter(auth)
    user = User.find_by_email(auth.info.email)
    unless user
      user = User.new
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.save!
    end

    user
  end

  def self.create_guest_user
    user = User.new(name: 'guest', email: "guest_#{SecureRandom.hex(5)}@quoiquoi.tw")
    user.save!(validate: false)
    user
  end
end
