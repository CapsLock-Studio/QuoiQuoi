class AddPriceColumnToAllOptions < ActiveRecord::Migration
  def change
    add_column :product_options, :price, :float
    add_column :course_options, :price, :float
  end
end
