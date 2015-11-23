class ShippingFee < ActiveRecord::Base
  has_many :shipping_fee_translates, dependent: :destroy

  has_one :shipping_fee_translate

  accepts_nested_attributes_for :shipping_fee_translates, allow_destroy: true
end
