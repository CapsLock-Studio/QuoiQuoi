class UserGift < ApplicationRecord
  belongs_to :user
  belongs_to :gift
  belongs_to :order
  belongs_to :registration

  has_one :payment
  has_many :user_gift_serials, dependent: :destroy

  belongs_to :used_user, class_name: 'User', foreign_key: 'used_user_id'
end