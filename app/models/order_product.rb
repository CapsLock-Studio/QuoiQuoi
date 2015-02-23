class OrderProduct < ActiveRecord::Base
  default_scope ->(){ order(:id) }

  belongs_to :order
  belongs_to :product
  belongs_to :product_option
end
