class AddUserColumns < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :zip_code, :integer
    add_column :users, :address, :string
    add_column :users, :line, :string
    add_column :users, :phone, :integer
  end
end
