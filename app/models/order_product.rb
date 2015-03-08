class OrderProduct < ActiveRecord::Base
  default_scope ->(){ order(:id) }

  belongs_to :order
  belongs_to :product
  belongs_to :product_option

  has_many :order_product_options
  accepts_nested_attributes_for :order_product_options

  def raw_price(locale_id)
    ApplicationController.helpers.price_discount(
        self.product.product_translates.find_by_locale_id(locale_id).price,
        self.discount
    )
  end
end
