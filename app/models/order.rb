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
end