class ProductTranslate < ActiveRecord::Base
  belongs_to :product
  belongs_to :locale
end
