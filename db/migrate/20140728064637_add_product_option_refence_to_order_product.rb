class AddProductOptionRefenceToOrderProduct < ActiveRecord::Migration
  def change
    add_reference :order_products, :product_option, index: true
  end
end
