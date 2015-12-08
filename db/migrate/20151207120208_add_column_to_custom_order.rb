class AddColumnToCustomOrder < ActiveRecord::Migration
  def change
    add_column :custom_orders, :references, :string
    add_column :custom_orders, :size, :string
    add_column :custom_orders, :description, :text
  end
end
