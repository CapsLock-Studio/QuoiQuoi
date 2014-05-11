class AddDefalutToRegistrationAndOrder < ActiveRecord::Migration
  def change
    change_column :orders, :closed, :boolean, default: false
    change_column :orders, :delivered, :boolean, default: false
    change_column :orders, :checkout, :boolean, default: false
    change_column :orders, :subtotal, :integer, defalut: 0

    change_column :registrations, :closed, :boolean, default: false
    change_column :registrations, :subtotal, :integer, default: 0
    change_column :registrations, :popular, :integer, default: 0
  end
end
