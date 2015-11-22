class OrderCustomItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :custom_order
  belongs_to :locale
end
