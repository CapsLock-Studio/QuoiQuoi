class Order < ActiveRecord::Base
  belongs_to :user
  has_one :ship
  has_many :order_products
  has_many :order_product_custom_items, through: :order_products
  accepts_nested_attributes_for :order_products

  has_many :order_custom_items
  accepts_nested_attributes_for :order_custom_items
end
