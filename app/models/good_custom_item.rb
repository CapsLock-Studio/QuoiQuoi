class GoodCustomItem < ActiveRecord::Base
  belongs_to :good
  belongs_to :product_custom_item
end
