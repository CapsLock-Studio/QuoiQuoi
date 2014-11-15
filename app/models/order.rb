class Order < ActiveRecord::Base
  validates :user_id, presence: true

  belongs_to :user
  has_many :order_products
  has_one :payment, dependent: :destroy
  accepts_nested_attributes_for :order_products

  belongs_to :shipping_fee

  has_many :order_custom_items
  accepts_nested_attributes_for :order_custom_items

  has_many :user_gifts

  def paid?
    self.payment
  end

  def in_cart_empty?
    self.order_products.size <= 0 && self.order_custom_items.size <= 0
  end

  def self.in_cart(user_id)
    self.where(user_id: user_id, checkout: false).order(:created_at).last || Order.create({closed: false, user_id: user_id, checkout: false})
  end

  def quantity
    self.order_products.count + self.order_custom_items.count
  end
end