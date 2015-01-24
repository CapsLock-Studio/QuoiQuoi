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
    self.where(user_id: user_id, checkout: false).order(:created_at).last
  end

  def self.create_cart(user_id, locale_id)
    self.create({closed: false, user_id: user_id, checkout: false, locale_id: locale_id, currency: Locale.find(locale_id).currency})
  end

  def quantity
    self.order_products.count + self.order_custom_items.count
  end

  # Order.includes(:order_custom_items, :order_products).find(317).amount <======= For test
  def get_subtotal
    subtotal = self.order_custom_items_subtotal + self.order_products_subtotal
    shipping_fee = ShippingFeeTranslate.find_by_shipping_fee_id_and_locale_id(self.shipping_fee_id, self.locale_id)

    if shipping_fee.free_condition.blank? || subtotal < shipping_fee.free_condition
      subtotal + shipping_fee.fee
    else
      subtotal
    end
  end

  def get_raw_subtotal
    (self.order_custom_items_subtotal + self.order_products_subtotal)
  end

  def order_custom_items_subtotal
    self.order_custom_items.includes(:order_custom_item_translate)
                           .where(order_custom_item_translates: {locale_id: self.locale_id}).sum(:price)
  end

  def order_products_subtotal
    self.order_products.map{|order_product| order_product.price * order_product.quantity}.sum
  end
end