class AddPriceToProductTranslate < ActiveRecord::Migration
  def change
    add_column :product_translates, :price, :float
  end
end
