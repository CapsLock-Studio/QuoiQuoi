class UserGift < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift
  belongs_to :order
  belongs_to :registration

  has_one :payment

  belongs_to :used_user, class_name: 'User', foreign_key: 'used_user_id'
end