class SetDefaultPriceToOption < ActiveRecord::Migration
  def change
    change_column :product_options, :price, :float, default: 0
  end
end
