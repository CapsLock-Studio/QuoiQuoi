class Order < ApplicationRecord
  enum payment_method: {remittance: 0, paypal: 1, cvs_family: 2, cvs_ibon: 3, webatm: 4, atm: 5, alipay: 6, credit_card: 7}

  validates :user_id, presence: true

  belongs_to :user
  has_many :order_products, dependent: :delete_all

  accepts_nested_attributes_for :order_products

  belongs_to :locale

  belongs_to :shipping_fee

  has_many :order_custom_items
  accepts_nested_attributes_for :order_custom_items

  has_one :user_gift_serial

  has_one :order_payment, dependent: :destroy

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
    self.get_raw_subtotal + self.shipping_fee!
  end

  def shipping_fee!
    shipping_fee = ShippingFeeTranslate.find_by_shipping_fee_id_and_locale_id(self.shipping_fee_id, self.locale_id)
    if shipping_fee.free_condition.blank? || self.get_raw_subtotal < shipping_fee.free_condition
      shipping_fee.fee
    else
      0
    end
  end

  def discount!
    discount = 0
    UserGiftSerial.where(order_id: self.id).each do |user_gift_serial|
      discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: self.locale_id).first.quota
    end

    discount
  end

  def get_raw_subtotal
    (self.order_custom_items_subtotal + self.order_products_subtotal)
  end

  def order_custom_items_subtotal
    order_custom_items.map(&:custom_order).sum(&:price)
  end

  def order_products_subtotal
    self.order_products.map{|order_product| order_product.price * order_product.quantity}.sum
  end

  def has_expire_time?
    (self.remittance? || self.cvs_family? || self.cvs_ibon? || self.atm?) &&
        (!self.order_payment.expire_time.nil?)
  end

  def empty_expire_time?
    (self.remittance? || self.cvs_family? || self.cvs_ibon? || self.atm?) &&
        (self.order_payment.expire_time.nil?)
  end

  def remaining_time_to_archive
    ((((self.delivery_report_handled?)? self.delivery_report_handled_time : self.delivered_time) + 30.days - Time.zone.now) / 1.days).to_i
  end
end