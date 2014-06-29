class ShippingFeeTranslate < ActiveRecord::Base
  belongs_to :locale
  belongs_to :shipping_fee
end
