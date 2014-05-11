class Order < ActiveRecord::Base
  validates :user_id, presence: true

  belongs_to :user
  has_many :order_products
  has_one :payment
  accepts_nested_attributes_for :order_products

  has_many :order_custom_items
  accepts_nested_attributes_for :order_custom_items

  def paid?
    self.payment
  end
end