class AddInformationToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :name, :string
    add_column :orders, :address, :string
    add_column :orders, :zip_code, :integer
    add_column :orders, :phone, :integer
  end
end
