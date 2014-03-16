class AddReferenceToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :product_type
  end
end
