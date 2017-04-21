class ShippingFeeTranslate < ApplicationRecord
  belongs_to :locale
  belongs_to :shipping_fee
end
