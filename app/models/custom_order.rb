class CustomOrder < ActiveRecord::Base
  belongs_to :user
  belongs_to :locale
  belongs_to :product
  has_many :order_custom_items
  has_many :messages

  validates :order_type, :style, :email, presence: true
end
