class AddForeignKeyToTranslateTables < ActiveRecord::Migration
  def change
    add_column :product_translates, :product_id, :integer
  end
end
