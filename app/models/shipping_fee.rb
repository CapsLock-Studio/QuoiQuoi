class ShippingFee < ActiveRecord::Base
  has_many :shipping_fee_translates, dependent: :destroy

  accepts_nested_attributes_for :shipping_fee_translates, allow_destroy: true
end
